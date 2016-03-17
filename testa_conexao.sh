#!/bin/bash
#	02/12/2015
#	script tem o intuito de fazer um teste de conexão
#	seja através de um site ou IP.
#
#	Flávio Oliveira (Flávio Dicas)
#	oliveiradeflavio@gmail.com
#	http://youtube.com/flaviodicas
#	http://flaviodeoliveira.com.br
#	https://github.com/oliveiradeflavio

#	função principal onde será executado o teste de conexão
testconnection()
{
echo "Aguarde!!! Verificando conexão com a internet"
if ! ping -c 7 www.google.com.br 1>/dev/null 2>/dev/stdout; then
	echo "Alguns módulos desse script precisa de conexão com a internet para serem executado"
	sleep 3
	read -p "Deseja refazer o teste de conexão? s/n: " -n1 escolha
	case $escolha in
			s|S) echo
				clear
				testaconexao
				;;
			n|N) echo
				echo Finalizando script...
				sleep 2
				exit
				;;
			*) echo
				echo Alternativas incorretas ... Saindo!!!!
				sleep 2
				exit
				;;
	esac
else
	echo "Teste de conexão está ok"
	sleep 1

fi
}
clear
	echo "Bem vindo ao Teste de Conexão"
	echo
read -n1 -p "Iniciar o teste de conexão com a internet? s/n " -s escolha
	case $escolha in
		s|S) echo
			echo 7 pacotes irão ser disparados
			sleep 2
			testconnection
			;;
		n|N) echo
			echo Finalizando script...
			sleep 1
			exit
			;;
		*) echo
			echo Alternativas incorretas, saindo!!
			exit
			;;
	esac
