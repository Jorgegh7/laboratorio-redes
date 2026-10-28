#!/usr/bin/env bash
# setup.sh: levanta el laboratorio, con ns1 y ns2 unidos por un cable veth
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Ejecuta con sudo: sudo $0"
  exit 1
fi

# 1. Limpiar restos de una ejecución anterior (no falla si no hay nada)
ip link del veth1 2>/dev/null || true
ip netns del ns1 2>/dev/null || true
ip netns del ns2 2>/dev/null || true

# 2. Crear los dos equipos
ip netns add ns1
ip netns add ns2

# 3. Crear el cable y mandar cada punta a su equipo
ip link add veth1 type veth peer name veth2
ip link set veth1 netns ns1
ip link set veth2 netns ns2

# 4. Darle IP a cada punta
ip netns exec ns1 ip addr add 10.10.0.1/24 dev veth1
ip netns exec ns2 ip addr add 10.10.0.2/24 dev veth2

# 5. Encender las puntas
ip netns exec ns1 ip link set veth1 up
ip netns exec ns2 ip link set veth2 up

echo "Laboratorio listo: ns1 (10.10.0.1) <-> ns2 (10.10.0.2)"
