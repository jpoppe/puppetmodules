#!/bin/bash

#db_version=$(/usr/bin/rake db:version 2> /dev/null | tail -n1 | cut -d' ' -f3)
#app_version=$(cat /usr/share/puppet-dashboard/db/schema.rb | grep ':version' | tr -dc 0-9\\n)
db_version=$(mysql --defaults-extra-file=/root/.my.cnf -uroot -BN dashboard -e 'SELECT * FROM schema_migrations ORDER BY version DESC LIMIT 1')
app_version=$(ls /usr/share/puppet-dashboard/db/migrate | tail  -n1 | cut -d'_' -f1)

if [ "$db_version" != "$app_version" ]; then
	echo "need to run rake migrate"
	exit 1
else
	exit 0
	echo "db is up to date"
fi
