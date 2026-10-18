# Bitacora del laboratorio

## Fecha
17/10/2026

## Que hice
Se crearon 2 Network namespace que se conectaron por un cable virtual type veth.
Para esto se utilizando los siguientes comandos:
- Crear los 2 equipos: 'sudo ip netns add ns1 / sudo ip netns add ns2'
- Comprobar la lista de namespaces: 'ip netns list'
- Crear el cable virtual: 'sudo ip link add veth1 type veth peer name veth2' -> se les da nombre a ambas puntas 
- Se conecta el cable la los NS: 'sudo ip link set veth1 netns ns1' / 'sudo ip link set veth2 netns ns2'
- Darle ip: 'sudo ip netns exec ns1 ip addr add 10.10.0.1/24 dev veth1' / 'sudo ip netns exec ns2 ip addr add 10.10.0.2/24 dev veth2'
- Encenderlos: 'sudo ip netns exec ns1 ip link set veth1 up' / 'sudo ip netns exec ns2 ip link set veth2 up'
- Mirar table ARP: 'sudo ip netns exec ns1 ip neigh' / 'sudo ip netns exec ns2 ip neigh' -> en este estado las tablas estan vacias 
- Levantar tcpdump: 'sudo ip netns exec ns1 tcpdump -i veth1 -n -e -l 'arp or icmp'' -> Registra el BROADCAST de de veth1 y la respuesta de veth2 a veth1
- Ping a 10.10.0.2: 'sudo ip netns exec ns1 ping -c 2 10.10.0.2'
- Limpiar la tabla ARP: 'sudo ip netns exec ns1 ip neigh flush all'   
- Revisar el impacto en memoria: No se registran cambios significativos en memoria
- Se eliminan las NS: 'sudo ip netns del ns1' / 'sudo ip netns del ns2'




