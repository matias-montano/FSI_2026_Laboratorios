# Práctica 3 - Red Privada Virtual (VPN)

Para verificar que el tráfico dentro de la VPN se transmite cifrado, se utilizó tcpdump capturando el tráfico UDP en el puerto 1194 (puerto de OpenVPN), y esto se ejecuto con:

```
sudo tcpdump -i ens4 -A udp port 1194
```

despues se abre otra terminal y se ejecuta netcat para el puerto 7 que es `echo`, de esta manera:
```
nc 172.16.1.1 7
```

luego se escribe:
```
hola buenos dias, como estan?
```

y en la consola que estaba corriendo el tcpdump, se puede observar este trafico, junto con paquetes keepalive, notar que son dos paquetes de largo 106, uno que se envia desde el cliente (attacker) a openvpn, y el otro de openvpn a attacker, como se puede ver todos los paquetes se transmiten cifrados:

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