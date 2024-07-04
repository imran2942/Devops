# Use an official PHP image as the base image
FROM php:8.2-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        unzip \
        curl \
        git \
        inetutils-ping \
    && docker-php-ext-install pdo_mysql zip

#RUN git clone https://github.com/aircrack-ng/aircrack-ng

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy the Laravel application files to the container
COPY . .

ENV COMPOSER_ALLOW_SUPERUSER=1


#install dockerize
#RUN curl -L -o /usr/local/bin/dockerize \
#    https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz \
#    && tar -C /usr/local/bin -xzvf /usr/local/bin/dockerize

# Install Laravel dependencies
#RUN composer config --no-plugins allow-plugins.pixelfear/composer-dist-plugin true
RUN composer update
RUN composer install --optimize-autoloader --no-dev

# Generate application key
RUN php artisan key:generate

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port 80
EXPOSE 80

#RUN chmod +x wait-script.sh

#RUN chmod +x timer.sh


# Wait for the database to be ready before running migrations
#RUN ["./wait-script.sh"]  # Assuming the script is in the same directory
#RUN ["./timer.sh"]
# Wait for the database to be ready before running migrations
#RUN ["dockerize", "-wait", "tcp://database:3306", "-timeout", "200s", "php", "artisan", "migrate", "--force"]

#RUN php artisan migrate

# Start Apache server
CMD php artisan serve --host=0.0.0.0 --port=80
