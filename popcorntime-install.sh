#!/bin/bash
#02/12/2015
#script irá fazer a instalação do programa Popcorntime manualmente
#sem a adição de PPA's
#
#por Flávio Oliveira
#http://flaviodeoliveira.com.br
#http://youtube.com/flaviodicas
#https://github.com/oliveiradeflavio

if [[ `id -u` -ne 0 ]]; then
	echo
		echo "Você precisa de poderes administrativos (root)"
		echo "Saindo do script..."
		sleep 2
		exit
fi

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

architecture()
{
clear
cd /tmp/

	if uname -m | grep '64'; then
		echo "Download Popcorntime"
		echo
		testconnection
		wget -c popcorn-time.se/Popcorn-Time-linux64.tar.gz -O pop64.tar.gz
		tar -vzxf pop64.tar.gz -C /opt/ ; mv /opt/Popcorn* /opt/popcorntime
		ln -sf /opt/popcorntime/Popcorn-Time /usr/bin/Popcorn-Time
	else
		echo "Download Popcorntime"
		echo
		testconnection
		wget -c popcorn-time.se/Popcorn-Time-linux32.tar.gz -O pop32.tar.gz
		tar -vzxf pop32.tar.gz -C /opt/ ; mv /opt/Popcorn* /opt/popcorntime
		ln -sf /opt/popcorntime/Popcorn-Time /usr/bin/Popcorn-Time
	fi
echo
echo "Concluído"
}

verify()
{
clear
	echo "Verificando Instalações anteriores..."
	echo " Por favor aguarde..."
	sleep 2
	if which -a popcorntime; then
		rm -Rf /opt/popcorntime
		rm -Rf /usr/bin/Popcorn-Time
		rm -Rf /usr/share/applications/popcorntime.desktop
		echo "Remoção concluída"
	fi
echo
echo "Concluído"
}

icon()
{
clear
	echo "Criando Atalho"
	echo
	echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nTerminal=false\nName=popcorntime\nExec=/opt/popcorntime/Popcorn-Time\nIcon=/opt/popcorntime/popcorntime.png\nCategories=Application;" >> /usr/share/applications/popcorntime.desktop
	sleep 1
	cp /usr/share/applications/popcorntime.desktop  ~/Área\ de\ Trabalho/
echo
echo "Concluído"
}
clear
	echo "Bem vindo"
	echo
	echo "i) Instalar"
	echo
	echo "r) Remover"
	echo
	echo "s) Sair"
	echo
	read -n1 -p "Escolha i(instalar), r(remover) ou s(sair)  " -s escolha
		case $escolha in
			i|I) echo
				echo Analisando sistema
				verify ; architecture ; icon
				;;
			r|R) echo
				echo Aguarde...
				verify
				;;
			s|S) echo
				echo Saindo...
				sleep 1 ; exit
				;;			
			*) echo
				echo Alternativas incorretas, saindo!
				sleep 1
				exit
				;;
		esac
