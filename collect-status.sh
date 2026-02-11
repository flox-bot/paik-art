#!/bin/bash
# collect-status.sh — Collects real system & agent data, writes status.json
export PATH="/usr/sbin:/usr/bin:/bin:/sbin:$PATH"
cd "$(dirname "$0")"

# CPU
CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.1f", s}')
CORES=$(sysctl -n hw.ncpu)
CPU_NORM=$(echo "$CPU $CORES" | awk '{printf "%.1f", $1/$2}')

# Memory
MEM_TOTAL_BYTES=$(sysctl -n hw.memsize)
MEM_TOTAL_GB=$(echo "$MEM_TOTAL_BYTES" | awk '{printf "%.1f", $1/1073741824}')
PAGE_SIZE=$(sysctl -n hw.pagesize)
VM_STAT=$(vm_stat)
PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | tr -d '.')
PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired" | awk '{print $4}' | tr -d '.')
PAGES_COMP=$(echo "$VM_STAT" | grep "Pages occupied by compressor" | awk '{print $5}' | tr -d '.')
MEM_USED_BYTES=$(echo "$PAGES_ACTIVE $PAGES_WIRED $PAGES_COMP $PAGE_SIZE" | awk '{printf "%.0f", ($1+$2+$3)*$4}')
MEM_PCT=$(echo "$MEM_USED_BYTES $MEM_TOTAL_BYTES" | awk '{printf "%.1f", ($1/$2)*100}')

UPTIME=$(uptime | sed 's/.*up //' | sed 's/,.*//')
HOSTNAME=$(hostname)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOAD=$(sysctl -n vm.loadavg | awk '{print $2}')

# Signal Activity (proxy: count messages in the last 15 mins in agent sessions)
MSG_COUNT=$(find /Users/yoon/.openclaw/agents/*/sessions/ -name "*.jsonl" -mmin -15 | wc -l | xargs)
SIGNAL_DENSITY=$(echo "$MSG_COUNT" | awk '{print ($1 > 5 ? 100 : $1 * 20)}')

cat > status.json << ENDJSON
{
  "timestamp": "$TIMESTAMP",
  "system": {
    "hostname": "$HOSTNAME",
    "cpu_percent": $CPU_NORM,
    "cpu_cores": $CORES,
    "ram_percent": $MEM_PCT,
    "ram_total_gb": $MEM_TOTAL_GB,
    "load": $LOAD,
    "uptime": "$UPTIME",
    "signal_density": $SIGNAL_DENSITY
  },
  "agents": [
    {"id":"paik","name":"PAIK","role":"VISUAL STRATEGIST","soul":"Nam June Paik","model":"gemini-3-flash","color":"#ff00ff","status":"active"},
    {"id":"flox","name":"FLOX","role":"ORCHESTRATOR","soul":"System Core","model":"gpt-5.3-codex","color":"#00e5ff","status":"idle"},
    {"id":"coder","name":"CODER","role":"DEVELOPER","soul":"Code Architect","model":"qwen3-coder-next (local)","color":"#39ff14","status":"idle"},
    {"id":"bowie","name":"BOWIE","role":"COSMIC SIGNAL","soul":"David Bowie","model":"gemini-3-flash","color":"#ffaa00","status":"idle"}
  ]
}
ENDJSON

echo "OK | $TIMESTAMP | CPU:${CPU_NORM}% RAM:${MEM_PCT}% Load:$LOAD"
