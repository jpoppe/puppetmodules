# Class: ntp
#
# This class manages the ntp client/server
#
# == Actions
#
# Install and configure NTP client
#
# == Parameters
#
# [*restrict_ips*]
#   List of ip's to restrict queries to. Defaults to ['127.0.0.1', '::1']
#
# [*restrict_options*]
#   List of options to allow for $restrict_ips. Defaults to ['default', 'kod',
#   'notrap', 'nomodify', 'nopeer', 'noquery']
#
# [*servers*]
#   List of servers to retrieve time from
#
# == Notes
#
#   Check if NTP is working correctly on a system
#     ntpq -p
#
# == Examples
#
#   class { 'ntp':
#     servers => ['overlord001.a.c.m.e', 'overlord002.a.c.m.e'] }
#   }
#
# == Resources
#
# http://www.eecis.udel.edu/~mills/ntp/html/index.html
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class ntp (
  $restrict_ips     = ['127.0.0.1', '::1'],
  $restrict_options = ['default', 'kod', 'notrap', 'nomodify', 'nopeer', 'noquery'],
  $servers
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { ['ntp', 'ntpdate']: ensure => present }

  service { 'ntp':
    enable     => true,
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['ntp'];
  }

  file { '/etc/ntp.conf':
    content  => template('ntp/etc/ntp.conf.erb'),
    notify   => Service['ntp'],
    require  => Package['ntp'];
  }

}
