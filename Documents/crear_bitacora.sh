#!/bin/bash

read -p "Ingrese el nombre de la bitácora: " nombre
fecha=$(date +"%Y_%m_%d_%H_%M")
archivo="bitacora_${fecha}_${nombre}.md"

touch "$archivo"
echo "Bitácora creada: $archivo"