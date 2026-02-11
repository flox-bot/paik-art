#!/bin/bash
# push-status.sh — Collect status and push to GitHub
export PATH="/usr/sbin:/usr/bin:/bin:/sbin:/usr/local/bin:$HOME/.nvm/versions/node/v24.13.0/bin:$PATH"
cd "$(dirname "$0")"

bash collect-status.sh

# Only push if status.json changed
if git diff --quiet status.json 2>/dev/null; then
    echo "No changes, skip push."
    exit 0
fi

git add status.json
git commit -m "auto: status update $(date -u +%H:%M)" --no-verify
git push origin master
echo "Pushed status update."
