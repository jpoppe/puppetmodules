#!/bin/bash

mysql --defaults-extra-file=/root/.my.cnf -uroot -e "CREATE DATABASE dashboard CHARACTER SET utf8"
mysql --defaults-extra-file=/root/.my.cnf -uroot -e "CREATE USER 'dashboard'@'localhost' IDENTIFIED BY 'puppet123'"
mysql --defaults-extra-file=/root/.my.cnf -uroot -e "GRANT ALL PRIVILEGES ON dashboard.* TO 'dashboard'@'localhost'"
