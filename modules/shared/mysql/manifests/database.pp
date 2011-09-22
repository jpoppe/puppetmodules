# Define: mysql::database
#
# This define creates a mysql database
#
# == Actions
#
# Create a mysql database
#
# == Parameters
#
# None
#
# == Examples
#
#   mysql::database { 'some_database':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define mysql::database () {

  exec { "Create database ${name}":
    command => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"CREATE DATABASE ${name}\"",
    unless  => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"SELECT IF(EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = \'${name}\'), \'Yes\',\'No\')\" | tail -n1 | grep Yes",
    require => Class['mysql::server'];
  }

}
