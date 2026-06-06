
## ¿Qué es una Shell Reversa?

**Shell normal**: Tú te conectas a una máquina remota (ej: `ssh usuario@192.168.1.10`)

**Shell reversa (reverse shell)**: Es **la máquina víctima la que se conecta a ti**.

```
Normal:    Atacante -----> Víctima (conecta al puerto abierto)
Reversa:   Atacante <----- Víctima (víctima inicia la conexión)
```

### ¿Por qué es peligrosa?

Porque los firewalls normalmente:
- ✅ **Bloquean** conexiones entrantes (al atacante no lo dejan entrar)
- ❌ **NO bloquean** conexiones salientes (la víctima SÍ puede salir a Internet)

**Ejemplo**: Una empresa bloquea que alguien de afuera se conecte al puerto 22 (SSH), pero permite que sus servidores web se conecten al puerto 80 (HTTP) para actualizar software. El atacante usa ese puerto 80 para que la víctima se conecte a él.

---

## En tu laboratorio específico:

1. La máquina víctima tiene **awstats vulnerable**
2. El atacante le hace ejecutar un **script en Perl** (lo sube con wget o lo escribe)
3. Ese script Perl le dice a la víctima: *"conéctate al atacante en el puerto 80"*
4. El atacante tiene **netcat (nc) escuchando** en su puerto 80
5. Cuando la víctima se conecta, **el atacante obtiene una shell**

```
Atacante: nc -lvp 80          (espera conexión)
Víctima:  perl script.pl      (se conecta a atacante:80)
¡Conexión establecida! Atacante escribe comandos.
```

¿Vamos con la siguiente duda? 😊