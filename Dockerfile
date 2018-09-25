ARG CONTAINER_USER
FROM olive007/ubuntu:18.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

ARG PHP_VERSION=7.2

# Install php7.2 and apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
                                   apt-get upgrade -y -qq &&                      \
                                   apt-get install -y -qq --no-install-recommends \
						   apache2 \
						   locales \
						   php-xdebug \
						   php${PHP_VERSION} \
						   php${PHP_VERSION}-bcmath \
						   php${PHP_VERSION}-bz2 \
						   php${PHP_VERSION}-cgi \
						   php${PHP_VERSION}-cli \
						   php${PHP_VERSION}-common \
						   php${PHP_VERSION}-curl \
						   php${PHP_VERSION}-dba \
						   php${PHP_VERSION}-enchant \
						   php${PHP_VERSION}-fpm \
						   php${PHP_VERSION}-gd \
						   php${PHP_VERSION}-gmp \
						   php${PHP_VERSION}-imap \
						   php${PHP_VERSION}-interbase \
						   php${PHP_VERSION}-intl \
						   php${PHP_VERSION}-json \
						   php${PHP_VERSION}-ldap \
						   php${PHP_VERSION}-mbstring \
						   php${PHP_VERSION}-mcrypt \
						   php${PHP_VERSION}-mysql \
						   php${PHP_VERSION}-odbc \
						   php${PHP_VERSION}-opcache \
						   php${PHP_VERSION}-pgsql \
						   php${PHP_VERSION}-phpdbg \
						   php${PHP_VERSION}-pspell \
						   php${PHP_VERSION}-readline \
						   php${PHP_VERSION}-recode \
						   php${PHP_VERSION}-snmp \
						   php${PHP_VERSION}-soap \
						   php${PHP_VERSION}-sqlite3 \
						   php${PHP_VERSION}-sybase \
						   php${PHP_VERSION}-tidy \
						   php${PHP_VERSION}-xml \
						   php${PHP_VERSION}-xmlrpc \
						   php${PHP_VERSION}-xsl \
						   php${PHP_VERSION}-zip \
						   libapache2-mod-php${PHP_VERSION} \
						   snmp-mibs-downloader # php-snmp dependency

# Install Composer
RUN wget -q https://getcomposer.org/installer -O/tmp/composer-setup.php && \
    [ `sha384sum /tmp/composer-setup.php | cut -d' ' -f1` = `wget -q -O - https://composer.github.io/installer.sig` ] && \
    cat /tmp/composer-setup.php | php -- --install-dir=/usr/local/bin --filename=composer && \
    rm /tmp/composer-setup.php

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Customize apache configuration
RUN echo "export APACHE_RUN_USER=$CONTAINER_USER_NAME" >> /etc/apache2/envvars
RUN echo "export APACHE_RUN_GROUP=$CONTAINER_USER_NAME" >> /etc/apache2/envvars

RUN rm -rf /var/www/html/*
VOLUME /var/www/html

# Change the permission of everything which is under /var/www
RUN echo "chown $CONTAINER_USER_NAME:$CONTAINER_USER_NAME /var/www/*"

# Remove the apache warning
RUN echo "echo \"ServerName \"`hostname -i` >> /etc/apache2/apache2.conf" >> /usr/local/script/startup.sh

# Enable services
RUN echo "ln -s /var/www/html /home/$CONTAINER_USER_NAME/www" >> /usr/local/script/startup.sh && \
    echo "service apache2 start" >> /usr/local/script/startup.sh
