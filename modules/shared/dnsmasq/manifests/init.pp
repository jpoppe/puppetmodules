# Class: dnsmasq
#
# Manages a dnsmasq installation
#
# == Actions
#
# Install dnsmasq
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'dnsmasq':; }
#
# == Resources
#
# http://www.thekelleys.org.uk/dnsmasq/doc.html
# https://wiki.debian.org/HowTo/dnsmasq
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class dnsmasq () {

  package { 'dnsmasq': ensure => installed; }

  service { 'dnsmasq':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['dnsmasq'];
  }

}
