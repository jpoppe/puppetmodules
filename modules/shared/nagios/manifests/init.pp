# Class: nagios
#
# This class manages a nagios installation
#
# == Action
#
# Installs a nagios3 installation
#
# == Parameters
#
# [*password*]
#   Password for this nagios installation. Defaults to 'nagios123'
#
# [*nagios_conf*]
#   Configuration file to use for this nagios installation. Defaults to
#   'puppet:///modules/nagios/etc/nagios3/nagios.cfg'
#
# == Example
#
#   class { 'nagios':; }
#
#   class { 'nagios':
#     password => 'some_other_password',
#     nagios_conf => 'puppet:///modules/nagios/etc/nagios3/some_other.cfg';
#   }
#
# == Resources
#
# http://www.nagios.org/documentation
# http://www.bytetouch.com/blog/linux/how-to-nagios-3-installation-on-debian/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class nagios (
  $password    = 'nagios123',
  $nagios_conf = 'puppet:///modules/nagios/etc/nagios3/nagios.cfg'
  ) {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  file { '/var/cache/debconf/nagios3-cgi.seed':
    content => template('nagios/var/cache/debconf/nagios3-cgi.seed.erb'),
    mode    => '0600',
    ensure  => present;
  }

  package {
    'nagios3-cgi':
      ensure       => installed,
      responsefile => '/var/cache/debconf/nagios3-cgi.seed',
      require      => File['/var/cache/debconf/nagios3-cgi.seed'];
    ['nagios3', 'nagios3-doc', 'nagios-snmp-plugins', 'nagios-nrpe-plugin']:
      ensure  => installed,
      require => Package['nagios3-cgi'];
    
  }

  service { 'nagios3':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['nagios3'];
  }

  Nagios_host        <<||>>
  Nagios_service     <<||>>
  Nagios_hostextinfo <<||>>

  Exec {
    path    => [ '/usr/sbin', '/usr/bin' ],
    require => Package['nagios3']
  }

  exec {
    '/usr/sbin/dpkg-statoverride --update --add nagios nagios 0751 /var/lib/nagios3':
      unless    => 'dpkg-statoverride --list nagios www-data 0751 /var/lib/nagios3',
      notify    => Service['nagios3'],
      require   => Package['nagios3'];
    '/usr/sbin/dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw':
      unless    => 'dpkg-statoverride --list nagios www-data 2710 /var/lib/nagios3/rw',
      notify    => Service['nagios3'],
      require   => Package['nagios3'];
  }

  file {
    [ '/etc/nagios3/conf.d/puppet_hostextinfo.cfg', '/etc/nagios3/conf.d/puppet_service.cfg', '/etc/nagios3/conf.d/puppet_host.cfg', '/etc/nagios3/conf.d/puppet_contacts.cfg', '/etc/nagios3/conf.d/puppet_contactgroups.cfg' ]:
      ensure  => file,
      replace => false,
      notify  => Service['nagios3'],
      require => Package['nagios3'];
  }

  file {
    '/etc/nagios3/htpasswd.users':
      #ensure  => present,
      mode    => '0644',
      owner   => 'www-data',
      group   => 'www-data',
      require => Package['nagios3'];
    '/etc/nagios3/nagios.cfg':
      ensure  => present,
      source  => $nagios_conf,
      mode    => '0644',
      notify  => Service['nagios3'],
      require => Package['nagios3'];
  }

}
