#!/bin/sh
# cloudflared-opnsense.sh
#
# Purpose:
#   Install and configure Cloudflare Tunnel (cloudflared) on OPNsense using FreeBSD ports,
#   provision a secure token file, install an rc.d service (as provided by user),
#   enable autostart on boot, and start the service—idempotently and with robust logging.
#
# Requirements:
#   - Run as root on OPNsense (FreeBSD)
#   - Internet access for fetching ports (if cloudflared not already installed)
#
# ──────────────────────────────────────────────────────────────────────────────
# ENVIRONMENT VARIABLES (optional)
#
# | Variable              | Default                               | What it does
# |-----------------------|----------------------------------------|---------------------------------------------------------------|
# | CF_TUNNEL_TOKEN       | (prompted if missing)                  | Cloudflare Tunnel token written to token file (securely).     |
# | CF_CLOUDFLARED_MODE   | tunnel                                 | Passed to the rc.d script as operational mode.                |
# | CF_ENABLE_ON_BOOT     | yes                                    | If "yes", enables service at boot (sysrc).                    |
# | CF_START_ON_INSTALL   | yes                                    | If "yes", starts/restarts the service after setup.            |
# | CF_NONINTERACTIVE     | no                                     | If "yes", never prompt for token (skip if not provided).      |
# | CF_SERVICE_FILE       | /usr/local/etc/rc.d/cloudflared        | Path of rc.d script.                                          |
# | CF_TOKEN_FILE         | /usr/local/etc/cloudflared/token       | Where the token is stored (0600).                             |
# | CF_LOG_FILE           | /var/log/cloudflared.log               | Log file used by the daemon(8) wrapper in rc.d.               |
# | CF_PID_FILE           | /var/run/cloudflared.pid               | PID file used by the daemon(8) wrapper in rc.d.               |
#
# NOTES:
# - The service file uses /usr/sbin/daemon to supervise /usr/local/bin/cloudflared and logs to CF_LOG_FILE.
# - If cloudflared is already in PATH, the build-from-ports phase is skipped.
# - This script is idempotent: safe to re-run any time.
#
# Inspired by: Cloudflare Tunnel on OPNsense workflows (token-based runs).
# ──────────────────────────────────────────────────────────────────────────────

set -Eeuo pipefail

# ---------- Config (override via env) ----------
CF_CLOUDFLARED_MODE="${CF_CLOUDFLARED_MODE:-tunnel}"
CF_ENABLE_ON_BOOT="${CF_ENABLE_ON_BOOT:-yes}"
CF_START_ON_INSTALL="${CF_START_ON_INSTALL:-yes}"
CF_NONINTERACTIVE="${CF_NONINTERACTIVE:-no}"

CF_SERVICE_FILE="${CF_SERVICE_FILE:-/usr/local/etc/rc.d/cloudflared}"
CF_TOKEN_FILE="${CF_TOKEN_FILE:-/usr/local/etc/cloudflared/token}"
CF_LOG_FILE="${CF_LOG_FILE:-/var/log/cloudflared.log}"
CF_PID_FILE="${CF_PID_FILE:-/var/run/cloudflared.pid}"

# Where to build from ports if needed
PORTS_DIR="/usr/ports/net/cloudflared"

# ---------- Logging ----------
TS() { date "+%Y-%m-%d %H:%M:%S%z"; }
log()  { printf "%s [INFO ] %s\n"  "$(TS)" "$*"; }
warn() { printf "%s [WARN ] %s\n"  "$(TS)" "$*" >&2; }
err()  { printf "%s [ERROR] %s\n"  "$(TS)" "$*" >&2; }
die()  { err "$*"; exit 1; }

# Trap for unexpected errors
on_err() {
  err "An unexpected error occurred (line ${1:-?}). Check output and try again."
}
trap 'on_err $LINENO' ERR

require_root() {
  [ "$(id -u)" -eq 0 ] || die "Please run as root."
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

run() {
  # Wrapper to show and run commands; pipe-safe
  log "+ $*"
  "$@"
}

file_write_atomic() {
  # file_write_atomic <path> <mode> <owner:group> <content-stdin>
  _path="$1"; _mode="$2"; _own="$3"
  _tmp="$(_mktemp_for "$_path")"
  cat >"$_tmp"
  chmod "$_mode" "$_tmp"
  # chown only if owner provided (OPNsense usually root:wheel is fine)
  [ -n "$_own" ] && chown "$_own" "$_tmp" || true
  mv -f "$_tmp" "$_path"
}

_mktemp_for() {
  # Create a sibling temp file in the same filesystem
  _target="$1"
  _dir="$(dirname "$_target")"
  mkdir -p "$_dir"
  mktemp "${_dir}/.tmp.XXXXXX"
}

sysrc_set() {
  if command -v sysrc >/dev/null 2>&1; then
    run sysrc -q "$1"
  else
    # Fallback: write to /etc/rc.conf.d/cloudflared
    mkdir -p /etc/rc.conf.d
    case "$1" in
      *=*) key="$(printf "%s" "$1" | cut -d= -f1)"; val="$(printf "%s" "$1" | cut -d= -f2-)";;
      *) die "Invalid sysrc_set arg: $1";;
    esac
    conf="/etc/rc.conf.d/cloudflared"
    if grep -q "^${key}=" "$conf" 2>/dev/null; then
      # replace line
      awk -v k="$key" -v v="$val" 'BEGIN{set=0}
        $0 ~ "^"k"=" { print k"="v; set=1; next }
        { print }
        END{ if (set==0) print k"="v }' "$conf" > "${conf}.tmp"
      mv -f "${conf}.tmp" "$conf"
    else
      printf "%s=%s\n" "$key" "$val" >> "$conf"
    fi
  fi
}

# ---------- Preflight ----------
require_root
require_cmd sh
require_cmd mkdir
require_cmd chmod
require_cmd mv
require_cmd cat
require_cmd service

if [ "$(uname -s)" != "FreeBSD" ]; then
  warn "This script is intended for OPNsense/FreeBSD. Detected: $(uname -s)"
fi

# ---------- Install cloudflared if missing ----------
if ! command -v cloudflared >/dev/null 2>&1; then
  log "cloudflared not found in PATH. Installing from ports…"
  require_cmd opnsense-code
  require_cmd make

  run opnsense-code ports tools
  [ -d "$PORTS_DIR" ] || die "Ports path not found after fetch: $PORTS_DIR"

  # -DBATCH to skip prompts; add 'clean' for tidiness
  ( cd "$PORTS_DIR" && run make -DBATCH install clean )
else
  log "cloudflared already present: $(command -v cloudflared)"
fi

# ---------- Write rc.d service file (exactly as requested) ----------
RC_CONTENT=$(cat <<'RC_EOF'
#!/bin/sh

# PROVIDE: cloudflared
# REQUIRE: NETWORKING SERVERS
# KEYWORD: shutdown

. /etc/rc.subr

name="cloudflared"
rcvar="cloudflared_enable"
logfile="/var/log/cloudflared.log"
pidfile="/var/run/cloudflared.pid"
procname="/usr/local/bin/cloudflared"

load_rc_config $name

: ${cloudflared_enable:="NO"}
: ${cloudflared_mode:="tunnel"}

# Load token from secure file
if [ -f /usr/local/etc/cloudflared/token ]; then
    token=$(cat /usr/local/etc/cloudflared/token)
    command_args="${cloudflared_mode} --token ${token}"
else
    command_args="${cloudflared_mode}"
fi

command="/usr/sbin/daemon"
command_args="-o ${logfile} -p ${pidfile} -f ${procname} ${command_args}"

run_rc_command "$1"
RC_EOF
)

if [ ! -f "$CF_SERVICE_FILE" ] || ! cmp -s /dev/stdin "$CF_SERVICE_FILE" <<EOF
$RC_CONTENT
EOF
then
  log "Installing rc.d service to $CF_SERVICE_FILE"
  printf "%s" "$RC_CONTENT" | file_write_atomic "$CF_SERVICE_FILE" 0755 "root:wheel"
else
  log "rc.d service file already up to date at $CF_SERVICE_FILE"
fi

# Ensure /usr/local/etc/cloudflared exists
run mkdir -p "$(dirname "$CF_TOKEN_FILE")"
# Permissions for dir can be default; token file itself is restricted below.

# ---------- Token handling ----------
WRITE_TOKEN="no"
if [ -n "${CF_TUNNEL_TOKEN:-}" ]; then
  WRITE_TOKEN="yes"
elif [ ! -s "$CF_TOKEN_FILE" ] && [ "$CF_NONINTERACTIVE" != "yes" ]; then
  # Interactive prompt (silent)
  printf "Enter Cloudflare Tunnel token (input hidden, leave blank to skip): "
  # shellcheck disable=SC2162
  stty -echo; read TOKEN_INPUT; stty echo; printf "\n"
  if [ -n "$TOKEN_INPUT" ]; then
    CF_TUNNEL_TOKEN="$TOKEN_INPUT"
    WRITE_TOKEN="yes"
  fi
fi

if [ "$WRITE_TOKEN" = "yes" ]; then
  log "Writing token to $CF_TOKEN_FILE (0600)"
  printf "%s\n" "${CF_TUNNEL_TOKEN}" | file_write_atomic "$CF_TOKEN_FILE" 0600 "root:wheel"
else
  if [ -s "$CF_TOKEN_FILE" ]; then
    log "Token file already present at $CF_TOKEN_FILE (leaving as-is)."
  else
    warn "No token provided and none found at $CF_TOKEN_FILE. Service will start without --token (likely not useful)."
  fi
fi

# ---------- Enable on boot ----------
if [ "$CF_ENABLE_ON_BOOT" = "yes" ]; then
  log "Enabling cloudflared to start on boot"
  sysrc_set "cloudflared_enable=YES"
  # Always persist the mode explicitly for clarity
  sysrc_set "cloudflared_mode=\"${CF_CLOUDFLARED_MODE}\""
else
  warn "Skipping enable-on-boot (CF_ENABLE_ON_BOOT=$CF_ENABLE_ON_BOOT)."
fi

# ---------- Start / Restart service ----------
if [ "$CF_START_ON_INSTALL" = "yes" ]; then
  # Touch log file so daemon can open it (and we can tail it immediately)
  : > "$CF_LOG_FILE" 2>/dev/null || true
  chmod 0644 "$CF_LOG_FILE" 2>/dev/null || true

  log "Restarting cloudflared service"
  service cloudflared stop >/dev/null 2>&1 || true
  if service cloudflared start; then
    log "cloudflared started successfully."
  else
    die "cloudflared failed to start. Check $CF_LOG_FILE for details."
  fi

  # Quick status & tail hint
  service cloudflared status || true
  log "Tail logs with: tail -f $CF_LOG_FILE"
else
  warn "Skipping service start (CF_START_ON_INSTALL=$CF_START_ON_INSTALL)."
fi

log "Done. cloudflared is installed and configured."
