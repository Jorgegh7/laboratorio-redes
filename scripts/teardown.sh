#!/usr/bin/env bash
# teardown.sh: borra el laboratorio completo
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
   echo "Ejecuta con sudo: sudo $0"
   exit 1
fi

ip link del veth1 2>/dev/null || true
ip netns del ns1 2>/dev/null || true
ip netns del ns2 2>/dev/null || true

echo "laboratorio borrado"
