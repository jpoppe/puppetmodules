# Class: thin
#
# This class installs and configures thin
#
# == Actions
#
# Install and configure thin
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'thin':; }
#
# == Resources
#
# http://code.macournoyer.com/thin/doc/files/README.html
#
# == Authors
#
# Lex van Roon <lvanroon@ebay.com>
#
class thin {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { 'thin': ensure => installed; }

  file {
    '/etc/thin1.8':
      ensure  => directory,
      recurse => true,
      notify  => Service['thin'];
    '/etc/thin':
      ensure  => symlink,
      target  => '/etc/thin1.8',
      require => File['/etc/thin1.8'],
      notify  => Service['thin'];
    '/var/run/thin':
      ensure  => directory,
      owner   => 'www-data',
      group   => 'www-data',
      recurse => true,
      notify  => Service['thin'];
    '/var/log/thin':
      ensure  => directory,
      owner   => 'www-data',
      group   => 'www-data',
      recurse => true,
      notify  => Service['thin'];
  }

  service { 'thin':
    ensure     => 'running',
    hasstatus  => false,
    hasrestart => true,
    require    => Package['thin'];
  }

}
