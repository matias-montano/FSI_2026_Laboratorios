# Bitácora: Respaldo seguro de claves y práctica con GitHub (FSI)

## Contexto del problema
Durante la práctica de Fundamentos de Ciberseguridad generé pares de claves (pública/privada) y subí archivos al repositorio.  
GitHub/GitGuardian detectó exposición de clave privada con alerta tipo:

> `Generic Private Key exposed`

Esto confirma una regla básica: **aunque sea para clase, una clave privada en Git es un secreto expuesto**.

---

## Lección principal
- Las claves privadas **no se suben en claro** al repositorio.
- Si ya se subieron una vez, se consideran **comprometidas**.
- Para respaldo en GitHub, se sube un **backup cifrado**, no la clave privada directa.

---

## Duda resuelta: `gpg` vs `tar.gz`
Sí, **puedo compactar para mantener toda la estructura**.  
De hecho, la secuencia recomendada es:

1. `tar` para empaquetar directorios y conservar estructura.
2. `gpg` para cifrar el paquete.

Ejemplo:

```bash
tar -cf respaldo_lab1.tar "Laboratorio 1/"
gpg -c respaldo_lab1.tar
```

Genera: `respaldo_lab1.tar.gpg` (apto para subir a GitHub).

### ¿Y por qué a veces se usa `tar.gz` + gpg?
Porque se mezclan dos objetivos:
- `tar`: agrupar estructura.
- `gz`: comprimir.
- `gpg`: cifrar.

Pero `gpg` puede comprimir internamente, así que muchas veces `tar` + `gpg` ya es suficiente.

---

## Ventajas de `tar` + `gpg`
- Mantiene estructura de carpetas/archivos.
- Evita exponer secretos en texto plano.
- Deja un archivo único más cómodo para versionar.
- Reduce riesgo de alertas de secretos en repo.

## Limitaciones
- Git no hace diff útil de archivos cifrados.
- El binario cifrado cambia entre ejecuciones.
- Si se pierde la passphrase/llave de descifrado, se pierde el backup.

---

## Flujo recomendado (estándar personal)
1. Generar/usar claves para práctica local.
2. Excluir secretos con `.gitignore`.
3. Empaquetar carpeta sensible con `tar`.
4. Cifrar con `gpg`.
5. Subir solo el archivo cifrado (`.gpg`) al repo.
6. Guardar passphrase fuera de Git (gestor de contraseñas, medio físico seguro).

---

## `.gitignore` mínimo sugerido
```gitignore
# Claves y material sensible
*.key
*priv*.asc
*private*.key
*.pem
*.p12
*.pfx

# Archivos temporales de descifrado
*.tar
```

---

## Si ya hubo exposición en commits anteriores
1. Dejar de trackear archivos sensibles (`git rm --cached ...`).
2. Limpiar historial (`git filter-repo` o BFG).
3. Hacer `push --force` (coordinando con el equipo).
4. Revocar/rotar claves comprometidas.

---

## Conclusión
La práctica correcta no es “no usar claves”, sino **usar claves con higiene operacional**:
- en local para trabajo,
- cifradas para respaldo,
- nunca en claro dentro del historial de Git.  

Si quieres, en el siguiente paso te escribo una versión más corta “tipo resumen para examen” de esta misma nota.


----

¡Ahora sí, te entiendo!  
Te refieres a crear un archivo comprimido (por ejemplo, con `tar.gz`) y protegerlo con contraseña, pero **sin usar GPG**.  
Eso se puede hacer con herramientas como `zip` o `7z` (7-Zip), que permiten cifrado con contraseña.

### Comparación rápida

#### 1. `tar.gz` + contraseña (con `zip` o `7z`)
- Ejemplo con `zip`:
  ```bash
  zip -er respaldo.zip "Laboratorio 1/"
  ```
- Ejemplo con `7z`:
  ```bash
  7z a -p respaldo.7z "Laboratorio 1/"
  ```
- **Ventajas**:  
  - Fácil de usar, multiplataforma.
  - Puedes poner una contraseña sencilla.
- **Desventajas**:  
  - El cifrado de `zip` tradicional es débil (no uses `zip` viejo, mejor `7z` o `zip` moderno con AES).
  - Menos opciones de cifrado fuerte y gestión de llaves que GPG.

#### 2. `tar` + `gpg -c`
- Ejemplo:
  ```bash
  tar -cf respaldo.tar "Laboratorio 1/"
  gpg -c respaldo.tar
  ```
- **Ventajas**:  
  - Cifrado fuerte (AES, por defecto).
  - Herramienta estándar en seguridad.
  - Puedes usar passphrase o llaves públicas.
- **Desventajas**:  
  - Un poco más técnico.
  - Si olvidas la passphrase, no hay recuperación.

---

### ¿Cuál es más seguro?
- **GPG** es más seguro y estándar para cifrado fuerte.
- **7z** con contraseña fuerte y cifrado AES es aceptable para uso personal/grupo, pero menos robusto que GPG para gestión de secretos a largo plazo.
- **No uses zip clásico** para secretos (cifrado débil).

---

### Respaldo de claves (pública y privada)
- La clave pública **sí puedes subirla en claro** (no es secreta).
- La clave privada **siempre cifrada** (con GPG o 7z con contraseña fuerte).

---

### Resumen práctico
- Para máxima seguridad: `tar` + `gpg -c` (con passphrase).
- Para algo sencillo y compartible: `7z` con contraseña fuerte.
- Nunca uses `zip` clásico para secretos.

¿Quieres ejemplos de comandos para ambos métodos y cómo compartir con compañeros?