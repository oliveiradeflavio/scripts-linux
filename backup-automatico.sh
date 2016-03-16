#!/bin/bash
#script para automatizar a execução de backup
#utiliza o programa rsync para backup e zenity para fazer as GUI
#
#ano: 2016
#por Flávio Oliveira (Flávio Dicas)
#http://www.flaviodeoliveira.com.br
#http://www.youtube.com/flaviodicas
#https://github.com/oliveiradeflavio
#oliveiradeflavio@gmail.com

bkpinc()
{
  clear
echo "Escolha o arquivo a ser feito o backup"
sleep 2
bkplocal=$(zenity --file-selection --multiple)
echo
echo "Escolha o destino para onde o backup será salvo"
sleep 2
bkpdest=$(zenity --file-selection --directory)
echo
clear
echo "Verifique as informações se estão corretas"
echo "Arquivo a ser salvo: $bkplocal"
echo "Destino do backup: $bkpdest"
sleep 3
echo
read -n1 -p "As informações estão corretas? s/n =  " escolha
case $escolha in
  S|s) echo
    rsync -Cavzpu --progress $bkplocal $bkpdest
    ;;
  N|n) echo
    bkpinc
    ;;
  *) echo
    echo Alternativas incorretas. Voltando ao Menu Principal.
    sleep 2
    mainmenu
    ;;
  esac
}

bkpfull()
{
  clear
  echo "Escolha o diretório a ser feito o backup"
  sleep 2
  bkplocal=$(zenity --file-selection --directory)
  echo
  echo "Escolha o destino para onde o backup será salvo"
  sleep 2
  bkpdest=$(zenity --file-selection --directory)
  echo
  clear
  echo "Verifique as informações se estão corretas"
  echo "Arquivo a ser salvo: $bkplocal"
  echo "Destino do backup: $bkpdest"
  sleep 3
  echo
  read -n1 -p "As informações estão corretas? s/n =  " escolha 
  case $escolha in
  S|s) echo
    rsync -bzpvrl --progress $bkplocal $bkpdest
    ;;
  N|n) echo
    bkpfull
    ;;
  *) echo
    echo Alternativas incorretas. Voltando ao Menu Principal.
    sleep 2
    mainmenu
    ;;
  esac
}

ajuda()
{
  clear
  echo -e "Backup Full = faz a cópia total do arquivo origem para o diretório\n
  destino. Se no destino contiver os mesmos arquivos, ele fará a substituição\n
  total dos arquivos do destino pelos os arquivos de origem."
  echo
  echo
  echo -e "Backup Incremental = faz a cópia dos arquivos origem para o diretório\n
  destino. Se no destino contiver os mesmos arquivos, ele somente fará a substiuiçao\n
  se os arquivos de origem forem diferentes dos arquivos de destino."
  echo
  read -n1 -p "Voltar ao Menu Principal. s/n " -s escolha ; echo "($escolha)"
  case $escolha in
    s|S) echo
        mainmenu
        ;;
    n|N) echo
        echo Saindo do script.
        sleep 0.5
        exit
        ;;
    *) echo
     echo Alternativas incorretas
      sleep 0.5 ; ajuda
      ;;
    esac
}

checkprog()
{
  which -a apt 1>/dev/null 2>/dev/stdout
  if [ $? -eq 0 ]; then
    echo
  else
    echo -e "Seu sistema utiliza outro gerenciador de pacotes\n
    (apt-get) desse script. Favor mudar no script na função checkprog\n
    para poder utilizar."
    sleep 3
    exit
  fi
clear
if which -a rsync 1>/dev/null 2>/dev/stdout || which -a zenity 1>/dev/null 2>/dev/stdout ; then
  echo
else
  echo -e "Você precisa do rsync e zenity para prosseguir.\nAguarde a instalação ..."
  sudo apt-get install rsync zenity -y 1>/dev/null 2>/dev/stdout
  sleep 2
fi
clear
}

mainmenu()
{
  checkprog
  clear
  echo "#############################################################"
  echo "#                     BACKUP AUTOMÁTICO                     #"
  echo "#                                                           #"
  echo "# utilizando o programa 'rsync' e 'zenity' por Flávio Dicas #"
  echo "#############################################################"
  echo
  echo "F) - Backup Full "
  echo
  echo "I) - Backup Incremental"
  echo
  echo "A) - Diferença entre BKP Full e Incremental"
  echo
  echo "S) - Sair"
  echo
  read -n1 -p "Escolha uma das alternativas acima " -s escolha
  case $escolha in
    F|f) echo
        bkpfull
        ;;
    I|i) echo
        bkpinc
        ;;
    A|a) echo
        ajuda
        ;;
    S|s) echo
      echo Saindo ...
      sleep 1
      exit
      ;;
    *) echo
      echo Alternativas incorretas!!!
      sleep 0.5
      mainmenu
      ;;
    esac

}
mainmenu
