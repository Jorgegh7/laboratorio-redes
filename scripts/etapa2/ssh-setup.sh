#!/bin/bash
# Arranca el servidor SSH dentro de h2 (la víctima del laboratorio).
# Requiere que setup.sh ya haya levantado h1, h2, h3 y br-lab.

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Ejecuta con sudo" 
    exit 1
fi

# Arrancar sshd dentro de h2

# sshd exige esta carpeta para aislar el proceso que atiende las conexiones
# entrantes antes de que se autentiquen. Vive en /run, que se vacía al
# reiniciar el dispositivo, así que hay que volver a crearla cada vez.
# -p crea también las carpetas padre que falten y no falla si ya existe,
# así este script se puede correr varias veces sin error.
mkdir -p /run/sshd

# Arranca el servidor SSH dentro de h2 (la víctima del laboratorio)
ip netns exec h2 /usr/sbin/sshd

echo "sshd arrancado en h2"

#sudo ip netns exec h2 ss -tlnp | grep ':22 '