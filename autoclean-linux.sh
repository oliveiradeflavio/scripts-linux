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

#Criei variaveis para as cores. Isso facilita a visualização do código depois
#A variavel "normal" ela serve para voltar a cor padrão do shell.
verde="\033[1;32m"
azul="\033[1;34m"
vermelho="\033[1;31m"
branco="\033[0;37m"
NORMAL="\033[m"


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
if which -a prelink && which -a pv; then
	clear
	echo -e "${verde}Limpando Cache de Bibliotecas${NORMAL}"
	dnf -y clean all
	dnf -y clean headers
	dnf -y clean packages
	echo "--------------------------------------------"
	echo -e "${verde}Removendo Arquivos (.bak, ~, .tmp) da pasta Home${NORMAL}"
	for i in *~ *.bak *.tmp; do
		find $HOME -iname "$i" -exec rm -f {} \;
	done
	echo "--------------------------------------------"
	echo -e "${verde}Otimizando as Bibliotecas dos Programas${NORMAL}"
	/etc/cron.daily/prelink | pv -p -e
	echo "--------------------------------------------"
	clear
	echo -e "${azul}#################################${NORMAL}"
	echo -e "${azul}#${NORMAL}				${azul}#${NORMAL}"
	echo -e "${azul}#${vermelho} LIMPEZA CONCLUIDA !!!!	${NORMAL}${azul}#${NORMAL}"
	echo -e "${azul}#${NORMAL}				${azul}#${NORMAL}"
	echo -e "${azul}#################################${NORMAL}"
	sleep 2
else
	clear
	echo -e "Você precisa instalar dois programa\n para continuar com a Limpeza."
	read -p "Deseja instalar o Prelink e  PV? s/n: " -n1 escolha
	case $escolha in
		s|S) echo
			dnf install prelink pv -y
			sed -i 's/unknown/yes/g' /etc/default/prelink
			cleaning_rpm
			;;
			n|N) echo
				echo -e ${azul}Saindo, não executando a limpeza...${NORMAL}
				sleep 1
				exit
				;;
			*) echo
				echo -e ${vermelho}Alternativas incorretas... Saindo!!!${NORMAL}
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
if which -a prelink && which -a deborphan && which -a pv; then
	clear
	echo -e "${verde}Esvaziando a Lixeira${NORMAL}"
	rm -rf /home/$SUDO_USER/.local/share/Trash/files/*
	echo "--------------------------------------------"
	echo -e "${verde}Esvaziando os Arquivos Temporários (pasta tmp)${NORMAL}"
	rm -rf /var/tmp/*
	echo "--------------------------------------------"
	echo -e "${verde}Excluindo Arquivos Inúteis do Cache do Gerenciador de Pacotes (apt)${NORMAL}"
	apt-get clean -y
	echo "--------------------------------------------"
	echo -e "${verde}Excluindo Pacotes Velhos que não tem utilidade para o Sistema${NORMAL}"
	apt-get autoremove -y
	echo "--------------------------------------------"
	echo -e "${verde}Excluindo Pacotes Duplicados${NORMAL}"
	apt-get autoclean -y
	echo "--------------------------------------------"
	echo -e "${verde}Reparando Pacotes com Problemas${NORMAL}"
	dpkg --configure -a
	echo "--------------------------------------------"
	echo -e "${verde}Removendo Pacotes Órfãos${NORMAL}"
	apt-get remove $(deborphan) -y ; apt-get autoremove -y
	echo "--------------------------------------------"
	echo -e "${verde}Removendo Arquivos (.bak, ~, .tmp) da pasta Home${NORMAL}"
	for i in *~ *.bak *.tmp; do
		find $HOME -iname "$i" -exec rm -f {} \;
	done
	echo "--------------------------------------------"
	echo -e "${verde}Otimizando as Bibliotecas dos Programas${NORMAL}"
	/etc/cron.daily/prelink | pv -p -e
	echo "--------------------------------------------"
	clear
	echo -e "${azul}#################################${NORMAL}"
	echo -e "${azul}#${NORMAL}				${azul}#${NORMAL}"
	echo -e "${azul}#${vermelho} LIMPEZA CONCLUIDA !!!!	${NORMAL}${azul}#${NORMAL}"
	echo -e "${azul}#${NORMAL}				${azul}#${NORMAL}"
	echo -e "${azul}#################################${NORMAL}"
	sleep 2
else
	clear
	echo -e "${vermelho}Você precisa instalar três programas\n para continuar com a Limpeza.${NORMAL}"
	read -p "Deseja instalar o Prelink, Deborphan e o PV? s/n: " -n1 escolha
	case $escolha in
		s|S) echo
			apt-get install prelink deborphan pv -y
			sed -i 's/unknown/yes/g' /etc/default/prelink
			cleaning_apt
			;;
		n|N) echo
			echo -e ${azul}Saindo, não executando a limpeza...${NORMAL}
			sleep 1
			exit
			;;
		*) echo
			echo -e ${vermelho}Alternativas incorretas... Saindo!!!${NORMAL}
			sleep 1
			exit
			;;
	esac

fi
}
clear
echo -e "${azul}#################################${NORMAL}"
echo -e "${azul}#${NORMAL}				${azul}#${NORMAL}"
echo -e "${azul}#${vermelho} BEM VINDO AO AUTOCLEAN LINUX	${NORMAL}${azul}#${NORMAL}"
echo -e "${azul}#${NORMAL}				${azul}#${NORMAL}"
echo -e "${azul}#################################${NORMAL}"
echo
read -n1 -p "Para continuar escolha s(sim) ou n(não)  " escolha
	case $escolha in
		s|S) echo
			packagemanager
			;;
		n|N) echo
			echo -e ${azul}Finalizando o script...${NORMAL}
			sleep 0.5
			exit
			;;
		*) echo
			echo -e ${vermelho}Alternativa incorreta!! Saindo...${NORMAL}
			sleep 1
			exit
			;;
	esac
