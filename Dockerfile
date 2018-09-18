FROM olive007/ubuntu:18.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

# Install php7.2 and apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
						   apache2 \
						   php7.2 \
						   php7.2-zip \
						   php7.2-bz2 \
						   php7.2-gd \
						   libapache2-mod-php7.2

# Customize some php configuration
# Increase the limit size of the uploaded file
#COPY etc/php/7.2/apache2/conf.d/80-custom.ini /etc/php/7.2/apache2/conf.d/80-custom.ini

# Enable services
RUN echo "service apache2 start" >> /usr/local/script/startup.sh
