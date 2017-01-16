# /bin/bash

dir=$(pwd)

# Check 2 arguments are given #
if [[ $# -lt 2 ]] || [[ $1 == --help ]] || [[ $1 != -*[vsc]* ]]; then
	echo "Usage : dirtycat.sh [OPTION] [FILENAME]"
	echo "  dirtycat.sh -vsc domains.txt"
	echo "========================================"
	echo "  OPTIONS"
	echo "   -v	:Virtual Host Configuration"
	echo "   -s	:Website Template Setup"
	echo "   -c	:Categorize Websites"
	exit
fi

# Check the given file is exist #
if [ ! -f $2 ]
then
        echo "Filename \"$2\" doesn't exist"
        exit
fi

option = $1
filename = $2

apt-get -q -y install zip unzip curl screen tmux apache2 php libapache2-mod-php php-mcrypt

while read p; do
	site=$(echo $p | cut -f1 -d\;)
	category=$(echo $p | cut -f2 -d\;)

	#echo $site
	#echo $category

# Virtual Host Configuration
	if [[ $option == *[v]* ]]; then
		cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$site.conf
		ln -s /etc/apache2/sites-available/$site.conf /etc/apache2/sites-enabled/$site.conf

		sed -ie "s/\#ServerName www.example.com/ServerName $site\nServerAlias www.$site/g" /etc/apache2/sites-available/$site.conf
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

		if [ "$category" == 'FINANCE' ] || [ "$category" == 'finance' ] || [ "$category" == 'Finance' ]; then
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
			unzip Templates/CHARITY/$rand*.zip -d /var/www/html/$site/
			mv /var/www/html/$site/web/* /var/www/html/$site/
		fi

		if [ "$category" == 'CAREER' ] || [ "$category" == 'career' ] || [ "$category" == 'Career' ]; then
			rand=$(( ( RANDOM % 16 )  + 1 ))
			unzip Templates/CHARITY/$rand*.zip -d /var/www/html/$site/
			mv /var/www/html/$site/web/* /var/www/html/$site/
		fi
	fi


done < $filename


service apache2 restart
