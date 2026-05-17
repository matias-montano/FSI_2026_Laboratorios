#!/usr/bin/env python3
# parse_empleados.py

import csv
import re
from html import unescape

# Si no quieres instalar BeautifulSoup, usa esta versión con regex puro
# (no requiere instalación adicional)

def parse_html_regex(html_content):
    """Versión que NO necesita BeautifulSoup - usa solo regex"""
    
    # Patrón para encontrar cada fila
    pattern = r'<TR>\s*<TD[^>]*>.*?<B>(.*?)</B>,\s*(.*?)\s*</P>\s*</TD>\s*<TD[^>]*>\s*<P>(.*?)</P>\s*</TD>\s*<TD[^>]*>\s*<P>(.*?)</P>\s*</TD>\s*</TR>'
    
    empleados = []
    
    for match in re.finditer(pattern, html_content, re.DOTALL | re.IGNORECASE):
        apellido = unescape(match.group(1).strip())
        nombre = unescape(match.group(2).strip())
        interno = unescape(match.group(3).strip())
        email = unescape(match.group(4).strip())
        
        # Limpiar
        interno = interno if interno and '&nbsp;' not in interno else ''
        email = email if email and '&nbsp;' not in email else ''
        
        # Generar username (primera letra nombre + apellido sin espacios)
        def normalize(s):
            s = s.lower()
            for a, b in [('á','a'),('é','e'),('í','i'),('ó','o'),('ú','u'),('ñ','n'),('ü','u')]:
                s = s.replace(a, b)
            return re.sub(r'[^a-z]', '', s)
        
        nombre_partes = nombre.split()
        primer_nombre = nombre_partes[0] if nombre_partes else ''
        apellido_limpio = normalize(apellido.split()[0] if apellido else '')
        username = f"{primer_nombre[0].lower() if primer_nombre else ''}{apellido_limpio}"
        
        empleados.append({
            'apellido': apellido,
            'nombre_completo': nombre,
            'username': username,
            'username_email': email.split('@')[0] if email else '',
            'interno': interno,
            'email': email,
            'has_email': bool(email)
        })
    
    return empleados

# Leer el archivo
with open('empleados.html', 'r', encoding='utf-8') as f:
    html = f.read()

# Parsear
empleados = parse_html_regex(html)

# Guardar a CSV
with open('empleados.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['apellido', 'nombre_completo', 'username', 
                                           'username_email', 'interno', 'email', 'has_email'])
    writer.writeheader()
    writer.writerows(empleados)

# Generar listas para ataques
sin_email = [e['username'] for e in empleados if not e['has_email']]
con_email = [e['username_email'] for e in empleados if e['has_email']]
internos = [e['interno'] for e in empleados if e['interno']]

with open('usuarios_sin_email.txt', 'w') as f:
    f.write('\n'.join(sin_email))

with open('usuarios_con_email.txt', 'w') as f:
    f.write('\n'.join(con_email))

with open('todos_usuarios.txt', 'w') as f:
    f.write('\n'.join(set(sin_email + con_email)))

with open('posibles_passwords_internos.txt', 'w') as f:
    for i in internos:
        f.write(f"{i}\n")
        if len(i) >= 3:
            f.write(f"{i}{i}\n")  # repetido ej: 128128
            f.write(f"2024{i}\n")  # año+interno

print(f"✅ Empleados procesados: {len(empleados)}")
print(f"📧 Con email: {len(con_email)}")
print(f"🔒 Sin email: {len(sin_email)}")
print(f"📁 Archivos generados:")
print(f"   - empleados.csv")
print(f"   - usuarios_sin_email.txt ({len(sin_email)} usuarios)")
print(f"   - usuarios_con_email.txt ({len(con_email)} usuarios)")
print(f"   - todos_usuarios.txt ({len(set(sin_email+con_email))} usuarios únicos)")
print(f"   - posibles_passwords_internos.txt ({len(internos)} números)")

# Mostrar primeros 10 sin email (los más vulnerables)
print(f"\n🎯 OBJETIVOS PRINCIPALES (usuarios SIN email):")
for i, u in enumerate(sin_email[:15], 1):
    print(f"   {i}. {u}")