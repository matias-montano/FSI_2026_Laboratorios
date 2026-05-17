from bs4 import BeautifulSoup

html = open("empleados.html", encoding="utf-8").read()
soup = BeautifulSoup(html, "html.parser")

rows = soup.find_all("tr")

for row in rows:
    cols = row.find_all("td")

    if len(cols) < 3:
        continue

    nombre = cols[0].get_text(" ", strip=True)
    correo = cols[2].get_text(" ", strip=True)

    if "@" not in correo:
        print(nombre)