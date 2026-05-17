Aquí tienes el documento completo con todo el reconocimiento que hicimos:

```markdown
# Informe de Reconocimiento - Laboratorio 2 Seguridad de Sistemas

**Autor:** Estudiante  
**Fecha:** 2026-05-17  
**Máquina atacante:** attacker-3  
**Objetivo:** Identificar máquina víctima y sus servicios para posterior ataque de fuerza bruta

---

## 1. Reconocimiento inicial - Configuración de red de la máquina atacante

### Comando ejecutado:
```bash
ip a
```

### Resultado:
```
1: lo: <LOOPBACK,UP,LOWER_UP> ... inet 127.0.0.1/8 scope host lo

2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> ... inet 192.168.44.13/25 brd 192.168.44.127 scope global ens3

3: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> ... inet 10.0.3.4/24 metric 100 brd 10.0.3.255 scope global dynamic ens4
```

### Análisis de interfaces:

| Interfaz | IP asignada | Máscara | Red | Broadcast | Rango utilizable |
|----------|-------------|---------|-----|-----------|------------------|
| `ens3` | 192.168.44.13 | /25 | 192.168.44.0/25 | 192.168.44.127 | 192.168.44.1 - 192.168.44.126 |
| `ens4` | 10.0.3.4 | /24 | 10.0.3.0/24 | 10.0.3.255 | 10.0.3.1 - 10.0.3.254 |

### Conclusiones iniciales:
- La máquina atacante tiene **dos redes** disponibles para atacar
- Red `10.0.3.0/24` tiene máscara /24 (256 hosts posibles)
- Red `192.168.44.0/25` tiene máscara /25 (solo 126 hosts posibles)

---

## 2. Descubrimiento de hosts activos

### 2.1 Escaneo con nmap a red 10.0.3.0/24

**Comando:**
```bash
nmap -sn 10.0.3.0/24
```

**Resultado:**
```
Starting Nmap 7.80 ( https://nmap.org ) at 2026-05-17 12:12 UTC
Nmap scan report for attacker-3 (10.0.3.4)
Host is up (0.00021s latency).
Nmap scan report for 10.0.3.5
Host is up (0.00063s latency).
Nmap done: 256 IP addresses (2 hosts up) scanned in 2.81 seconds
```

**Hosts encontrados:**
- `10.0.3.4` (propia máquina atacante)
- `10.0.3.5` **(posible víctima)**

### 2.2 Escaneo manual con ping a red 10.0.3.0/24

**Comando:**
```bash
for i in {1..254}; do (ping -c 1 -W 1 10.0.3.$i > /dev/null && echo "Host 10.0.3.$i está activo") & done
```

**Resultado parcial:**
```
Host 10.0.3.1 está activo
Host 10.0.3.11 está activo
Host 10.0.3.13 está activo
Host 10.0.3.12 está activo
Host 10.0.3.14 está activo
Host 10.0.3.15 está activo
Host 10.0.3.16 está activo
... (múltiples hosts activos detectados)
```

> **Nota:** El escaneo manual mostró muchos hosts activos, contrario al nmap -sn. Esto sugiere que algunos hosts responden a ping pero no al escaneo SYN de nmap (posible firewall).

### 2.3 Escaneo a red 192.168.44.0/25

**Comando correcto (no ejecutado completamente debido a error en el rango):**
```bash
for i in {1..126}; do (ping -c 1 -W 1 192.168.44.$i > /dev/null && echo "Host 192.168.44.$i activo") & done
```

**Observación:** El comando inicial usó `{1..254}` generando errores "Network is unreachable" para IPs > 126, lo cual es esperado dado que la máscara es /25.

---

## 3. Escaneo de puertos a la posible víctima

### 3.1 Escaneo rápido de puertos

**Comando:**
```bash
nmap -sT --open 10.0.3.5
```

**Resultado:**
```
Starting Nmap 7.80 ( https://nmap.org ) at 2026-05-17 12:14 UTC
Nmap scan report for 10.0.3.5
Host is up (0.00029s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE
21/tcp open  ftp
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 0.05 seconds
```

### 3.2 Escaneo con detección de versiones

**Comando:**
```bash
nmap -sT -sV --open 10.0.3.5
```

**Resultado:**
```
Starting Nmap 7.80 ( https://nmap.org ) at 2026-05-17 12:14 UTC
Nmap scan report for 10.0.3.5
Host is up (0.0011s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.5
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.52 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.35 seconds
```

---

## 4. Resumen de hallazgos

### Máquina víctima identificada:
- **IP:** `10.0.3.5`
- **Sistema Operativo:** Linux (Ubuntu)
- **Servicios expuestos:**

| Puerto | Servicio | Versión | Posible vector de ataque |
|--------|----------|---------|--------------------------|
| 21/tcp | FTP | vsftpd 3.0.5 | Fuerza bruta, vulnerabilidades conocidas |
| 22/tcp | SSH | OpenSSH 8.9p1 | **Fuerza bruta con hydra** (objetivo de la práctica) |
| 80/tcp | HTTP | Apache 2.4.52 | Enumeración web, directorios ocultos |

---

## 5. Próximos pasos según la práctica

Según el enunciado del laboratorio:

1. **Parte 1 - Crackers de contraseñas:**
   - Extraer lista de usuarios del archivo `listadopersonal.html`
   - Generar diccionario de usuarios (`usuarios.txt`)
   - Usar `hydra` para atacar SSH en `10.0.3.5`

2. **Comando propuesto para ataque SSH:**
   ```bash
   hydra -L usuarios.txt -P dic.txt ssh://10.0.3.5 -t 4 -V -o credenciales.txt
   ```

3. **Parte 2 - Escalada de privilegios:**
   - Una vez dentro, transferir `linpeas.sh` (en `/usr/share/john/linpeas.sh`)
   - Ejecutar reconocimiento local
   - Escalar a root y obtener `/root/flag.txt`

---

## 6. Herramientas disponibles en máquina atacante

| Herramienta | Ruta | Uso |
|-------------|------|-----|
| `hydra` | /usr/bin/hydra | Fuerza bruta a servicios |
| `nmap` | /usr/bin/nmap | Escaneo de puertos |
| `ssh` | /usr/bin/ssh | Cliente SSH |
| `scp` | /usr/bin/scp | Copia segura de archivos |
| `curl/wget` | /usr/bin/curl, /usr/bin/wget | Transferencia HTTP |
| `nc/netcat` | /usr/bin/nc → /etc/alternatives/nc | Conexiones de red manuales |
| `linpeas.sh` | /usr/share/john/linpeas.sh | Escalada de privilegios |

---

## 7. Notas importantes

- ⚠️ `nmap -sS` requiere root, por eso se usó `-sT` (TCP Connect)
- 🔍 La red `192.168.44.0/25` no fue completamente escaneada por error en el rango del ping
- ✅ La víctima principal está confirmada como `10.0.3.5`
- 📝 El siguiente paso es extraer usuarios del HTML y lanzar `hydra`

---

*Documento generado durante el Laboratorio 2 - Fundamentos de Seguridad Informática*
```

¿Quieres que ahora generemos la lista de usuarios a partir del `listadopersonal.html`?