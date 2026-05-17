¡Excelente pregunta! Hydra tiene **soporte nativo para pausar y reanudar**.

---

## ⏸️ Para **pausar/cortar** Hydra:

Presioná `Ctrl + C` una sola vez. Hydra automáticamente guarda el estado en un archivo `hydra.restore`.

Verás algo como:
```
^CThe session file ./hydra.restore was written. Type "hydra -R" to resume session.
```

---

## ▶️ Para **reanudar**:

```bash
hydra -R
```

Eso retoma exactamente donde lo dejaste.

---

## 📁 Si querés guardar el estado en un archivo específico:

```bash
# Al empezar, usá -O (O mayúscula) para guardar estado
hydra -L usuarios.txt -P dic.txt ftp://10.0.3.5 -t 4 -V -O hydra_mi_sesion

# Para reanudar después:
hydra -R hydra_mi_sesion
```

---

## 🛡️ Mejor práctica para labores largos:

```bash
# 1. Iniciar con -O
hydra -L usuarios.txt -P dic.txt ftp://10.0.3.5 -t 4 -V -O sesion_ftp hydra_ftp.txt

# 2. Si necesitás cortar: Ctrl+C (se guarda automáticamente)

# 3. Para reanudar:
hydra -R sesion_ftp

# 4. Cuando termine, el resultado está en hydra_ftp.txt
```

---

## 📝 Notas importantes:

- El archivo `hydra.restore` se crea en el directorio actual
- No borres `hydra.restore` si querés reanudar
- Si usás `-O nombre`, el estado se guarda en `nombre.restore`
- Al reanudar con `-R`, Hydra **no** vuelve a probar lo ya intentado

---

## ⚠️ Precaución:

Si cortás con `Ctrl+C` varias veces seguidas, puede corromperse el estado. Mejor:
1. Un solo `Ctrl+C`
2. Esperá a que termine de escribir `hydra.restore`
3. Reanudá con `hydra -R`

---

**¿Te armamos el comando completo con `-O` para que puedas cortar y reanudar tranquilo?**