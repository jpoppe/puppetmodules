# Class: bootstrap
#
# This class bootstraps a puppet master
#
# == Actions
#
# Bootstrap a puppet-master, this manifest will only run once
#
# == Parameters
#
#   None
#
# == Examples
#
#   class { 'puppet_master::bootstrap':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class puppet_master::bootstrap () {

  # copy the puppet data to /etc/puppet
  exec { 'untar_repo':
    command => '/bin/tar cf - * | ( cd /etc/puppet; /bin/tar xfp -)',
    cwd     => '/root/ecg-puppet-staging',
    creates => '/etc/puppet/modules/shared';
  }

  # use a minimal configured puppetmaster config to be able to finish bootstrapping
  file {
    '/etc/default/puppetmaster':
      ensure  => present,
      source  => 'puppet:///modules/puppet_master/etc/default/puppetmaster',
      require => Package['puppetmaster'];
    '/etc/puppet/puppetmaster.conf':
      ensure  => present,
      content => template('puppet_master/etc/puppet/puppetmaster.conf.erb'),
      require => Package['puppetmaster'];
    '/etc/puppet/puppet.conf':
      ensure  => present,
      content => "[main]\nserver=${fqdn}\npluginsync=true\nssldir=/var/lib/puppet/ssl\n",
      require => Exec['untar_repo'];
  }

  # do a puppetmaster restart at the end of the run
  service { 'puppetmaster':
    ensure    => running,
    hasstatus => true,
    subscribe => File['/etc/default/puppetmaster', '/etc/puppet/puppetmaster.conf', '/etc/puppet/puppet.conf'],
    require   => [Exec['untar_repo'], File['/etc/init.d/puppetmaster']];
  } -> exec { '/etc/init.d/puppetmaster restart': }

}
