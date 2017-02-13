#!/bin/bash
#02/12/2015 - última atualização 13/02/2017
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
		wget https://get.popcorntime.sh/build/Popcorn-Time-0.3.10-Linux-64.tar.xz -O popcorntime.tar.xz
        mkdir /opt/popcorntime
		tar Jxf popcorntime.tar.xz -C /opt/popcorntime/ 1>/dev/null 2>/dev/stdout
        ln -sf /opt/popcorntime/Popcorn-Time /usr/bin/Popcorn-Time
        echo -e '[Desktop Entry]\n Version=1.0\n Name=popcorntime\n Exec=/opt/popcorntime/Popcorn-Time\n Icon=/opt/popcorntime/src/app/images/icon.png\n Type=Application\n Categories=Application' | sudo tee /usr/share/applications/popcorntime.desktop
        chmod +x /usr/share/applications/popcorntime.desktop
        cp /usr/share/applications/popcorntime.desktop  ~/Área\ de\ Trabalho/
	else
		echo "Download Popcorntime"
		echo
		testconnection
		wget https://get.popcorntime.sh/build/Popcorn-Time-0.3.10-Linux-32.tar.xz -O popcorntime.tar.xz
        mkdir /opt/popcorntime
		tar Jxf popcorntime.tar.xz -C /opt/popcorntime/ 1>/dev/null 2>/dev/stdout
        ln -sf /opt/popcorntime/Popcorn-Time /usr/bin/Popcorn-Time
        echo -e '[Desktop Entry]\n Version=1.0\n Name=popcorntime\n Exec=/opt/popcorntime/Popcorn-Time\n Icon=/opt/popcorntime/src/app/images/icon.png\n Type=Application\n Categories=Application' | sudo tee /usr/share/applications/popcorntime.desktop
        chmod +x /usr/share/applications/popcorntime.desktop
        cp /usr/share/applications/popcorntime.desktop  ~/Área\ de\ Trabalho/
        
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
