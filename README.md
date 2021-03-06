## PHPIPAM Version 1.4 ##

PHPIPAM installed with PHP:7.4-apache and MYSQL:5.6.49. If you are importing existing data with a new installation then a manual import is recommended. Your backup SQL data can be placed in the volume created and then manually imported (See PHPIPAM documentation for details).

* The volume created links to the database container at /var/lib/mysql
* The url will be localhost:8080/phpipam/

## Docker Compose File ##
    version: "3.8"
    services:
      web:
        image: deonj/phpipam
        container_name: ipam_web
        ports:
          - "8080:80"
        environment:
          TZ: America/Port_of_Spain
        depends_on:
          - db
        tty: true
      db:
        image: mysql:5.6.49
        container_name: ipam_db
        volumes:
          - db-data:/var/lib/mysql
        environment:
          TZ: America/Port_of_Spain
          MYSQL_DATABASE: phpipam
          MYSQL_USER: phpipam
          MYSQL_PASSWORD: phpipamadmin
          MYSQL_ROOT_PASSWORD: <PUT_YOUR_ROOT_PASSWORD_HERE>
          
    volumes:
      db-data:
        name: phpipam_db

The container ecosystem can now be launched as follows:

    docker-compose up -d
