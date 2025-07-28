#!/bin/sh

set -e

# # wait for the DB to be ready
# until (mysqladmin ping -h"$MDB_HOST" -u${MDB_USER} -p${MDB_PWD} --silent || exit 1); do 
#     echo "Waiting for MariaDB at $MDB_HOST..."
#     sleep 1
# done

#if wordpress is not already installed
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "[INFO] Installing WordPress..."

    wp config create \
        --dbname=$MDB_NAME \
        --dbuser=$MDB_USER \
        --dbpass=$MDB_PWD \
        --dbhost=$MDB_HOST \
        --path="/var/www/html" \
        --allow-root #doute ici
    
    wp core install \
        --url=WP_URL \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PWD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root #same
    
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PWD \
        --role=subscriber \
        --allow-root

    wp option update home $WP_URL --allow-root 
    wp option update siteurl $WP_URL --allow-root
else
    echo "[INFO] Wordpress already configured"
fi

exec "$@"