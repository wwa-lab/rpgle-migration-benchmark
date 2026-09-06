#!/bin/sh
# Serve the standalone deck. No backend, no build step.
cd "$(dirname "$0")"
PORT="${1:-4173}"
echo "RPGFLOW presentation: http://127.0.0.1:${PORT}/"
exec python3 -m http.server "$PORT"
