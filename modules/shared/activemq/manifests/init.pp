# Class: activemq
#
# This class installs and configures ActiveMQ
#
# == Actions
#
# Install and configure ActiveMQ
#
# == Parameters
#
# [*start*]
#   Start ActiveMQ during system startup. Defaults to 'yes'
#
# [*config*]
#   Template file for activemq.xml
#
# [*camel*]
#   Template file for camel.xml
#
# [*jetty*]
#   Source file for jetty.xml
#
# [*log4j*]
#   Source file for log4j.properties
#
# [*jetty_realm*]
#   Source file for jetty-realm.properties
#
# [*credentials*]
#   Source file for credentials.properties
#
# == Notes
#
# Make sure to keep the documentation up-to-date during development of this
# module.
#
# == Examples
#
#   class { 'activemq':; }
#
#   class { 'activemq':
#     jetty       => 'puppet:///modules/xx_overlord/etc/activemq/jetty.xml',
#     log4j       => 'puppet:///modules/xx_overlord/etc/activemq/log4j.properties',
#     jetty_realm => 'puppet:///modules/xx_overlord/etc/activemq/jetty-realm.properties',
#     credentials => 'puppet:///modules/xx_overlord/etc/activemq/credentials.properties';
#   }
#     
# == Resources
#
# http://activemq.apache.org
# http://activemq.apache.org/getting-started.html
# http://activemq.apache.org/faq.html
# http://camel.apache.org/activemq.html
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class activemq (
  $start       = 'yes',
  $config      = template('activemq/etc/activemq/activemq.xml.erb'),
  $camel       = template('activemq/etc/activemq/camel.xml.erb'),
  $jetty       = '',
  $log4j       = '',
  $jetty_realm = '',
  $credentials = ''
  ) {

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['activemq'],
    require => Package['activemq']
  }

  package { 'activemq': ensure => installed; }

  service { 'activemq':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [Package['activemq'], File['/etc/default/activemq']];
  }

  file { '/etc/default/activemq':
    ensure  => present,
    content => template("${module_name}/etc/default/activemq.erb");
  }
  
  file {
    '/etc/activemq/activemq.xml':
      ensure  => present,
      content => $config;
    '/etc/activemq/camel.xml':
      ensure  => present,
      content => $camel;
  }

  if $jetty {

    file { '/etc/activemq/jetty.xml':
      ensure  => present,
      source  => $jetty;
    }

  }

  if $jetty_realm {

    file { '/etc/activemq/jetty-realm.properties':
      ensure  => present,
      source  => $jetty_realm;
    }

  }

  if $log4j {

    file { '/etc/activemq/log4j.properties':
      ensure  => present,
      source  => $log4j;
    }

  }

  if $credentials {

    file { '/etc/activemq/credentials.properties':
      ensure  => present,
      source  => $credentials;
    }

  }

}
