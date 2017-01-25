# /bin/bash

dir=$(pwd)

# Check 2 arguments are given #
if [[ $# -lt 2 ]] || [[ $1 == --help ]] || [[ $1 != -*[vptsw]* ]]; then
	echo "Usage : dirtycat.sh [OPTION] [FILENAME]"
	echo "  dirtycat.sh -vts domains.txt"
	echo "========================================"
	echo "  OPTIONS"
	echo "   -v	:Virtual Host Configuration"
	echo "   -p :Virtual Hosts on Different ports"
	echo "   -t	:Website Template Setup"
	echo "   -w	:WebFEET Setup"
	echo "   -s :Slit setup"
	echo "========================================"
	echo "  Current Categories"
	echo "   HEALTH"
	echo "   FINANCIAL"
	echo "   CHARITY"
	echo "   TECH"
	echo "   CAREER"
	echo "========================================"
	echo "  File Format"
	echo "   web.example.com;TECH"
	exit
fi

# Check the given file is exist #
if [ ! -f $2 ]
then
        echo "Filename \"$2\" doesn't exist"
        exit
fi

option=$1
filename=$2
port=8000

sudo apt-get update && sudo apt-get -q -y upgrade
sudo apt-get -q -y install openssh-server zip unzip curl screen tmux apache2 php libapache2-mod-php php-mcrypt php7.0 libapache2-mod-php7.0 uml-utilities whois
ssh-keygen

while read p; do
	site=$(echo $p | cut -f1 -d\;)
	category=$(echo $p | cut -f2 -d\;)

	#echo $site
	#echo $category

# Virtual Host Configuration
	if [[ $option == *[v]* ]]; then
		cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$site.conf
		ln -s /etc/apache2/sites-available/$site.conf /etc/apache2/sites-enabled/$site.conf

		if [[ $option == *[p]* ]]; then
			sh -c "echo Listen $port | cat - /etc/apache2/sites-available/$site.conf > temp && mv temp /etc/apache2/sites-available/$site.conf"
			sed -ie "s/:80/:$port/g" /etc/apache2/sites-available/$site.conf
			port=$((port+1))
		fi

		sed -ie "s/\#ServerName www.example.com/ServerName $site\nServerAlias $site/g" /etc/apache2/sites-available/$site.conf
		sed -ie "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/$site/g" /etc/apache2/sites-available/$site.conf

		a2ensite $site
	fi

# Website Template Setup
	if [[ $option == *[s]* ]]; then
		mkdir -p /var/www/html/$site

		if [ "$category" == 'HEALTH' ] || [ "$category" == 'health' ] || [ "$category" == 'Health' ]; then
			rand=$(( ( RANDOM % 43 )  + 1 ))
			unzip Templates/HEALTH/$rand*.zip -d /var/www/html/$site/
			mv /var/www/html/$site/web/* /var/www/html/$site/
		fi

		if [ "$category" == 'FINANCIAL' ] || [ "$category" == 'financial' ] || [ "$category" == 'Financial' ]; then
			rand=$(( ( RANDOM % 32 )  + 1 ))
			unzip Templates/FINANCE/$rand*.zip -d /var/www/html/$site/
			mv /var/www/html/$site/web/* /var/www/html/$site/
		fi

		if [ "$category" == 'CHARITY' ] || [ "$category" == 'charity' ] || [ "$category" == 'Charity' ]; then
			rand=$(( ( RANDOM % 19 )  + 1 ))
			unzip Templates/CHARITY/$rand*.zip -d /var/www/html/$site/
			mv /var/www/html/$site/web/* /var/www/html/$site/
		fi

		if [ "$category" == 'TECH' ] || [ "$category" == 'tech' ] || [ "$category" == 'Tech' ]; then
			rand=$(( ( RANDOM % 16 )  + 1 ))
			unzip Templates/TECH/$rand*.zip -d /var/www/html/$site/
			mv /var/www/html/$site/web/* /var/www/html/$site/
		fi

		if [ "$category" == 'CAREER' ] || [ "$category" == 'career' ] || [ "$category" == 'Career' ]; then
			rand=$(( ( RANDOM % 16 )  + 1 ))
			unzip Templates/CAREERS/$rand*.zip -d /var/www/html/$site/
			mv /var/www/html/$site/web/* /var/www/html/$site/
		fi
	fi

done < $filename

if [[ $option != -*[vpt]* ]]; then
	ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
fi

service apache2 restart
letsencrypt --apache

if [[ $option == *[s]* ]]; then
	chmod +x slit_setup.sh
	./slit_setup.sh
fi

if [[ $option == *[w]* ]]; then
	if [ ! -f /home/user/WebFEET-Prestine/ ]; then
        echo "Place WebFEET-Prestine here: /home/user/WebFEET-Prestine/"
        exit
	fi
	cp -r WebFEET-Prestine/ /var/www/html/WF
	echo 'Insert the following into the target page: <iframe src="http://<FQDN>/WF/index2.html" height=10 width=10></iframe>'

fi