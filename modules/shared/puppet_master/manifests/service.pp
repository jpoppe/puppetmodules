# Class: puppet_master::service
#
# This class manages the puppetmaster service
#
# == Actions
#
# Manage the puppetmaster daemon
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'puppet_master::service':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class puppet_master::service () {

  service { 'puppetmaster':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['puppetmaster'],
    subscribe  => File['/etc/default/puppetmaster'];
  }

}
