# Define: deploy
#
# This module manages munin plugin deployment
#
# == Actions
#
# Deploy a new munin plugin
#
# == Parameters
#
# [*source*]
#   Source for the plugin, or $name when undef. Defaults to undef
#
# [*ensure*]
#   Ensure action for this plugin. Defaults to 'present'
#
# [*config*]
#   Configuration for this plugin. Defaults to ''
#
# == Examples
#
#   munin::deploy { 'tinydns':; }
#
#   munin::deploy { 'nagios_hosts':
#     config => 'user root';
#   }
#
#   munin::deploy { 'nagios_perf_hosts':
#     source => 'puppet:///modules/munin/usr/share/munin/plugins/nagios_perf',
#     config => 'user root';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define munin::deploy (
  $source = undef,
  $ensure = 'present',
  $config = ''
  ) {

  $real_source = $source ? { default => $source, undef => "puppet:///modules/${module_name}/usr/share/munin/plugins/${name}" }

  file { "/usr/share/munin/plugins/${name}":
    ensure  => present,
    source  => $real_source,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Package['munin-node'];
  }

  munin::plugin { $name:
    config => $config;
  }

}
