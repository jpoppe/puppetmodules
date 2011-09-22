# Class: xx_minion
#
# This class configures a system to be a xx_minion
#
# == Actions
#
# Configure a system to be a xx_minion
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'xx_puppetca':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_puppetca () {

  $masters = 2
  $hasca   = true

  Class['xx_base_system'] -> Class['xx_puppetca::pre'] -> Class['puppet_master'] -> Class['puppet_master::ca'] -> Class['puppet_master::ca_final'] -> Service['puppetmaster'] -> Service['nginx']

  Class['puppet_master::ca_final'] ~> Service['puppetmaster'] ~> Service['nginx']

  class { 'xx_base_system':; }

  class { 'xx_puppetca::pre':; }

  class { 
    'puppet_master':; 
    'puppet_master::ca': 
      master            => 'overlord001.a.c.m.e',
      puppetmaster_conf => template("${module_name}/etc/puppet/puppetmaster.conf.erb"),
      autosign          => ['*.a.c.m.e'];
    'puppet_master::ca_final':;
    'puppet_master::service':;
  }

  class {
    'xx_monitoring::nagios_basic':
      allowed_hosts => '192.168.20.1,192.168.20.2';
    'xx_monitoring::munin_basic':
      server_fqdn => 'overlord001.a.c.m.e';
  }

}
