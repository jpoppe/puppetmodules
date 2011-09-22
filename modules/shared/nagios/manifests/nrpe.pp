# Class: nrpe
#
# This class manages the nagios nrpe client
#
# == Actions
#
#   Configure and add additional nrpe plugins
#
# == Parameters
#
# [*nagios_nrpe_cfg*]
#   specify a custom /etc/nrpe.cfg
#
# [*allowed_hosts*]
#   Hosts allowed to connect to this nrpe instance. Defaults to '127.0.0.1'
#
# [*server_address*]
#   Address of the server. Defaults to $ipaddress
#
# [*command_timeout*]
#   Timeout for running commands in seconds. Defaults to '60'
#
# [*connection_timeout*]
#   Timeout for connections in seconds. Defaults to '300'
#
# [*nrpe_local_cfg*]
#   Local configuration file for nrpe. Defaults to 
#   'puppet:///modules/nagios/etc/nagios/nrpe_local.cfg'
#
# [*checks*]
#   Source for the file containing the checks. Defaults to undef
#
# == Examples
#
#   class { 'nrpe':; }
#
# == Resources
#
# http://nagios.sourceforge.net/docs/nrpe/NRPE.pdf
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class nagios::nrpe (
  $nrpe_cfg           = 'nagios/etc/nagios/nrpe.cfg.erb',
  $allowed_hosts      = '127.0.0.1',
  $server_address     = $ipaddress,
  $command_timeout    = '60',
  $connection_timeout = '300',
  $nrpe_local_cfg     = 'puppet:///modules/nagios/etc/nagios/nrpe_local.cfg',
  $checks             = undef
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { ['nagios-nrpe-server', 'nagios-plugins-basic', 'nagios-plugins-standard']: ensure => present; }

  file {
    '/etc/nagios/nrpe.d':
      ensure  => directory,
      mode    => '0755',
      require => Package['nagios-nrpe-server'];
    '/etc/nagios/nrpe.cfg':
      content => template("${nrpe_cfg}"),
      notify  => Service['nagios-nrpe-server'],
      require => Package['nagios-nrpe-server'];
    '/etc/nagios/nrpe_local.cfg':
      source  => $nrpe_local_cfg,
      notify  => Service['nagios-nrpe-server'],
      require => Package['nagios-nrpe-server'];
  }

  file {
    '/usr/local/lib/nagios':
      ensure => directory,
      mode   => '0755';
    '/usr/local/lib/nagios/plugins':
      path    => '/usr/local/lib/nagios/plugins',
      source  => "puppet:///modules/${module_name}/usr/local/lib/nagios/plugins",
      mode    => '0755',
      recurse => true,
      purge   => true;
  }

  if $checks {

    file { '/etc/nagios/nrpe.d/checks.cfg':
      source => $checks,
      notify => Service['nagios-nrpe-server'];
    }

  }

  service { 'nagios-nrpe-server':
    ensure     => running,
    hasrestart => true,
    pattern    => '/usr/sbin/nrpe',
    require    => Package['nagios-nrpe-server'];
  }

}
