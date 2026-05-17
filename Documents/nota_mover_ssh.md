¡Claro! Para mover (copiar) una carpeta desde tu máquina local a un servidor usando SSH, el comando más común es scp (secure copy). Aquí tienes el comando básico:

```bash
scp -r /ruta/a/tu/carpeta usuario@ip_del_servidor:/ruta/destino/en/servidor
```

Explicación:
- -r: copia recursiva (necesaria para carpetas).
- /ruta/a/tu/carpeta: la carpeta que quieres mover (por ejemplo, ~/Escritorio/mi_carpeta).
- usuario: tu usuario en el servidor.
- ip_del_servidor: la IP o nombre del servidor.
- /ruta/destino/en/servidor: dónde quieres dejar la carpeta en el servidor (por ejemplo, ~/).

Ejemplo práctico:
```bash
scp -r ~/Escritorio/mi_carpeta usuario@192.168.1.100:~/
```

Te pedirá la contraseña de tu usuario en el servidor (a menos que tengas configurado acceso por clave SSH).

---

Si ya configuraste acceso SSH al cluster “fsi” (por ejemplo, con una clave y un Host en tu archivo ~/.ssh/config), puedes usar el alias que pusiste en ese archivo.

Por ejemplo, si en ~/.ssh/config tienes algo como:

```
Host fsi
    HostName cluster.fsi.universidad.edu
    User tu_usuario
    IdentityFile ~/.ssh/id_rsa_fsi
```

Entonces puedes copiar la carpeta así:

```bash
scp -r ~/Escritorio/mi_carpeta fsi:~/
```

Eso usa el alias fsi y toda la configuración que guardaste. No necesitas poner usuario ni IP, solo el nombre del Host que configuraste.

---

----

¡Es casi igual! Solo cambias el orden de origen y destino.

Para descargar una carpeta del servidor a tu máquina local:

```bash
scp -r fsi:/ruta/en/servidor/carpeta ~/ruta/destino/local/
```

Por ejemplo, para traer la carpeta mi_carpeta desde tu home en el cluster a tu Escritorio local:

```bash
scp -r fsi:~/mi_carpeta ~/Escritorio/
```

Así copias del servidor a tu PC. El resto funciona igual, usando el alias fsi y tu configuración SSH.

