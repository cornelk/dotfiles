#!/usr/bin/env bash
#
# Show the Command Code usage percentages as a Waybar custom module.
#
# Reads the API key that Command Code keeps in ~/.commandcode/auth.json and
# queries the Command Code billing endpoints. The key is long-lived, so this
# script never refreshes credentials.

set -euo pipefail

AUTH_FILE="${COMMAND_CODE_CONFIG_DIR:-$HOME/.commandcode}/auth.json"
CREDITS_URL="https://api.commandcode.ai/alpha/billing/credits"
SUBSCRIPTIONS_URL="https://api.commandcode.ai/alpha/billing/subscriptions"
REQUEST_TIMEOUT=10
ACTION="${1:-}"
STATE_FILE="${XDG_RUNTIME_DIR:-/run/user/$UID}/waybar-commandcode-expanded"

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
  waybar_json "CC --" "Command Code auth file not found: $AUTH_FILE"
  exit 0
fi

API_KEY=$(python3 -c '
import json, sys
print(json.load(open(sys.argv[1])).get("apiKey") or "")
' "$AUTH_FILE")

if [[ -z "$API_KEY" ]]; then
  waybar_json "CC --" "No API key in $AUTH_FILE"
  exit 0
fi

if ! CREDITS=$(curl -fsS --max-time "$REQUEST_TIMEOUT" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Accept: application/json" \
  "$CREDITS_URL" 2>/dev/null); then
  waybar_json "CC --" "Command Code usage request failed (offline, or key invalid)"
  exit 0
fi

# The plan id comes from a second endpoint; a failure here only loses the
# monthly bar, not the 5h and weekly windows.
SUBSCRIPTIONS=$(curl -fsS --max-time "$REQUEST_TIMEOUT" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Accept: application/json" \
  "$SUBSCRIPTIONS_URL" 2>/dev/null) || SUBSCRIPTIONS=""

EXPANDED=0
if [[ -e "$STATE_FILE" ]]; then
  EXPANDED=1
fi

OUTPUT=$(EXPANDED="$EXPANDED" SUBSCRIPTIONS="$SUBSCRIPTIONS" python3 -c '
import json, os, sys
from datetime import datetime, timedelta

data = json.load(sys.stdin)
subs = json.loads(os.environ["SUBSCRIPTIONS"] or "{}")

# The credits endpoint returns monthly *remaining* credits, not the cap, so
# the cap is mapped from the plan id (official pricing table).
MONTHLY_CAPS = {
    "individual-go": 10,
    "individual-goat": 70,
    "individual-pro": 80,
    "max-10x": 100,
    "max-20x": 200,
    "team-pro": 40,
}

def monthly_cap(plan_id):
    if not plan_id:
        return None
    matches = [k for k in MONTHLY_CAPS if k in plan_id.lower()]
    return MONTHLY_CAPS[max(matches, key=len)] if matches else None

def fmt_dollar(value):
    if value is None:
        return "?"
    if value >= 100:
        return f"${value:.0f}"
    if value >= 10:
        return f"${value:.1f}".rstrip("0").rstrip(".")
    return f"${value:.2f}"

def fmt_reset(ms):
    if not ms:
        return "reset unknown"
    reset = datetime.fromtimestamp(ms / 1000)
    time_left = max(reset - datetime.now(), timedelta(0))
    hours = time_left.days * 24 + time_left.seconds // 3600
    minutes = time_left.seconds % 3600 // 60
    left = f"{time_left.days}d {time_left.seconds // 3600}h" if time_left.days else f"{hours}h {minutes}m"
    return f"resets {reset:%Y-%m-%d %H:%M} (in {left})"

windows = data.get("windowLimits") or {}
five_hour = windows.get("fiveHour") or {}
weekly = windows.get("weekly") or {}
credits = data.get("credits") or {}

def remaining(used, cap):
    if not cap:
        return None
    return max(100 - round(used / cap * 100), 0)

fh_used = five_hour.get("used") or 0
fh_cap = five_hour.get("cap")
wk_used = weekly.get("used") or 0
wk_cap = weekly.get("cap")
fh_left = remaining(fh_used, fh_cap)
wk_left = remaining(wk_used, wk_cap)

plan_id = ((subs.get("data") or {}).get("planId")) or "unknown"
mo_cap = monthly_cap(plan_id)
mo_left = credits.get("monthlyCredits")

lines = []
if five_hour:
    fh_reset = five_hour.get("resetAt")
    lines.append(f"Session (5h) remaining: {fh_left}% ({fmt_dollar(fh_used)}/{fmt_dollar(fh_cap)} used)")
    lines.append(f"  {fmt_reset(fh_reset)}")
if weekly:
    wk_reset = weekly.get("resetAt")
    lines.append(f"Weekly remaining: {wk_left}% ({fmt_dollar(wk_used)}/{fmt_dollar(wk_cap)} used)")
    lines.append(f"  {fmt_reset(wk_reset)}")
if mo_left is not None:
    if mo_cap:
        mo_used = max(mo_cap - mo_left, 0)
        lines.append(f"Monthly: {remaining(mo_used, mo_cap)}% ({fmt_dollar(mo_used)}/{fmt_dollar(mo_cap)} used, {fmt_dollar(mo_left)} left)")
    else:
        lines.append(f"Monthly: {fmt_dollar(mo_left)} left (plan {plan_id} cap not mapped)")
lines.append(f"Plan: {plan_id}")

main_left = wk_left if wk_left is not None else fh_left
text = f"CC {main_left}%" if main_left is not None else "CC --"
if fh_left is not None and fh_left < 100:
    text = f"{text} ({fh_left}%)"
if os.environ["EXPANDED"] == "1" and (five_hour or weekly):
    window = weekly or five_hour
    reset = datetime.fromtimestamp((window.get("resetAt") or 0) / 1000)
    text = f"{text} · resets {reset:%Y-%m-%d %H:%M}"
print(json.dumps({"text": text, "tooltip": "\n".join(lines)}))
' <<<"$CREDITS")

emit_json "$OUTPUT"
