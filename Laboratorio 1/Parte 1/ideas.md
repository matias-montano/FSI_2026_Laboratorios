cat archivo.txt | fold -w1 | sort | uniq -c | sort -nr

tr -d '\n' < archivo.txt

sed 's/A/X/g' archivo.txt