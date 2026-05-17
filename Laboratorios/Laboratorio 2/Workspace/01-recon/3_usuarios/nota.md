lo que se hizo fue con el archivo empleados.html se ejecuto

grep -oP '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' empleados.html > mails.txt

y luego 

cut -d@ -f1 mails.txt > users.txt


luego se vio que la estructura era como

```
<TR>
<TD WIDTH=332>
    <P><B>URCIUOLO</B>, Marta S. 
    </P>
    </TD>
    <TD WIDTH=365>
    <P>268 
    </P>
    </TD>
    <TD WIDTH=252>
    <P>&nbsp</P>
    </TD>
    </TR>
<TR>
```

notamos que los que no tenian correo usaban `&nbsp`, asi que paresamos obtuvimos los nombres y despues armamos variaciones de estos