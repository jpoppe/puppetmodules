# Class: mysql::server
# 
# This class manages the installation and configuration of a mysql server
#
# == Actions
#
#   Configure and install mysql::server
#
# == Parameters
#
# [*mysql_server_pkgname*]
#   mysql server package name to install and use, defaults to mysql-server-5.1
#
# [*mysql_root_password*]
#   root password for mysql 
#
# [*mysql_bootstrap*]
#   script to run after mysql installations
#
# [*sql_bootstrap_unless*]
#   command to check if the bootstrap script has been executed successfully
#
# == Examples
#
#   $mysql_root_password       = 'password'
#   $mysql_server_pkgname      = 'percona-server-server-5.1'
#   $mysql_server_seed_entries = [
#        "percona-server-server-5.1       percona-server-server/root_password     $mysql_root_password",
#        "percona-server-server-5.1       percona-server-server/root_password_again       $mysql_root_password",
#        'percona-server-server-5.1       percona-server-server/error_setting_password    error',
#        'percona-server-server-5.1       percona-server-server/no_upgrade_when_using_ndb error',
#        'percona-server-server-5.1       percona-server-server-5.1/really_downgrade      boolean false',
#        'percona-server-server-5.1       percona-server-server-5.1/start_on_boot boolean true',
#        'percona-server-server-5.1       percona-server-server/password_mismatch error',
#        'percona-server-server-5.1       percona-server-server-5.1/postrm_remove_databases       boolean false',
#        'percona-server-server-5.1       percona-server-server-5.1/nis_warning   note'
#        ]
#   $mysql_bootstrap           = 'puppet:///modules/sn_puppetmaster/var/cache/mysql/mysql_bootstrap.sh'
#   $mysql_bootstrap_unless    = '/usr/bin/mysql -B -e "SELECT IF(EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = \'puppet\'), \'Yes\',\'No\')" | tail -n1 | grep Yes'
#   $mysql_isamchk_entries     = [ ]
#   $mysql_mysqld_entries      = [ ]
#   $mysql_mysqld_safe_entries = [ ]
#   $mysql_mysqldump_entries   = [ ]
#
#   class { 'mysql::server':; }
#
class mysql::server inherits mysql {

  File {
    owner  => 'root',
    group  => 'root'
  }

  if ! $mysql_server_pkgname {
    $mysql_server_pkgname = 'mysql-server-5.1'
  }

  if ! $mysql_root_password {
    $mysql_root_password = ''
  }

  if ! $mysql_server_seed_entries {
    $mysql_server_seed_entries = [
              "mysql-server-5.1        mysql-server/root_password_again        password     $mysql_root_password",
              "mysql-server-5.1        mysql-server/root_password      password     $mysql_root_password",
              'mysql-server-5.1        mysql-server/error_setting_password     error',
              'mysql-server-5.1        mysql-server-5.1/nis_warning    note',
              'mysql-server-5.1        mysql-server-5.1/really_downgrade       boolean false',
              'mysql-server-5.1        mysql-server-5.1/start_on_boot  boolean true',
              'mysql-server-5.1        mysql-server-5.1/postrm_remove_databases        boolean false',
              'mysql-server-5.1        mysql-server/password_mismatch  error',
              'mysql-server-5.1        mysql-server/no_upgrade_when_using_ndb  error'
              ]
  }

  $mysql_server_package = $mysql_package ? {
    percona => 'percona-server-server-5.1',
    default => 'mysql-server-5.1'
  }

  user { 'mysql':
    require => Package["$mysql_server_pkgname"];
  }

  package { $mysql_server_pkgname:
    ensure       => installed,
    responsefile => "/var/cache/debconf/${mysql_server_pkgname}.seed",
    require      => File["/var/cache/debconf/${mysql_server_pkgname}.seed"];
  }

  file { "/var/cache/debconf/${mysql_server_pkgname}.seed":
    content => inline_template("<% ${mysql_server_seed_entries}.each do |entry| %><%= entry %><% end -%>"),
    mode    => '0600',
    ensure  => present;
  }

  file { '/root/.my.cnf':
    content => template('mysql/root/.my.cnf.erb'),
    mode    => '0600',
    ensure  => present;
  }

  file { '/usr/local/bin/mysqltuner.pl':
    source => 'puppet:///modules/mysql/usr/local/bin/mysqltuner.pl',
    mode   => '0755',
    ensure => present;
  }

  if $mysql_bootstrap {

    file { 
      '/var/cache/mysql':
        ensure => directory,
        mode   => '0700';
      '/var/cache/mysql/mysql_bootstrap.sh':
        ensure => present,
        source => "$mysql_bootstrap",
        mode   => '0700';
    }

    exec { '/var/cache/mysql/mysql_bootstrap.sh':
      unless  => "$mysql_bootstrap_unless",
      require => [ File['/var/cache/mysql/mysql_bootstrap.sh'], Package[ "$mysql_server_package", "$mysql_client_package" ] ];
    }

  }

}
