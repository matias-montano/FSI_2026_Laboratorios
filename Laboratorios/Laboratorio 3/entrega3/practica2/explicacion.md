# Práctica 2 - Firewall

La política implementada es restrictiva. Esto significa que solamente se permite el tráfico que aparece explícitamente autorizado en las reglas. Todo el tráfico restante es registrado y descartado mediante la regla final de denegación.

## Reglas de policy

0. Acceso SMTP al servidor multisrv

Se permite el acceso al servicio SMTP del servidor multisrv desde cualquier red.

La regla permite conexiones TCP con puerto destino 25 hacia el host multisrv, cuya dirección IP es 172.16.42.2. Esta regla habilita el acceso al servicio de correo del servidor ubicado en la DMZ.

Regla conceptual:

Source: Any
Destination: multisrv
Service: SMTP TCP/25
Action: Accept

1. Acceso HTTP al servidor multisrv

Se permite el acceso al servicio web del servidor multisrv desde cualquier red.

La regla permite conexiones TCP con puerto destino 80 hacia el host multisrv, cuya dirección IP es 172.16.42.2. Esta regla permite que las máquinas de cualquiera de las redes puedan acceder al servidor web ubicado en la DMZ.

Regla conceptual:

Source: Any
Destination: multisrv
Service: HTTP TCP/80
Action: Accept

2. Acceso DNS desde la red interna hacia multisrv

Se permite que solamente la red interna acceda al servicio DNS del servidor multisrv.

La regla habilita consultas DNS desde la red interna 172.16.43.0/24 hacia el servidor multisrv 172.16.42.2. Para DNS se permiten tanto UDP/53 como TCP/53, ya que UDP se utiliza para consultas comunes y TCP puede utilizarse para respuestas grandes o casos especiales del protocolo DNS.

Regla conceptual:

Source: interna
Destination: multisrv
Service: DNS UDP/53 y DNS TCP/53
Action: Accept

3. Tráfico DNS desde multisrv hacia la red insegura

Se permite que el servidor multisrv, actuando como servidor DNS, envíe tráfico DNS hacia la red insegura.

La regla permite tráfico desde el host 172.16.42.2 hacia la red 172.16.44.0/24, únicamente para los servicios DNS UDP/53 y TCP/53. De esta forma, solamente el servidor DNS autorizado puede realizar consultas o reenviar tráfico DNS hacia la red insegura.

Regla conceptual:

Source: multisrv
Destination: insegura
Service: DNS UDP/53 y DNS TCP/53
Action: Accept

4. Acceso SSH de administración hacia el firewall

Se permite el acceso SSH al firewall solamente desde las máquinas de gestión autorizadas.

Las máquinas autorizadas son:

172.16.43.3
172.16.43.4
172.16.43.5

La regla permite conexiones TCP con puerto destino 22 desde los managements hacia el objeto firewall-lab3. Esta regla corresponde al tráfico dirigido al propio firewall, no al tráfico que atraviesa el firewall.

Regla conceptual:

Source: management1, management2, management3
Destination: firewall-lab3
Service: SSH TCP/22
Action: Accept

5. Acceso SSH desde la red interna hacia la DMZ

Se permite que las máquinas de la red interna inicien conexiones SSH hacia la DMZ.

Esta regla permite tráfico TCP con puerto destino 22 desde la red interna 172.16.43.0/24 hacia la red DMZ 172.16.42.0/24. Se utiliza para permitir administración o acceso remoto desde la red interna hacia equipos de la DMZ.

Regla conceptual:

Source: interna
Destination: DMZ
Service: SSH TCP/22
Action: Accept

6. Acceso SSH desde la red interna hacia la red insegura

Se permite que las máquinas de la red interna inicien conexiones SSH hacia la red insegura.

Esta regla permite tráfico TCP con puerto destino 22 desde la red interna 172.16.43.0/24 hacia la red insegura 172.16.44.0/24. La regla se separa de la administración del firewall para evitar que cualquier equipo interno pueda acceder por SSH al firewall.

Regla conceptual:

Source: interna
Destination: insegura
Service: SSH TCP/22
Action: Accept

7. Acceso HTTP desde la red interna hacia la DMZ

Se permite que las máquinas de la red interna inicien conexiones HTTP hacia la DMZ.

Esta regla permite tráfico TCP con puerto destino 80 desde la red interna 172.16.43.0/24 hacia la red DMZ 172.16.42.0/24.

Regla conceptual:

Source: interna
Destination: DMZ
Service: HTTP TCP/80
Action: Accept

8. Acceso HTTP desde la red interna hacia la red insegura

Se permite que las máquinas de la red interna inicien conexiones HTTP hacia la red insegura.

Esta regla permite tráfico TCP con puerto destino 80 desde la red interna 172.16.43.0/24 hacia la red insegura 172.16.44.0/24.

Regla conceptual:

Source: interna
Destination: insegura
Service: HTTP TCP/80
Action: Accept

9. Regla final de denegación y registro

Se agrega una regla final que coincide con cualquier tráfico no permitido por las reglas anteriores.

Esta regla registra el tráfico mediante la opción de log y luego lo descarta. De esta manera se cumple la política de denegar todo tráfico no autorizado y registrar los paquetes descartados.

Regla conceptual:

Source: Any
Destination: Any
Service: Any
Action: Deny/Drop
Options: Log enabled

## Reglas de NAT

0. Regla NAT para la red interna

Se configura NAT para que el tráfico originado en la red interna use como dirección origen la IP externa del firewall.

La red interna 172.16.43.0/24 utiliza direcciones privadas dentro de la organización. Cuando su tráfico sale por la interfaz externa del firewall, se aplica traducción de dirección origen para que los paquetes salgan con la dirección 172.16.44.1, correspondiente a la interfaz externa del firewall.

Regla conceptual de NAT:

Original Source: interna
Original Destination: Any
Original Service: Any
Translated Source: external / 172.16.44.1
Translated Destination: Original
Translated Service: Original
Interface Out: eth0
Action: Translate

1. Regla NAT para la DMZ

Se configura NAT para que el tráfico originado en la DMZ use como dirección origen la IP externa del firewall.

La red DMZ 172.16.42.0/24 también es enmascarada al salir por la interfaz externa. Esto hace que el tráfico saliente desde la DMZ aparezca con la dirección 172.16.44.1.

Regla conceptual de NAT:

Original Source: DMZ
Original Destination: Any
Original Service: Any
Translated Source: external / 172.16.44.1
Translated Destination: Original
Translated Service: Original
Interface Out: eth0
Action: Translate

## notas finales

El firewall funciona de forma stateful, por lo que las reglas permiten iniciar conexiones nuevas según la política definida, y el tráfico de respuesta correspondiente se permite como tráfico establecido o relacionado.

Por ejemplo, si una máquina interna inicia una conexión HTTP hacia un servidor permitido, el firewall permite la respuesta del servidor sin necesidad de crear una regla inversa manual.

Los servicios se definieron usando puerto de origen cualquiera y puerto de destino específico.

Por ejemplo, para HTTP se usa puerto destino 80, pero el puerto de origen queda como cualquiera. Esto se debe a que el cliente normalmente inicia la conexión usando un puerto efímero aleatorio, mientras que el servidor escucha en un puerto conocido.

Por esa razón, los objetos de servicio se configuraron con puerto de origen Any y puerto de destino según el servicio correspondiente.

