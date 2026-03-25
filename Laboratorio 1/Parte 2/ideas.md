En informática, "codificar" puede referirse a varios procesos, pero normalmente significa transformar información de un formato a otro
- Cifrar un mensaje (para ocultar su contenido).
- Codificar texto (por ejemplo, en base64, uuencode, etc.) para transmitirlo de forma segura.
- Escribir código fuente (programar).

codificar archivos para enviarlos o guardarlos de forma segura (como el bloque "begin 664 ... end" que mostraste).


sudo apt-get install sharutils


----


gpg --full-generate-key
gpg (GnuPG) 2.4.4; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (3072) 
Requested keysize is 3072 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: 
Email address: 
Comment: fsi03
You selected this USER-ID:
    " (fsi03)"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: directory '/home/matias/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/home/matias/.gnupg/openpgp-revocs.d/363181601B2E961D9F75D5BE66C20289B49FFFE4.rev'
public and secret key created and signed.

pub   rsa3072 2026-03-25 [SC]
      363181601B2E961D9F75D5BE66C20289B49FFFE4
uid                       (fsi03)
sub   rsa3072 2026-03-25 [E]

----
gpg --import fsi-pub.asc

gpg --list-keys

gpg --output paracifrar.txt.gpg --encrypt --recipient "fsi@fing.edu.uy" paracifrar.txt

---




gpg --armor --output fsi03-pub.asc --export "fsi03"


---

¡Muy bien! El ID de la clave de los docentes es la línea larga debajo de su nombre:

```
pub   dsa1024 2008-03-31 [SC]
      1206991F34BE73C336167DB0D70A1DB335846E40
uid           [ unknown] Docentes FSI 2008 (GPG Fundamentos de la Seguridad Informatica) <fsi@fing.edu.uy>
```

El ID es:  
**1206991F34BE73C336167DB0D70A1DB335846E40**

Puedes usar ese ID para firmar la clave:

```sh
gpg --sign-key 1206991F34BE73C336167DB0D70A1DB335846E40
```

O también puedes usar el email:

```sh
gpg --sign-key "fsi@fing.edu.uy"
```

Ambos funcionan igual. ¿Te ayudo con algún paso más?


¡Acabas de firmar la clave pública de los docentes con tu clave del grupo!

Esto significa que:
- Estás diciendo (digitalmente) que confías en que la clave de los docentes realmente les pertenece.
- Ahora, cuando compartas tu anillo de claves, otros verán que tu grupo "avala" la autenticidad de la clave de los docentes.

Este es un paso importante en la "web de confianza" de GPG.

¿Quieres que te ayude a exportar la clave firmada o necesitas justificar este paso para el informe?


---

Se asignó confianza full (nivel 4) a la clave de los docentes porque fue distribuida oficialmente en el marco del curso y se verificó su fingerprint en la consigna/material provisto. En este contexto académico se considera una fuente confiable para firmar otras claves relacionadas con la práctica.  No se asignó nivel ultimate (5) porque ese nivel se reserva para claves propias. no se asigno 3 porque vino de un canal oficial el eva del curso

 Sí podrías poner 3 y no estaría "mal", pero cambia el significado:

3 = marginal: "confío algo en que esta persona verifica identidades, pero no del todo"


la idea es que .... como lo ovbtuvimos del eva...., que es un entorno universitario confiamos en los docentes

Si la clave de docentes vino por canal oficial del curso y su fingerprint fue verificada, 4 está mejor justificado.



----


Perfecto. Para esa parte con OpenSSL, estando en el directorio del lab, puedes hacerlo así:

### 1. Generar par de claves RSA (privada + pública)

Genera la **clave privada** (2048 o 3072 bits; 3072 está bien):

```sh
openssl genpkey -algorithm RSA -out grupo03-private.key -pkeyopt rsa_keygen_bits:3072
```

Extrae la **clave pública** desde la privada:

```sh
openssl rsa -pubout -in grupo03-private.key -out grupo03-public.pem
```

---

### 2. Generar el CSR (Certificate Signing Request)

```sh
openssl req -new -key grupo03-private.key -out grupo03.csr
```

Te va a preguntar datos como:
- Country Name
- State
- Organization
- Common Name (puedes poner `grupo03`)

Si quieres evitar preguntas interactivas, hazlo en una línea:

```sh
openssl req -new -key grupo03-private.key -out grupo03.csr -subj "/C=UY/ST=Montevideo/L=Montevideo/O=FING/OU=fsi03/CN=grupo03"
```

---

### Verificación rápida

```sh
openssl pkey -in grupo03-private.key -text -noout
openssl req -in grupo03.csr -text -noout
```

Si quieres, te paso también cómo empaquetar los archivos exactos que normalmente piden entregar (`.key`, `.pem`, `.csr`).