# Parte 3

En esta parte configuramos un entorno con una maquina virtual, en este caso descargamos de osboxes.org ubuntu oracular oriole 24.10

podemos ver el SO de la maquina virutal:

````
osboxes@osboxes:~$cat /etc/os-release
PRETTY_NAME="Ubuntu 24.10"
NAME="Ubuntu"
VERSION_ID="24.10"
VERSION="24.10 (Oracular Oriole)"
VERSION_CODENAME=oracular
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=oracular
LOGO=ubuntu-logo
osboxes@osboxes:~$
````


Primero instalamos las librerias necesarias con:

```bash
sudo apt update
sudo apt install -y libpam-passwdqc libpam-google-authenticator
```

donde `libpam-passwdqc` es para reforzar contrasena y `libpam-google-authenticator` es apra el 2FA

## mejorar contrasena

enotnces ahora hacemos:
```
sudo nano /etc/pam.d/common-password
```

y modificamos la linea

```
password        requisite         pam_passwdqc.so
```

por

```
password requisite pam_passwdqc.so min=disabled,19,19,15,12 retry=4 match=4 similar=deny enforce=everyone 
```

para esta parte se consulto 

```
man passwdqc.conf
```

y en el mismo hablaba que el parametro `min` para setear el minimo de caracteres, acepta como parametro un array, y este aray representa la cantidad de clases necesarias (siendo algunas de estas clases mayúsculas, minúsculas, dígitos y caracteres especiales ), es decir `min=N0,N1,N2,N3,N4` y seria:
- N0: representa la cantidad de caracteres minimos para las contrasenas de 1 sola clase
- N1: representa la cantidad de caracteres minimos para las contrasenas con 2 clases
- N2: representa la cantidad de caracteres minimos para las passphrase, que, son contrasenas de la forma `arvejas francia harlequin impresora`, es decir, con 2 clases (que son los espacio y letra)
- N3: representa la cantidad de caracteres minimos para las contrasenas con 3 clases
- N4: representa la cantidad de caracteres minimos para las contrasenas con 4 clases o mas

y para cumplir los requisitos de seguridad impusimos:
```
password requisite pam_passwdqc.so min=disabled,19,19,15,12 passphrase=0 retry=4 match=4 similar=deny
```

- Si tiene entre 12 y 14 caracteres, debe usar las 4 clases 
- Si tiene entre 15 y 18 caracteres, debe usar al menos 3 de esas clases
- Si tiene 19 o más caracteres, alcanza con 2 clases
- Usar una sola clase nunca está permitido, sin importar el largo

Despues aparecen otras opciones que hacen:
- retry=4: se da hasta 4 oportunidades para ingresar una válida antes de cancelar el cambio.
- match=4: se busca si la contraseña contiene partes del nombre de usuario u otra información del sistema. Detecta substrings de 4 o más caracteres
- similar=deny: La nueva contraseña no puede parecerse demasiado a la que el usuario tenía antes, mira si contiene una porción suficientemente larga

y despues se hizo pruebas

Menos de 12 con una clase
```bash
passwd
# Nueva: 123
BAD PASSWORD: The password is shorter than 8 characters
```

Menos de 12 de dos clase
```bash
passwd
# Nueva: abcd1234
BAD PASSWORD: The password fails the dictionary check - it is too simplistic/systematic
```

15 caracteres con 3 clases
```bash
passwd
# Nueva: p2qwer23Sds1cxv
passwd: password updated successfully
```

12 caracteres con 4 clases
```bash
passwd
# Nueva: p2q&*wer23Sd
passwd: password updated successfully
```

# colcoar el 2FA en el sistema

ejecutamos:
```bash
sudo nano /etc/pam.d/common-auth
```

modificando common-auth, que es un archivo que cuando login,ssh,sudo, lo incluyen con `@include common-auth`, y adentro se coloca al principio:

```
auth required pam_google_authenticator.so 
```

y luego solicitamos para agregar a nuestro usuario:
```bash
google-authenticator
```

Esto genera un QR para escanear con cualquier app TOTP (Google Authenticator, Authy, etc.) o tambien se puede colocar un codigo directamente, asi se colcoa en una aplicacion como keepax


```
Do you want authentication tokens to be time-based (y/n) y
Warning: pasting the following URL into your browser exposes the OTP secret to Google:
  https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/osboxes@osboxes%3Fsecret%3D4C7H6CUB5WV7PIU2DN6GFKBE34%26issuer%3Dosboxes
  
Your new secret key is: 4C7H6CUB5WV7PIU2DN6GFKBE34
Enter code from app (-1 to skip): 960375
Code confirmed
Your emergency scratch codes are:
  42837524
  16266977
  41530755
  42083533
  48716730

Do you want me to update your "/home/osboxes/.google_authenticator" file? (y/n) y

Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, a new token is generated every 30 seconds by the mobile app.
In order to compensate for possible time-skew between the client and the server,
we allow an extra token before and after the current time. This allows for a
time skew of up to 30 seconds between authentication server and client. If you
experience problems with poor time synchronization, you can increase the window
from its default size of 3 permitted codes (one previous code, the current
code, the next code) to 17 permitted codes (the 8 previous codes, the current
code, and the 8 next codes). This will permit for a time skew of up to 4 minutes
between client and server.
Do you want to do so? (y/n) N

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting? (y/n) y
```


a continuacion se explica las opciones:

- `Do you want authentication tokens to be time-based?`: esto es para setear el tipo de 2FA, ya sea Y con TOTP, donde el código cambia cada 30 segundos, o N con HOTP, el código cambia solo al usarlo (contador). Lo recomendable es el Y

- `Do you want me to update your ~/.google_authenticator file?`: esto es para modificar el archivo, se debe presionar Y, sin esto no se guarda la configuracion.

- `Do you want to disallow multiple uses of the same authentication token?`: aca la idea es que con el Y cada código de 30s solo se puede usar una vez, para prevenir ataques de replay, mientras que N permite que el mismo código puede usarse varias veces en esos 30s. Marcaremos Y por ser mas seguro

- `Do you want to increase the window...`: en este caso Y acepta códigos de hasta 4 minutos antes/después, y N solo acepta ±30 segundos. notar que en este caso es mas seguro el N.

- `Do you want to enable rate-limiting?`: con Y hay un máximo 3 intentos cada 30s. Frena ataques de fuerza bruta, con N hay intentos ilimitados, es buena práctica setearlo con Y.

ademas hay unos codigos de emenrgencia que se entregan:
```
Your emergency scratch codes are:
  42837524
  16266977
  41530755
  42083533
  48716730
```

Estos son códigos de emergencia de un solo uso, que no se comparten, sirven para cunado uno no tiene acceso a la aplicacion que le da el TOTP, entonces en vez del código de 6 dígitos, se usa uno de los anteriores,RECORDAR que cada uno se puede usar una sola vez, para poder acceder y hacer cambios de emergencia (por ejemplo como ya se dijo en caso de pérdida del dispositivo y luego configurar nuevamente el 2FA con un nuevo secreto), notar que estos codigos se necesita guardarlos en un lugar seguro, preferentemenet separado de donde este la app de TOTP. Esto es considerado una buena practica

Otra buena practica es que, si esta en un servidor, sincronizar la hora del dispositivo y del servidor (prefeiblemente mediante un protocolo como NTP) para evitar problemas con TOTP.
