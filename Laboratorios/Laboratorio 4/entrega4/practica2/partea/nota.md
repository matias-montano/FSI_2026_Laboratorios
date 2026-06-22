primero compilamos el programa con

```
gcc -fno-stack-protector -o practica2 practica2.c
```

Al observar el codigo fuente, podemos identificar una vulnerabilidad en el uso de la funcion scanf(), la funcion scanf() con el especificador %s no controla la cantidad de caracteres que se pueden ingresar. Simplemente copia el string ingresado por el usuario en el bufer password, sin verificar que quepa dentro de los 10 bytes reservados.

El ataque es posible debido a como  se organizan las variables en la memoria (pila/stack). La variable passwdOK se almacena en la pila en una posicion adyacente a password. Entonces, cuando el usuario ingresa datos con scanf("%s", password), el programa escribe secuencialmente desde la dirección de password hacia direcciones superiores.

Es decir, para desbordar el buffer de password[10], solo necesitamos escribir 10 caracteres que desbordaran el dicho buffer y pasaran a sobrescribr la variable passwdOK, con la nueva passwordOK, asi si ingresamos primero:
```
BBBBBBBBBBESTlab4
```

y apretamos enter, para que luego escribamos:

```
ESTlab4
```