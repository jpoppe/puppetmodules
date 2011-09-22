# Class: xx_overlord
#
# This class configures a system to be a xx_overlord system
#
# == Actions
#
# Configure a system to be a xx_overlord
#
# == Parameters
#
# None
#
# == Examples
#
# class { 'xx_overlord':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_overlord () {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  class { 'xx_overlord::pre':
    logstash_listener_ip   => '127.0.0.1',
    logstash_listener_port => '1514';
  }

  # if we are running Puppet via a Puppet server
  if $serverversion {

    Class['xx_base_system'] -> Class['xx_overlord::pre'] -> Class['xx_overlord::main'] -> Service['puppet'] -> Class['xx_overlord::puppet'] -> Class['puppet_master'] -> File <| tag == 'mcollective' or tag == 'activemq' or tag == 'puppet_master' or tag == 'munin' or tag == 'nagios' or tag == 'gosa' or tag == 'nagios::nrpe' |> -> Service['puppetmaster'] -> Service['nginx']

    class { 'xx_overlord::puppet':
      #puppet_ca    => 'puppetca001.a.c.m.e',
      #amq_password => 'puppet123',
      autosign     => ['*.a.c.m.e', 'dashboard'];
    }

    class { 'puppet_master::service':; }

    class {
      'xx_base_system':
        puppet_daemon        => false,
        puppet_keepalive     => false;
      'xx_overlord::main':
        logstash_listener_ip   => '127.0.0.1',
        logstash_listener_port => '1514',
        masters                => '2';
    }

  } else {

    class { 'puppet_master::bootstrap': }

  }

  class { 'puppet_master':
    altnames => 'puppet';
  }

}
