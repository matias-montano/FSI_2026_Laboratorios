# Práctica 3 - Red Privada Virtual (VPN)

Primero, en la primera terminal se accedio por ssh, y se hizo con esto:

```
ssh vpnserver@10.0.3.6
vpnserver
```

luego se pasaron los archivos de la carpeta `fsi`, cabe destacar que 
no se copia el contienido de la carpeta client

```
scp -r fsi vpnserver@10.0.3.6:~/
```

despues se hace nano y se pega el server.config usando el ssh y se ejecuta el siguiente comando
```
sudo openvpn --config server.config
```

que empezara con
```
2026-06-06 20:42:03 --cipher is not set. Previous OpenVPN version defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
2026-06-06 20:42:03 OpenVPN 2.5.11 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Apr 23 2026
2026-06-06 20:42:03 library versions: OpenSSL 3.0.2 15 Mar 2022, LZO 2.10
2026-06-06 20:42:03 net_route_v4_best_gw query: dst 0.0.0.0
2026-06-06 20:42:03 net_route_v4_best_gw result: via 0.0.0.0 dev 
2026-06-06 20:42:03 Diffie-Hellman initialized with 4096 bit key
2026-06-06 20:42:03 TUN/TAP device tun0 opened
2026-06-06 20:42:03 net_iface_mtu_set: mtu 1500 for tun0
2026-06-06 20:42:03 net_iface_up: set tun0 up
2026-06-06 20:42:03 net_addr_v4_add: 172.16.1.1/24 dev tun0
2026-06-06 20:42:03 Could not determine IPv4/IPv6 protocol. Using AF_INET
2026-06-06 20:42:03 Socket Buffers: R=[212992->212992] S=[212992->212992]
2026-06-06 20:42:03 UDPv4 link local (bound): [AF_INET][undef]:1194
2026-06-06 20:42:03 UDPv4 link remote: [AF_UNSPEC]
2026-06-06 20:42:03 MULTI: multi_init called, r=256 v=256
2026-06-06 20:42:03 IFCONFIG POOL IPv4: base=172.16.1.2 size=253
2026-06-06 20:42:03 Initialization Sequence Completed
```

luego, en el cliente, se abre otra terminal y se crea con nano el client.config y se ejecuta:
```
sudo openvpn --config client.config
```

ahora, necesitamos abrir otra terminal y podemos corroborar el tunel, que es `5: tun0:`:
```
fsi03@attacker-3:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:7a:e3:e5 brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    inet 192.168.44.13/25 brd 192.168.44.127 scope global ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe7a:e3e5/64 scope link 
       valid_lft forever preferred_lft forever
3: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:9e:c2:40 brd ff:ff:ff:ff:ff:ff
    altname enp0s4
    inet 10.0.3.4/24 metric 100 brd 10.0.3.255 scope global dynamic ens4
       valid_lft 3014sec preferred_lft 3014sec
    inet6 fe80::5054:ff:fe9e:c240/64 scope link 
       valid_lft forever preferred_lft forever
5: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none 
    inet 172.16.1.2/24 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::7b85:5c46:e3b6:b769/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
```

de hecho mientras la VPN estaba activa, se enviaron pings desde el cliente al servidor:
```
fsi03@attacker-3:~$ ping -c 10 172.16.1.1
PING 172.16.1.1 (172.16.1.1) 56(84) bytes of data.
64 bytes from 172.16.1.1: icmp_seq=1 ttl=64 time=0.831 ms
64 bytes from 172.16.1.1: icmp_seq=2 ttl=64 time=0.840 ms
64 bytes from 172.16.1.1: icmp_seq=3 ttl=64 time=0.746 ms
64 bytes from 172.16.1.1: icmp_seq=4 ttl=64 time=0.843 ms
64 bytes from 172.16.1.1: icmp_seq=5 ttl=64 time=0.849 ms
64 bytes from 172.16.1.1: icmp_seq=6 ttl=64 time=0.893 ms
64 bytes from 172.16.1.1: icmp_seq=7 ttl=64 time=0.734 ms
64 bytes from 172.16.1.1: icmp_seq=8 ttl=64 time=0.809 ms
64 bytes from 172.16.1.1: icmp_seq=9 ttl=64 time=0.953 ms
64 bytes from 172.16.1.1: icmp_seq=10 ttl=64 time=0.808 ms

--- 172.16.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9088ms
rtt min/avg/max/mdev = 0.734/0.830/0.953/0.060 ms
```

Para verificar que el tráfico dentro de la VPN se transmite cifrado, se utilizó tcpdump capturando el tráfico UDP en el puerto 1194 (puerto de OpenVPN), y esto se ejecuto con:

```
sudo tcpdump -i ens4 -A udp port 1194
```

despues de abre una cuarta terminal y se ejecuta netcat para el puerto 7 que es `echo`, de esta manera:
```
nc 172.16.1.1 7
```

luegos e escribe:
```
hola buenos dias, como estan?
```

y en la tercera consola, que estaba corriendo el tcpdump, se puede observar este trafico, junto con paquetes keepalive, notar que son dos paquetes de largo 106, uno que se envia desde el cliente (attacker) a openvpn, y el otro de openvpn a attacker, como se puede ver todos los paquetes se transmiten cifrados:

```
...
........U.pH.............8........(e..}....?.$d.oi......j..u....=....   .%`.....F..n..
}B.
21:06:51.560334 IP 10.0.3.6.openvpn > attacker-3.54925: UDP, length 77
E..ia9@.@..A
...
........U.pH...........|g...U.....E.9...4.A...>1$+.....k.]...o...<..?...Fw9.o..Je.......
21:06:51.560443 IP attacker-3.54925 > 10.0.3.6.openvpn: UDP, length 76
E..hWo@.@...
...
........T.oH.......8RI.A..c_..G*0.....K3.......9....P.ca.7|.    ..(9..".`...Z...t#T.,..g/U
21:06:58.404430 IP attacker-3.54925 > 10.0.3.6.openvpn: UDP, length 106
E...[.@.@...
...
........r..H.......Az..,4.<u/..o.~..\...=lP.!UC.t]S....1G.....k.!J<_.]*...,....0,8f.g0....I...!.....!.%..`..mq_>;e...
21:06:58.405330 IP 10.0.3.6.openvpn > attacker-3.54925: UDP, length 106
E...g|@.@...
...
........r..H.......].^...d6!K.H......a.._y......'..0Uu.].\..6Jj....y..Q.a...........x.-X....lw3..\ew...Boqo....Sc..d.
21:06:58.405449 IP attacker-3.54925 > 10.0.3.6.openvpn: UDP, length 76
E..h[.@.@...
...
........T.oH............d.
.....\on...P.dqX.......r.k...."/Lu*..`ud^..F.!....-.x5......
```