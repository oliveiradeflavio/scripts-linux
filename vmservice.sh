#!/bin/bash
#04/12/2015
#
#script para automatizar a transformação de VM como serviço
#é preciso ter a VM no programa virtualbox e a mesma feita com o usuário root
#use script junto com o script vboxcontrol que está na mesma pasta
#
#por Flávio Oliveira
#https://github.com/oliveiradeflavio
#http://youtube.com/flaviodicas
#http://flaviodeoliveira.com.br


if [[ `id -u` -ne 0 ]]; then
	echo
		echo "Execute como superusuário (root)"
		echo "Saindo..."
		sleep 2
		exit
fi

packagemanager()
{
clear
echo
	which apt 1>/dev/null 2>/dev/stdout
	if [ $? -eq 0 ]; then
		main
	else
		echo -e "Sistema incompativel\ncom os comandos deste script"
		sleep 3
		exit
	fi
}

vmservice()
{
echo "Aguarde Verificando alguns programas necessarios"
which chkconfig 1>/dev/null 2>/dev/stdout
if [ $? -eq 0 ]; then
	echo "ok" 1>/dev/null 2>/dev/stdout
else
	echo "Você precisa do programa chkconfig"
	sleep 2
	echo "Finalizando script...=/"
	sleep 1
	exit
fi
clear
	echo "Criando diretório"
	echo
	mkdir /etc/virtualbox
	echo
	echo -e "Criando arquivo que conterá\ntodas as VM a serem inicializadas"
	touch /etc/virtualbox/machines_enabled ; touch /etc/virtualbox/config
	echo "$namevmuser" >> /etc/virtualbox/machines_enabled
	cp vboxcontrol /etc/init.d/
	chmod 755 /etc/init.d/vboxcontrol
	echo
	echo "Registrando o Script Vboxcontrol"
	cd /etc/init.d/
	update-rc.d vboxcontrol start 90 2 3 4 5 . stop 10 0 1 6 .
	chkkconfig --add vboxcontrol
	chkconfig vboxcontrol on
	echo
	echo "Instalação Concluída"
	sleep 2
	exit
}
#variavel global para saber qual o nome da vm que usuário criou
namevmuser=" "

main()
{
clear
echo
	echo "Bem vindo"
	echo "Primeiramente antes de continuar"
	echo "Você precisará ter uma VM"
	echo "pronta, instalada como superusuário (root)"
	echo
	read -p "Digite o nome da sua VM. Exemplo: server, linux:  " namevmuser
	sleep 1
	read -n1 -p "O nome da VM é $namevmuser ?? s/n  " escolha
		case $escolha in
			s|N) echo
				vmservice
				;;
			n|N) echo
				echo reiniciando script...
				sleep 1 ; main
				;;
			*) echo
				echo Alternativas incorretas, saindo!!
				sleep 1
				exit
				;;
		esac
}
packagemanager
