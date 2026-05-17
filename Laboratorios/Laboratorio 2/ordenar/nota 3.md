Eso ya da una pista importante.

El problema NO es la víctima.
El problema es que la VM atacante tiene configurada una variable proxy rota:

```bash
Could not resolve proxy: proxy.fing.edu.uy
```

Entonces `curl` intenta salir por un proxy inexistente incluso para tráfico interno.

Probá ver las variables:

```bash
env | grep -i proxy
```

Seguramente aparezca algo como:

```bash
http_proxy=http://proxy.fing.edu.uy:3128
https_proxy=http://proxy.fing.edu.uy:3128
```

Para desactivarlas temporalmente:

```bash
unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY
```

Y después:

```bash
curl -I http://10.0.3.5
```

o:

```bash
curl http://10.0.3.5
```

También podés hacerlo en una sola línea:

```bash
curl --noproxy "*" http://10.0.3.5
```

---

Lo de `nikto` es normal: no está instalado y no tenés sudo.

Para labs muchas veces alcanza con:

```bash
curl
wget
nmap
gobuster
dirb
lynx
```

Probá además:

```bash
nmap -sV -Pn 10.0.3.5
```

para identificar:

* versión Apache/nginx
* puertos
* banners
* servicios

Y si HTTP responde:

```bash
wget http://10.0.3.5
ls
cat index.html
```

Eso ya te deja empezar reconocimiento web serio.
