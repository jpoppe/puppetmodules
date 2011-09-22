# Define: mysql::import
#
# This define imports a mysql database based on a template
#
# == Actions
#
# Import a mysql database
#
# == Parameters
#
# [*database*]
#   Database to import into. Defaults to false
#
# [*source*]
#   Source to be used for the import
#
# [*unless*]
#   Unless condition.
#
# == Notes
#
# Since qa_cs_gumtree uses this define without specifying the database, we need to add
# a default value of 'false'.
# 
# == Examples
#
#   mysql::import { 'some_description':
#     content => 'yourmodule/var/lib/puppet/var/mysql_update_some_database.sql.erb',
#     unless  => 'some unless statements';
#   }
#
define mysql::import (
  $database = false,
  $source,
  $unless
  ) {

  Service['mysql'] -> Exec["mysql_import_${name}.sql"]

  File {
    owner => 'root',
    group => 'root',
    mode  => '0700'
  }

  file { "/var/lib/puppet/var/mysql_import_${name}.sql":
    ensure  => present,
    source  => $source,
    mode    => '0600';
  }

  if $database {

    exec { "mysql_import_${name}.sql":
      command   => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -u root ${database} < /var/lib/puppet/var/mysql_import_${name}.sql",
      unless    => $unless,
      logoutput => on_failure,
      require   => [File["/var/lib/puppet/var/mysql_import_${name}.sql"], Service['mysql']];
    }

  } else {

    exec { "mysql_import_${name}.sql":
      command   => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -u root < /var/lib/puppet/var/mysql_import_${name}.sql",
      unless    => $unless,
      logoutput => on_failure,
      require   => [File["/var/lib/puppet/var/mysql_import_${name}.sql"], Service['mysql']];
    }

  }

}
