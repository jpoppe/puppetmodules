# Define: remoteplugin
#
# This define wraps around munin::plugin using puppet
#
# == Actions
#
# Installs a munin plugin
#
# == Parameters
#
# [*source*]
#   Source for this plugin
#
# [*config*]
#   Configuration for this plugin
#
# == Examples
#
#   munin::remoteplugin { 'nagios_perf':
#     source => 'puppet:///modules/munin/usr/share/munin/plugins/nagios_perf';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define munin::remoteplugin (
  $config = undef,
  $source
  ) {

  file { "/var/lib/puppet/modules/munin/plugins/${name}":
    source => $source,
    owner  => 'root',
    group  => 'root',
    mode   => '0755';
  }

  munin::plugin { $name:
    config => $config;
  }

}
