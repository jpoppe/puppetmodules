# Class: puppetmaster::server
#
# This class installs and configures a puppetmaster
#
# == Actions
#
# Install and configure a puppetmaster
#
# == Parameters
#
# [*autosign*]
#   List containing domains which will be autosigned
#
# [*puppet_ca*]
#   Host that will be the puppet CA server, if this variable is not set
#   the Puppet Master will also be the CA server
#
# [*masters*]
#   Number of puppetmasters to start
#
# == Examples
#
#   class { 'puppet_master::server':
#     autosign  => ['*.a.c.m.e', 'dashboard'],
#     puppet_ca => 'some_ca_server',
#     masters   => '4';
#   }
#
# == Resources
#
# http://docs.puppetlabs.com/guides/setting_up.html
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class puppet_master::server (
  $autosign  = [],
  $puppet_ca = '',
  $masters
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  file { '/etc/default/puppetmaster':
    ensure  => present,
    content => template('puppet_master/etc/default/puppetmaster.erb');
  }

  if $puppet_ca {

    file { '/var/lib/puppet/var/deploycert.rb':
      ensure => present,
      mode   => '0755',
      source => 'puppet:///modules/puppet_master/var/lib/puppet/var/deploycert.rb';
    }

  }

  # If the $serverversion variable is available, we're running from configured master and will do a full run
  file { '/etc/puppet/autosign.conf':
    ensure  => present,
    content => template('puppet_master/etc/puppet/autosign.conf.erb');
  }

}
