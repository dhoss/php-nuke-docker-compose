# Use an older, compatible PHP base image with Apache
FROM php:5.6-apache

# Install legacy MySQL extensions required by PHP-Nuke
RUN docker-php-ext-install mysql mysqli

# Copy your PHP-Nuke source code into the web root
COPY ./src/html /var/www/html

RUN echo "HTML: "
RUN echo ls -la /var/www/html
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf
RUN printf '<VirtualHost *:80>\n\tDocumentRoot /var/www/html\n\t<Directory /var/www/html>\n\t\tDirectoryIndex index.php index.html\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tRequire all granted\n\t</Directory>\n</VirtualHost>\n' > /etc/apache2/sites-available/000-default.conf

RUN echo "error_reporting = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED" >> /usr/local/etc/php/php.ini

RUN echo "display_startup_errors = On" >> /usr/local/etc/php/php.ini
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/php.ini

RUN echo "date.timezone = UTC" >> /usr/local/etc/php/php.ini

# Suppress warnings from outputting into the HTML header blocks
RUN echo "display_errors = Off" >> /usr/local/etc/php/php.ini
RUN echo "log_errors = On" >> /usr/local/etc/php/php.ini

# Adjust file permissions for the web server
RUN chown -R www-data:www-data /var/www/html
