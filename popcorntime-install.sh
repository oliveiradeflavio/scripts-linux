#!/bin/bash
#02/12/2015
#script irá fazer a instalação do programa Popcorntime manualmente
#sem a adição de PPA's
#
#por Flávio Oliveira
#http://flaviodeoliveira.com.br
#http://youtube.com/flaviodicas
#https://github.com/oliveiradeflavio

if [[ `id -u` -eq 0 ]]; then
	echo
		echo "Execute esse script sem ser ROOT"
		echo "Saindo do script..."
		sleep 5
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

	if uname -m | grep '64' 1>/dev/null 2>/dev/stdout; then
		echo "Download Popcorntime"
		echo
		testconnection
		wget -c http://www67.zippyshare.com/d/79zgV98j/7057/Popcorn-Time-0.3.8-5-Linux-64.tar.xz -O pop64.tar.xz
		tar -Jxf pop64.tar.xz 1>/dev/null 2>/dev/stdout ; cd pop64/ ; ./install
	else
		echo "Download Popcorntime"
		echo
		testconnection
		wget -c http://www50.zippyshare.com/d/mFes2Adx/6814/Popcorn-Time-0.3.8-5-Linux-32.tar.xz -O pop32.tar.gz
		tar -Jxf pop32.tar.xz 1>/dev/null 2>/dev/stdout ; cd pop32/ ; ./install
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
		rm -Rf /opt/popcorntime
		rm -Rf /usr/bin/Popcorn-Time
		rm -Rf /usr/share/applications/popcorntime.desktop
		rm -Rf ~/.Popcorn-Time
		rm -Rf ~/.local/share/applications/Popcorn-Time.desktop
		rm -Rf ~/.local/share/icons/popcorntime.png
		rm -Rf ~/.config/Popcorn-Time
		echo "Remoção concluída"
	
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
				verify ; architecture
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
