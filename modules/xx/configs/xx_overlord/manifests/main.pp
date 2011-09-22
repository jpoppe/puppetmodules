# Class: xx_overlord::main
#
# This class performs the main configuration for an xx_overlord
#
# == Actions
#
# Perform the main configuration for an xx_overlord
#
# == Parameters
#
# [*masters*]
#   Number of puppetmasters to run
#
# [*hasca*]
#   Wether the system has a CA. Can be 'true' or 'false'
#
# == Examples
#
#   class { 'xx_overlord::main':; }
#
# or
#
#   class { 'xx_overlord::main':
#     masters => '4',
#     hasca   => 'false';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_overlord::main (
  $logstash_listener_ip,
  $logstash_listener_port,
  $hasca                  = 'true',
  $masters
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  Service['activemq'] -> Class['mcollective::client'] -> Service['mcollective']

  #Service['puppet-dashboard-workers'] ~> Service['thin']

  Class['puppet_master::dashboard'] -> Service['thin']

  Class['logstash'] ~> Service['syslog-ng']

  $amq_password_mcollective  = 'marionette'
  $amq_password_admin        = '123activemq'
  $amq_password_puppet       = '123puppet' 
  $puppet_dashboard_password = 'puppet123'

  class {
    'activemq':
      config => template('xx_overlord/etc/activemq/activemq.xml.erb'),
      camel  => template('xx_overlord/etc/activemq/camel.xml.erb');
    'mcollective':
      mongo_server => 'localhost',
      stomp_host   => 'overlord001.a.c.m.e';
    'mcollective::client':;
    'mcollective::plugins':;
  }

  class { 'thin':; }

  thin::service { 'dashboard':
    user    => 'puppet',
    group   => 'puppet',
    appdir  => '/usr/share/puppet-dashboard',
    pidfile => '/var/run/puppet/dashboard.pid',
    logfile => '/var/log/puppet/dashboard.log';
  }

  class {
    'puppet_master::doc':;
    'puppet_master::dashboard':
      password  => 'puppet123',
      db_config => template("${module_name}/etc/puppet-dashboard/database.yml.erb"),
      settings  => template("${module_name}/etc/puppet-dashboard/settings.yml.erb"),
      use_thin  => true;
  }

  class {
    'nagios':
      password => 'nagios123';
    'nagios::nrpe':;
  }

  class {
    'munin::server':;
    'xx_monitoring::munin_node':;
  }

  class { 'phpmyadmin':; }

  class { 'sphinx':; }

  class { 'seedbank':; }

  seedbank::bootstrap { 'debian-squeeze-amd64':; }

  sphinx::generate { 'seedbank':
    source_dir => '/usr/share/doc/seedbank/manual';
  }

  Package['seedbank'] ~> Exec['rest_to_html_seedbank']

  class { 'jmxp':; }

  class { 'logstash':
    listener_ip   => $logstash_listener_ip,
    listener_port => $logstash_listener_port;
  }

  #file {
  #  '/etc/rsyslog.d/logstash.conf':
  #    ensure  => present,
  #    content => template("${module_name}/etc/rsyslog.d/logstash.conf.erb"),
  #    require => Package['rsyslog'],
  #    owner   => 'root',
  #    group   => 'root',
  #    mode    => '0644',
  #    notify  => Service['rsyslog'];
  #}

  class { 'nginx':
    default_structure => true,
    status            => '82';
  }

  nginx::site {
    'default':
      source => template('xx_overlord/etc/nginx/sites-available/default.erb');
    'puppetmaster':
      source => template('xx_overlord/etc/nginx/sites-available/puppetmaster.erb');
  }

  nginx::conf {
    'general.conf':
      source => "puppet:///modules/${module_name}/etc/nginx/conf.d/general.conf";
  }

  file {
    '/var/www/nginx-default/index.html':
      ensure  => present,
      content => template("${module_name}/var/www/nginx-default/index.html.erb"),
      require => Package['nginx'];
    '/var/www/nginx-default/menu.html':
      ensure  => present,
      content => template("${module_name}/var/www/nginx-default/menu.html.erb"),
      require => Package['nginx'];
    '/var/www/nginx-default/main.html':
      ensure  => present,
      content => template("${module_name}/var/www/nginx-default/main.html.erb"),
      require => Package['nginx'];
    '/var/www/nginx-default/background.jpg':
      ensure  => present,
      source  => "puppet:///modules/${module_name}/var/www/nginx-default/background.jpg",
      require => Package['nginx'];
 }

}
