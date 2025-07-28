#!/bin/sh

set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql
rm -f /run/mysqld/mysqld.sock

# INIT MARIADB IF NECESSARY
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi
mysqld --user=mysql --skip-networking &
pid="$!"

# Wait for mariabd
until mysqladmin ping -u${MDB_USER} -p${MDB_PWD} --silent; do 
    echo "[INFO] Waiting for MariaDB to be ready..."
    sleep 1
done

echo "[INFO] Creating database and users..."
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MDB_NAME}\`;
CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_PWD}';
CREATE USER IF NOT EXISTS '${MDB_USER}'@'localhost' IDENTIFIED BY '${MDB_PWD}';
GRANT ALL PRIVILEGES ON \`${MDB_NAME}\`.* TO '${MDB_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${MDB_NAME}\`.* TO '${MDB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${MDB_ROOT}" shutdown || kill "$pid"


echo "[INFO] Starting MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0 --port=3306 --skip-networking=0