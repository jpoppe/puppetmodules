# Class: mysql::ssl
#
# This class configures SSL certificates for mysql-server
#
# == Actions
#
# Install and configure SSL certificates for mysql-server
#
# == Parameters
#
# [*ca*]
#   Source for CA certificate. Defaults to undef
#
# [*key*]
#   Source for key. Defaults to undef
#
# [*cert*]
#   Source for certificate. Defaults to undef
#
# [*notify*]
#   What to notify when done. Defaults to undef
#
# == Notes
#
#   If no parameters are passed to this define, it will configure SSL based
#   on the puppet SSL certificates for this host.
#
# == Examples
#
# http://www.option-c.com/xwiki/MySQL_Replication_with_SSL
# http://projects.puppetlabs.com/projects/1/wiki/Mysql_With_Ssl_And_Puppet_Certs_Patterns
#
class mysql::ssl (
  $ca = undef,
  $key = undef,
  $cert = undef,
  $notify = undef
  ) {

  case $ca {
    undef: { $ca_source = '/var/lib/puppet/ssl/certs/ca.pem' }
    default: { $ca_source = $ca }
  }

  case $key {
    undef: { $key_source = "/var/lib/puppet/ssl/private_keys/${fqdn}.pem" }
    default: { $key_source = $key }
  }

  case $cert {
    undef: { $cert_source = "/var/lib/puppet/ssl/certs/${fqdn}.pem" }
    default: { $cert_source = $cert }
  }

  File {
    owner  => 'mysql',
    group  => 'mysql'
  }

  file {
    '/etc/mysql/ssl':
      ensure => directory,
      mode   => '0750';
    '/etc/mysql/ssl/ca.pem':
      ensure => present,
      source => $ca_source,
      mode   => '0640';
    "/etc/mysql/ssl/cert.pem":
      ensure => present,
      source => $cert_source,
      mode   => '0640';
    "/etc/mysql/ssl/key.pem":
      ensure => present,
      source => $key_source,
      mode   => '0640'
  }

  if $notify {

    file { '/etc/mysql/conf.d/ssl.cnf':
      ensure  => present,
      source  => 'puppet:///modules/mysql/etc/mysql/conf.d/ssl.cnf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/mysql/ssl/ca.pem', '/etc/mysql/ssl/cert.pem', '/etc/mysql/ssl/key.pem'],
      notify  => $notify;
    }

  } else {

    file { '/etc/mysql/conf.d/ssl.cnf':
      ensure  => present,
      source  => 'puppet:///modules/mysql/etc/mysql/conf.d/ssl.cnf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/mysql/ssl/ca.pem', '/etc/mysql/ssl/cert.pem', '/etc/mysql/ssl/key.pem'];
    }

  }

}
