# Define: register
#
# This define registers a munin-node on a munin master
#
# == Actions
#
# Register a munin-node with a master
#
# == Parameters
#
# [*description*]
#   Description for the munin-node
#
# [*config*]
#   Configuration for the munin-node
#
# [*munin_host*]
#   Hostname of the master node. Defaults to $fqdn
#
# == Examples
#
#   munin::register { 'somehost.example.com':
#     description => 'This is somehost',
#     config      => ['use_node_name yes', 'load.load.warning 5', 'load.load.critical 10'];
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define munin::register (
  $description = 'absent',
  $config      = [],
  $host        = $fqdn,
  $port        = '4949',
  $server_fqdn
  ) {

  $clean_server_fqdn = regsubst($server_fqdn, '\.', '_', 'G')

  @@file { "/etc/munin/munin-conf.d/general_${name}":
    ensure  => present,
    content => template('munin/etc/munin/munin-conf.d/general_node.erb'),
    tag     => "munin_${clean_server_fqdn}";
  }

}
