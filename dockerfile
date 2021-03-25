FROM php:7.4.16-apache
RUN apt-get update && apt-get install -y libpng-dev libgmp-dev libxml2-dev wget &&\
    docker-php-ext-install opcache gd gmp intl mysqli sockets gettext pdo_mysql &&\
    rm -rf /var/lib/apt/lists/* &&\
    wget https://sourceforge.net/projects/phpipam/files/latest/download/phpipam-1.4.tar &&\
    tar -C /var/www/html -xvf phpipam-1.4.tar && rm phpipam-1.4.tar &&\
    mv /var/www/html/phpipam/config.dist.php /var/www/html/phpipam/config.php
WORKDIR /etc/apache2/sites-enabled
RUN sed -i '$ a \\n<Directory /var/www/html/phpipam>' 000-default.conf &&\
    sed -i '$ a \\tOptions FollowSymLinks' 000-default.conf &&\
    sed -i '$ a \\tAllowOverride all' 000-default.conf &&\
    sed -i '$ a \\tRequire all granted' 000-default.conf &&\
    sed -i '$ a \\tOrder allow,deny' 000-default.conf &&\
    sed -i '$ a \\tAllow from all' 000-default.conf &&\
    sed -i '$ a </Directory>' 000-default.conf &&\
    chown -R www-data:www-data /var/www/html/phpipam &&\
    chmod -R 755 /var/www/html/phpipam &&\
    sed -i "s/define('BASE', \"\/\");/define('BASE', \"\/phpipam\/\");/" /var/www/html/phpipam/config.php &&\
    sed -i "s/\$db\['host'\] = 'localhost'/\$db\['host'\] = 'db'/" /var/www/html/phpipam/config.php &&\
    a2enmod rewrite
