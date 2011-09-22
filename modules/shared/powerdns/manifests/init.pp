# Class: powerdns
#
# This class installs powerdns
#
# == Actions
#
# Install powerdns
#
# == Parameters
#
# [*master*]
#   Configure PowerDNS to be a master. Defaults to false
#
# [*slave*]
#   Configure PowerDNS to be a slave. Defaults to false
#
# [*recursor*]
#   Enable the PowerDNS recursor. Defaults to false
#
# [*backend*]
#   Backend to use. Can be 'mysql' or 'sqlite3'. Defaults to mysql
#
# [*axfr_allowed*]
#   Comma separated list of ip's that are allowed to run AXFR queries. Defaults to false
#
# [*recurse_allowed*]
#   Comma separated list of ip's that are allowed to run recursive queries. Defaults to false
#
# [*listen_address*]
#   Address where PowerDNS binds to. Defaults to $ipaddress
#
# [*recursor_address*]
#   Address where the recursor binds to. Defaults to '127.0.0.1'
#
# [*recursor_port*]
#   Port where the recursor binds to.  Defaults to '15353'
#
# [*default_soa_name*]
#   Default SOA name when there is none configured. Defaults to 'powerdns'
#
# [*webserver*]
#   Run the built-in webserver. Defaults to false
#
# [*webserver_address*]
#   Address where the webserver binds to. Defaults to '127.0.0.1'
#
# [*webserver_port*]
#   Port where the webserver binds to. Defaults to '18081'
#
# [*db_host*]
#   Where to connect to for the database. Defaults to 'localhost'
#
# [*db_user*]
#   User used to connect to the database. Defaults to 'pdns'
#
# [*db_password*]
#   Password used to connect to the database. Defaults to 'pdns123'
#
# [*db_name*]
#   Name for the database. Defaults to 'pdns'
#
# [*forward_zones*]
#   Zones to forward to a specific dns server. Defaults to false
#
# == Notes
#
# Make sure to keep the documentation up-to-date during development of this
# module.
#
# == Examples
#
#   class { 'powerdns':; }
#
# == Resources
#
# http://doc.powerdns.com/
#
# == Authors
#
# Lex van Roon <lvanroon@ebay.com>
# Jasper Poppe <jpoppe@ebay.com>
#
class powerdns (
  $master            = false,
  $slave             = false,
  $recursor          = false,
  $backend           = 'mysql',
  $axfr_allowed      = false,
  $recurse_allowed   = false,
  $listen_address    = "$ipaddress",
  $query_address     = "$ipaddress",
  $recursor_address  = '127.0.0.1',
  $recursor_port     = '15353',
  $default_soa_name  = 'powerdns',
  $webserver         = false,
  $webserver_address = '127.0.0.1',
  $webserver_port    = '18081',
  $db_host           = 'localhost',
  $db_user           = 'pdns',
  $db_password       = 'pdns123',
  $db_name           = 'pdns',
  $forward_zones     = false
  ) {

  if !$master and !$slave and !$recursor {
    fail ('You need to set atleast $master or $slave or $recursor')
  }

  if $master and !$axfr_allowed {
    fail ('You need to set $axfr_allowed when you want to run a master')
  }

  if $recursor and !$recurse_allowed {
    fail ('You need to set $recurse_allowed when you want to run a recursor')
  }

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    notify  => Service['pdns'],
    require => Package['pdns-server']
  }

  package { 'pdns-server': ensure => installed; }

  if $master or $slave {

    case $backend {
      'mysql':   { package { 'pdns-backend-mysql': ensure => installed; } }
      'sqlite3': { package { 'pdns-backend-sqlite3': ensure => installed; } }
      default:   { fail ('You need to select a backend if you want to configure a master or a slave') }
    }

  }

  if $recursor {

    Package['pdns-recursor'] -> Package['pdns-server']

    package { 'pdns-recursor': ensure => installed; }

    file { '/etc/powerdns/recursor.conf':
      content => template('powerdns/etc/powerdns/recursor.conf.erb'),
      notify  => Service[ 'pdns-recursor', 'pdns' ],
      require => Package['pdns-recursor'];
    }

    service { 'pdns-recursor':
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
      status     => 'pgrep -P 1 pdns_recursor',
      require    => File['/etc/powerdns/recursor.conf'];
    }

  } else {

    service { 'pdns-recursor':
      ensure     => 'stopped',
      hasstatus  => true,
      status     => 'pgrep -P 1 pdns_recursor';
    }

  }

  file {
    '/etc/powerdns/pdns.conf':
      content => template('powerdns/etc/powerdns/pdns.conf.erb');
    '/etc/powerdns/pdns.d/backend.conf':
      content => template('powerdns/etc/powerdns/pdns.d/backend.conf.erb');
  }

  service { 'pdns':
    ensure     => running,
    hasrestart => true,
    require    => File['/etc/powerdns/pdns.conf'];
  }

}
