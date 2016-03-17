#!/bin/bash
#	05/12/2015
#	script agenda um horário para o sistema ser desligado
#	as janelas são construidas através do programa zenity
#	que já vem instalado na maioria das distribuições.
#
#	por Flávio Oliveira (Flávio Dicas)
#	https://github.com/oliveiradeflavio
#	http://youtube.com/flaviodicas
#	http://flaviodeoliveira.com.br
#	oliveiradeflavio@gmail.com

#verifica se o usuário é root
if [[ `id -u` -ne 0 ]]; then
	echo
		zenity --info --text="Você precisa ter poderes administrativos (root)

    Execute pelo Terminal:
    sudo ./poweroff.sh" && echo $?
		if [ $? -eq 1 ]; then
        exit 1
    fi
    exit 0
fi

#verifica se o gerenciador do linux é (apt-get)
packagemanager()
{
	which apt 1>/dev/null 2>/dev/stdout
	if [ $? -eq 0 ]; then
		poweroffsystem
	else
		zenity --info --text="Erro !!! Alguns comandos incompatíveis.
		Fechando script." && echo $?
		if [ $? -eq 1 ]; then
			exit 1
		fi
		exit 0
	fi
}

#função principal onde acontece todo o agendamento e exclusão.
poweroffsystem()
{
	zenity --info --text="Desliga o sistema automaticamente através de um aviso prévio" && echo $?
	if [ $? -eq 1 ]; then
		exit 1
	fi

escolha=$(zenity --scale --text="Deslize para um valor em minutos") && echo $?
	if [ $? -eq 1 ]; then
		exit 1
	fi

shutdown -h +$escolha &

	zenity --question --text="Seu sistema se encerrará em $escolha minutos. Você está certo disso?" && echo $?
	if [ $? -ne 0 ]; then
		zenity --info --text="Agendamento excluído"
		shutdown -c
		exit
	else
		zenity --info --text="Agendado com Sucesso\nSe quiser cancelar, execute novamente o script\ne escolha a opção 'Cancelar Agendamento'"
	fi
}

ans=$(zenity --list --text="Escolha uma das opções abaixo" --radiolist --column "escolha" --column "opção" TRUE "Agendar Desligamento" FALSE "Cancelar Desligamento"); echo $ans
	if [[ $ans == "Agendar Desligamento" ]]; then
		packagemanager
	elif [[ $ans == "Cancelar Desligamento" ]]; then
		zenity --info --text="Agendamento excluído"
		shutdown -c
		exit
	elif [ $? -eq 1 ]; then
		exit 1
	fi
