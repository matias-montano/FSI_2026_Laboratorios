se ejecuto 

nmap -sV -Pn 10.0.3.5


y se obtuvo

Starting Nmap 7.80 ( https://nmap.org ) at 2026-05-17 11:15 UTC
Nmap scan report for 10.0.3.5
Host is up (0.00024s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.5
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.52 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.37 seconds




Qué hace cada flag:

    -sV → Detecta versión de los servicios

    -Pn → No hace ping previo (asume que el host está vivo)