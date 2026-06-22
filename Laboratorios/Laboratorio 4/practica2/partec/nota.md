Ahora, para la parte 3 se decidio agregar dos nuevas funcionalidades:
- Leer archivo
- Crear respaldo tar.gz

y a continuacion se describe el problema que representa lo mismos

## Path Traversal 

para la primera opcion, un usuario puede ingresar el nombre del archivo que desea leer,
el tema es que, si no se 'sanitiza' la entrada, un usuario puede colcar `../` y asi
retroceder y leer carpetas diferentes al path actual, por ejemplo

```
Ingrese nombre de su archivo a leer: ../llegue.md

Contenido del archivo:
llegamos!
```

Esto es especialmente peligroso porque un usuario podría retroceder varios niveles y 
acceder a archivos sensibles del sistema como /etc/shadow o /etc/passwd, 
comprometiendo la confidencialidad del sistema.

## Command Injection

para la segunda opcion, se penso por ejemplo en un comando que hiciese un comprimido de todos los
archivos .md de la carpeta actual y permitir al usuario colocar el nombre al respaldo
como se ve en este ejemplo

```
mi_respaldo

creando respaldo de los .md del directorio actual...
Ingrese nombre del respaldo: mi_respaldo
Respaldo creado: mi_respaldo.tar.gz
```


El problema radica en que el programa construye el comando tar utilizando 
directamente la entrada del usuario sin ninguna validacion. Esto permite que un 
usuario malintencionado pueda inyectar comandos adicionales usando caracteres 
como `;`, `&&` u otros separadores de comandos, y por lo que, puede
colocar un input como:

```
aaaa ; cat /etc/passwd; fffff
```

Con lo cual, se genera el siguiente comando:

```
tar -czf aaaa ; cat /etc/passwd; fffff.tar.gz *.md
```

Y la salida sería:

```
creando respaldo de los .md del directorio actual...
Ingrese nombre del respaldo: aaaa ; cat /etc/passwd; fffff
tar: Cowardly refusing to create an empty archive
Try 'tar --help' or 'tar --usage' for more information.
root:x:0:0:root:/root:/bin/bash
.
.
.
.
libvirt-dnsmasq:x:127:133:Libvirt Dnsmasq,,,:/var/lib/libvirt/dnsmasq:/usr/sbin/nologin
sh: 1: fffff.tar.gz: not found
Respaldo creado: aaaa ; cat /etc/passwd; fffff.tar.gz
```

Aunque tar muestra un error por no encontrar archivos .md, el comando cat /etc/passwd se ejecuta exitosamente, exponiendo información sensible del sistema, demostrando lo peligroso de este metodo