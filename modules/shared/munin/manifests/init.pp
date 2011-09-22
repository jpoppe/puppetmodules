# Class: munin
#
# This module installs munin
#
# == Actions
#
# Install munin-node and perform configuration
#
# == Parameters
#
# [*allow*]
#   Allow connects from this range. Defaults to ^192\.168\.20\..*$
#
# == Examples
#
#   class { 'munin':
#     '^192\.168\.20\..*$';
#   }
#
# == Resources
#
# http://www.debian-administration.org/articles/229
# http://munin-monitoring.org/wiki/Documentation
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class munin (
  $allow = '^192\.168\.20\..*$'
  ) {

  package { ['munin-node', 'munin-plugins-extra']: ensure => installed; }

  user { 'munin': require => Package['munin-node']; }

  group { 'munin': require => Package['munin-node']; }

  service { 'munin-node':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['munin-node'];
  }

  file { '/etc/munin/munin-node.conf':
    content => template('munin/etc/munin/munin-node.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['munin-node'],
    require => Package['munin-node'];
  }

}
