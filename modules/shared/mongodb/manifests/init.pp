# Class: mongodb
#
# This class installs and configures mongodb
#
# == Actions
#
# Install and configure mongodb
#
# == Parameters
#
# [*bind_ip*]
#   IP to bind to. Defaults to '127.0.0.1'
#
# [*bind_port*]
#   Port to bind on. Defaults to '27017'
#
# [*master*]
#   If this node is a master. Defaults to 'true'
#
# [*slave*]
#   If this node is a slave. Defaults to 'false'
#
# [*source*]
#   Where to pull our data from. Defaults to false
#
# [*mms_token*]
#   Account token for mongo monitoring server. Defaults to false
#
# [*mms_name*]
#   Server name for mongo monitoring server. Defaults to false
#
# [*mms_interval*]
#   Ping interval for mongo monitoring server. Defaults to false
#
# [*use_auth*]
#   If to enable authentication. Defaults to 'false'
#
# [*http_interface*]
#   If to enable the http interface. Defaults to false
#
# [*pair_with*]
#   Address of a server to pair with in the form of <server:port>. Defaults to false
#
# [*arbiter*]
#   Address of the arbiter server in the form of <server:port>. Defaults to false
#
# [*autoresync*]
#   Automatically resync if slave data is stale. Defaults to false
#
# == Examples
#
#   class { 'mongodb':; }
#
# == Resources
#
# http://www.mongodb.org/display/DOCS/Manual
#
# == Authors
#
# Lex van Roon <lvanroon@ebay.com>
#
class mongodb (
  $bind_ip        = '127.0.0.1',
  $bind_port      = '27017',
  $master         = true,
  $slave          = false,
  $source         = false,
  $mms_token      = false,
  $mms_name       = false,
  $mms_interval   = false,
  $use_auth       = false,
  $http_interface = false,
  $pair_with      = false,
  $arbiter        = false,
  $autoresync     = false
  ) {

  package { ['mongodb-server', 'mongodb-clients', 'python-pymongo']: ensure => 'installed'; }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  file { '/etc/mongodb.conf':
    ensure  => present,
    content => template('mongodb/etc/mongodb.conf.erb'),
    notify  => Service['mongodb'];
  }

  service { 'mongodb':
    ensure     => 'running',
    hasstatus  => true,
    hasrestart => true,
    require    => [Package['mongodb-server'], File['/etc/mongodb.conf']];
  }

}
