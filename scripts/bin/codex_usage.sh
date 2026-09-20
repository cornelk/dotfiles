#!/usr/bin/env bash
#
# Show the Codex weekly usage percentage as a Waybar custom module.
#
# Reads the ChatGPT OAuth token that the Codex CLI keeps in
# ~/.codex/auth.json and queries the Codex backend usage endpoint.
# Never refreshes the token: Codex rotates refresh tokens on use, so
# refreshing here would invalidate the CLI's stored credentials.

set -euo pipefail

AUTH_FILE="${CODEX_HOME:-$HOME/.codex}/auth.json"
USAGE_URL="https://chatgpt.com/backend-api/wham/usage"
REQUEST_TIMEOUT=10
WEEKLY_WINDOW_SECONDS=604800
ACTION="${1:-}"
STATE_FILE="${XDG_RUNTIME_DIR:-/run/user/$UID}/waybar-codex-expanded"

if [[ "$ACTION" == "--toggle" ]]; then
  if [[ -e "$STATE_FILE" ]]; then
    rm -f -- "$STATE_FILE"
  else
    touch "$STATE_FILE"
  fi
  exit 0
fi

emit_json() {
  local output="$1"
  printf '%s\n' "$output"
}

waybar_json() {
  local output

  output=$(python3 -c '
import json, sys
print(json.dumps({"text": sys.argv[1], "tooltip": sys.argv[2]}))
' "$1" "$2")
  emit_json "$output"
}

if [[ ! -f "$AUTH_FILE" ]]; then
  waybar_json "CDX --" "Codex auth file not found: $AUTH_FILE (run: codex login)"
  exit 0
fi

read -r ACCESS_TOKEN ACCOUNT_ID < <(python3 -c '
import json, sys
tokens = json.load(open(sys.argv[1])).get("tokens") or {}
print(tokens.get("access_token") or "", tokens.get("account_id") or "")
' "$AUTH_FILE")

if [[ -z "$ACCESS_TOKEN" ]]; then
  waybar_json "CDX --" "No ChatGPT token in $AUTH_FILE (run: codex login)"
  exit 0
fi

if ! RESPONSE=$(curl -fsS --max-time "$REQUEST_TIMEOUT" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "chatgpt-account-id: $ACCOUNT_ID" \
  -H "User-Agent: codex-cli" \
  -H "Accept: application/json" \
  "$USAGE_URL" 2>/dev/null); then
  waybar_json "CDX --" "Codex usage request failed (offline, or token expired - run: codex login)"
  exit 0
fi

EXPANDED=0
if [[ -e "$STATE_FILE" ]]; then
  EXPANDED=1
fi

OUTPUT=$(EXPANDED="$EXPANDED" WEEKLY_WINDOW_SECONDS="$WEEKLY_WINDOW_SECONDS" python3 -c '
import json, os, sys
from datetime import datetime, timedelta

data = json.load(sys.stdin)
limit = data.get("rate_limit") or {}
windows = [w for w in (limit.get("primary_window"), limit.get("secondary_window")) if w]
if not windows:
    print(json.dumps({"text": "CDX --", "tooltip": "Codex reported no rate limit window"}))
    raise SystemExit(0)

weekly_seconds = int(os.environ["WEEKLY_WINDOW_SECONDS"])
window = next((w for w in windows if w.get("limit_window_seconds") == weekly_seconds), windows[0])
used = int(window.get("used_percent", 0))
remaining = max(100 - used, 0)
hours = int((window.get("limit_window_seconds") or 0) / 3600)
label = "weekly" if window.get("limit_window_seconds") == weekly_seconds else f"{hours}h"

reset_at = window.get("reset_at")
if reset_at:
    reset = datetime.fromtimestamp(reset_at)
    time_left = max(reset - datetime.now(), timedelta(0))
    reset_short = f"resets {reset:%a %d %b %H:%M}"
    reset_line = f"Resets {reset:%a %d %b %H:%M} (in {time_left.days}d {time_left.seconds // 3600}h)"
else:
    reset_short = "reset unknown"
    reset_line = "Reset time unknown"

plan = (data.get("plan_type") or "unknown").capitalize()
state = "limit reached" if limit.get("limit_reached") else "ok"
tooltip = (
    f"Codex {label} remaining: {remaining}% ({used}% used)\n"
    f"Plan: {plan} ({state})\n"
    f"{reset_line}"
)
text = f"CDX {remaining}%"
if os.environ["EXPANDED"] == "1":
    text = f"{text} · {reset_short}"
print(json.dumps({"text": text, "tooltip": tooltip}))
' <<<"$RESPONSE")

emit_json "$OUTPUT"
