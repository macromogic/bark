# Users can configure these in ~/.zshrc:
# export BARK_KEY="your_device_key"
# export BARK_SERVER="https://api.day.app"   # Optional (defaults to the official service)
# export BARK_GROUP="terminal"               # Optional
# export BARK_SOUND="minuet"                 # Optional
# export BARK_LEVEL="active"                 # Optional: active / timeSensitive / passive
# export BARK_ICON="https://example.com/icon.png"  # Optional

# Simple URL encoding: prefer python3, then python; otherwise fall back to conservative replacements.
_bark_urlencode() {
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$1"
  elif command -v python >/dev/null 2>&1; then
    python -c 'import sys, urllib; print urllib.quote(sys.argv[1], safe="")' "$1"
  else
    local s="$1"
    s="${s// /%20}"
    s="${s//$'\n'/%0A}"
    print -r -- "$s"
  fi
}

_bark_send() {
  local title="$1"
  local body="$2"
  local server="${BARK_SERVER:-https://api.day.app}"
  local key="${BARK_KEY:-}"

  [[ -z "$key" ]] && return 0
  command -v curl >/dev/null 2>&1 || return 0

  local enc_title enc_body url
  enc_title="$(_bark_urlencode "$title")"
  enc_body="$(_bark_urlencode "$body")"
  url="${server%/}/${key}/${enc_title}/${enc_body}"

  local -a params
  [[ -n "${BARK_GROUP:-}" ]] && params+=("--data-urlencode" "group=${BARK_GROUP}")
  [[ -n "${BARK_SOUND:-}" ]] && params+=("--data-urlencode" "sound=${BARK_SOUND}")
  [[ -n "${BARK_LEVEL:-}" ]] && params+=("--data-urlencode" "level=${BARK_LEVEL}")
  [[ -n "${BARK_ICON:-}"  ]] && params+=("--data-urlencode" "icon=${BARK_ICON}")

  curl -fsS -G \
    "${params[@]}" \
    "$url" >/dev/null 2>&1 || true
}

_bark_format_duration() {
  local total_ms="$1"
  local total_s=$(( total_ms / 1000 ))
  local ms=$(( total_ms % 1000 ))
  local h=$(( total_s / 3600 ))
  local m=$(( (total_s % 3600) / 60 ))
  local s=$(( total_s % 60 ))

  if (( h > 0 )); then
    print -r -- "${h}h ${m}m ${s}s"
  elif (( m > 0 )); then
    print -r -- "${m}m ${s}s"
  elif (( total_s > 0 )); then
    print -r -- "${s}.${ms}s"
  else
    print -r -- "${ms}ms"
  fi
}

bark() {
  if (( $# == 0 )); then
    echo "usage: bark <command> [args...]"
    return 2
  fi

  local start_ms end_ms elapsed_ms rc
  local cmd_display duration title body

  # Keep the original command display as much as possible.
  cmd_display="$*"

  # Millisecond timestamps: prefer python3, otherwise use date (seconds resolution).
  if command -v python3 >/dev/null 2>&1; then
    start_ms=$(python3 - <<'PY'
import time
print(int(time.time() * 1000))
PY
)
  else
    start_ms=$(( $(date +%s) * 1000 ))
  fi

  "$@"
  rc=$?

  if command -v python3 >/dev/null 2>&1; then
    end_ms=$(python3 - <<'PY'
import time
print(int(time.time() * 1000))
PY
)
  else
    end_ms=$(( $(date +%s) * 1000 ))
  fi

  elapsed_ms=$(( end_ms - start_ms ))
  duration="$(_bark_format_duration "$elapsed_ms")"

  if (( rc == 0 )); then
    title="Command finished"
  else
    title="Command failed"
  fi

  body="cmd: ${cmd_display}
duration: ${duration}
exit code: ${rc}"

  _bark_send "$title" "$body"
  return "$rc"
}
