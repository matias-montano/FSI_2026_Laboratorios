¡Excelente pregunta! Te explico:

---

## ¿Por qué funcionó SIN el `.jpg`?

El sistema de archivos de Linux **no necesita la extensión** para leer un archivo. La extensión (`.jpg`, `.txt`, etc.) es solo una ayuda visual para los humanos y para que los programas sepan cómo abrirlo.

**Lo que importa es el nombre base:** `path-traversal-secret`

```
path-traversal-secret.jpg  → nombre real en el disco
path-traversal-secret      → Linux lo encuentra igual
```

---

## ¿Por qué el filtro bloqueaba con `.jpg`?

El desarrollador puso un filtro probablemente así:

```java
if (param.contains(".") || param.contains("../")) {
    // BLOQUEAR
}
```

O con una regex mal hecha:
```java
if (param.matches(".*\\..*")) {  // bloquea cualquier punto
    // BLOQUEAR
}
```

---

## Resumen de lo que pasó en este ejercicio:

| Lo que probamos | Resultado |
|-----------------|-----------|
| `id=1` | ✅ Imagen normal |
| `id=../path-traversal-secret.jpg` | ❌ Illegal characters |
| `id=%2e%2e%2f%2e%2e%2f` | ✅ Lista el directorio (sin archivo) |
| `id=%2e%2e%2f%2e%2e%2fpath-traversal-secret.jpg` | ❌ Vacío (el `.jpg` disparaba el filtro) |
| `id=%2e%2e%2f%2e%2e%2fpath-traversal-secret` | ✅ ¡ARCHIVO ENCONTRADO! |

---

## Moraleja:

Cuando hay un filtro, pensá **QUÉ está filtrando realmente**:
- Filtraba `../` → lo bypaseamos con `%2e%2e%2f`
- Filtraba `.jpg` → lo bypaseamos omitiendo la extensión
- Filtrar por puntos en general es mala idea porque rompe nombres de archivo normales

---

¿Pasamos al siguiente ejercicio o querés repasar algo más de este?