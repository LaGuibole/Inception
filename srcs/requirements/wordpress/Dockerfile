# FROM alpine:3.19

# # packet install
# RUN apk update && apk add --no-cache \
#     php \
#     php-fpm \
#     php-mysqli \
#     php-curl \
#     php-dom \
#     php-mbstring \
#     php-opcache \
#     php-session \
#     php-xml \
#     php-zlib \
#     php-phar \
#     curl \
#     mariadb-client \
#     wget \
#     bash \
#     && rm -rf /var/cache/apk/*

# RUN mkdir -p /var/www/wordpress
# WORKDIR /var/www/wordpress

# RUN wget https://wordpress.org/latest.tar.gz && \
#     tar -xzf latest.tar.gz --strip-components=1 && \
#     rm latest.tar.gz

# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#     chmod +x wp-cli.phar && \
#     mv wp-cli.phar /usr/local/bin/wp

# COPY tools/config.sh /tools/config.sh
# RUN chmod +x /tools/config.sh

# # RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# # Redirect PHP-FPM logs to stdout for Docker logs
# RUN ln -sf /dev/stdout /var/log/php7.4-fpm.log

# EXPOSE 9000

# ENTRYPOINT ["/tools/config.sh"]
# CMD ["php-fpm81", "-F"]

FROM debian:bullseye

COPY . .

RUN apt update && apt upgrade -y

# Install necessary packages
RUN apt -y install \
    wget \
    curl \
    netcat \
    php \
    php-mysql \
    php-fpm \
    php-cli \
    mariadb-client

# Create directory for PHP-FPM socket
RUN mkdir -p /run/php
RUN chown -R www-data:www-data /run/php

# Create the /var/www/html directory
RUN mkdir -p /var/www/html

# Install WordPress
RUN wget https://wordpress.org/latest.tar.gz -P /var/www/ \
    && tar -xvf /var/www/latest.tar.gz -C /var/www/html --strip-components=1 \
    && rm -rf /var/www/latest.tar.gz

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Update PHP-FPM configuration to listen on port 9000
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Redirect PHP-FPM logs to stdout for Docker logs
RUN ln -sf /dev/stdout /var/log/php7.4-fpm.log

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT [ "sh", "/tools/config.sh" ]

CMD [ "/usr/sbin/php-fpm7.4", "-F" ]