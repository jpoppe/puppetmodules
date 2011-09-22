# Define: config
#
# Add configuration to dnsmasq
#
# == Actions
#
# Add configuration file to /etc/dnsmasq.d
#
# == Parameters
#
# [*source*]
#   source file to use as configuration
#
# == Examples
#
#   dnsmasq::config {
#     'acme':
#       source => "puppet:///modules/${module_name}/etc/dnsmasq.d/acme";
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define dnsmasq::config (
  $source
  ) {

  file { "/etc/dnsmasq.d/${name}":
    ensure  => present,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['dnsmasq'],
    require => Package['dnsmasq'];
  }

}
