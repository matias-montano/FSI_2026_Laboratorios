# Herramientas de Pentesting - Máquina Atacante (attacker-3)

**Fecha de reconocimiento:** 2026-05-17  
**Sistema Operativo:** Ubuntu 22.04.2 LTS  
**Kernel:** GNU/Linux 5.15.0-75-generic x86_64  
**IPs asignadas:** 192.168.44.13 / 10.0.3.4

---

## 📦 Herramientas disponibles en `/usr/bin/`

| Herramienta | Ruta | Tamaño | Fecha | Descripción |
|-------------|------|--------|-------|-------------|
| `curl` | /usr/bin/curl | 260328 | Mar 14 2023 | Transferencia de datos por URL |
| `hydra` | /usr/bin/hydra | 361520 | Ene 31 2022 | Ataque de fuerza bruta a servicios de red |
| `nc` (netcat) | /usr/bin/nc → /etc/alternatives/nc | symlink | Jun 16 2023 | Lectura/escritura por red (el "navaja suiza") |
| `netcat` | /usr/bin/netcat → /etc/alternatives/netcat | symlink | Jun 16 2023 | Netcat (enlace alternativo) |
| `nmap` | /usr/bin/nmap | 3026896 | Ene 12 2023 | Escáner de puertos y reconocimiento de red |
| `scp` | /usr/bin/scp | 133720 | Nov 23 2022 | Copia segura de archivos por SSH |
| `ssh` | /usr/bin/ssh | 846888 | Nov 23 2022 | Cliente SSH para acceso remoto seguro |
| `wget` | /usr/bin/wget | 527376 | Ene 24 2022 | Descarga de archivos por HTTP/HTTPS/FTP |

> **Nota:** No se encontraron `john`, `zip2john` ni `sqlmap` en `/usr/bin/`

---

## 📁 Directorios de recursos

### `/usr/share/hydra/`
- `dpl4hydra_local.csv` - Diccionario/lista para Hydra

### `/usr/share/john/`
| Archivo | Descripción |
|---------|-------------|
| `ascii.chr` | Character set para ataques de fuerza bruta (caracteres ASCII) |
| `cronjob` | Posible script o configuración de cron |
| `digits.chr` | Character set de dígitos (0-9) |
| `lm_ascii.chr` | Character set para hashes LM (Windows legacy) |
| `password.lst` | Diccionario de contraseñas común |
| `linpeas.sh` | **Script de reconocimiento para escalada de privilegios** (PEASS-ng) |

### `/usr/local/bin/`
- Vacío (no hay herramientas adicionales)

---

## 🛠️ Herramientas disponibles pero verificadas

Aunque `john` no está en `/usr/bin`, se encontró su directorio en `/usr/share/john/` con scripts y configuraciones. Esto sugiere que `john` podría estar disponible con otro nombre o ruta.

### Comando de verificación adicional sugerido:
```bash
find /usr -name "*john*" -type f 2>/dev/null
which john
john --help