# Class: seedbank
#
# This class installs and configures seedbank
#
# == Actions
#
# Install and configure seedbank
#
# == Parameters
#
# [*settings*]
#   Template to use for seedbank settings. Defaults to undef
#
# == Sample Usage
#
#   class { 'seedbank':; }
#
# or
#
#   class { 'seedbank':
#     settings => 'path/to/some/template.erb';
#   }
#
# == Resources
#
# https://91.211.73.63/dokuwiki/seedpimp
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class seedbank (
  $settings = undef
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { 'seedbank': ensure => present; }

  service { 'seedbank':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['seedbank'];
  }

  if $settings {

    file { '/etc/seedbank/settings.py':
      content => template($settings),
      notify  => Service['seedbank'],
      require => Package['seedbank'];
    }

  }

  exec { '/usr/bin/seedbank_setup -s':
    creates => '/var/lib/tftpboot/pxelinux.0',
    require => Package['seedbank'];
  }

}
