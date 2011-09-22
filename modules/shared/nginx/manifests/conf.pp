# Define: conf
#
# This define manages a configuration file fragment for nginx
#
# == Actions
#
# Install a configuration file fragment for nginx
#
# == Parameters
#
# [*source*]
#   The source for this configuration file
#
# == Examples
#
#  nginx::conf {
#    'general':
#      source => "puppet:///${module_name}/etc/nginx/conf.d/general";
#  }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define nginx::conf (
  $source
  ) {

  file { "/etc/nginx/conf.d/${name}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    notify  => Service['nginx'],
    require => Package['nginx'];
  }

}
