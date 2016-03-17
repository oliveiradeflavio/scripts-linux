#!/bin/bash
#	30/11/2015
#	Script irá tentar otimizar o sistema operacional
#	Diminuindo a prioridade de uso do SWAP e instalando
#	alguns programas Prelink e Preload
#
#	Flávio Oliveira (Flávio Dicas)
# http://www.flaviodeoliveira.com.br
#	http://www.youtube.com/flaviodicas
#	https://github.com/oliveiradeflavio
#	oliveiradeflavio

#verifica se o usário é root
if [[ `id -u` -ne 0 ]]; then
	echo
		echo "Você precisa ter poderes administrativos (root)"
		echo "O script está sendo finalizado ..."
		sleep 4
		exit
fi

#verifica o gerenciador de pacotes da distro (apt-get)
packagemanager()
{
clear
echo
	which apt 1>/dev/null 2>/dev/stdout
	if [ $? -eq 0 ]; then
		swap ; optimize
	else
		echo -e "Distribuição incompativel\ncom esse script"
		sleep 2
		exit
	fi
}

#	diminui a prioridade de swap em disco
swap()
{
memoswap=$(grep "vm.swappiness=10" /etc/sysctl.conf)
memocache=$(grep "vm.vfs_cache_pressure=60" /etc/sysctl.conf)
background=$(grep "vm.dirty_background_ratio=15" /etc/sysctl.conf)
ratio=$(grep "vm.dirty_ratio=25" /etc/sysctl.conf)

	clear
	echo "Diminuindo a Prioridade de uso da memória SWAP"
	echo
	if [[ $memoswap == "vm.swappiness=10" ]]; then
		echo "Otimizando..."
		su -c "echo 'vm.swappiness=10' >> /etc/sysctl.conf"

	elif [[ $memocache == "vm.vfs_cache_pressure=60" ]]; then
		echo "Otimizando..."
		su -c "echo 'vm.vfs_cache_pressure=60' >> /etc/sysctl.conf"

	elif [[ $background == "vm.dirty_background_ratio=15" ]]; then
		echo "Otimizando..."
		su -c "echo 'vm.dirty_background_ratio=15' >> /etc/sysctl.conf"

	elif [[ $ratio == "vm.dirty_ratio=25" ]]; then
		echo "Otimizando..."
		su -c "echo 'vm.dirty_ratio=25' >> /etc/sysctl.conf"
	else
		echo "Não há nada para ser otimizado"
		echo "Isso porque já foi otimizado anteriormente!"
	fi
}

#	altera alguns valores relacionado a cache e memória RAM (cache).
#	instalação do programa PRELINK e PRELOAD
optimize()
{
memfree=$(grep "memfree = 50" /etc/preload.conf)
memcached=$(grep "memcached = 0" /etc/preload.conf)
processes=$(grep "processes = 30" /etc/preload.conf)
prelink=$(grep "PRELINKING=unknown" /etc/default/prelink)

	if which -a prelink 1>/dev/null 2>/dev/stdout && which -a preload 1>/dev/null 2>/dev/stdout; then
		echo
		echo "Configurando o PRELOAD"
		if [[ $memfree == "memfree = 90" ]];then
			echo "configurando..."
			sed -i 's/memfree = 50/memfree = 90/g' /etc/preload.conf

		elif [[ $memcached == "memcached = 35" ]]; then
			echo "configurando..."
			sed -i 's/memcached = 0/memcached = 35/g' /etc/preload.conf

		elif [[ $processes == "processes = 50" ]]; then
			echo "configurando..."
			sed -i 's/processes = 30/processes = 50/g' /etc/preload.conf

		else
			echo "Não há nada para ser configurado"
			echo "Isso porque já foi configurado anteriomente"
		fi
		echo
		echo "Ativando o PRELINK"
		if [[ $prelink == "PRELINKING=unknown" ]]; then
			echo "adicionando ..."
			sed -i 's/unknown/yes/g' /etc/default/prelink

		else
			echo "Otimização já adicionada anteriormente."

		fi
	else
		clear
		echo -e "Você precisa instalar dois programas\n para continuar com a otimização."
		read -p "Deseja instalar o Prelink e o Preload? s/n: " -n1 escolha
			case $escolha in
				s|S) echo
				     	apt-get install prelink preload -y 1>/dev/null 2>/dev/stdout
				     	;;
				n|N) echo
				     	echo Fechando script...
					sleep 2
					exit
					;;
				*) echo
					echo Alternativas incorretas!
					sleep 2
					optimize
					;;
			esac
	fi
	echo
	echo "Otimização Concluída"
	sleep 1
}
clear
echo "#######################################"
echo "# Bem vindo ao script Otimiza Sistema #"
echo "#######################################"
echo
read -n1 -p "Para continuar escolha s(sim) ou n(não)  " escolha
	case $escolha in
		s|S) echo
			packagemanager
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
