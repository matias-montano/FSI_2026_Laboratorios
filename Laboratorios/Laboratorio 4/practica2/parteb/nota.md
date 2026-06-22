Para eliminar la vulnerabilidad de desbordamiento de bufer, se realizaron dos cambios:

- Se modificó scanf("%s", password) por scanf("%9s", password), limitando la lectura a 9 caracteres, notese que  es 9, porque en C, todos los string deben terminar con `\0` que  ocupa un byte por eso se leen 9 caracteres
- Ademas hay un problema con scanf, y es que, al leer del buffer de entrada, se detiene  hasta que aparesca un `\n`, para evitar problemas con este salto de linea es que se ejecuta `while (getchar() != '\n');`, esta línea consume todos los caracteres hasta encontrar un \n, limpiando completamente el buffer de entrada.

Con estos cambios, el programa ya no permite sobrescribir la variable passwdOK, eliminando así la vulnerabilidad.