#!/bin/bash
# Detiene el servidor SSH dentro de h2

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Ejecuta con sudo" 
    exit 1
fi

ip netns exec h2 pkill -f /usr/sbin/sshd || true

echo "sshd detenido en h2"