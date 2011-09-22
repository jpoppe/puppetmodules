# Class: puppetmaster::queue
#
# == Actions
#
# Configure the Puppet queue daemon
#
# == Parameters
#
# None
#
# == Notes
#
# The Debian Ruby STOMP version is to old, an easy way to get a deb with the latest version
#   sudo apt-get install build-essential bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libxml2-dev libxslt-dev autoconf libc6-dev 
#   sudo gem install fpm
#   /var/lib/gems/1.8/gems/fpm-0.3.7/bin/fpm -s gem stomp -t deb
#
# == Examples
#
#   class { 'puppet_master::queue':; }
#
# == Resources
#
# http://projects.puppetlabs.com/projects/1/wiki/Using_Stored_Configuration
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class puppet_master::queue () {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  file { '/etc/default/puppetqd':
    ensure  => present,
    source  => 'puppet:///modules/puppet_master/etc/default/puppetqd',
    require => Package['puppetmaster'];
  }

  #package { 'rubygem-stomp': ensure => present; }

  service { 'puppetqd':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['puppetmaster'],
    notify     => Service['puppetmaster'];
  }

}
