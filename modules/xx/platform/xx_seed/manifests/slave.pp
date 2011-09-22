# Class: xx_seed::slave
#
# This class configures a system to be a seed slave host
#
# == Actions
#
# Configure a host to be a seed slave host
#
# == Parameters
#
# [*master_fqdn*]
#   FQDN for the master seed host.
#
# == Examples
#
#   class { 'xx_seed::slave':
#     master_fqdn => 'some.seed.master.server';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_seed::slave (
  $master_fqdn
  ) {
  
  File {
    owner => 'root',
    group => 'root'
  }

  resources { 'cron': purge => true; }

  package { 'at': ensure => present; }

  file {
    '/usr/local/bin/rsync_repositories.sh':
      ensure  => present,
      content => template('xx_seed/usr/local/bin/rsync_repositories.sh.erb'),
      mode    => '0755';
    '/usr/local/bin/rsync_nginx.sh':
      ensure  => present,
      content => template('xx_seed/usr/local/bin/rsync_nginx.sh.erb'),
      mode    => '0755';
  }

  cron {
    'rsync_repositories':
      command => '/usr/local/bin/rsync_repositories.sh',
      user    => 'root',
      minute  => '*/45';
    'rsync_nginx':
      command => '/usr/local/bin/rsync_nginx.sh',
      user    => 'root',
      minute  => '*/10';
  }

}
