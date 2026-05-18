t.txt --format=sha512crypt users.txt   
Using default input encoding: UTF-8
Loaded 1 password hash (sha512crypt, crypt(3) $6$ [SHA512 256/256 AVX2 4x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Will run 4 OpenMP threads
Note: Passwords longer than 26 [worst case UTF-8] to 79 [ASCII] rejected
Press 'q' or Ctrl-C to abort, 'h' for help, almost any other key for status
Warning: Only 1 candidate buffered, minimum 16 needed for performance.
rbt.2%5(w`z>4)o&+?l-c]9:x=/h<qj@ (root)     
1g 0:00:00:00 DONE (2026-05-18 12:22) 6.250g/s 6.250p/s 6.250c/s 6.250C/s rbt.2%5(w`z>4)o&+?l-c]9:x=/h<qj@
Use the "--show" option to display all of the cracked passwords reliably
Session completed


jajaja sí, exacto — **John the Ripper**, Jack el Destripador en inglés. El nombre tiene sentido para una herramienta que "destroza" hashes.

Y confirmado: `rbt.2%5(w`z>4)o&+?l-c]9:x=/h<qj@` es la contraseña de root. Hash verificado, lab completado. 

Ahora solo te falta el `cat /root/flag.txt` si no lo hiciste ya, y armar el entregable con todo el proceso documentado.