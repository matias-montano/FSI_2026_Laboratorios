cat texto_interpretar.txt | fold -w1 | sort | uniq -c | sort -nr

tr -d '\n' < texto_interpretar.txt

sed 's/G/Y/g' texto_interpretar.txt

tr ' ' '\n' < texto_interpretar.txt | sort | uniq -c | sort -nr

sed -e 's/G/Y/g' -e 's/TI/DE/g' texto_interpretar.txt
sed -e 's/G/Y/g' -e 's/MT/DE/g' texto_interpretar.txt
sed -e 's/G/Y/g' -e 's/LM/DE/g' texto_interpretar.txt
sed -e 's/G/Y/g' -e 's/CV/DE/g' texto_interpretar.txt

sed 's/G/Y/g' texto_interpretar.txt

expr $(printf "%d" "'Y") - $(printf "%d" "'G")
expr $(printf "%d" "'T") - $(printf "%d" "'D")
expr $(printf "%d" "'I") - $(printf "%d" "'E")

expr $(printf "%d" "'D") - $(printf "%d" "'L")
expr $(printf "%d" "'M") - $(printf "%d" "'D")




expr $(printf "%d" "'D") - $(printf "%d" "'L")
expr $(printf "%d" "'E") - $(printf "%d" "'M")
-8
-8


¡Exacto! El resultado -8 significa que para ir de L a D (o de M a E) hay que desplazar 8 posiciones hacia la izquierda en el alfabeto (usando valores ASCII).

Si querés hacer ese shift de 8 posiciones a la izquierda en un texto, podés usar tr así:

```sh
tr 'A-Z' 'S-ZA-R' < texto_interpretar.txt
```

Esto mueve cada letra 8 lugares a la izquierda (A→S, B→T, ..., H→Z, I→A, ...). Si necesitás el comando para minúsculas o para otro desplazamiento, avisame. ¿Te gustaría que lo agregue a tu archivo ideas.md?

----


* CONFIGURAR LA HERRAMIENTA ETTERCAP PARA CAPTURAR EL TRAFICO ENTRE
LA MAQUINA SERVIDOR Y LA VICTIMA.
* EL TRAFICO TRANSMITIDO CONTIENE UNA FRASE OCULTA. SE OCULTO
UTILIZANDO UN ALGORITMO DE CODIFICACION CONOCIDO (ERRE EFE CE
TREINTA Y CINCO CUARENTA Y OCHO).
* ENTREGABLES: DENTRO DE UN DIRECTORIO PRACTICA1, ALMACENAR UN
ARCHIVO, SIN FORMATO (TEXTO PLANO), QUE CONTENGA:
* NUMERO DE PUERTO TCP DESTINO DEL MENSAJE Y NOMBRE DEL SERVICIO
POR DEFECTO EN ESE PUERTO.
* EL TEXTO PLANO TRANSMITIDO.%   


## parte 3

CONFIGURAR LA HERRAMIENTA ETTERCAP PARA CAPTURAR EL TRAFICO ENTRE
LA MAQUINA SERVIDOR Y LA VICTIMA.

sudo ettercap -T -i ens4 -M arp:remote /10.0.3.5// /10.0.3.6//



Wed Mar 25 21:24:10 2026 [320873]
TCP  10.0.3.5:41474 --> 10.0.3.6:7 | AP (660)
IlBhZ2VzIG9uZSBhbmQgdHdvIFtvZiBaYXBob2QncyBwcmVzaWRlbnRpYWwgc3BlZWNoXSBoYWQgCmJlZW4gc2FsdmFnZWQgYnkgYSBEYW1vZ3JhbiBGcm9uZCBDcmVzdGVkIEVhZ2xlIGFuZCBoYWQgCmFscmVhZHkgYmVjb21lIGluY29ycG9yYXRlZCBpbnRvIGFuIGV4dHJhb3JkaW5hcnkgbmV3IGZvcm0gCm9mIG5lc3Qgd2hpY2ggdGhlIGVhZ2xlIGhhZCBpbnZlbnRlZC4gSXQgd2FzIGNvbnN0cnVjdGVkIApsYXJnZWx5IG9mIHBhcGllciBtYWNoZSBhbmQgaXQgd2FzIHZpcnR1YWxseSBpbXBvc3NpYmxlIGZvciAKYSBuZXdseSBoYXRjaGVkIGJhYnkgZWFnbGUgdG8gYnJlYWsgb3V0IG9mIGl0LiBUaGUgRGFtb2dyYW4gCkZyb25kIENyZXN0ZWQgRWFnbGUgaGFkIGhlYXJkIG9mIHRoZSBub3Rpb24gb2Ygc3Vydml2YWwgb2YgCnRoZSBzcGVjaWVzIGJ1dCB3YW50ZWQgbm8gdHJ1Y2sgd2l0aCBpdC4iIAoKLSBBbiBleGFtcGxlIG9mIERhbW9ncmFuIHdpbGRsaWZlLiA=

Wed Mar 25 21:24:10 2026 [320873]
TCP  10.0.3.5:41474 --> 10.0.3.6:7 | FA (0)


Wed Mar 25 21:24:10 2026 [328593]
TCP  10.0.3.6:7 --> 10.0.3.5:41474 | A (0)


Wed Mar 25 21:24:10 2026 [330703]
TCP  10.0.3.6:7 --> 10.0.3.5:41474 | AP (660)
IlBhZ2VzIG9uZSBhbmQgdHdvIFtvZiBaYXBob2QncyBwcmVzaWRlbnRpYWwgc3BlZWNoXSBoYWQgCmJlZW4gc2FsdmFnZWQgYnkgYSBEYW1vZ3JhbiBGcm9uZCBDcmVzdGVkIEVhZ2xlIGFuZCBoYWQgCmFscmVhZHkgYmVjb21lIGluY29ycG9yYXRlZCBpbnRvIGFuIGV4dHJhb3JkaW5hcnkgbmV3IGZvcm0gCm9mIG5lc3Qgd2hpY2ggdGhlIGVhZ2xlIGhhZCBpbnZlbnRlZC4gSXQgd2FzIGNvbnN0cnVjdGVkIApsYXJnZWx5IG9mIHBhcGllciBtYWNoZSBhbmQgaXQgd2FzIHZpcnR1YWxseSBpbXBvc3NpYmxlIGZvciAKYSBuZXdseSBoYXRjaGVkIGJhYnkgZWFnbGUgdG8gYnJlYWsgb3V0IG9mIGl0LiBUaGUgRGFtb2dyYW4gCkZyb25kIENyZXN0ZWQgRWFnbGUgaGFkIGhlYXJkIG9mIHRoZSBub3Rpb24gb2Ygc3Vydml2YWwgb2YgCnRoZSBzcGVjaWVzIGJ1dCB3YW50ZWQgbm8gdHJ1Y2sgd2l0aCBpdC4iIAoKLSBBbiBleGFtcGxlIG9mIERhbW9ncmFuIHdpbGRsaWZlLiA=


---

ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:6a:27:41 brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    inet 192.168.44.13/25 brd 192.168.44.127 scope global ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe6a:2741/64 scope link 
       valid_lft forever preferred_lft forever
3: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:6e:83:06 brd ff:ff:ff:ff:ff:ff
    altname enp0s4
    inet 10.0.3.4/24 metric 100 brd 10.0.3.255 scope global dynamic ens4
       valid_lft 2422sec preferred_lft 2422sec
    inet6 fe80::5054:ff:fe6e:8306/64 scope link 
       valid_lft forever preferred_lft forever


nmap -sn 10.0.3.0/24
Starting Nmap 7.80 ( https://nmap.org ) at 2026-03-25 21:28 UTC
Nmap scan report for attacker-3 (10.0.3.4)
Host is up (0.00076s latency).
Nmap scan report for 10.0.3.5
Host is up (0.00066s latency).
Nmap scan report for 10.0.3.6
Host is up (0.00065s latency).
Nmap done: 256 IP addresses (3 hosts up) scanned in 3.03 seconds




"Pages one and two [of Zaphod's presidential speech] had 
been salvaged by a Damogran Frond Crested Eagle and had 
already become incorporated into an extraordinary new form 
of nest which the eagle had invented. It was constructed 
largely of papier mache and it was virtually impossible for 
a newly hatched baby eagle to break out of it. The Damogran 
Frond Crested Eagle had heard of the notion of survival of 
the species but wanted no truck with it." 

- An example of Damogran wildlife. %     



---

¡Exacto! "La Guía del autoestopista galáctico" (The Hitchhiker's Guide to the Galaxy) es una famosa novela de ciencia ficción y humor de Douglas Adams. En la historia, un grupo de seres construye una supercomputadora llamada "Pensamiento Profundo" (Deep Thought) para encontrar la respuesta a la pregunta fundamental sobre la vida, el universo y todo lo demás. La respuesta que da la máquina es... 42.

Luego, se dan cuenta de que no saben cuál es la pregunta, así que construyen otra máquina aún más grande (la Tierra) para descubrir cuál es la pregunta definitiva.

El fragmento que viste antes es parte del humor absurdo y creativo de la novela. ¿Te gustaría saber más sobre la historia, los personajes o alguna referencia en particular?

---

