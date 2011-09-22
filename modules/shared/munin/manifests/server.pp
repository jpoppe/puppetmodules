# Class: server
#
# This class manages a munin server
#
# == Actions
#
# Install a munin server and perform basic configuration
#
# == Parameters
#
# [*ignore*]
#   Files to ignore by Puppet
#
# == Examples
#
#   class { 'munin::server':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class munin::server (
  $ignore = ['.gitignore']
  ) {

  $clean_server_fqdn = regsubst($fqdn, '\.', '_', 'G')

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['munin-node'],
    require => Package['munin']
  }

  package { 'munin': ensure => installed; }

  file {
    '/etc/munin/munin.conf':
      content => template('munin/etc/munin/munin.conf.erb');
    '/etc/munin/plugins':
      source   => "puppet:///modules/${module_name}/etc/munin/plugins",
      ignore   => ['.gitignore', 'jmx_*'],
      ensure   => directory,
      checksum => mtime,
      recurse  => true,
      purge    => true,
      force    => true,
      mode     => '0755';
    '/etc/munin/plugin-conf.d':
      source   => "puppet:///modules/${module_name}/etc/munin/plugin-conf.d",
      ignore   => ['.gitignore', '*.jmx'],
      ensure   => directory,
      checksum => mtime,
      recurse  => true,
      purge    => true,
      force    => true,
      mode     => '0755';
    '/etc/munin/munin-conf.d':
      source   => "puppet:///modules/${module_name}/etc/munin/plugin-conf.d",
      ignore   => '.gitignore',
      ensure   => directory,
      checksum => mtime,
      recurse  => true,
      purge    => true,
      force    => true,
      mode     => '0755';
  }

  file { '/usr/local/bin/force_munin_run.sh':
    content => "su - munin --shell /bin/bash munin-cron\n",
    mode    => '0755';
  }

  File <<| tag == "munin_${clean_server_fqdn}" |>>

  Exec <<| tag == "munin_${clean_server_fqdn}" |>> ~> Service['munin-node']

}
