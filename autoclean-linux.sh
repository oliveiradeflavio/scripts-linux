#!/bin/bash
#
#30/11/2015
#Script irá tentar fazer uma limpeza no sistema operacional
#Removedo arquivos que não estão sendo utilizados (cache de Terminal, lib
#sem uso, etc)
#será preciso instalar dois programas para concluir a limpeza (Deborphan
#e Prelink)
#
#por Flávio Oliveira (flávio dicas)
#contato: oliveiradeflavio@gmail.com http://youtube.com/flaviodicas

if [[ `id -u` -ne 0 ]]; then
	echo
		echo "Você precisa ter poderes administrativos (root)"
		echo "O script está sendo finalizado ..."
		sleep 4
		exit
fi

cleaning()
{
clear
if which -a prelink && which -a deborphan; then
	clear
	echo "Esvaziando a Lixeira"
	rm -rf /home/$SUDO_USER/.local/share/Trash/files/*
	echo "--------------------------------------------"
	echo "Esvaziando os Arquivos Temporários (pasta tmp)"
	rm -rf /var/tmp/*
	echo "--------------------------------------------"
	echo "Excluindo Arquivos Inúteis do Cache do Gerenciador de Pacotes (apt)"
	apt-get clean -y
	echo "--------------------------------------------"
	echo "Excluindo Pacotes Velhos que não tem utilidade para o Sistema"
	apt-get autoremove -y
	echo "--------------------------------------------"
	echo "Excluindo Pacotes Duplicados"
	apt-get autoclean -y
	echo "--------------------------------------------"
	echo "Reparando Pacotes com Problemas"
	dpkg --configure -a
	echo "--------------------------------------------"
	echo "Removendo Pacotes Órfãos"
	apt-get remove $(deborphan) -y ; apt-get autoremove -y
	echo "--------------------------------------------"
	echo "Otimizando as Bibliotecas dos Programas"
	/etc/cron.daily/prelink
	echo "--------------------------------------------"
	clear
	echo "Limpeza Concluída ... "
	sleep 3
else
	clear
	echo -e "Você precisa instalar dois programas\n para continuar com a Limpeza."
	read -p "Deseja instalar o Prelink e o Deborphan? s/n: " -n1 escolha
	case $escolha in
		s|S) echo
			testaconexao
			apt-get install prelink deborphan -y ; 
			sed -i 's/unknown/yes/g' /etc/default/prelink
			limpeza
			;;
		n|N) echo
			echo Saindo, não executando a limpeza...
			sleep 1
			exit
			;;
		*) echo
			echo Alternativas incorretas ... Saindo!!!
			sleep 1
			exit
			;;
	esac

fi
}
clear
echo "Bem vindo ao script Autoclean Linux"
read -n1 -p "Para continuar escolha s(sim) ou n(não)  " escolha
	case $escolha in
		s|S) echo
			cleaning
			;;
		n|N) echo
			echo Finalizando o script...
			sleep 1
			exit
			;;
		*) echo
			echo Alternativa incorreta!! Saindo...
			sleep 1
			exit
			;;
	esac
