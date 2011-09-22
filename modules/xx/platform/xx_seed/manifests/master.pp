# Class: xx_seed::master
#
# This class configures a system to be a seed host
#
# == Actions
#
# Configure a host to be a seed host
#
# == Parameters
#
# None
#
# == Notes
#
# Only one server has DHCP active change the $xx_seed_active variable
# when you want to switch the active one
#
# == Examples
#
#   class { 'xx_seed':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class xx_seed::master (
  ) {
  
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  resources { 'cron': purge => true; }

  package { 'at': ensure => present; }

  class { 'gpg':; }

  # Private key used by reprepro for signing Debian packages (key has been taken out, so add your own)
  gpg::key {
    'private':
      keyid       => '12345678',
      source      => "puppet:///modules/${module_name}/var/lib/puppet/var/private.key",
      user        => 'repo',
      environment => 'HOME=/home/repo';
    'debian_key':
      keyid       => '473041FA',
      user        => 'repo',
      environment => 'HOME=/home/repo';
  }

  class { 'reprepro':; }

  reprepro::repository {
    'custom':
      source => "puppet:///modules/${module_name}/opt/repositories/debian/custom/conf",
      type   => 'debian';
    'mirror':
      source => "puppet:///modules/${module_name}/opt/repositories/debian/mirror/conf",
      type   => 'debian';
    'backports':
      source => "puppet:///modules/${module_name}/opt/repositories/debian/backports/conf",
      type   => 'debian';
  }

  class { 'rsync::server':
    rsyncd_conf => "puppet:///modules/${module_name}/etc/rsyncd.conf";
  }

  cron {
    'update_debian_mirror':
      command => '/usr/local/bin/rep.py -u mirror',
      user    => 'repo',
      hour    => '6',
      minute  => '0';
    'update_debian_backports':
      command => '/usr/local/bin/rep.py -u backports',
      user    => 'repo',
      hour    => '7',
      minute  => '0';
  }

}
