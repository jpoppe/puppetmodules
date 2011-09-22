# Class: ca
#
# This class configures a puppet_master as a CA server
#
# == Actions
#
# Configure a puppet_master as a CA server
#
# == Parameters
#
# [*master*]
#   Source for autosign.conf
#
# [*puppetmaster_conf*]
#   Content for puppetmaster.conf
#
# [*autosign*]
#   List containing domains which are autosigned
#
# == Examples
#
#   class { 'puppet_master::ca':
#     master            => 'puppet:///modules/puppet_master/etc/puppet/autosign.conf',
#     puppetmaster_conf => template('some_module/etc/puppet/puppetmaster.conf.erb'),
#     autosign          => ['*.a.c.m.e', 'dashboard']
#   }
#
# == Resources
#
# https://projects.puppetlabs.com/projects/1/wiki/Certificates_And_Security
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class puppet_master::ca (
  $master,
  $puppetmaster_conf,
  $autosign
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  file { '/etc/puppet/manifests/site.pp':
    content => 'node default { fail(\'This is not a puppetmaster, this is the central Puppet CA server!\') }',
    ensure  => present;
  }

  file { '/etc/puppet/autosign.conf':
    ensure  => present,
    content => template('puppet_master/etc/puppet/autosign.conf.erb');
  }

  file {
    '/etc/puppet/puppetmaster.conf':
      ensure  => present,
      content => $puppetmaster_conf;
    '/etc/default/puppetmaster':
      ensure  => present,
      content => template('puppet_master/etc/default/puppetmaster.erb');
  }

}
