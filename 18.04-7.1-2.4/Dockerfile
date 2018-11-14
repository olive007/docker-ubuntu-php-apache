FROM olive007/ubuntu:18.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

ARG GIT_URL=https://raw.githubusercontent.com/olive007/docker-commonFile
ARG PHP_VERSION=7.1

# Install php7.1 and apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq gnupg && \
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ondrej-php.list && \
    echo "# deb-src http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" >> /etc/apt/sources.list.d/ondrej-php.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
						   apache2 \
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
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


RUN rm -rf /var/www/*
# Here the user have to define a volume into /var/www/html
VOLUME /var/www/html

# Add file to get server information
RUN mkdir /var/www/info
ADD $GIT_URL/master/var/www/info/index.html /var/www/info/index.html 
ADD $GIT_URL/master/var/www/info/phpinfo.php /var/www/info/phpinfo.php
RUN chmod 644 /var/www/info/index.html /var/www/info/phpinfo.php 

# Add configuration file for apache
ADD $GIT_URL/master/etc/apache2/sites-available/000-info.conf /etc/apache2/sites-available/000-info.conf
RUN chmod 644 /etc/apache2/sites-available/000-info.conf
RUN echo "Listen 88" >> /etc/apache2/ports.conf && a2ensite 000-info

# Enable
# - proxy_fcgi (php-fpm depency)
# - info to get information on ADDR_IP:88/apache
RUN a2enmod info proxy_fcgi
# Disable php to use php-fpm
RUN a2dismod php$PHP_VERSION && a2enconf php$PHP_VERSION-fpm

# Display the php error on the web page
RUN sed -i 's/^display_errors = .*$/display_errors = On/' /etc/php/${PHP_VERSION}/fpm/php.ini

# Fix PHP-FPM Error (unable to connect to Unix domain socket /run/php/${PHP_VERSION}-fpm.sock)
RUN mkdir /run/php


# Add script configuration for apache and php
ADD $GIT_URL/master/usr/local/script/entry-point.d/apache.sh /usr/local/script/entry-point.d/apache.sh
ADD $GIT_URL/master/usr/local/script/entry-point.d/php.sh /usr/local/script/entry-point.d/php.sh
RUN chmod 644 /usr/local/script/entry-point.d/apache.sh /usr/local/script/entry-point.d/php.sh

# Enable services
RUN echo "service php$PHP_VERSION-fpm start" >> /usr/local/script/startup.sh
RUN echo "service apache2 start" >> /usr/local/script/startup.sh


# Stop SSH service with the container-stopped script
RUN echo "service ssh stop" >> /usr/local/script/container-stopped.sh


# Define Environment variable
ENV XDEBUG_IDEKEY=PHPSTORM
ENV PHP_INIT_POST_MAX_SIZE=2.2G
ENV PHP_INIT_UPLOAD_MAX_FILESIZE=2G
