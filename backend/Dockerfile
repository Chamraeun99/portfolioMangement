# Change from 8.3 to 8.4 to support Laravel 13/Symfony 8 requirements
FROM php:8.4-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpq-dev \
    libzip-dev \
    unzip \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_pgsql pgsql zip bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy composer files first for layer caching
COPY composer.json composer.lock ./
# We add --ignore-platform-reqs just in case, but PHP 8.4 fixes the main issue
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy package.json and install node deps for Vite build
COPY package.json package-lock.json* ./
RUN npm install

# Copy the rest of the application
COPY . .

# Re-run composer scripts (post-autoload-dump, etc.)
RUN composer dump-autoload --optimize

# Build frontend assets with Vite
RUN npm run build

# Create storage directories and set permissions
RUN mkdir -p storage/framework/{sessions,views,cache} \
    && mkdir -p storage/logs \
    && mkdir -p bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Expose port (Render uses PORT env variable)
EXPOSE 8000

# Start script: cache config/routes, run migrations, then serve
# We use the ${PORT} variable which Render provides automatically
CMD php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=${PORT:-8000}