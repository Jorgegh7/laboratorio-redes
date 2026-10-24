# Laboratorio de redes sin VMs

Laboratorio de redes con *network namespaces* de Linux: dos "equipos" (`ns1` y `ns2`) unidos por un cable virtual (`veth`) dentro de un solo notebook, sin máquinas virtuales.

## Uso

Requisitos: Linux con `iproute2` y `tcpdump`.

```bash
sudo ./scripts/setup.sh      # levanta el laboratorio
sudo ./scripts/verify.sh     # comprueba ping y ARP
sudo ./scripts/teardown.sh   # lo borra
```

`setup.sh` se puede ejecutar varias veces seguidas: primero borra lo que haya quedado de antes.

## Qué contiene

- `ns1` (10.10.0.1/24) y `ns2` (10.10.0.2/24), conectados por un par `veth`.
- `capturas/arp-icmp.pcap`: captura del ARP y del ping entre ambos.
- `docs/bitacora.md`: bitácora de avance.

## Consumo de recursos

En un notebook de 8 GB, con el laboratorio levantado, la memoria usada pasó de 3,1 a 3,2 Gi y la disponible se mantuvo en 4,0 Gi. Es una medición simple con `free -h`, no un benchmark.

## Créditos

Inspirado en *Automatización y Monitoreo de Red Corporativa, Etapa 1*, de Stefania Randazzo, que usa EVE-NG y máquinas virtuales. Este proyecto busca lo mismo de forma liviana.

Úsalo solo en equipos y redes propias.
