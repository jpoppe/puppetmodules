# Class: xx_overlord::puppet
#
# This class performs the main configuration for an xx_overlord
#
# == Actions
#
# Perform the Puppet configuration for an xx_overlord
#
# == Parameters
#
# [*puppet_ca*]
#   The Puppet CA server
#
# [*autosign*]
#   Array with Puppet autosign.conf entries
#
# == Examples
#
#   class { 'xx_overlord::main':
#     puppet_ca => 'puppetca001.a.c.m.e',
#     hasca     => ['*.a.c.m.e', 'dashboard'];
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_overlord::puppet (
  $puppet_ca    = '',
  $amq_password = '',
  $autosign
  ) {

  Class['puppet_master::server'] -> Class['puppet_master::server_final']

  Class['puppet_master::server_final'] ~> Service['nginx']

  class {
    'puppet_master::server':
      puppet_ca => $puppet_ca,
      autosign  => $autosign,
      masters   => '2';
    'puppet_master::server_final':
      puppet_ca         => $puppet_ca,
      puppetmaster_conf => "${module_name}/etc/puppet/puppetmaster.conf.erb",
      amq_password      => $amq_password;
  }

  if $amq_password {

    Class['puppet_master::queue'] ~> Service['puppetmaster']

    class { 'puppet_master::queue':; }

  }

}
