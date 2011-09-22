# Class: tomcatmulti
#
# == Actions
#
# Configure and manage multiple Tomcat instances
# Every instance will get it's own init script named like '/etc/init.d/tomcat-<instancename>'
#
# '/etc/init.d/tomcatmulti' script will be created, with this script it is possible to manage
# multiple instances at once for example:
#   /etc/init.d/tomcatmulti start
#   /etc/init.d/tomcatmulti stop
#   /etc/init.d/tomcatmulti status
#   /etc/init.d/tomcatmulti start frontend api 6009
#
# == Parameters
#
# [*user*]
#   Tomcat admin user
#
# [*password*]
#   Tomcat admin password
#
# == Required Modules
#
# Java
#
# == Examples
#  
#  class['java'] -> Class['tomcatmulti']
# 
#  class {
#    'java':;
#    'tomcatmulti':;     
#  }
#
# == Notes
#
# - The old tomcatmulti script only works if portnumbers are used as instance names
# - maybe use the default file for all variables instead of templating it? (Java variables)
# - secure JMX!
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class tomcatmulti (
  $user     = 'tomcat',
  $password = 'tomcat123'
  ) {

  File { 
    owner => 'root',
    group => 'root',
    mode  => '0755'
  }

  user { 'tomcat6':
    gid     => 'tomcat6',
    require => Package['tomcat6'];
  }

  package { ['tomcat6', 'tomcat6-admin', 'tomcat6-extras', 'tomcatmanager']: ensure => present; }

  service { 'tomcat6': 
    ensure  => stopped,
    enable  => false,
    pattern => '/var/lib/tomcat6/conf/logging.properties',
    require => Package['tomcat6', 'tomcat6-admin'];
  }

  file {
    ['/etc/tomcat6', '/etc/default/tomcat6', '/var/lib/tomcat6', '/var/log/tomcat6', '/var/cache/tomcat6', '/etc/cron.daily/tomcat6']:
      ensure  => absent,
      force   => true,
      require => Package['tomcat6', 'tomcat6-admin'];
    '/etc/init.d/tomcatmulti':
      ensure => present,
      source => 'puppet:///modules/tomcatmulti/etc/init.d/tomcatmulti';
    '/usr/local/bin/tomcatmanager':
      ensure => present,
      source => 'puppet:///modules/tomcatmulti/usr/local/bin/tomcatmanager';
    '/etc/tomcatmanager.conf':
      ensure  => present,
      mode    => '0600',
      content => template('tomcatmulti/etc/tomcatmanager.conf.erb');
    ['/etc/tomcatmulti', '/etc/default/tomcatmulti.d', '/var/lib/tomcatmulti']:
      ensure => directory;
    ['/var/log/tomcatmulti/', '/var/cache/tomcatmulti', '/var/run/tomcatmulti']:
      ensure => directory,
      owner  => 'tomcat6',
      group  => 'adm',
      mode   => '0755';
  }

}
