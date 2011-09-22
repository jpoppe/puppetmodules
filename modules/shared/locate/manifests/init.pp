# Class: locate
# 
# This class installs the locate package
#
# == Parameters
#
# None
#
# == Actions
#
# Install locate and run updatedb
#
# == Examples
#
#   class { 'locate':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class locate () {

  package { 'locate':
    ensure => installed,
    notify => Exec['/usr/bin/updatedb'];
  }

  exec { '/usr/bin/updatedb':
    creates     => '/var/cache/locate/locatedb',
    refreshonly => true;
  }

}
