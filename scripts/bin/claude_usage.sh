#!/usr/bin/env bash
#
# Show the Claude weekly usage percentage as a Waybar custom module.
#
# Reads the OAuth token that Claude Code keeps in
# ~/.claude/.credentials.json and queries the Claude OAuth usage endpoint.
# Never refreshes the token: Claude Code rotates refresh tokens on use, so
# refreshing here would invalidate the CLI's stored credentials.

set -euo pipefail

CREDENTIALS_FILE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json"
USAGE_URL="https://api.anthropic.com/api/oauth/usage"
REQUEST_TIMEOUT=10
ACTION="${1:-}"
STATE_FILE="${XDG_RUNTIME_DIR:-/run/user/$UID}/waybar-claude-expanded"

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

if [[ ! -f "$CREDENTIALS_FILE" ]]; then
  waybar_json "CL --" "Claude credentials file not found: $CREDENTIALS_FILE (run: claude, then /login)"
  exit 0
fi

read -r ACCESS_TOKEN EXPIRES_AT < <(python3 -c '
import json, sys
oauth = json.load(open(sys.argv[1])).get("claudeAiOauth") or {}
print(oauth.get("accessToken") or "-", oauth.get("expiresAt") or 0)
' "$CREDENTIALS_FILE")

if [[ "$ACCESS_TOKEN" == "-" ]]; then
  waybar_json "CL --" "No OAuth token in $CREDENTIALS_FILE (run: claude, then /login)"
  exit 0
fi

if (( EXPIRES_AT / 1000 < $(date +%s) )); then
  waybar_json "CL --" "Claude OAuth token expired (start claude to refresh it)"
  exit 0
fi

if ! RESPONSE=$(curl -fsS --max-time "$REQUEST_TIMEOUT" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "anthropic-beta: oauth-2025-04-20" \
  -H "Accept: application/json" \
  "$USAGE_URL" 2>/dev/null); then
  waybar_json "CL --" "Claude usage request failed (offline, or token expired - start claude to refresh it)"
  exit 0
fi

EXPANDED=0
if [[ -e "$STATE_FILE" ]]; then
  EXPANDED=1
fi

OUTPUT=$(EXPANDED="$EXPANDED" python3 -c '
import json, os, sys
from datetime import datetime, timedelta, timezone

data = json.load(sys.stdin)
weekly = data.get("seven_day")
session = data.get("five_hour")
if not weekly and not session:
    print(json.dumps({"text": "CL --", "tooltip": "Claude reported no usage window"}))
    raise SystemExit(0)

def remaining(window):
    used = int(round(window.get("utilization") or 0))
    return max(100 - used, 0), used

def reset_times(window):
    resets_at = window.get("resets_at")
    if not resets_at:
        return "reset unknown", "Reset time unknown"
    reset = datetime.fromisoformat(resets_at).astimezone()
    time_left = max(reset - datetime.now(timezone.utc), timedelta(0))
    hours, minutes = time_left.seconds // 3600, time_left.seconds % 3600 // 60
    left = f"{time_left.days}d {hours}h" if time_left.days else f"{hours}h {minutes}m"
    return f"resets {reset:%Y-%m-%d %H:%M}", f"Resets {reset:%Y-%m-%d %H:%M} (in {left})"

lines = []
for name, window in (("Session (5h)", session), ("Weekly", weekly)):
    if not window:
        continue
    left, used = remaining(window)
    lines.append(f"{name} remaining: {left}% ({used}% used)")
    lines.append(f"  {reset_times(window)[1]}")

for limit in data.get("limits") or []:
    model = ((limit.get("scope") or {}).get("model") or {}).get("display_name")
    if limit.get("kind") == "weekly_scoped" and model:
        scoped_left = max(100 - int(limit.get("percent") or 0), 0)
        lines.append(f"Weekly {model}: {scoped_left}% remaining")

main = weekly or session
left, _ = remaining(main)
session_left = remaining(session)[0] if session else 100
text = f"CL {left}%"
if session and session_left < 100:
    text = f"{text} ({session_left}%)"
if os.environ["EXPANDED"] == "1":
    text = f"{text} · {reset_times(main)[0]}"
print(json.dumps({"text": text, "tooltip": "\n".join(lines)}))
' <<<"$RESPONSE")

emit_json "$OUTPUT"
