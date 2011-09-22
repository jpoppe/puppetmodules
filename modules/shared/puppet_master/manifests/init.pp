# Class: puppet_master
#
# This class installs a puppet server (CA or Master)
#
# == Actions
#
# To install a puppetmaster;
# 1) When reinstalling and using a central CA, revoke the certificate on the CA:
#   puppetca -c <fqdn>
#
# 2) Put a tar of the git repository in /root/ecg.tgz and extract it somewhere.
#
# 3) In the codebase, run:
#   puppet --modulepath $PWD/modules/shared --no-daemonize --onetime \
#   manifests/site.pp
#
# 4) Next, run puppetd once:
#   puppetd --no-daemonize --onetime
#
# To install a central CA:
# 1) Clean up the CA server to make sure no traces of old master instances
#    are left over:
#   /etc/init.d/puppetmaster stop; rm -rf /var/lib/puppet/ssl
#
# 2) Configure puppet (if not done already):
#   printf "server=puppetmaster.client\npluginsync=true\n" \
#   >> /etc/puppet/puppet.conf
#
# 3) Run puppetd:
#   puppetd --test
#
# 4) On the puppetmaster, run:
#   puppetd --test
#
# == Parameters
#
# [*altnames*]
#   List of altnames. Defaults to undef
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class puppet_master (
  $altnames = undef
  ) {

  File {
    owner => 'root',
    group => 'root',
  }

  package { ['puppet-common', 'puppetmaster', 'vim-puppet', 'libjson-ruby', 'libactiverecord-ruby', 'mongrel']: ensure => installed; }

  file {
    '/etc/init.d/puppetmaster':
      ensure  => present,
      source  => 'puppet:///modules/puppet_master/etc/init.d/puppetmaster',
      mode    => '0755',
      require => Package['puppetmaster'];
    '/etc/init.d/puppetqd':
      ensure  => present,
      source  => 'puppet:///modules/puppet_master/etc/init.d/puppetqd',
      mode    => '0755',
      require => Package['puppetmaster'];
  }

  file { '/etc/puppet/files':
    ensure  => directory,
    mode    => '0755',
    require => Package['puppet-common'],
    before  => Package['puppetmaster'];
  }

}
