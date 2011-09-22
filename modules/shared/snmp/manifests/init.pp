# Class: snmp
#
# This class manages the snmp configuration create the /etc/snmp/checks
# directory where custom checks should be placed, those checks should
# resist in the configs or platforms module paths.
#
# == Actions
#
# Install and configure snmpd
#
# == Parameters
#
# [*com2sec_paranoid*]
#   Community to use for paranoid mode. Defaults to ''
#
# [*com2sec_readonly*]
#   Community to use for read only mode. Defaults to ''
#
# [*com2sec_readwrite*]
#   Community to use for read and write mode. Defaults to ''
#
# [*syslocation*]
#   Set syslocation to this value. Defaults to 'Unknown'
#
# [*syscontact*]
#   Set syscontact to this value. Defaults to 'root <root@localhost>'
#
# [*local_conf*]
#   Define the /etc/snmp/snmpd.local.conf file (yes/no). Defaults to ''
#
# [*enable_trapd*]
#   Enable trapd (yes/no). Defaults to 'no'
#
# == Examples
#
#   class { 'snmp':
#     enable_trapd => "yes",
#     com2sec_paranoid => "paranoid",
#     com2sec_readonly => "readonly",
#     com2sec_readwrite => "test",
#     local_conf => "localtemplate",
#     syslocation => "Unknown",
#     syscontact => "root <root@localhost>"
#   }
#
# == Resources
#
# http://www.net-snmp.org/docs/readmefiles.html
# http://www.net-snmp.org/wiki/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class snmp (
  $enable_trapd      ='no',
  $com2sec_paranoid  = undef,
  $com2sec_readonly  = undef,
  $com2sec_readwrite = undef,
  $local_conf        = undef,
  $syslocation       ='Unknown',
  $syscontact        ='root <root@localhost>') {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package{ 'snmpd': ensure => 'present'; }

  service { 'snmpd':
    ensure     => running,
    hasrestart => true;
  }

  file { '/etc/snmp/snmpd.conf':
    content => template('snmp/etc/snmp/snmpd.conf.erb'),
    mode    => '0640',
    notify  => Service['snmpd'],
    require => Package['snmpd'];
  }

  file { '/etc/snmp/checks':
    ensure  => directory,
    mode    => '0755',
    require => Package['snmpd'];
  }

  file { '/etc/default/snmpd':
    ensure  => present,
    content => template('snmp/etc/default/snmpd.erb'),
    notify  => Service['snmpd'],
    require => Package['snmpd'];
  }

  if $local_conf {

    file { '/etc/snmp/snmpd.local.conf':
      ensure  => present,
      content => template($local_conf),
      notify  => Service['snmpd'],
      require => Package['snmpd'];
    }

  }

}
