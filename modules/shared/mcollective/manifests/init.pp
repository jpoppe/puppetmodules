# Class: mcollective
#
# This class installs and configures MCollective
#
# == Actions
#
# Install and configure MCollective
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
# [*factsource*]
#   Source for facts. Defaults to 'facter'
#
# [*mongo_server*]
#   Mongo server to use, if defined. Defaults to ''
#
# == Notes
#
# Make sure to keep the documentation up-to-date during development of this
# module.
#
# == Examples
#
#   class { 'mcollective':
#     psk            => create_and_print_password('mcollective-psk'),
#     stomp_password => create_and_print_password('activemq-general-mcollective-password'),
#   }
#
# == Resources
#
# http://projects.puppetlabs.com/projects/mcollective-plugins/wiki
#
class mcollective (
  $stomp_user     = 'mcollective',
  $stomp_password = 'marionette',
  $stomp_host     = 'localhost',
  $stomp_port     = '61613',
  $psk            = 'mcollective123',
  $factsource     = 'facter',
  $mongo_server   = ''
  ) {

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mcollective']
  }

  package { ['mcollective', 'rubygem-stomp']: ensure => present; }

  package { 'rubygem-net-ping': ensure => present; }

  if $mongo_server {
    package { 'rubygem-mongo': ensure => present; }
  }

  service { 'mcollective':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['mcollective', 'rubygem-stomp'];
  }

  file {
    '/etc/mcollective/server.cfg':
      ensure  => present,
      content => template('mcollective/etc/mcollective/server.cfg.erb'),
      mode    => '0640',
      notify  => Service['mcollective'];
    '/etc/mcollective/facts.yaml':
      ensure   => present,
      mode     => '0400',
      loglevel => info,
      content  => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime_seconds|timestamp|free)/ }.to_yaml %>')
  }

}
