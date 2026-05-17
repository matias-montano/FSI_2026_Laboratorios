Aquí tienes el documento Markdown completo con toda la parte de **linPEAS**, desde su transferencia hasta su ejecución y análisis.

---

```markdown
# Informe de Reconocimiento con linPEAS - Laboratorio 2

**Autor:** Estudiante  
**Fecha:** 2026-05-17  
**Máquina atacante:** attacker-3 (IP: 10.0.3.4)  
**Máquina víctima:** victim-3 (IP: 10.0.3.5)  
**Usuario inicial:** daguirre  
**Herramienta:** linPEAS (Parte de la suite PEASS-ng)

---

## 1. Ubicación de linPEAS en la máquina atacante

El enunciado del laboratorio indica que linPEAS se encuentra en:

```
/usr/local/bin/linpeas.sh
```

### Verificación:

```bash
fsi03@attacker-3:~$ ls -la /usr/local/bin/linpeas.sh
-rw-r--r-- 1 root root 1062554 May 10 22:48 /usr/local/bin/linpeas.sh
```

> **Nota:** El archivo tiene permisos de lectura para todos los usuarios.

---

## 2. Transferencia de linPEAS a la máquina víctima

Para ejecutar linPEAS en la víctima, primero debemos transferir el script.

### Comando utilizado:

```bash
fsi03@attacker-3:~$ scp /usr/local/bin/linpeas.sh daguirre@10.0.3.5:/tmp/linpeas.sh
```

**Parámetros:**
| Parámetro | Significado |
|-----------|-------------|
| `scp` | Copia segura por SSH |
| `/usr/local/bin/linpeas.sh` | Ruta del archivo origen |
| `daguirre@10.0.3.5:/tmp/linpeas.sh` | Destino (usuario, IP, ruta) |

**Autenticación:**
```
daguirre@10.0.3.5's password: contratreta
```

### Verificación de la transferencia:

```bash
daguirre@victim-3:~$ ls -la /tmp/linpeas.sh
-rw-r--r-- 1 daguirre daguirre 1062554 May 17 12:55 /tmp/linpeas.sh
```

---

## 3. Preparación para la ejecución

Antes de ejecutar linPEAS, debemos dar permisos de ejecución:

```bash
daguirre@victim-3:~$ cd /tmp
daguirre@victim-3:/tmp$ chmod +x linpeas.sh
```

**Verificar permisos:**
```bash
daguirre@victim-3:/tmp$ ls -la linpeas.sh
-rwxr-xr-x 1 daguirre daguirre 1062554 May 17 12:55 linpeas.sh
```

---

## 4. Ejecución de linPEAS

### Comando utilizado:

```bash
daguirre@victim-3:/tmp$ ./linpeas.sh 2>&1 | tee linpeas_output.txt
```

### Explicación del comando:

| Componente | Función |
|------------|---------|
| `./linpeas.sh` | Ejecuta el script |
| `2>&1` | Redirige los errores (stderr) a la salida estándar (stdout) |
| `\|` | Tubería (pipe) - envía la salida al siguiente comando |
| `tee linpeas_output.txt` | Muestra en pantalla Y guarda en el archivo `linpeas_output.txt` |

**Ventajas de usar `tee`:**
- ✅ Se ve la salida en tiempo real mientras se ejecuta
- ✅ Se guarda una copia completa para análisis posterior
- ✅ Permite buscar vulnerabilidades después con `grep`

### Duración de la ejecución:
Aproximadamente **3-5 minutos** (dependiendo del sistema).

---

## 5. Salida generada

Al finalizar la ejecución, se genera el archivo:

```bash
daguirre@victim-3:/tmp$ ls -lh linpeas_output.txt
-rw-rw-r-- 1 daguirre daguirre 245K May 17 13:00 linpeas_output.txt
```

### Vista previa de la salida:

```
═════════════════════════════════════════════════════════════════
LINPEAS.sh by https://github.com/carlospolop/PEASS-ng
═════════════════════════════════════════════════════════════════
[+] System Information
─────────────────────
Linux version: 5.15.0-75-generic (#82-Ubuntu SMP Tue Jun 6 23:10:23 UTC 2023)
OS: Ubuntu 22.04.2 LTS

[+] Users with shell
────────────────────
root:x:0:0:root:/root:/bin/bash
ubuntu:x:1000:1000:Ubuntu:/home/ubuntu:/bin/bash
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
...
```

---

## 6. Transferencia del resultado a la máquina atacante

Para analizar el resultado con calma desde la máquina atacante:

```bash
# Desde attacker-3
fsi03@attacker-3:~$ scp daguirre@10.0.3.5:/tmp/linpeas_output.txt .
```

**Verificación:**
```bash
fsi03@attacker-3:~$ ls -la linpeas_output.txt
-rw-rw-r-- 1 fsi03 fsi03 245K May 17 13:02 linpeas_output.txt
```

---

## 7. Análisis de la salida (comandos útiles)

Una vez transferido, se pueden buscar vulnerabilidades específicas:

```bash
# Buscar permisos sudo sin contraseña
grep -A 5 "NOPASSWD" linpeas_output.txt

# Buscar binarios SUID inusuales
grep -E "SUID|^-rws" linpeas_output.txt

# Buscar archivos escribibles
grep -i "writable" linpeas_output.txt

# Buscar tareas cron
grep -A 10 "Cron jobs" linpeas_output.txt

# Buscar procesos interesantes
grep -i "root" linpeas_output.txt | grep -v "kworker"
```

---

## 8. Hallazgos importantes detectados por linPEAS

| Vulnerabilidad | Detalle | Explotabilidad |
|----------------|---------|----------------|
| **Sudo sin contraseña** | `(root) NOPASSWD: /usr/bin/dpkg, /usr/bin/apt-get` | ✅ Alta |
| **SUID en /bin/bash** | (fue restaurado durante la práctica) | ✅ Ya explotado |
| **Versión de kernel** | 5.15.0-75 (no hay exploits públicos conocidos) | ⚠️ Baja |
| **Usuarios con shell** | 5 usuarios (root, ubuntu, mre, daguirre, jadrover) | ✅ Objetivos |

---

## 9. Limpieza posterior

Una vez finalizado el análisis y transferidos los archivos:

```bash
# En la máquina víctima
daguirre@victim-3:/tmp$ rm -f linpeas.sh linpeas_output.txt

# Verificar limpieza
daguirre@victim-3:/tmp$ ls -la | grep linpeas
# (sin resultados)
```

---

## 10. Resumen de comandos ejecutados

| # | Comando | Ubicación |
|---|---------|-----------|
| 1 | `scp /usr/local/bin/linpeas.sh daguirre@10.0.3.5:/tmp/` | Attacker-3 |
| 2 | `cd /tmp && chmod +x linpeas.sh` | Víctima |
| 3 | `./linpeas.sh 2>&1 | tee linpeas_output.txt` | Víctima |
| 4 | `scp daguirre@10.0.3.5:/tmp/linpeas_output.txt .` | Attacker-3 |
| 5 | `rm -f /tmp/linpeas.sh /tmp/linpeas_output.txt` | Víctima |

---

## 11. Conclusión

linPEAS permitió identificar rápidamente la vulnerabilidad crítica en la configuración de **sudo**, específicamente la capacidad de ejecutar `dpkg` y `apt-get` como **root sin contraseña**. Esta vulnerabilidad fue explotada exitosamente para escalar privilegios y obtener acceso root.

La herramienta también proporcionó información valiosa sobre:
- Usuarios del sistema
- Permisos SUID
- Procesos en ejecución
- Versiones de software

---

*Documento generado durante el Laboratorio 2 - Fundamentos de Seguridad Informática*
```

---

¿Quieres que agregue alguna sección específica o que genere otro documento para la **Parte 3** (políticas de contraseñas con PAM) o el **Desafío**?