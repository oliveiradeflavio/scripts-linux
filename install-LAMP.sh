#!/bin/bash
#	03/12/2015
#	script irá instalar o LAMP no seu sistema Linux
#	Linux, Apache, MySQL e PHP
#
#	Flávio Oliveira (Flávio Dicas)
#	https://github.com/oliveiradeflavio
#	http://youtube.com/flaviodicas
#	http://flaviodeoliveira.com.br
#	oliveiradeflavio@gmail.com

#	verifica se o usuário é root
if [[ `id -u` -ne 0 ]]; then
	echo
		echo "Execute como superusuário (root)"
		echo "Saindo..."
		sleep 2
		exit
fi

#	verifica o gerenciador de pacotes da distro (apt-get)
#	se quiser instalar em outra distro não utilize o apt-get, só fazer a alteração
# abaixo para que ele passe a reconhecer o seu gerenciador de pacotes
packagemanager()
{
clear
echo
	which apt 1>/dev/null 2>/dev/stdout
	if [ $? -eq 0 ]; then
		insta
	else
		echo -e "Distribuição incompativel\ncom os comandos deste script"
		sleep 2
		exit
	fi
}

#	verifica sua comunicação com a internet. Já que iremos baixar bastante pacotes
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
				sleep 1
				exit
				;;
			*) echo
				echo Alternativas incorretas ... Saindo!!!!
				sleep 1
				exit
				;;
	esac
else
	echo "Teste de conexão está ok"
	sleep 1

fi
}

#	função principal, onde será realizado toda a instalação (LAMP)
insta()
{
clear
testconnection
apt-get update 1>/dev/null 2>/dev/stdout
#	abrir link's no navegador padrão do sistema
apt-get install libgnome2-0 -y 1>/dev/null 2>/dev/stdout

	echo "APACHE"
	sleep 2
	if which -a apache2; then
		echo "Sistema já contém o programa"
		sleep 1
	else
		echo "instalando..."
		apt-get install apache2 -y
		sleep 2
		clear
		echo
	        echo "Testando o APACHE"
       		echo -e "será aberto o navegador e você verá uma página\nsobre informações do APACHE"
       		sleep 3
       		gnome-open http://localhost
       	        sleep 3
	fi
	clear
	echo "MySQL"
	sleep 2
	if which -a mysql-server; then
		echo
		echo "Seu sistema já contém o programa"
		sleep 2
	else
		echo "instalando..."
		apt-get install mysql-server php5-mysql -y
		sleep 2
		service mysql restart
		clear
	fi
	clear
	echo "PHP"
	sleep 2
	if which -a php5; then
		echo
		echo "Seu sistema já contém o programa"
		sleep 2
	else
		echo "instalando..."
		apt-get install php5 libapache2-mod-php5 phpmyadmin php5-mcrypt php5-cli mcrypt -y
		sleep 2
		clear
		echo "ativando extensão mcrypt"
		php5enmod mcrypt
		sleep 4
		clear
		sleep 3
	        echo "Testando o PHP"
       	        echo -e "será aberto o navegador e você verá uma página\nsobre informações do PHP"
      	        sleep 3
       	        touch /var/www/html/info.php
       	        echo -e "<?php\nphpinfo();\n?>" >> /var/www/html/info.php
      	        sleep 1
      	        gnome-open http://localhost/info.php
       	        sleep 3
	fi
	clear
	echo "Instalação do LAMP está concluída"
	sleep 2
	exit
}
clear
	echo "BEM VINDO !!!"
	echo -e "Esse script irá instalar o LAMP que são pacotes para\nLINUX, APACHE, MYSQL e PHP"
	echo
	read -n1 -p "Deseja prosseguir? s/n  " escolha
	case $escolha in
		s|S) echo
			packagemanager
			;;
		n|N) echo
			echo Saindo do script
			sleep 1
			exit
			;;
		*) echo
			echo Alternativas incorretas. Saindo...
			sleep 1
			;;
	esac
