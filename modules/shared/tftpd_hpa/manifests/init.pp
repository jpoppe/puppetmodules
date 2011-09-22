# Class: tftpd_hpa
# 
# This class installs the tftpd_hpa package and makes sure it
# it will run as a standalone daemon
# 
# == Actions
#
# Install tftpd_hpa
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'tftpd_hpa':; }
#
# == Resources
#
# http://freshmeat.net/projects/tftp-hpa/
# http://processors.wiki.ti.com/index.php/Setting_Up_a_TFTP_Server
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class tftpd_hpa () {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { 'tftpd-hpa':
    ensure       => present,
    responsefile => '/var/cache/debconf/tftpd-hpa.seed',
    require      => File['/var/cache/debconf/tftpd-hpa.seed'];
  }

  service { 'tftpd-hpa':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['tftpd-hpa'];
  }

  file { 
    '/etc/default/tftpd-hpa':
      ensure  => present,
      source  => 'puppet:///modules/tftpd_hpa/etc/default/tftpd-hpa',
      notify  => Service['tftpd-hpa'],
      require => Package['tftpd-hpa'];
    '/var/cache/debconf/tftpd-hpa.seed':
      ensure  => present,
      source  => 'puppet:///modules/tftpd_hpa/var/cache/debconf/tftpd-hpa.seed';
  }

}
