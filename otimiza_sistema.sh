#!/bin/bash
#30/11/2015
#Script irá tentar otimizar o sistema operacional
#Diminuindo a prioridade de uso do SWAP e instalando
#alguns programas Prelink e Preload
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
		/bin/su -c "echo 'vm.swappiness=10' >> /etc/sysctl.conf"

	elif [[ $memocache == "vm.vfs_cache_pressure=60" ]]; then
		echo "Otimizando..."
		/bin/su -c "echo 'vm.vfs_cache_pressure=60' >> /etc/sysctl.conf"

	elif [[ $background == "vm.dirty_background_ratio=15" ]]; then
		echo "Otimizando..."
		/bin/su -c "echo 'vm.dirty_background_ratio=15' >> /etc/sysctl.conf"

	elif [[ $ratio == "vm.dirty_ratio=25" ]]; then
		echo "Otimizando..."
		/bin/su -c "echo 'vm.dirty_ratio=25' >> /etc/sysctl.conf"
	else
		echo "Não há nada para ser otimizado"
		echo "Isso porque já foi otimizado anteriormente!"
	fi
}

optimize()
{
memfree=$(grep "memfree = 90" /etc/preload.conf)
memcached=$(grep "memcached = 35" /etc/preload.conf)
processes=$(grep "processes = 50" /etc/preload.conf)
prelink=$(grep "PRELINKING=unknown" /etc/default/prelink)

	if which -a prelink && which -a preload; then
		echo
		echo "Configurando o PRELOAD"
		if [[ $memfree != "memfree = 90" ]];then
			echo "configurando..."
			sed -i 's/memfree = 50/memfree = 90/g' /etc/preload.conf

		elif [[ $memcached != "memcached = 35" ]]; then
			echo "configurando..."
			sed -i 's/memcached = 0/memcached = 35/g' /etc/preload.conf

		elif [[ $processes != "processes = 50" ]]; then
			echo "configurando..."
			sed -i 's/processes = 30/processes = 50/g' /etc/preload.conf

		else
			echo "Não há nada para ser configurado"
			echo "Isso porque já foi configurado anteriomente"
		fi
		echo
		echo "Ativando o PRELINK"
		if [[ $prelink == "PRELINKING=unknown" ]]; then
			echo "Otimização já adicionada anteriormente."
		else
			echo "adicionando ..."
			sed -i 's/unknown/yes/g' /etc/default/prelink
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
echo "Bem vindo ao script Otimiza Sistema"
read -n1 -p "Para continuar escolha s(sim) ou n(não)  " escolha
	case $escolha in
		s|S) echo
			swap ; optimize
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
