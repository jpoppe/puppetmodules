# Class: mysql::server
# 
# This class manages the installation and configuration of a mysql server
#
# == Parameters
#
# [*root_password*]
#   root password for mysql
#
# [*server_package*]
#   Server package to use. Can be 'percona' or undef. Defaults to undef
#
# [*my_cnf*]
#   Template location for my.cnf, defaults to undef
#
# == Actions
#
#   Configure and install mysql::server
#
# == Examples
#
#   class { 'mysql::server':
#     root_password => 'some_password';
#   }
#
#   class { 'mysql::server':
#     root_password  => 'some_password',
#     server_package => 'percona';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class mysql::server (
  $root_password  = '',
  $server_package = undef,
  $my_cnf         = undef
  ) {

  File {
    owner => 'root',
    group => 'root'
  }

  $package = $server_package ? { percona => 'percona-server-server-5.1', default => 'mysql-server-5.1' }

  user { 'mysql': require => Package[$package]; }

  service { 'mysql':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package["${package}"];
  }

  package { $package:
    ensure       => present,
    responsefile => '/var/cache/debconf/mysql-server-5.1.seed',
    require      => File['/var/cache/debconf/mysql-server-5.1.seed', '/root/.my.cnf'];
  }

  file { '/var/cache/debconf/mysql-server-5.1.seed':
    ensure  => present,
    mode    => '0600',
    content => template('mysql/var/cache/debconf/mysql-server-5.1.seed.erb');
  }

  if $my_cnf {

    file {
      '/etc/mysql':
        ensure  => directory,
        mode    => '0755';
      '/etc/mysql/my.cnf':
        ensure  => present,
        content => template($my_cnf),
        mode    => '0640',
        notify  => Service['mysql'],
        before  => Package["${package}"];
    }

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

}
