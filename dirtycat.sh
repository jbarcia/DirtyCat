# /bin/bash

apt-get -y install zip unzip curl screen tmux apache2 php libapache2-mod-php php-mcrypt

# Generate vhosts
while read p; do
site=$(echo $p | cut -f1 -d\;)
category=$(echo $p | cut -f2 -d\;)

echo $site
echo $category
mkdir -p /var/www/html/$site

cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$site.conf
ln -s /etc/apache2/sites-available/$site.conf /etc/apache2/sites-enabled/$site.conf

sed -ie "s/\#ServerName www.example.com/ServerName $site\nServerAlias www.$site/g" /etc/apache2/sites-available/$site.conf
sed -ie "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/$site/g" /etc/apache2/sites-available/$site.conf

a2ensite $site

if [ "$category" == 'HEALTH' ] || [ "$category" == 'health' ] || [ "$category" == 'Health' ]; then
	rand=$(( ( RANDOM % 43 )  + 1 ))
	unzip Templates/HEALTH/$rand*.zip -d /var/www/html/$site/
	mv /var/www/html/$site/web/* /var/www/html/$site/
fi

done < $1


service apache2 restart
