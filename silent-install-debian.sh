#!/usr/bin/env bash
#	01/12/2015
#	Script tem a finalidade de adicionar alguns repositórios oficiais do Brasil
#	dentro da /etc/apt/sources.list e instalar alguns programas padrões para uso.
#
#	Flávio Oliveira (Flávio Dicas)
#	http://flaviodeoliveira.com.br
#	http://youtube.com/flaviodicas
# http://github.com/oliveiradeflavio
#	oliveiradeflavio@gmail.com

#	verificação de usário root
if [[ `id -u` -ne 0 ]]; then
	echo
		echo "Você precisa ter poderes administrativos (root)"
		echo "O script está sendo finalizado ..."
		sleep 4
		exit
fi

#	verificação de qual versão Debian o usuário tem
check()
{
clear
verificadistro=$(cat /etc/lsb-release | grep "DISTRIB_ID")
verificaversao=$(cat /etc/lsb-release | grep "DISTRIB_RELEASE")

	if [[ $verificadistro == "DISTRIB_ID=Debian" ]] && [[ $verificaversao == "DISTRIB_RELEASE=8.3" ]]; then
		echo "Distribuiçao Debian Jessie"
		echo
		echo -e "\033[04;32mProgramas que serão instalados\033[0m"
		echo -e "Firefox\nGoogle Chrome\nJava Web\nJava JDK\nVLC Player\nAudacious Player\nCodecs\nFlash Player\nFFMulti Converter\nBleachbit\n"
		echo
		sleep 5

		read -n1 -p "Deseja continuar com a instalação? s/n  " escolha
		case $escolha in
			s|S) echo
				repo
				;;
			n|N) echo
				echo Saindo do script!!
				sleep 1
				exit
				;;
			*) echo
				echo Alternativas incorretas! Saindo...
				;;
		esac
	else
		echo
		echo "Script contém alguns comandos ou programas incompativeis com sua distro!"
		echo "saindo..."
		sleep 2
		exit
	fi
}

#	cria um backup da 'sources.list' antes de fazer toda a modificação de repositórios
# lembrando que são repositórios oficias do Brasil e que vocẽ pode encontrar a Lista
#	completa no site do Debian (www.debian.org)
repo()
{
clear
	echo "Criando um backup da sources.list (/etc/apt/sources.list)"
	echo
	cp /etc/apt/sources.list /etc/apt/sources.list_backup ; rm /etc/apt/sources.list 1>/dev/null 2>/dev/stdout
	echo "Backup Concluído e está como '/etc/apt/sources.list_backup'"
	sleep 2
	echo
	echo "Adicionando novos repositórios"
	echo -e "#repositorio_de_pacotes\n""deb http://ftp.br.debian.org/debian/ jessie main contrib non-free\n""#repositorio_backports\n""deb http://ftp.br.debian.org/debian/ jessie-backports main contrib non-free\n""#repositorio_security\n""deb http://security.debian.org/ jessie/updates main contrib non-free\n""repositorio_update\n""deb http://ftp.br.debian.org/debian/ jessie-updates main contrib non-free\n""#repositorio_proposedupdate\n""deb http://ftp.br.debian.org/debian/ jessie-proposed-updates main contrib non-free\n""#repositorio_multimediacodecs\n""deb http://www.deb-multimedia.org jessie main non-free\n""#repositorio_firefox_linuxmint_lmde\n""deb http://packages.linuxmint.com debian import\n" >> /etc/apt/sources.list
	sleep 2
	echo
	echo "Concluído"
key
}

#	importação de chave de segurança para validação de alguns programas a serem instalados
key()
{
clear
	echo "Importando Chaves de Autenticação"
	echo
	gpg --keyserver pgp.mit.edu --recv-keys 3EE67F3D0FF405B2
	gpg --export 3EE67F3D0FF405B2 > 3EE67F3D0FF405B2.gpg
	apt-key add ./3EE67F3D0FF405B2.gpg
	rm ./3EE67F3D0FF405B2.gpg
wget -c http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2015.6.1_all.deb && dpkg -i
deb-multimedia-keyring_2015.6.1_all.deb ; rm deb-multimedia-keyring_2015.6.1_all.deb
	echo
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	echo
	sleep 2
	echo "Concluído"

installation
}

# função principal onde ocorre toda a atualização da source e instalação de programas
installation()
{
clear
	echo "Atualizando Lista de Fontes"
	apt-get update 1>/dev/null 2>/dev/stdout
	echo
	echo "Instalando Programas"
	sleep 1
	clear
	echo "Instalando Firefox"
	apt-get install firefox -y ; apt-get install -f -y
	apt-get install firefox-l10n-pt-br -y
	clear
	echo "Instalando Chrome"
	apt-get install google-chrome-stable -y ; apt-get install -f -y
	clear
	echo "Instalando o Java Web e JDK"
	apt-get install oracle-java8-installer -y
	clear
	echo "Instalando o VLC Player"
	apt-get install vlc -y ; apt-get install -f -y
	clear
	echo "Instalando o Audacious Music"
	apt-get install audacious -y ; apt-get install -f -y
	clear
	echo "Instalando Codecs Debian Multimedia"
apt-get install gstreamer0.10-fluendo-mp3 gstreamer0.10-plugins-really-bad
ffmpeg sox twolame vorbis-tools lame faad w64codecs libdvdcss2 faac faad
ffmpeg2theora flac icedax id3v2 lame libflac++6 libjpeg-progs mencoder
mjpegtools mpeg2dec mpeg3-utils mpegdemux mpg123 mpg321 regionset sox
uudeview vorbis-tools x264 arj p7zip p7zip-full p7zip-rar rar unrar
unace-nonfree sharutils uudeview mpack cabextract libdvdread4 libav-tools -y
	clear
	echo "Instalando o Adobe Flash Player"
	apt-get install flashplugin-nonfree -y ; apt-get install -f -y
	clear
	echo "Instalando o Bleachbit"
	apt-get install bleachbit -y ; apt-get install -f -y
	clear
	echo "Instalando o conversor FF Multi Converter 1.7"
	apt-get install ffmulticonverter -y ; apt-get install -f -y
	echo
	apt-get dist-upgrade -y 1>/dev/null 2>/dev/stdout
	clear
	echo "Instalação Concluída"
}
clear
	echo "Bem vindo!! Script instalará programas básicos e codecs no seu Debian"
	echo
	echo "Script está analisando seu sistema, aguarde..."
	sleep 2
	check
