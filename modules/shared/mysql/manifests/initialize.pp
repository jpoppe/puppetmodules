# Define: initialize
#
# This define initializes a mysql database
#
# == Actions
#
# Initialize a mysql database
#
# == Parameters
#
# [*initialize*]
#   Source to use for for initialization script
#
# [*unless*]
#   Run this command to check if we need to run the initialization script
#
# == Examples
#
#   mysql::initialize { 'puppet':
#     initialize => 'puppet:///modules/sn_puppetmaster/var/cache/mysql/mysql_initialize.sh',
#     unless     => '/usr/bin/mysql -B -e "SELECT IF(EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = \'puppet\'), \'Yes\',\'No\')" | tail -n1 | grep Yes';
#   }
#
define mysql::initialize (
  $initialize,
  $unless
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0700'
  }

  file { "/var/lib/puppet/var/mysql_initialize_${name}.sh":
    ensure  => present,
    source  => $initialize;
  }

  exec { "mysql_initialize_${name}.sh":
    command   => "/var/lib/puppet/var/mysql_initialize_${name}.sh",
    unless    => $unless,
    logoutput => on_failure,
    require   => [File["/var/lib/puppet/var/mysql_initialize_${name}.sh"], Service['mysql']];
    #require   => [File["/var/lib/puppet/var/mysql_initialize_${name}.sh"], Service['mysql'], Package['mysql-server-5.1', 'mysql-client-5.1']];
  }
}
