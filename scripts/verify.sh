#!/usr/bin/env bash
# verify.sh: comprueba que ns1 llega a ns2 y que aprende su MAC por ARP
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Ejecuta con sudo: sudo $0"
  exit 1
fi

# Borrar la tabla ARP para obligar a repetir la pregunta
ip netns exec ns1 ip neigh flush all

# Prueba 1: el ping responde
if ip netns exec ns1 ping -c 2 -W 1 10.10.0.2 > /dev/null; then
  echo "OK     ping de ns1 a ns2"
else
  echo "FALLA  ping de ns1 a ns2"
  exit 1
fi

# Prueba 2: ns1 aprendió la MAC de ns2
if ip netns exec ns1 ip neigh show to 10.10.0.2 | grep -q lladdr; then
  echo "OK     ns1 aprendió la MAC de ns2 (ARP)"
else
  echo "FALLA  ns1 no tiene la MAC de ns2"
  exit 1
fi

echo "Todas las pruebas pasaron"
