FROM php:7.4-fpm


ENV WORKDIR "/var/www/laravel"

# Install common tools and libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    zip \
    unzip \
    vim \
    openssl \
    libz-dev \
    libzip-dev \
    libmcrypt-dev \
    autoconf \
    file \
    g++ \
    gcc

# Install PHP database modules
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Install PHP intl module
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils libonig-dev libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl

# Install PHP Image module and libraries
RUN apt-get update && apt-get install -y  \
	libfreetype6-dev libjpeg62-turbo-dev libpng-dev libgd-dev \
	&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install exif

# Install PHP String module
RUN docker-php-ext-install mbstring

# Install Xdebug and Redis
#RUN docker-php-source extract \
#    && pecl install xdebug-alpha redis \
#    && docker-php-ext-enable xdebug redis \
#    && docker-php-source delete

# PHP Zip Archive
RUN apt-get install -y zlib1g-dev \
    && docker-php-ext-install zip

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

# RUN pwd && ls /var/www/laravel
# RUN php /usr/local/bin/composer install --working-dir /var/www/laravel
# Install Node.js (LTS version 8.11.1)
# RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
#   apt-get install -y nodejs

# Set your timezone here
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Tehran /etc/localtime
RUN "date"
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
COPY ./conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./conf/php.ini /usr/local/etc/php/conf.d/php.ini
RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}