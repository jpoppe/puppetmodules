# Class: dashboard
#
# This class installs and configures puppet-dashboard
#
# == Actions
#
# Install and configure puppet-dashboard
#
# == Todo
#
# Make Puppet Dashboard working with Nginx and Thin
#
# == Parameters
#
# [*password*]
#   Password to use when connecting to the database. Defaults to 'puppet123'
#
# [*db_config*]
#   Source for the database configuration. Defaults to template('puppet_master/etc/puppet-dashboard/database.yml.erb')
#
# [*settings*]
#   Source for the settings. Defaults to template('puppet_master/etc/puppet-dashboard/settings.yml.erb')
#
# [*use_thin*]
#   Use thin instead of puppet-dashboard+mongrel. Defaults to undef
#
# == Examples
#
#   class { 'puppet_master::dashboard':; }
#
# or
#
#   class { 'puppet_master::dashboard':
#     password  => 'other_password',
#     db_config => template('puppet_master/etc/puppet-dashboard/db.yml.erb'),
#     settings  => template('puppet_master/etc/puppet-dashboard/other.yml.erb'),
#     use_thin  => true;
#   }
#
# == Resources
#
# http://www.puppetlabs.com/puppet/related-projects/dashboard/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class puppet_master::dashboard (
  $password  = 'puppet123',
  $workers   = '2',
  $db_config = template('puppet_master/etc/puppet-dashboard/database.yml.erb'),
  $settings  = template('puppet_master/etc/puppet-dashboard/settings.yml.erb'),
  $use_thin  = undef
  ) {

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['puppet-dashboard'],
    before  => Service['puppet-dashboard-workers']
  }

  Exec {
    logoutput => on_failure
  }

  package { ['puppet-dashboard', 'rake']: ensure => installed; }

  if $use_thin {

    service { 'puppet-dashboard':
      ensure => stopped,
      enable => false;
    }

  } else {

    service { 'puppet-dashboard':
      ensure     => 'running',
      hasstatus  => true,
      hasrestart => true,
      require    => Package['puppet-dashboard'];
    }

  }

  service { 'puppet-dashboard-workers':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['puppet-dashboard'];
  }

  file {
    '/etc/puppet-dashboard/database.yml':
      ensure  => present,
      content => $db_config,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0640',
      require => Package['puppet-dashboard'];
    '/etc/puppet-dashboard/settings.yml':
      ensure  => present,
      content => $settings,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0640',
      require => Package['puppet-dashboard'];
    '/usr/share/puppet-dashboard/config/settings.yml':
      ensure => link,
      target => '/etc/puppet-dashboard/settings.yml';
    '/usr/share/puppet-dashboard/config/database.yml':
      ensure => link,
      target => '/etc/puppet-dashboard/database.yml';
    '/etc/default/puppet-dashboard':
      ensure => present,
      source => 'puppet:///modules/puppet_master/etc/default/puppet-dashboard';
    '/usr/share/puppet-dashboard/log':
      ensure  => directory,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0644',
      recurse => true;
    '/usr/share/puppet-dashboard/public':
      ensure  => directory,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0644',
      recurse => true;
    '/usr/share/puppet-dashboard/tmp':
      ensure  => directory,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0666',
      ignore  => ['pids'],
      recurse => true;
  }

  # Uploaded reports will be placed here
  file {
    '/usr/share/puppet-dashboard/spool':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      before => $dashboard_service;
    '/etc/puppet-dashboard':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0750',
      before => $dashboard_service;
  }

  file { '/etc/default/puppet-dashboard-workers':
    ensure  => present,
    content => template('puppet_master/etc/default/puppet-dashboard-workers.erb'),
    notify  => Service['puppet-dashboard-workers'];
  }

  file { '/var/lib/puppet/var/check_puppet_dashboard_db.sh':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/puppet_master/var/lib/puppet/var/check_puppet_dashboard_db.sh';
  }

  exec { '/usr/bin/rake db:migrate':
    unless  => '/var/lib/puppet/var/check_puppet_dashboard_db.sh',
    cwd     => '/usr/share/puppet-dashboard',
    path    => ['/bin', '/usr/bin'],
    before  => Service['puppet-dashboard-workers'],
    require => File['/etc/puppet-dashboard/database.yml', '/var/lib/puppet/var/check_puppet_dashboard_db.sh'];
  }

  /*
  # Disabled since it seems to work without, should be fixed in future
  exec { 'puppet_dashboard_certs':
    command   => 'rake cert:create_key_pair && rake cert:request && rake cert:retrieve',
    creates   => '/usr/share/puppet-dashboard/certs/dashboard.private_key.pem',
    cwd       => '/usr/share/puppet-dashboard',
    path      => ['/usr/bin', 'usr/sbin'],
    logoutput => on_failure,
    require   => File['/usr/share/puppet-dashboard/config/settings.yml', '/usr/share/puppet-dashboard/config/database.yml'];
  }
  */

}
