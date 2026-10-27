import os
import shlex
import subprocess
import sys

def ejecutar(comando):
    return subprocess.run(shlex.split(comando), capture_output=True, text=True)

if os.geteuid() != 0:
    print("Ejecuta con sudo")
else:
    # Borrar la tabla ARP para obligar a repetir la pregunta
    comando = "ip netns exec ns1 ip neigh flush all"
    flush = ejecutar(comando)
    if flush.returncode == 0:
        print("OK     tabla ARP de ns1 borrada")
    else:
        print("FALLA  no se pudo borrar la tabla ARP")
        sys.exit(1)

    # Prueba 1: el ping responde
    comando = "ip netns exec ns1 ping -c 2 -W 1 10.10.0.2"
    ping = ejecutar(comando)
    if ping.returncode == 0:
        print("OK     ping de ns1 a ns2")
    else:
        print("FALLA  ping de ns1 a ns2")
        sys.exit(1)

    # Prueba 2: ns1 aprendió la MAC de ns2
    comando = "ip netns exec ns1 ip neigh show to 10.10.0.2"
    vecinos = ejecutar(comando)
    if "lladdr" in vecinos.stdout:
        print("OK     ns1 aprendió la MAC de ns2 (ARP)")
    else:
        print("FALLA  ns1 no tiene la MAC de ns2")
        sys.exit(1)