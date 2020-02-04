#!/bin/bash
mkdir txt
for  file in *.pdf; do
	pdftotext "$file" txt/"$file.txt";
done
clear
cd txt/
mkdir filtrado/
for  file in *.txt; do
	cat "$file" | cut -d: -f1,2,3 | egrep -i "Nome:|Endereço:|CEP:|Cidade:|E-mail:|Telefone:" > filtrado/"$file.txt";
done
clear
cd filtrado/
mkdir filtrado2
for  file in *.txt; do
	cat "$file" | cut -d: -f1,2,3 | tr '\n' ' ' > filtrado2/"$file.txt";
done
clear
cd filtrado2/
sed -n p *.txt > dados.csv
echo "Finalizado!!!"
