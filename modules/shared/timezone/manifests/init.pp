# Class: timezone
# 
# This class manages timezones
#
# == Actions
#
# Configure timezone settings
#
# == Notes
#
# One way to look up the time zone name is checking tz column in /usr/share/zoneinfo/zone.tab
#
# == Parameters
#
# None
#
# == Todo
#
# Implement functionality for adding extra apt sources
#
# == Examples
#
#   class { 'timezone':
#     zone => 'Europe/Amsterdam';
#   }
#
# == Resources
#
# http://en.wikipedia.org/wiki/Tz_database
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
# GJ Moed <gmoed@ebay.com>
#
class timezone (
  $zone
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { 'tzdata': ensure => present; }

  file { 
    '/etc/localtime': 
      ensure => link,
      target => "/usr/share/zoneinfo/${zone}";
    '/etc/timezone':
      ensure  => present,
      content => $zone;
  }

}
