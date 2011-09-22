#!/bin/bash

mysql --defaults-extra-file=/root/.my.cnf -uroot -e "CREATE DATABASE puppet;"
mysql --defaults-extra-file=/root/.my.cnf -uroot -e "GRANT ALL PRIVILEGES ON puppet.* TO puppet@localhost IDENTIFIED BY 'puppet123';"
