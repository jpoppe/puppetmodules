# Class: client
#
# This class installs and configures the mcollective client
#
# == Actions
#
# Install and configure the mcollective client
#
# == Parameters
#
# [*stomp_user*]
#   Username used to connect to the stomp MQ. Defaults to 'mcollective'
#
# [*stomp_password*]
#   Password used to connect to the stomp MQ. Defaults to 'marionette'
#
# [*stomp_host*]
#   Hostname for the stomp MQ. Defaults to 'localhost'
#
# [*stomp_port*]
#   Port for the stomp MQ. Defaults to '61613',
#
# [*psk*]
#   Pre-Shared Key used within the collective. Defaults to 'mcollective123'
#
# == Notes
#
# Make sure to keep the documentation up-to-date during development of this
# module.
#
# == Examples
#
#   class { 'mcollective::client':
#     psk            => create_and_print_password('mcollective-psk'),
#     stomp_password => create_and_print_password('activemq-general-mcollective-password'),
#   }
#
class mcollective::client (
  $stomp_user     = 'mcollective',
  $stomp_password = 'marionette',
  $stomp_host     = 'localhost',
  $stomp_port     = '61613',
  $psk            = 'mcollective123'
  ) {

  package { 'mcollective-client': ensure => present; }

  /*
  include mcollective::plugin::filemgr::client
  include mcollective::plugin::iptables::client
  include mcollective::plugin::nrpe::client
  include mcollective::plugin::package::client
  include mcollective::plugin::process::client
  include mcollective::plugin::puppetd::client
  include mcollective::plugin::service::client
  */

  file { '/etc/mcollective/client.cfg': 
    ensure  => present,
    content => template('mcollective/etc/mcollective/client.cfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode  => '0644',
    require => Package['mcollective-client'];
  }

  file { '/var/tmp/mcollective': 
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode  => '0755';
  }

}
