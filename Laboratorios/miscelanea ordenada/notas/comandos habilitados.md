Perfecto. Vamos paso a paso, **sintético y documentable**.

---

## 🗑️ 1. Borrar todo dentro de `archivos/` en el servidor

```bash
rm -rf ~/archivos/*
```

O si querés borrar el directorio entero y dejarlo limpio:

```bash
rm -rf ~/archivos
mkdir ~/archivos
```

---

## 🔍 2. Ver qué herramientas tienes instaladas

```bash
# Herramientas del lab
which john hydra nmap netcat nc sqlmap metasploit msfconsole linpeas.sh

# Versiones
john --version
hydra -h 2>&1 | head -5
nmap --version

# Lenguajes
python3 --version
python --version
python3 -c "import sys; print(sys.version)"
gcc --version
g++ --version
make --version

# Shells disponibles
cat /etc/shells

# Editores
which nano vim vi emacs
```

Si querés **listado completo** de paquetes instalados (en Debian/Ubuntu):

```bash
dpkg -l | grep -E "john|hydra|nmap|gcc|python"
```

---

## 🐍 3. ¿Puedes ejecutar Python, C u otros programas?

### Python (casi siempre sí)
```bash
python3 -c "print('Hola desde Python')"
```

### Compilar y ejecutar C
```bash
echo '#include <stdio.h>' > test.c
echo 'int main(){printf("C funciona\n");return 0;}' >> test.c
gcc test.c -o test
./test
```

### Si no hay gcc, probá con:
```bash
clang --version
tcc --version
```

### Otros lenguajes comunes en pentesting boxes:
```bash
perl -e 'print "Perl ok\n"'
ruby -e 'puts "Ruby ok"'
go version
node --version
```

---

## ⚠️ 4. ¿Solo shell? (restricted shell)

Para detectar si estás en un shell restringido:

```bash
echo $0          # muestra el shell actual
echo $SHELL      # shell por defecto
cd /tmp && pwd   # ¿puedes salir de tu home?
export PATH=$PATH:/usr/local/sbin  # ¿puedes modificar PATH?
```

Si ves `rbash` o `-r` en `echo $0` → estás restringido.

---

## 📝 5. Documentación rápida para tu informe

Creá este archivo en tu **máquina local**:

```bash
cat > ~/lab2/herramientas_attacker3.txt << 'EOF'
=== HERRAMIENTAS DISPONIBLES EN attacker-3 ===
Fecha: $(date)
Usuario: fsi03

== Pentesting ==
- John the Ripper: $(john --version 2>&1 | head -1)
- Hydra: $(hydra -h 2>&1 | grep -i "hydra" | head -1)
- Nmap: $(nmap --version 2>&1 | head -1)

== Lenguajes ==
- Python: $(python3 --version 2>&1)
- GCC: $(gcc --version 2>&1 | head -1)
- Shell: $(echo $SHELL)

== Estado ==
- ¿Restricted shell? $(if [ "$(echo $0)" = "rbash" ]; then echo "SÍ"; else echo "NO"; fi)
EOF
```

---

**Ejecutá los comandos del punto 2 y pegá la salida** para saber con certeza qué tenés disponible. Así adaptamos los ataques a lo que realmente existe en el servidor.


Excelente. Ya tenemos **información concreta** para documentar. Te ayudo a ordenarlo.

---

## ✅ 1. Resumen de herramientas disponibles en `attacker-3`

| Herramienta | Estado | Ruta |
|-------------|--------|------|
| John the Ripper | ✅ Sí | `/usr/sbin/john` |
| Hydra | ✅ Sí (v9.2) | `/usr/bin/hydra` |
| Nmap | ✅ Sí (v7.80) | `/usr/bin/nmap` |
| netcat/nc | ✅ Sí | `/usr/bin/netcat` |
| sqlmap | ❌ No | - |
| metasploit | ❌ No | - |
| linpeas.sh | ❌ No | - |

**Lenguajes:**
- Python 3.10.6 ✅ (el comando es `python3`)
- GCC ❌ No
- G++ ❌ No
- Make ❌ No

**Shells disponibles:**
- `bash` (normal)
- `rbash` (restringido, pero no es tu caso actual)

**Editores:**
- `nano`, `vim`, `vi` ✅ todos disponibles

---

## ⚠️ 2. Observación importante sobre John

El comando `john --version` no funcionó. Probá en su lugar:

```bash
john --list=formats 2>&1 | head -5
# o
/usr/sbin/john --list=buildinfo
```

Para ver la versión real:
```bash
dpkg -l | grep john
```

---

## 📝 3. Documentación para tu informe

Creá esto en tu máquina **atacante** o local:

```bash
cat > ~/archivos/herramientas_inventario.txt << 'EOF'
=== INVENTARIO attacker-3 ===
Fecha: $(date)
Usuario: fsi03

== HERRAMIENTAS OFENSIVAS ==
- John the Ripper: Instalado en /usr/sbin/john
- Hydra: v9.2 (THC)
- Nmap: v7.80
- netcat: Disponible

== CAPACIDADES ==
- Python 3.10.6: SÍ (python3)
- Compilar C: NO (gcc no instalado)
- Scripting: Bash + Python

== SHELL ==
- Actual: bash
- Shells disponibles: bash, rbash, dash

== NOTAS ==
- Sin metasploit (ataques manuales)
- Sin linpeas (habrá que hacer reconocimiento manual o transferirlo)
- Python disponible para scripts personalizados

== COMANDOS ÚTILES VERIFICADOS ==
- Escaneo: nmap -sV -sC <target>
- Fuerza bruta SSH: hydra -L users.txt -P pass.txt ssh://<target>
- Cracking local: john --wordlist=dic.txt shadow.txt
EOF

cat ~/archivos/herramientas_inventario.txt
```

---

## 🎯 4. Próximo paso: ¿Qué falta según el lab?

Con estas herramientas, puedes **completar todo el lab**:

### Parte 1 (crackear credenciales SSH) ✅ posible
- Generar usuarios desde HTML (con Python o bash)
- Hydra contra SSH

### Parte 2 (escalada de privilegios) ⚠️ sin linpeas.sh
Alternativas:
```bash
# Transferir linpeas desde tu máquina local
# En LOCAL:
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh

# En attacker-3 (si hay internet):
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o linpeas.sh
chmod +x linpeas.sh
./linpeas.sh
```

O hacer reconocimiento manual:
```bash
sudo -l
find / -perm -4000 2>/dev/null
ls -la /etc/crontab
```

### Parte 3 (PAM + 2FA) ✅ se hace en otra máquina Linux separada

---

## 📋 5. Check rápido: ¿Qué archivos tienes ahora?

```bash
ls -la ~/archivos/
```

Pegá el resultado para saber si ya tenés:
- `listadopersonal.html`
- `dic.txt`
- `usuarios.txt` (creado por vos)
- Resultados de hydra

Y seguimos ordenando.