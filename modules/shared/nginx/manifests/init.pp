# Class: nginx
# 
# This class manages nginx
#
# == Actions
#
#  Install and configure nginx
#
# == Parameters
#
# [*status*]
#   if set, status page will be added.
#
# [*default_structure*]
#   if set, paths for default nginx configuration will be created
#
# [*config*]
#   if set, /etc/nginx/nginx.conf will be set to this file
#
# [*ssl_certificate*]
#   if set, ssl certificate will be copied
#
# [*ssl_key*]
#   if set, ssl key will be copied
#
# == Todo
#
# Add template support?, add support for multiple certificates?, etc.
# Implement init script for fast cgi!!: http://wiki.nginx.org/PHPFcgiExample
#
# == Notes
#
# Generate a self signed SSL certificate:
#   openssl genrsa -des3 -out cert.key 2048
#   openssl req -new -key cert.key -out cert.csr
#   # remove the passphrase
#   cp cert.key cert.key.org
#   openssl rsa -in cert.key.org -out cert.key
#   # generate the certificate
#   openssl x509 -req -days 3650 -in cert.csr -signkey cert.key -out cert.pem
# 
# == Resources
#
# http://nginx.org/en/docs/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class nginx (
  $status            = undef,
  $default_structure = undef,
  $config            = undef,
  $ssl_key           = undef,
  $ssl_certificate   = undef
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { 'nginx': ensure => installed; }

  service { 'nginx':
    ensure     => running,
    hasrestart => true,
    require    => Package['nginx'];
  }

  file {
    '/etc/nginx/sites-available':
      purge   => true,
      force   => true,
      recurse => true,
      ensure  => directory,
      require => Package['nginx'];
    '/etc/nginx/sites-enabled':
      purge   => true,
      force   => true,
      recurse => true,
      ensure  => directory,
      require => Package['nginx'];
    '/etc/nginx/conf.d':
      purge   => true,
      force   => true,
      recurse => true,
      ensure  => directory,
      require => Package['nginx'];
  }

  if $config {

    file { '/etc/nginx/nginx.conf':
      ensure  => present,
      content => $config,
      notify  => Service['nginx'],
      require => Package['nginx'];
    }

  }

  if $ssl_key {

    file { '/etc/nginx/cert.key':
      ensure  => present,
      source  => $ssl_key,
      notify  => Service['nginx'],
      require => Package['nginx'];
    }

  }

  if $ssl_certificate {

    file { '/etc/nginx/cert.pem':
      ensure  => present,
      source  => $ssl_certificate,
      notify  => Service['nginx'],
      require => Package['nginx'];
    }

  }

  if $default_structure {

    file { 
      '/var/www':
        ensure => directory,
        mode   => '0755';
      '/var/www/nginx-default':
        ensure => directory,
        mode   => '0755',
        notify => Service['nginx'];
    }

  }

  if $status {

    file { 
      '/etc/nginx/sites-available/nginx_status':
        ensure  => present,
        content => template('nginx/etc/nginx/sites-available/nginx_status.erb'),
        notify  => Service['nginx'],
        require => Package['nginx'];
      '/etc/nginx/sites-enabled/nginx_status':
        ensure => link,
        target => '/etc/nginx/sites-available/nginx_status';
    }

  }

}
