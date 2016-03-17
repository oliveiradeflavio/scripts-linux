#!/bin/bash
#
# Data inicial: 30/11/2015
# O script faz a limpeza de arquivos que não estão sendo mais utilizados pelo
# sistema. Como bibliotecas obsoletas, caches de programas, configurações etc.
# O script faz a verificação de dois programas "preload e deborphan". Se os mesmos
# não estiverem instalado, a instalação ocorrerá automaticamente se o usuário permitir
#
# Flávio Oliveira (Flávio Dicas)
# http://www.flaviodeoliveira.com.br
# http://www.youtube.com/flaviodicas
# http://github.com/oliveiradeflavio
# oliveiradeflavio@gmail.com

if [[ `id -u` -ne 0 ]]; then
	echo
		zenity --info --text="Você precisa ter poderes administrativos (root)

    Execute pelo Terminal:
    sudo ./autoclean-linux.sh" && echo $?
		if [ $? -eq 1 ]; then
        exit 1
    fi
    exit 0
fi

#verifica qual gerenciador de pacotes Linux a distro utiliza
packagemanager()
{
clear
echo
	which apt 1>/dev/null 2>/dev/stdout
	if [ $? -eq 0 ]; then
		cleaning_apt
	else
		cleaning_rpm
	fi
}

#gerenciador de pacotes rpm (dnf)
cleaning_rpm()
{
clear
if which -a prelink; then
	clear
	echo "Limpando Cache de Bibliotecas"
	dnf -y clean all
	dnf -y clean headers
	dnf -y clean packages
	echo "--------------------------------------------"
	echo "Removendo Arquivos (.bak, ~, .tmp) da pasta Home"
	for i in *~ *.bak *.tmp; do
		find $HOME -iname "$i" -exec rm -f {} \;
	done
	echo "--------------------------------------------"
	echo "Otimizando as Bibliotecas dos Programas"
	/etc/cron.daily/prelink
	echo "--------------------------------------------"
	clear
	echo "Limpeza Concluída"
	sleep 2
else
	clear
	echo -e "Você precisa instalar um(1) programa\n para continuar com a Limpeza."
	read -p "Deseja instalar o Prelink ? s/n: " -n1 escolha
	case $escolha in
		s|S) echo
			dnf install prelink -y
			sed -i 's/unknown/yes/g' /etc/default/prelink
			cleaning_rpm
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

#gerenciador de pacotes deb (apt-get)
cleaning_apt()
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
	echo "Removendo Arquivos (.bak, ~, .tmp) da pasta Home"
	for i in *~ *.bak *.tmp; do
		find $HOME -iname "$i" -exec rm -f {} \;
	done
	echo "--------------------------------------------"
	echo "Otimizando as Bibliotecas dos Programas"
	/etc/cron.daily/prelink
	echo "--------------------------------------------"
	clear
	echo "Limpeza Concluída ... "
	sleep 2
else
	clear
	echo -e "Você precisa instalar dois programas\n para continuar com a Limpeza."
	read -p "Deseja instalar o Prelink e o Deborphan? s/n: " -n1 escolha
	case $escolha in
		s|S) echo
			apt-get install prelink deborphan -y
			sed -i 's/unknown/yes/g' /etc/default/prelink
			cleaning_apt
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
echo "#################################"
echo "# Bem vindo ao Autoclean Linux 	#"
echo "#################################"
echo
read -n1 -p "Para continuar escolha s(sim) ou n(não)  " escolha
	case $escolha in
		s|S) echo
			packagemanager
			;;
		n|N) echo
			echo Finalizando o script...
			sleep 0.5
			exit
			;;
		*) echo
			echo Alternativa incorreta!! Saindo...
			sleep 1
			exit
			;;
	esac
