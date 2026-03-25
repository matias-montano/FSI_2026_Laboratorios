cat texto_interpretar.txt | fold -w1 | sort | uniq -c | sort -nr

tr -d '\n' < texto_interpretar.txt

sed 's/G/Y/g' texto_interpretar.txt

sed -e 's/G/Y/g' -e 's/TI/DE/g' texto_interpretar.txt
sed -e 's/G/Y/g' -e 's/MT/DE/g' texto_interpretar.txt

tr ' ' '\n' < texto_interpretar.txt | sort | uniq -c | sort -nr