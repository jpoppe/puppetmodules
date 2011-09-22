# Define: site
#
# This define manages a site within nginx
#
# == Actions
#
# Configure and enable a website with nginx
#
# == Parameters
#
# [*source*]
#   Source for this website
#
# == Examples
#
#   nginx::conf {
#     'website':
#       source => "puppet:///${module_name}/etc/nginx/sites-available/website";
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define nginx::site (
  $source
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  file {
    "/etc/nginx/sites-available/${name}":
      ensure  => present,
      content => $source,
      notify  => Service['nginx'],
      require => Package['nginx'];
    "/etc/nginx/sites-enabled/${name}":
      ensure  => "/etc/nginx/sites-available/${name}",
      notify  => Service['nginx'],
      require => File["/etc/nginx/sites-available/${name}"];
  }

}
