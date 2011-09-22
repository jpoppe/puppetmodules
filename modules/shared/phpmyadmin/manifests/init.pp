# Class: phpmyadmin
# 
# This class manages the installation and configuration of phpmyadmin
#
# == Parameters
#
# [*password*]
#   Password for the phpmyadmin database
#
# == Actions
#
#   Configure and install phpmyadmin
#
# == Examples
#
#   Class['mysql'] -> Class['apache2'] -> Class['phpmyadmin']
#
#   class { 'phpmyadmin':; }
#
# == Resources
#
# http://www.phpmyadmin.net
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class phpmyadmin (
  $password = 'phpmyadmin123'
  ) {

  package { 'phpmyadmin':
    ensure       => present,
    responsefile => '/var/cache/debconf/phpmyadmin.seed',
    require      => File['/var/cache/debconf/phpmyadmin.seed'];
  }

  file { '/var/cache/debconf/phpmyadmin.seed':
    ensure  => present,
    mode    => '0600',
    content => template('phpmyadmin/var/cache/debconf/phpmyadmin.seed.erb');
  }


}

