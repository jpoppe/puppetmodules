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
#   class { 'xx_minion':; }
#
class xx_minion () {

  class { 'xx_base_system':; }

  class {
    'mcollective':
      stomp_host => 'overlord001.a.c.m.e';
    'mcollective::plugins':
  }

  class {
    'xx_monitoring::nagios_basic':
      allowed_hosts => '192.168.20.1,192.168.20.2';
    'xx_monitoring::munin_basic':
      server_fqdn => 'overlord001.a.c.m.e';
  }

  class { 'rsyslog':; }

  Class['java'] -> Class['tomcatmulti']

  class {
    'java':;
    'tomcatmulti':;
  }

  tomcatmulti::instance { 'helloworld_a':
    httpconnector_port => '8080',
    catalina_aopts     => "-Djava.rmi.server.hostname=${ipaddress}",
    startmemory        => '32m',
    maxmemory          => '32m',
    maxpermsize        => '32m';
  }

  tomcatmulti::instance { 'helloworld_b':
    httpconnector_port => '8090',
    catalina_aopts     => "-Djava.rmi.server.hostname=${ipaddress}",
    startmemory        => '32m',
    maxmemory          => '32m',
    maxpermsize        => '32m';
  }

  rsyslog::config { 'client.conf':
    template => '*.* @192.168.20.1:514';
  }

}
