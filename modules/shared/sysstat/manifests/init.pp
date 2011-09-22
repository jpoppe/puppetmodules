# Class: sysstat
#
# This class manages sysstat
#
# == Actions
#
# Configure /etc/default/sysstat
#
# == Parameters
#
# [*default*]
#   Source for /etc/default/sysstat. Defaults to 'ENABLED="true"\nOPTIONS="-d
#   -F -L -"\nSA1_OPTIONS="-d"\nSA2_OPTIONS=""'
#
# == Notes
#
# Show CPU usage and I/O wait time percentage
#   sar
#   
# Show the kernel paging performance  
#   sar -B
#
# Show network statistics
#   sar -n DEV
#
# Show network failures
#   sar -n EDEV
#
# Show the CPU statistics 5 times with one second interval
#   sar 1 5
#
# == Examples
#
#   class { 'sysstat':; }
# 
# == Resources
#
# http://sebastien.godard.pagesperso-orange.fr/tutorial.html
# http://www.thegeekstuff.com/2011/03/sar-examples
# http://sourceforge.net/projects/ksar
# 
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class sysstat (
  $default = 'ENABLED="true"\nOPTIONS="-d -F -L -"\nSA1_OPTIONS="-d"\nSA2_OPTIONS=""'
  ) {

  package { 'sysstat': ensure => installed; }

  file { '/etc/default/sysstat': 
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $default,
    require => Package['sysstat'];
  }

}
