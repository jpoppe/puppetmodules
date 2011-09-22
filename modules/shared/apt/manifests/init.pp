# Class: apt
# 
# This class manages the configuration of Debian repositories on the client
#
# == Actions
#
# Configure and manage apt repositories
#
# == Parameters
#
# [*proxy*]
#   configure a proxy for apt
#
# [*unsigned*]
#   allow the installation of unsigned Debian packages, STRONGLY DISRECOMMENDED
#
# == Notes
#
# Add manually a key to the Apt keyring
#   sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <key_id>
#
# Since Debian Squeeze there is an /etc/apt/preferences.d directory, so
# apt preferences could be set from any Puppet module
#
# == Examples
#   
#   class { 'apt':
#     proxy => 'http://xx-proxy001.a.c.m.e:3128';
#   }
#
# == Resources
#
# https://wiki.debian.org/Apt
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class apt (
  $proxy    = false,
  $unsigned = false
  ) {
  
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  exec { '/usr/bin/apt-get -qq update':
    refreshonly => true,
    logoutput   => on_failure;
  }

  if $proxy {

    file { '/etc/apt/apt.conf.d/80aptproxy':
      content => template('apt/etc/apt/conf.d/80aptproxy.erb'),
      notify  => Exec['/usr/bin/apt-get -qq update'];
    }

  }

  if $unsigned {

    file { '/etc/apt/apt.conf.d/80unsigned':
      content => 'APT::Get::AllowUnauthenticated "true";',
      notify  => Exec['/usr/bin/apt-get -qq update'];
    }

  }

}
