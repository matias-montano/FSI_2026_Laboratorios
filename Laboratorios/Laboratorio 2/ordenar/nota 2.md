Sí. Guardalo como por ejemplo `notas.md`.

````md
# Notas Lab Seguridad - Reconocimiento Web

## Recurso roto encontrado

En el HTML aparece:

```html
<IMG SRC="htslogo.jpg">
````

La imagen no renderiza.

---

## Posibles interpretaciones

### 1. El archivo no existe

Posibilidades:

* El HTML fue movido
* El recurso quedó olvidado
* La estructura original cambió

Esto puede revelar paths antiguos o estructura previa del sitio.

---

### 2. El path relativo está roto

El HTML espera:

```text
./htslogo.jpg
```

Si el HTML se abrió desde otro directorio local, la imagen no aparece.

Comando útil:

```bash
find . -name "htslogo.jpg"
```

---

### 3. El servidor web podría tener el archivo

Si el HTML fue descargado localmente, el recurso puede seguir disponible en el servidor.

Probar:

```bash
curl -I http://10.0.x.5/htslogo.jpg
```

o desde navegador:

```text
http://10.0.x.5/htslogo.jpg
```

Posibles hallazgos:

* directory listing habilitado
* assets olvidados
* backups
* nombres internos
* versiones viejas

---

## Metadata e información oculta

Si se obtiene la imagen:

```bash
exiftool htslogo.jpg
strings htslogo.jpg
```

Buscar:

* metadata
* usernames
* nombres reales de empresa
* software utilizado

---

## Enumeración web

Realizar fuzzing/directories:

```bash
gobuster dir -u http://10.0.x.5 -w /usr/share/wordlists/dirb/common.txt
```

o:

```bash
dirb http://10.0.x.5
```

Buscar especialmente:

* /admin
* /staff
* /test
* backups
* .bak
* .old

---

## Posible valor del nombre “HTS”

“HTS” probablemente sea:

* nombre de empresa
* acrónimo interno

Puede reutilizarse en:

* passwords
* usernames
* hostnames
* banners SSH

Ejemplos posibles:

```text
HTS2024
hts123
WelcomeHTS
```

---

## Indicadores de archivos legacy

El HTML parece exportado desde OpenOffice 2007.

Posibles archivos auxiliares:

* .bak
* .old
* .tmp
* .swp
* .~lock

Buscar con:

```bash
find . | grep -Ei 'bak|old|tmp|swp|lock'
```

---

## Observación importante

Los recursos rotos suelen ser pivots útiles en:

* labs educativos
* CTFs
* pentests reales

Pueden revelar estructura, tecnología, naming interno o archivos olvidados.

```
```
