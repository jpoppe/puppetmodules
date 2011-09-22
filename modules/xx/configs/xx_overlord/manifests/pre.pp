# Class: xx_overlord::pre
#
# This class contains the actions for the first Puppet run
#
# == Parameters
#
# None
#
# == Examples
#
# class { 'xx_overlord::pre'; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_overlord::pre (
  $logstash_listener_ip,
  $logstash_listener_port
  ) {

  package { ['libmysql-ruby', 'git']: ensure => installed; }

  class { 'dnsmasq':; }

  class { 'java':; }

  class { 'syslog_ng':
    cfgfile => template("${module_name}/etc/syslog-ng/syslog-ng.conf.erb");
  }

  class { 'mongodb':
    bind_ip => '0.0.0.0';
  }

  dnsmasq::config { 'acme':
    source => "puppet:///modules/${module_name}/etc/dnsmasq.d/acme";
  }

  class { 'powerdns':
    master            => true,
    recursor          => true,
    webserver         => true,
    webserver_address => '0.0.0.0',
    listen_address    => '0.0.0.0',
    axfr_allowed      => '127.0.0.1',
    recurse_allowed   => '127.0.0.1,192.168.20.0/24';
  }
  
  class {
    'mysql':;
    'mysql::server':
      root_password => 'eCg_sQl51!',
      my_cnf       => "${module_name}/etc/mysql/my.cnf.erb";
  }

  mysql::initialize { 'puppet_master':
    initialize => "puppet:///modules/puppet_master/var/lib/puppet/var/mysql_initialize_puppet.sh",
    unless     => '/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e "SELECT IF(EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = \'puppet\'), \'Yes\',\'No\')" | tail -n1 | grep Yes';
  }

  mysql::initialize { 'puppet_dashboard':
    initialize => "puppet:///modules/puppet_master/var/lib/puppet/var/mysql_initialize_puppet-dashboard.sh",
    unless     => '/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e "SELECT IF(EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = \'dashboard\'), \'Yes\',\'No\')" | tail -n1 | grep Yes';
  }

  mysql::database { 'pdns':; }

  mysql::user { 'pdns':
    password => 'pdns123',
    requires => Mysql::Database['pdns'];
  } ->

  mysql::import { 'pdns_schema':
    database => 'pdns',
    source   => "puppet:///modules/${module_name}/var/lib/puppet/var/mysql_import_pdns_schema.sql",
    unless   => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"SELECT IF(EXISTS (SELECT TABLE_NAME FROM TABLES WHERE TABLE_NAME = \'domains\' AND TABLE_SCHEMA = \'pdns\'), \'Yes\', \'No\')\" information_schema | tail -n1 | grep Yes";
  } ->

  mysql::import { 'pdns_acme_domain':
    database => 'pdns',
    source   => "puppet:///modules/${module_name}/var/lib/puppet/var/mysql_import_pdns_acme_domain.sql",
    unless   => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf pdns -B -e \"SELECT name FROM domains WHERE name LIKE \'%a.c.m.e\'\" | grep \'a.c.m.e\'";
  }

  mysql::grant { 'pdns_select':
    right    => 'SELECT',
    database => 'pdns',
    table    => '*',
    user     => 'pdns',
    requires => Mysql::User['pdns'];
  }

  /*
  file { '/etc/dhcp/dhclient.conf':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/etc/dhcp/dhclient.conf";
  }
  */

}
