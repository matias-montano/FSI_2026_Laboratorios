tenemos que preguntar

"¿La Parte 3 (configuración de políticas de contraseñas y 2FA) se hace en la máquina víctima, en la máquina atacante, o en una máquina Linux aparte (ej: mi propia VM)?"


> asumiremos root


----



primera parte es política de contraseñas

para eso vemos el SO que tenemos

````
bash-5.1# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.2 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.2 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
bash-5.1# 
````


y ahora... usando una maquina con ese SO
descargamos:

```
~ ▓▒░ apt download libpam-passwdqc libpam-google-authenticator                                                      ░▒▓ ✔ │ 12:28:37 

Get:1 http://archive.ubuntu.com/ubuntu noble/universe amd64 libpam-google-authenticator amd64 20191231-2build1 [46.8 kB]
Get:2 http://archive.ubuntu.com/ubuntu noble/universe amd64 libpam-passwdqc amd64 2.0.3-1build1 [15.8 kB]
Fetched 62.6 kB in 0s (163 kB/s)     
```


y luego movimos con scp a la maquina de daguirre

````
scp ~/archivos/libpam-passwdqc_2.0.3-1build1_amd64.deb daguirre@10.0.3.5:/tmp/
scp ~/archivos/libpam-google-authenticator_20191231-2build1_amd64.deb daguirre@10.0.3.5:/tmp/
daguirre@10.0.3.5's password: 
libpam-passwdqc_2.0.3-1build1_amd64.deb                                                              100%   15KB   9.2MB/s   00:00    
daguirre@10.0.3.5's password: 
libpam-google-authenticator_20191231-2build1_amd64.deb
````

y se instala con root

```
-bash-5.1$ # Forzar instalación ignorando dependencias
sudo dpkg --force-depends -i /tmp/libpam-passwdqc_2.0.3-1build1_amd64.deb
sudo dpkg --force-depends -i /tmp/libpam-google-authenticator_20191231-2build1_amd64.deb
(Reading database ... 65123 files and directories currently installed.)
Preparing to unpack .../libpam-passwdqc_2.0.3-1build1_amd64.deb ...
Unpacking libpam-passwdqc:amd64 (2.0.3-1build1) over (2.0.3-1build1) ...
dpkg: libpam-passwdqc:amd64: dependency problems, but configuring anyway as you requested:
 libpam-passwdqc:amd64 depends on libpasswdqc1 (>= 2.0.0); however:
  Package libpasswdqc1 is not installed.

Setting up libpam-passwdqc:amd64 (2.0.3-1build1) ...
Processing triggers for man-db (2.10.2-1) ...
(Reading database ... 65123 files and directories currently installed.)
Preparing to unpack .../libpam-google-authenticator_20191231-2build1_amd64.deb ...
Unpacking libpam-google-authenticator (20191231-2build1) over (20191231-2build1) ...
dpkg: libpam-google-authenticator: dependency problems, but configuring anyway as you requested:
 libpam-google-authenticator depends on libc6 (>= 2.38); however:
  Version of libc6:amd64 on system is 2.35-0ubuntu3.1.
 libpam-google-authenticator depends on libqrencode4; however:
  Package libqrencode4 is not installed.

Setting up libpam-google-authenticator (20191231-2build1) ...
Processing triggers for man-db (2.10.2-1) ...
-bash-5.1$ 
```

una v3ez instalado:

```
-bash-5.1$ ls -la /usr/lib/x86_64-linux-gnu/security/ | grep -E "passwdqc|google"
-rw-r--r--  1 root root   1037 Apr 22  2024 pam_google_authenticator.la
-rw-r--r--  1 root root  43504 Apr 22  2024 pam_google_authenticator.so
-rw-r--r--  1 root root  22520 Apr 22  2024 pam_passwdqc.so
-bash-5.1$ 
```

enotnces ahora hago:
```
nano /etc/pam.d/common-password
```

y modifico la linea

```
password        requisite         pam_passwdqc.so
```

por

```
password requisite pam_passwdqc.so min=disabled,19,disabled,15,12 retry=4 similar=deny enforce=users
```

O sea:

12–14 caracteres → obligatoriamente 4 clases
15–18 → mínimo 3 clases
19+ → mínimo 2 clases

y despues se hizo pruebas


```bash
passwd daguirre
# Nueva: solosolos
# Error: BAD PASSWORD: it does not contain enough character classes
# falla  (1 clase - solo minúsculas)
```

### ❌ Debe fallar (2 clases - minúsculas + dígitos, pero menos de 19 caracteres)
```bash
passwd daguirre
# Nueva: abcd1234
# Error: BAD PASSWORD: it is too short (needs 19 chars for 2 classes)
```

### ✅ Debe funcionar (3 clases, 15+ caracteres)
```bash
passwd daguirre
# Nueva: Abc123Def456Ghi
# Result: password updated successfully
```

### ✅ Debe funcionar (4 clases, 12+ caracteres)
```bash
passwd daguirre
# Nueva: Abc123!Def456
# Result: password updated successfully
```

---

## 🔄 Restaurar la contraseña original

Después de las pruebas, vuelve a dejar la contraseña original (`contratreta`):

```bash
passwd daguirre
# Nueva: contratreta
```

**⚠️ Pero ojo:** `contratreta` tiene 11 caracteres, 2 clases (minúsculas + dígitos). Con tu política actual (`min=disabled,19,15,12,12`), **no cumpliría** porque:
- 2 clases requiere 19+ caracteres
- 11 caracteres es muy corto

---

## 💡 Si `contratreta` no cumple la política

No podrás volver a ponerla. Entonces:

### Opción 1: Elegir una nueva contraseña que SÍ cumpla

```bash
# Ejemplo que cumple (4 clases, 12+ chars)
Nueva: Contratreta2024!
```

### Opción 2: Deshabilitar temporalmente la política (solo para pruebas)

```bash
# Comentar la línea de passwdqc
nano /etc/pam.d/common-password
# Poner # al principio de la línea
# password requisite pam_passwdqc.so ...
```

Luego cambias a `contratreta`, y después vuelves a activar la línea.

---

## 🎯 Resumen de prueba

| Paso | Comando | Resultado esperado |
|------|---------|-------------------|
| 1 | `passwd daguirre` | Inicia cambio |
| 2 | Probar "solos" | ❌ Error (1 clase) |
| 3 | Probar "abcd1234" | ❌ Error (2 clases, corta) |
| 4 | Probar "Abc123Def456Ghi" | ✅ Éxito (3 clases, 15 chars) |
| 5 | Probar "Abc123!Def456" | ✅ Éxito (4 clases, 12 chars) |
| 6 | Restaurar contraseña válida | ✅ Éxito |

---

**¿Ejecutamos la prueba con `passwd daguirre`?** Prueba una contraseña que cumpla y me dices el resultado.













-----------------------------



cat /etc/os-release


~ ▓▒░ cat /etc/os-release                                                                                           ░▒▓ ✔ │ 13:24:25 
───────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
       │ File: /etc/os-release
───────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ PRETTY_NAME="Ubuntu 24.04.3 LTS"
   2   │ NAME="Ubuntu"
   3   │ VERSION_ID="24.04"
   4   │ VERSION="24.04.3 LTS (Noble Numbat)"
   5   │ VERSION_CODENAME=noble
   6   │ ID=ubuntu
   7   │ ID_LIKE=debian
   8   │ HOME_URL="https://www.ubuntu.com/"
   9   │ SUPPORT_URL="https://help.ubuntu.com/"
  10   │ BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
  11   │ PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
  12   │ UBUNTU_CODENAME=noble
  13   │ LOGO=ubuntu-logo
───────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

 ~ ▓▒░                                                                                                               ░▒▓ ✔ │ 13:25:43 



instalar paquetes

```
# Actualizar lista de paquetes
sudo apt update

# Instalar módulos PAM
sudo apt install -y libpam-passwdqc libpam-google-authenticator

```


Módulos PAM ya presentes
Módulo	Archivo	Estado
Política de contraseñas	pam_pwquality.so	✅ Activo
Política de contraseñas	pam_passwdqc.so	✅ Activo
2FA	pam_google_authenticator.so	✅ Instalado




```
# 1. Configurar PAM para SSH
sudo nano /etc/pam.d/sshd
# Agregar al principio: auth required pam_google_authenticator.so

# 2. Configurar SSH
sudo nano /etc/ssh/sshd_config
# Asegurar: ChallengeResponseAuthentication yes
#           UsePAM yes

# 3. Reiniciar
sudo systemctl restart ssh

# 4. Configurar para tu usuario
google-authenticator
```


Your new secret key is: V7IKD2YIW3SELVTCVM7N2NFFZ4
Enter code from app (-1 to skip): 105275
Code confirmed
Your emergency scratch codes are:
  78685825
  50798727
  56841311
  54224700
  42881992

Do you want me to update your "/home/armadillo/.google_authenticator" file? (y/n) y

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
Do you want to do so? (y/n) n

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting? (y/n)  y


El 2FA funciona si te pide algo adicional a tu contraseña normal. En tu caso, te pide el verification code, que es el segundo factor.





----


sudo nano /etc/pam.d/common-password
