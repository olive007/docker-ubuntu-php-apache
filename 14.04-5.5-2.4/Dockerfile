FROM olive007/ubuntu:14.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

ARG GIT_URL=https://raw.githubusercontent.com/olive007/docker-commonFile
ARG PHP_VERSION=5

# Install php5 and apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
						   apache2 \
						   php${PHP_VERSION} \
						   php${PHP_VERSION}-cgi \
						   php${PHP_VERSION}-cli \
						   php${PHP_VERSION}-common \
						   php${PHP_VERSION}-curl \
						   php${PHP_VERSION}-enchant \
						   php${PHP_VERSION}-fpm \
						   php${PHP_VERSION}-gd \
						   php${PHP_VERSION}-gmp \
						   php${PHP_VERSION}-imap \
						   php${PHP_VERSION}-interbase \
						   php${PHP_VERSION}-intl \
						   php${PHP_VERSION}-json \
						   php${PHP_VERSION}-ldap \
						   php${PHP_VERSION}-mcrypt \
						   php${PHP_VERSION}-mysql \
						   php${PHP_VERSION}-odbc \
						   php${PHP_VERSION}-pgsql \
						   php${PHP_VERSION}-pspell \
						   php${PHP_VERSION}-readline \
						   php${PHP_VERSION}-recode \
						   php${PHP_VERSION}-sybase \
						   php${PHP_VERSION}-tidy \
						   php${PHP_VERSION}-xdebug \
						   php${PHP_VERSION}-xmlrpc \
						   php${PHP_VERSION}-xsl \
						   libapache2-mod-fastcgi


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
# - fastcgi to use php-fpm
# - alias (require for php-fpm)
RUN a2enmod info actions fastcgi alias
RUN a2enconf php5-cgi

# Display the php error on the web page
RUN sed -i 's/^display_errors = .*$/display_errors = On/' /etc/php5/fpm/php.ini

# Add script configuration for apache and php
ADD $GIT_URL/master/usr/local/script/entry-point.d/apache.sh /usr/local/script/entry-point.d/apache.sh
ADD $GIT_URL/php5/usr/local/script/entry-point.d/php.sh /usr/local/script/entry-point.d/php.sh
ADD $GIT_URL/php5/etc/apache2/conf-enabled/php5-cgi.conf /etc/apache2/conf-enabled/php5-cgi.conf

# Enable services
RUN echo "service php5-fpm start" >> /usr/local/script/startup.sh
RUN echo "service apache2 start" >> /usr/local/script/startup.sh


# Stop SSH service with the container-stopped script
RUN echo "service php5-fpm stop" >> /usr/local/script/container-stopped.sh
RUN echo "service apache2 stop" >> /usr/local/script/container-stopped.sh


# Define Environment variable
ENV XDEBUG_IDEKEY=PHPSTORM
ENV PHP_INIT_POST_MAX_SIZE=2.2G
ENV PHP_INIT_UPLOAD_MAX_FILESIZE=2G
