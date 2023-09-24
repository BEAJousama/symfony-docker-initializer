# Base image
FROM php:8.2-cli

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    wget \
    libpq-dev \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-install pdo_mysql pdo_pgsql zip intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Set the working directory
WORKDIR /var/www/html

# Copy the Symfony project
COPY . .

RUN git config --global http.sslVerify false

# Install project dependencies
RUN composer install --no-scripts --no-interaction

# Expose port 8000 for Symfony web server
EXPOSE 8000

# Start the Symfony server
CMD ["symfony", "server:start", "--no-tls", "--allow-http"]