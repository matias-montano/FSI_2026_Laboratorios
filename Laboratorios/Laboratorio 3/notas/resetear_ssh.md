¡Claro! Es completamente normal que esto ocurra después de resetear una máquina virtual, especialmente si se reinstaló el sistema operativo o se regeneraron las claves SSH.

**No es un ataque** (en tu caso), solo que la clave SSH almacenada en tu computadora ya no coincide con la nueva clave de la máquina virtual.

## Solución rápida (1 comando):

Ejecuta en tu terminal:

```bash
ssh-keygen -f '/home/armadillo/.ssh/known_hosts' -R '192.168.44.13'
```

Ese comando **elimina la entrada antigua** de la clave para esa IP.

## Luego vuelve a conectarte:

```bash
ssh usuario@192.168.44.13
```

Te preguntará algo como:  
*"The authenticity of host '192.168.44.13' can't be established. Are you sure you want to continue connecting?"*

Responde **yes** y se guardará la nueva clave.

---

## Alternativa manual (si prefieres editar tú mismo):

Abre el archivo:
```bash
nano ~/.ssh/known_hosts
```

Borra la **línea 10** (donde dice "Offending ECDSA key in línea 10") y guarda.

---

**Resumen:** Solo tienes que eliminar la clave vieja. Tu máquina cambió, es esperado, no hay peligro real en este caso.