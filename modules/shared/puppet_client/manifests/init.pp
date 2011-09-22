# Class: puppet_client
#
# This class manages the puppet clients
#
# == Actions
#
# Configure the puppet client
#
# == Parameters
#
# [*puppetmaster*]
#   The address of the puppetmaster, best to make it ip based (watch for cert
#   issues!), can be vip of course. Defaults to '10.10.10.10'
#
# [*puppetca*]
#   The server to use for certificate authority requests. Defaults to
#   '10.10.10.20'
#
# [*report_server*]
#   The server to send reports to. Defaults to '10.10.10.30'
#
# [*report*]
#   Send a report. Defaults to true
#
# [*thin_storeconfigs*]
#   Store thin configurations. Defaults to true
#
# [*runinterval*]
#   How often puppetd applies the client configuration, in seconds. Defaults
#   to '900'
#
# [*configtimeout*]
#   How long the client should wait for the configuration to be retrieved
#   before considering it a failure, in seconds. Defaults to '120'
#
# [*splay*]
#   Whether to sleep for a pseudo-random (but consistent) amount of time
#   before a run. Defaults to true
#
# [*splaylimit*]
#   The maximum time to delay before runs, in seconds. Defaults to '300'
#
# [*pluginsync*]
#   Whether plugins should be synced with the central server. Defaults to true
#
# [*usecacheonfailure*]
#   Whether to use the cached configuration when the remote configuration will
#   not compile. Defaults to false
#
# [*puppet_environment*]
#   Environment to run puppet in. Defaults to 'staging'
#
# [*maxmempct*]
#   Restart puppet agent when it uses more than a certain percentage of
#   memory. Defaults to '20'
#
# [*keepalive*]
#   Make sure puppet keeps running. Defaults to true
#
# == Examples
#
# If you do not use any parameters, the defaults will be set as found by doing
# a puppetd --genconfig
#   class { 'puppet_client':
#     puppetmaster       => '10.10.10.10',
#     puppetca           => '10.10.10.20',
#     report_server      => '10.10.10.30',
#     report             => true,
#     thin_storeconfigs  => true,
#     runinterval        => '900',
#     configtimeout      => '120',
#     splay              => true,
#     splaylimit         => '300',
#     pluginsync         => true,
#     usecacheonfailure  => false,
#     puppet_environment => staging,
#     maxmempct          => 20,
#     keepalive          => true
# }
#
# == Authors
#
# GJ Moed <gmoed@ebay.com>
# 
# == Credits
#
# Jasper Poppe <jpoppe@ebay.com>
# Lex van Roon <lvanroon@ebay.com>
#
class puppet_client (
  $puppetmaster       = 'puppet',
  $puppetca           = $puppetmaster,
  $puppet_daemon      = true,
  $report_server      = $puppetmaster,
  $report             = false,
  $thin_storeconfigs  = false,
  $runinterval        = '1800',
  $configtimeout      = '120',
  $splay              = false,
  $splaylimit         = '1800',
  $pluginsync         = false,
  $usecacheonfailure  = true,
  $puppet_environment = 'production',
  $maxmempct          = 0,
  $keepalive          = false
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  Package['puppet'] -> File['/etc/puppet/puppet.conf'] -> Service['puppet']

  package { ['puppet', 'facter']: ensure => installed, configfiles => keep; }

  service { 'puppet':
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    ensure     => $puppet_daemon ? { default => stopped, true => running },
    pattern    => 'puppetd',
    require    => Package['puppet'];
  }

  if versioncmp($puppetversion, '2.6.8') >= 0 {

    cron { 'puppet-keep-alive':
      command => "if [ -e /var/run/puppet/agent.pid ]; then ps uw -p `cat /var/run/puppet/agent.pid` | grep -q '/usr/bin/ruby1.8 /usr/bin/puppet agent' || (rm /var/run/puppet/puppetd.pid; /usr/sbin/invoke-rc.d puppet start); else /usr/sbin/invoke-rc.d puppet start; fi",
      ensure  => $keepalive ? { true => 'present', default => 'absent' },
      user    => 'root',
      minute  => '*/5';
    }

  } else {

    cron { 'puppet-keep-alive':
      command => "if [ -e /var/run/puppet/puppetd.pid ]; then ps uw -p `cat /var/run/puppet/puppetd.pid` | grep -q 'ruby /usr/sbin/puppetd' || (rm /var/run/puppet/puppetd.pid; /usr/sbin/invoke-rc.d puppet start); else /usr/sbin/invoke-rc.d puppet start; fi",
      ensure  =>  $keepalive ? { true => 'present', default => 'absent' },
      user    => 'root',
      minute  => '*/5';
    }

  }

  file {
    '/etc/puppet/puppet.conf':
      content => template('puppet_client/etc/puppet/puppet.conf.erb'),
      notify  => Service['puppet'];
    '/etc/default/puppet':
      content => template('puppet_client/etc/default/puppet.erb');
  }

  if $maxmempct > 0 {

    exec { "Restart puppet if memuse more than ${maxmempct}pct":
      alias     => 'RestartPuppetAndFreeMem',
      path      => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      command   => 'invoke-rc.d puppet restart',
      logoutput => on_failure,
      timeout   => 10,
      tries     => 2,
      try_sleep => 5,
      onlyif    => "[ -e /var/run/puppet/puppetd.pid ] && test `ps -o pmem= -p \\`cat /var/run/puppet/puppetd.pid\\` | cut -d \".\" -f 1` -ge ${maxmempct}",
    }

  }

}
