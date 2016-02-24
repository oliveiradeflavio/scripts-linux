#!/bin/bash
#2016
#Instalação do Teamspeak
#Debian, Ubuntu, Linux Mint
#
#por Flávio Oliveira
#https://github.com/oliveiradeflavio
#http://youtube.com/flaviodicas
#http://flaviodeoliveira.com.br
#oliveiradeflavio@gmail.com

if [[ `id -u` -ne 0 ]]; then
	echo
		echo "Você precisa ter poderes administrativos (root)"
		echo "O script está sendo finalizado ..."
		sleep 4
		exit
fi

architecture()
{
cd /tmp/
clear
if which -a teamspeak 1>/dev/null 2>/dev/stdout; then
  echo "Você já possui uma versão do Teamspeak" ; sleep 3
else
  if uname -m | grep '64' ; then
    echo "Baixando Teamspeak versão 32bits"
    echo
    wget -b http://dl.4players.de/ts/releases/3.0.18.2/TeamSpeak3-Client-linux_x86-3.0.18.2.run -O teamspeak.run && cp teamspeak.run /opt/ && chmod +x teamspeak.run && ./teamspeak.run
    cd /teamspeak && ./ts3client_runscript.sh

  else
    echo "Baixando Teamspeak versão 64bits"
    echo
    wget -b http://dl.4players.de/ts/releases/3.0.18.2/TeamSpeak3-Client-linux_amd64-3.0.18.2.run -O teamspeak.run && cp teamspeak.run /opt/ && chmod +x teamspeak.run && ./teamspeak.run
    cd /teamspeak && ./ts3client_runscript.sh
  fi
fi
echo
clear
}

shortcuts()
{
clear
cd /home/$SUDO_USER/
echo "Ativando permissões na pasta oculta Teamspeak"
chmod 777 -R .ts3client/
sleep 4
echo
clear
echo "Criando um Link Simbólico para o Terminal"
ln -sf /opt/teamspeak/ts3client_runscript.sh /usr/bin/teamspeak
echo
echo -e "... Agora você poderá executar o programa via Terminal\n digitando teamspeak "
sleep 4
echo
echo "Criando atalho no menu"
touch /usr/share/applications/teamspeak.desktop
echo -e "[Desktop Entry]\nName=Teamspeak\nGenericName=teamspeak\n
Comment=comunicação\nExec=teamspeak\nTerminal=false\nType=Application\nIcon=teamspeak3\n
Categories=Communications;"
echo
echo "Atalho criado com sucesso"
echo
echo -e "Caso queira certificar que o atalho foi criado com sucesso\nRode o comando\n
abaixo no Terminal"
echo
echo "ls /usr/share/applications | grep 'teamspeak'"
sleep 5
}

clear
echo "Esse script instalará o Teamspeak 3.0.18.2"
echo
echo -e "Caso tenha uma versão mais recente visite o site\n
oficial do desenvolvedor, pois em breve esse script será atualizado\npara a nova
versão "
echo
read -n1 -p "Deseja continuar com a instalação? s/n" -s escolha
  case $escolha in
    s|S) echo
      architecture ; shortcuts
      ;;
      n|N) echo
      echo Finalizando script!!!...
      sleep 3
      exit
      ;;
      *) echo
      echo Alternativas incorretas. Fechando script!!!
      sleep 1
      exit
      ;;
  esac
