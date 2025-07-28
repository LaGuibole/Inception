FROM alpine:3.19

# Installing necessary packets
RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    bash \
    openrc \
    tzdata \
    && rm -rf /var/cache/apk/*

# Creating required folders 
RUN mkdir -p /run/mysqld /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copying config files and init script
COPY tools/config.sh /config.sh
RUN chmod +x /config.sh

# Expose port
EXPOSE 3306

ENTRYPOINT ["/config.sh"]