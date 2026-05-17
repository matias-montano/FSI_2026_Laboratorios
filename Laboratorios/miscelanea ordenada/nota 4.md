Perfecto. Ya confirmaste varias cosas importantes del reconocimiento:

* El servidor web responde correctamente.
* Hay una intranet accesible.
* Existe una política de usernames bastante consistente.
* El contenido parece reciclado/adaptado del HTML viejo del laboratorio.

Las cuentas siguen un patrón tipo:

```text
primera_letra_nombre + apellido
```

Ejemplos:

```text
Eduardo Acosta  -> eacosta
Rodolfo Acosta  -> racosta
Jorge Adrover   -> jadrover
Diego Aguirre   -> daguirre
```

Pero ojo: viste algo MUY interesante:

```text
eaosta@hackme.org
```

Eso parece typo.

Probablemente el username real sea:

```text
eacosta
```

pero el mail publicado tiene error.

Eso pasa MUCHO en labs y sistemas reales.

---

Ahora ya podés empezar una lista de usuarios válida para Hydra.

Ejemplo:

```bash id="sl3f88"
cat > usuarios.txt
```

Pegás:

```text
eacosta
racosta
jadrover
daguirre
gaguirre
halagia
games
nandrus
aandrada
```

Terminás con:

```text
CTRL+D
```

Verificás:

```bash id="xux5mv"
cat usuarios.txt
```

---

También podés extraer usuarios automáticamente del HTML.

Por ejemplo:

```bash id="7l80jv"
curl --noproxy '*' http://10.0.3.5/empleados.html | grep -oP '[a-z]+@hackme\.org' | cut -d@ -f1
```

Y guardarlo:

```bash id="qz2r7s"
curl --noproxy '*' http://10.0.3.5/empleados.html | grep -oP '[a-z]+@hackme\.org' | cut -d@ -f1 > usuarios.txt
```

Después:

```bash id="yl8f7v"
wc -l usuarios.txt
head usuarios.txt
```

Eso te deja listo para reconocimiento de credenciales en SSH usando el diccionario del lab.
