#!/bin/bash
#	2015-2016
#	Restaura as configurações de fábrica da Interface Unity
#
#	por Flávio Oliveira
#	https://github.com/oliveiradeflavio
#	http://youtube.com/flaviodicas
#	http://flaviodeoliveira.com.br
#	oliveiradeflavio@gmail.com

#verifica se o usuário é root (via interface zentiy)
if [[ `id -u` -ne 0 ]]; then
	echo
		zenity --info --text="Você precisa ter poderes administrativos (root)

    Execute pelo Terminal:
    sudo ./reset-config-unity.sh" && echo $?
		if [ $? -eq 1 ]; then
        exit 1
    fi
    exit 0
fi

#função principal onde será executada toda o reset do unity
reset_conf()
{
  clear
  if which -a dconf 1>/dev/null 2>/dev/stdout; then
    echo "..."
  else
    echo "Instalando programa Dconf"
    apt-get install dconf-editor -y
    sleep 1
  fi
  clear
  echo "Restaurando as configurações do Unity"
  dconf reset -f /org/compiz/
  dconf dump /org/compiz/
  rm -rf .config
  rm -rf .local
  rm -rf .gconf
  setsid Unity
  unity --reset-icons
  echo
  sleep 1
  echo "Sistema será reiniciado..."
  sleep 2
  reboot
}

clear
echo "-------------------------------------------------------------------------"
echo -e "\033[01;31mCuidado! Ao executar esse script, todas as configurações\n
da interface Unity será restaurada para seus valores padrões. Históricos\n
personalizações de diretórios irão ser resetados. Não se preocupe\n
seus arquivos estarão intactos.\033[0m\n"
echo "-------------------------------------------------------------------------"
echo
read -n1 -p "Deseja continuar com a restauração? s/n " escolha
case $escolha in
    S|s) echo
    echo -e "Antes de continuar, feche todos os programas\n
    abertos, pois no final do script, o sistema será reiniciado automaticamente"
    sleep 3
    reset_conf
    ;;
    N|n) echo
    echo "Cancelando e saindo do script!..."
    sleep 1
    exit
    ;;
    *) echo
    echo "Alternativas incorretas..."
    sleep 1
    exit
    ;;
esac
