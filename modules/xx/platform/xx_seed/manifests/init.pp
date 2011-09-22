# Class: xx_seed
#
# This class configures a system to be a seed host
#
# == Actions
#
# Configure a host to be a seed host
#
# == Parameters
#
# None
#
# == Notes
#
# Only one server has DHCP active change the $xx_seed_active variable
# when you want to switch the active one
#
# == Examples
#
#   class { 'xx_seed':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_seed (
  $heartbeat_key,
  $heartbeat_ucast,
  $heartbeat_nodes,
  $heartbeat_preferred_node,
  $heartbeat_ip_address,
  $heartbeat_resources,
  $sks_server_name,
  $sks_server_port,
  $sks_peers
  ) {
  
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  class { 'rsync':; }

  class { 'tftpd_hpa':; }

  class { 'seedbank':
    settings => 'xx_seed/etc/seedbank/settings.py.erb';
  }

  class { 'sks':
    server_name => $sks_server_name,
    server_port => $sks_server_port;
  }

  seedbank::bootstrap { 'debian-squeeze-amd64':; }

  file { '/etc/seedbank/recipes':
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => "puppet:///modules/${module_name}/etc/seedbank/recipes";
  }

  file {
    '/etc/seedbank/seeds/squeeze.seed':
      ensure  => present,
      content => template("${module_name}/etc/seedbank/seeds/squeeze.seed.erb"),
      require => Package['seedbank'];
    '/etc/sks/membership':
      ensure  => present,
      content => template("${module_name}/etc/sks/membership.erb"),
      require => Package['sks'];
  }

  class { 'isc_dhcp_server':
    interfaces => 'bond0',
    static     => "puppet:///modules/${module_name}/etc/dhcp/dhcpd.conf",
    vlans      => ['vlan_100'];
  }

  isc_dhcp_server::vlan { '100':
    subnet              => '192.168.100.0',
    netmask             => '255.255.255.0',
    routers             => '192.168.100.1',
    next_server         => '192.268.0.1',
    domain_name         => 'poppe.emc.local',
    domain_name_servers => '192.168.0.1, 192.168.0.2';
  }

  class { 'nginx':
    status            => '81',
    default_structure => true;
  }

  nginx::site {
    'default':
      source => template("${module_name}/etc/nginx/sites-available/default.erb");
    'subkeys':
      source => template("${module_name}/etc/nginx/sites-available/subkeys.erb");
  }

  nginx::conf { 'server_names_hash_bucket_size.conf':
    source => "puppet:///modules/${module_name}/etc/nginx/conf.d/server_names_hash_bucket_size.conf";
  }

  class { 'heartbeat':
    key            => $heartbeat_key,
    ucast          => $heartbeat_ucast,
    nodes          => $heartbeat_nodes,
    preferred_node => $heartbeat_preferred_node,
    ip_address     => $heartbeat_ip_address,
    resources      => $heartbeat_resources;
  }

}
