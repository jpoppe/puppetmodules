# Class: syslog_ng
#
# This class installs and configures syslog-ng
#
# == Actions
#
# Install syslog-ng
#
# == Parameters
#
# [*cfg_file*]
#   Content for config file. Defaults to ''
#
# == Examples
#
#   class { 'syslog_ng':; }
#
# == Resources
#
# https://www.balabit.com/sites/default/files/documents/syslog-ng-v3.0-guide-admin-en.html/index.html-single.html
#
# == Authors
#
# Lex van Roon <lvanroon@ebay.com>
#
class syslog_ng (
  $cfgfile = ''
  ) {

  package { 'syslog-ng': ensure => present; }

  if $cfgfile {

    file { '/etc/syslog-ng/syslog-ng.conf':
      ensure  => present,
      require => Package['syslog-ng'],
      content => $cfgfile,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['syslog-ng'];
    }

  }

  service { 'syslog-ng':
    ensure     => running,
    hasstatus  => false,
    hasrestart => true;
  }

}
