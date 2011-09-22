# Define: plugin
#
# This define manages a munin plugin
#
# == Actions
#
# Install or remove a munin plugin and its configuration
#
# == Notes
#
# To test some plugins the MUNIN_LIBDIR variable needs to be set:
#    MUNIN_LIBDIR=/usr/share/munin /etc/munin/plugins/if_err_eth0
#
# == Parameters
#
# [*config*]
#   Configuration for this plugin. Defaults to undef
#
# == Examples
#
#   munin::plugin { 'netstat':; }
#
#   $ifs = regsubst(split($interfaces, " |,"), "(.+)", "if_\\1") 
# 
#   munin::plugin { $ifs: target => 'if_'; } 
#   
#   $if_errs = regsubst(split($interfaces, " |,"), "(.+)", "if_err_\\1") 
#     
#   munin::plugin { $if_errs: target => 'if_err_'; } 
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define munin::plugin (
  $config = undef,
  $target = undef
  ) {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['munin-node']
  }

  $plugin = $target ? { default => $target, undef => $name }

  file { "/etc/munin/plugins/${name}":
    ensure  => "/usr/share/munin/plugins/${plugin}",
    require => Package['munin-node'];
  }

  if $config {

    file { "/etc/munin/plugin-conf.d/${name}.conf":
      content => "[${name}]\n$config\n",
      require => Package['munin-node'];
    }

  }

}
