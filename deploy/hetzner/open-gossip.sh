#!/bin/bash
# Open the gossip window on the Hetzner host. Does not enable or disable ufw,
# and does not touch the ledger.
set -euo pipefail
HOST_IP=95.216.154.157
cat <<EOF
Gossip entrypoint: ${HOST_IP}:8000
Allow tcp/8080, tcp+udp 8000-8020.
Allow tcp/8899 and tcp/8900 only from ${HOST_IP} (the local proxy).
EOF
if ! command -v ufw >/dev/null 2>&1; then
  echo "ufw is not installed. Apply those allows on the host firewall."
  exit 0
fi
if ! ufw status | head -n 1 | grep -q "Status: active"; then
  echo "ufw is not active. Leaving it disabled."
  exit 0
fi
ufw allow 8080/tcp
ufw allow 8000:8020/udp
ufw allow 8000:8020/tcp
ufw allow from "$HOST_IP" to any port 8899 proto tcp
ufw allow from "$HOST_IP" to any port 8900 proto tcp
ufw deny 8899/tcp
ufw deny 8900/tcp
ufw status
