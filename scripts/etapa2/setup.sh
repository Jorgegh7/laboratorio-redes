#!/bin/bash

# -e: se detiene al primer error 
# -u: error si usas una variable sin definir 
# -o pipefail: falla si falla cualquier parte de un |
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script con sudo."
  exit 1

else
    echo "Ejecutando script de configuración como root..."
fi

# Paso 1: limpieza de lo que haya de una ejecución anterior

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

# Paso 2: crear los namespaces h1, h2 y h3
ip netns add h1
ip netns add h2
ip netns add h3
# ip netns list 

# Paso 3: crear el puente br-lab y encenderlo
ip link add br-lab type bridge
ip link set br-lab up            
# ip link show br-lab 

# Paso 4: crear los cables veth (cada uno con su tarjeta eth0-hN)
ip link add veth-h1 type veth peer name eth0-h1
ip link add veth-h2 type veth peer name eth0-h2
ip link add veth-h3 type veth peer name eth0-h3
# ip link show type veth 

# Paso 5: meter cada eth0-hN dentro de su namespace
ip link set eth0-h1 netns h1
ip link set eth0-h2 netns h2
ip link set eth0-h3 netns h3
# ip link show type veth 

# Paso 6: enchufar cada veth-hN al puente y encenderlo
ip link set veth-h1 master br-lab
ip link set veth-h2 master br-lab
ip link set veth-h3 master br-lab
ip link set veth-h1 up
ip link set veth-h2 up
ip link set veth-h3 up
# bridge link show

# Paso 7: encender cada eth0-hN dentro de su namespace
ip netns exec h1 ip link set eth0-h1 up
ip netns exec h2 ip link set eth0-h2 up
ip netns exec h3 ip link set eth0-h3 up
# bridge link show 

# Paso 8: asignar las IP a cada eth0-hN
ip netns exec h1 ip addr add 10.20.0.1/24 dev eth0-h1
ip netns exec h2 ip addr add 10.20.0.2/24 dev eth0-h2
ip netns exec h3 ip addr add 10.20.0.3/24 dev eth0-h3
# sudo ip netns exec h1 ping -c 2 10.20.0.2