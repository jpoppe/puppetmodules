# Class: logstash
#
# This class installs and configures logstash
#
# == Actions
#
# Install and configure logstash
#
# == Parameters
#
# [*listener_ip*]
#   IP on which to receive syslog messages. Defaults to '127.0.0.1'
#
# [*listener_port*]
#   Port on which to receive syslog messages. Defaults to '1514'
#
# == Examples
#
#   class { 'logstash':; }
#
# == Resources
#
# http://logstash.net/docs/1.0.10/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
# Lex van Roon <lvanroon@ebay.com>
#
class logstash (
  $listener_ip   = '127.0.0.1',
  $listener_port = '1514'
  ) {

  File{
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { ['logstash', 'libevent-1.4-2', 'libtokyocabinet8', 'grok', 'rubygem-grok']: ensure => present; }

  file {
    '/etc/logstash/logstash.conf':
      ensure  => present,
      content => template('logstash/etc/logstash/logstash.conf.erb'),
      require => Package['logstash'],
      notify  => Service['logstash'];
  }

  service { 'logstash':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['logstash'];
  }

}
