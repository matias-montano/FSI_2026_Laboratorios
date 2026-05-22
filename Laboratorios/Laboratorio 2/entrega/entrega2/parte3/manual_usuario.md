# GUIA PARA AUTENTICACION DE DOS FACTORES (2FA) EN EL SISTEMA

Es un segundo paso de seguridad. Además de tu contraseña, necesitarás un código
que genera un celular o un manejador de contrasenas como keepax, sirve para reforzar el login.

Para configurarlo:

1. se instala una aplicacion de autenticación ya sea Google Authenticator, Microsoft Authenticator o Keepax si es para un pc

2. En la terminal de tu usuario, se ejecuta:

```
google-authenticator
```

3. Te aparecerá un código QR en la termina, puedes utilzar el mismo o ingresar la `secret key` que aparece en pantalla

4. La aplicacion empezará a mostrar un código de 6 dígitos que cambia cada 30 segundos.

5. El programa te hará varias preguntas, la sugerencia para mayor seguridad:
   - ¿Tokens basados en tiempo? → y (YES)
   - ¿Actualizar archivo? → y (YES)
   - ¿Evitar usar el mismo token varias veces? → y (YES)
   - ¿Aumentar ventana de tiempo? → n (NO)
   - ¿Limitar intentos? → y (YES)

6. Anota los códigos de emergencia que aparecen al final (5 números). Guárdalos en un lugar seguro, separado de tu celular. Sirven para entrar si pierdes o rompes tu celular.

Después de haber completado estos pasos, lo que sucederá es que primero te pedirá un código numérico de 6 dígitos, que es el que se muestra en la aplicación que estés usando, y luego escribirás tu contraseña normal de usuario. Esto refuerza de manera considerable la seguridad al tener dos mecanismos de autenticación: algo que sabes (tu contraseña) y algo que tienes (el dispositivo que ejecuta la aplicacion). Así, aunque alguien descubra tu contraseña, no podrá entrar sin el código que solo genera tu celular.

Pro ultimo, algunas buenas practicas son:
- No compartir el códigos de emergencia con nadie.
- Sincroniza la hora de tu computadora con NTP (la hora debe ser exacta para que los códigos funcionen).
- Si pierdes el dispositivo que ejecuta la aplicacion, usa un código de emergencia para entrar y luego configura de nuevo el 2FA.