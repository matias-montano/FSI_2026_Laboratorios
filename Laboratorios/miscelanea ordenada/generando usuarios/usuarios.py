#!/usr/bin/env python3
"""
Generador de usernames - Versión simple y directa
"""

import re
import html
from unicodedata import normalize

def limpiar(texto):
    """Limpia texto: quita HTML, normaliza, convierte a ASCII"""
    if not texto:
        return ""
    # Decodificar entidades HTML
    texto = html.unescape(texto)
    # Quitar etiquetas HTML
    texto = re.sub(r'<[^>]+>', '', texto)
    # Normalizar y quitar acentos
    texto = normalize('NFKD', texto).encode('ASCII', 'ignore').decode('ASCII')
    # Limpiar caracteres no deseados
    texto = re.sub(r'[^a-zA-Z\s\.\,\-]', '', texto)
    return texto.strip()

def main():
    print("[*] Leyendo empleados.html...")
    
    with open('empleados.html', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extraer todas las filas de la tabla (cada TR)
    # Buscar desde <TBODY> hasta </TBODY>
    tbody_match = re.search(r'<TBODY>(.*?)</TBODY>', content, re.DOTALL | re.IGNORECASE)
    if not tbody_match:
        print("[!] No se encontró TBODY")
        return
    
    tbody = tbody_match.group(1)
    
    # Dividir por filas (cada <TR>)
    rows = re.findall(r'<TR>(.*?)</TR>', tbody, re.DOTALL | re.IGNORECASE)
    
    print(f"[*] Se encontraron {len(rows)} filas")
    
    empleados = []
    
    for row in rows:
        # Extraer las celdas <TD>
        celdas = re.findall(r'<TD[^>]*>(.*?)</TD>', row, re.DOTALL | re.IGNORECASE)
        
        if len(celdas) < 3:
            continue
        
        nombre_celda = celdas[0]
        email_celda = celdas[2]
        
        # Limpiar nombre
        nombre_limpio = limpiar(nombre_celda)
        if not nombre_limpio:
            continue
        
        # Buscar email
        email_match = re.search(r'([a-z]+@hackme\.org)', email_celda, re.IGNORECASE)
        email = email_match.group(1).replace('@hackme.org', '') if email_match else ""
        
        # Extraer apellido y nombre del formato "APELLIDO, Nombre"
        if ',' in nombre_limpio:
            apellido, nombre = nombre_limpio.split(',', 1)
            apellido = apellido.strip().lower()
            nombre = nombre.strip().lower()
        else:
            apellido = nombre_limpio.lower()
            nombre = ""
        
        # Extraer primer nombre
        primer_nombre = nombre.split()[0] if nombre else ""
        
        empleados.append({
            'nombre': primer_nombre,
            'apellido': apellido,
            'email': email,
            'raw': nombre_limpio
        })
    
    print(f"[*] Empleados procesados: {len(empleados)}")
    
    # Generar variaciones de usernames
    usuarios = set()
    
    for emp in empleados:
        n = emp['nombre']
        a = emp['apellido']
        e = emp['email']
        
        if not a:
            continue
        
        # Reglas de generación
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
        
        # Siempre agregar apellido solo
        usuarios.add(a)
        
        # Agregar nombre si existe
        if n:
            usuarios.add(n)
        
        # Agregar email si existe (puede tener typos)
        if e:
            usuarios.add(e)
            # Corregir typo específico
            if e == 'eaosta':
                usuarios.add('eacosta')
            if e == 'games':
                usuarios.add('lames')
                usuarios.add('lucasames')
            if e == 'nandrus':
                usuarios.add('nandruskiewitsch')
    
    # Agregar usuarios sospechosos (trampas típicas)
    sospechosos = [
        'root', 'admin', 'administrador', 'administrator', 'sysadmin',
        'test', 'testing', 'user', 'default', 'guest', 'backup',
        'hackme', 'empresa', 'hackme2024', 'hackme2025',
        'webadmin', 'itadmin', 'support', 'info', 'webmaster',
        'postgres', 'mysql', 'apache', 'www-data', 'ftp', 'anonymous',
        'nobody', 'daemon', 'bin', 'sync', 'halt', 'mail', 'lp'
    ]
    usuarios.update(sospechosos)
    
    # Ordenar
    usuarios_ordenados = sorted([u for u in usuarios if u and len(u) >= 3])
    
    # Guardar archivos
    with open('usuarios.txt', 'w') as f:
        for u in usuarios_ordenados:
            f.write(f"{u}\n")
    
    print(f"\n[+] Total usuarios generados: {len(usuarios_ordenados)}")
    print("\n[*] Primeros 50 usuarios:")
    for i, u in enumerate(usuarios_ordenados[:50], 1):
        print(f"    {i:3}. {u}")
    
    # Mostrar algunos empleados procesados como ejemplo
    print("\n[*] Ejemplos de empleados procesados:")
    for emp in empleados[:10]:
        print(f"    Nombre: {emp['nombre']:12} Apellido: {emp['apellido']:15} Email: {emp['email']}")

if __name__ == "__main__":
    main()