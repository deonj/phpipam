FROM php:7.4-apache
RUN apt-get update
RUN apt-get install -y libpng-dev libgmp-dev libxml2-dev
RUN docker-php-ext-install opcache gd gmp xmlrpc intl mysqli sockets gettext pdo_mysql
RUN rm -rf /var/lib/apt/lists/*
# ADD phpipam-1.4.tar /var/www/html/
RUN wget https://sourceforge.net/projects/phpipam/files/latest/download/phpipam-1.4.tar
RUN tar -C /var/www/html -xvf phpipam-1.4.tar
RUN rm phpipam-1.4.tar
RUN mv /var/www/html/phpipam/config.dist.php /var/www/html/phpipam/config.php
WORKDIR /etc/apache2/sites-enabled
RUN sed -i '$ a \\n<Directory /var/www/html/phpipam>' 000-default.conf
RUN sed -i '$ a \\tOptions FollowSymLinks' 000-default.conf
RUN sed -i '$ a \\tAllowOverride all' 000-default.conf
RUN sed -i '$ a \\tRequire all granted' 000-default.conf
RUN sed -i '$ a \\tOrder allow,deny' 000-default.conf
RUN sed -i '$ a \\tAllow from all' 000-default.conf
RUN sed -i '$ a </Directory>' 000-default.conf
RUN chown -R www-data:www-data /var/www/html/phpipam
RUN chmod -R 755 /var/www/html/phpipam
RUN sed -i "s/define('BASE', \"\/\");/define('BASE', \"\/phpipam\/\");/" /var/www/html/phpipam/config.php
RUN sed -i "s/\$db\['host'\] = 'localhost'/\$db\['host'\] = 'db'/" /var/www/html/phpipam/config.php
RUN a2enmod rewrite
