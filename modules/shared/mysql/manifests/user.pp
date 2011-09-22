# Define: mysql::user
#
# This define creates a mysql user
#
# == Actions
#
# Create a mysql user
#
# == Parameters
#
# [*password*]
#   Password for this user
#
# [*host*]
#   Host where the user is allowed access from. Defaults to 'localhost'
#
# [*requires*]
#   Create the user after this resource
#
# == Examples
#
#   mysql::user { 'someuser': password => 'some_password'; }
#
define mysql::user (
  $password,
  $host      = 'localhost',
  $requires
  ) {

  #Class['mysql'] -> Exec["Create user ${name}@${host}"]

  exec { "Create user ${name}@${host}":
    command => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"CREATE USER ${name}@\'${host}\' IDENTIFIED BY \'${password}\'\"",
    unless  => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"SELECT IF(EXISTS (SELECT User FROM mysql.user WHERE User = \'${name}\'), \'Yes\', \'No\')\" | tail -n1 | grep Yes",
    require => $requires;
  }

}
