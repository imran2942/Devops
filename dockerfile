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
    && docker-php-ext-install pdo_mysql zip

RUN git clone https://github.com/aircrack-ng/aircrack-ng

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Laravel application files to the container
COPY . .

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer update
# Install Laravel dependencies
RUN composer install --optimize-autoloader --no-dev

# Generate application key
RUN php artisan key:generate

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port 80
EXPOSE 80

CMD php artisan migrate

# Start Apache server
CMD php artisan serve --host=0.0.0.0 --port=80
