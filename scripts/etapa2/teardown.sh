#!/bin/bash
set -euo pipefail

if [ "EUID" -ne 0 ]; then
  echo "Ejecuta este script con sudo."
  exit 1
else
    echo "Ejecutando script de limpieza como root..."
fi

# Eliminar cables virtuales ethernet
ip link del veth-h1 2>/dev/null || true
ip link del veth-h2 2>/dev/null || true
ip link del veth-h3 2>/dev/null || true 

# Eliminar namespaces
ip netns del h1 2>/dev/null || true
ip netns del h2 2>/dev/null || true
ip netns del h3 2>/dev/null || true

# Eliminar bridge
ip link del br-lab 2>/dev/null || true

echo "Laboratorio de la Etapa 2 eliminado"