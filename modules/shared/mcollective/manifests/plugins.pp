# Class: plugins
#
# This class installs MCollective plugins
#
# == Actions
#
# Install MCollective plugins
#
# == Parameters
#
# None
#
# == Notes
#
# This manifest is automatically generated, manual changes will be lost!
#
# Make sure to keep the documentation up-to-date during development of this
# module.
#
# == Examples
#
#   class { 'mcollective::plugins':; }
#
# == Resources
#
# https://projects.puppetlabs.com/projects/mcollective-plugins/wiki
#
class mcollective::plugins () {

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mcollective']
  }

  file {
    '/usr/sbin/mc-package':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-package";
    '/usr/sbin/mc-ssh-highline':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-ssh-highline";
    '/usr/sbin/mc-ssh':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-ssh";
    '/usr/sbin/mc-service':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-service";
    '/usr/sbin/mc-peermap':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-peermap";
    '/usr/sbin/mc-filemgr':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-filemgr";
    '/usr/sbin/mc-apt':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-apt";
    '/usr/sbin/mc-pgrep':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-pgrep";
    '/usr/sbin/check-mc-nrpe':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/check-mc-nrpe";
    '/usr/sbin/mc-collectivemap':
      ensure => present,
      mode   => '0755',
      source => "puppet:///modules/${module_name}/usr/sbin/mc-collectivemap";
    '/usr/share/mcollective/plugins/mcollective/application/filemgr.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/application/filemgr.rb";
    '/usr/share/mcollective/plugins/mcollective/application/mc-service':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/application/mc-service";
    '/usr/share/mcollective/plugins/mcollective/application/mc-apt':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/application/mc-apt";
    '/usr/share/mcollective/plugins/mcollective/application/service.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/application/service.rb";
    '/usr/share/mcollective/plugins/mcollective/application/nrpe.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/application/nrpe.rb";
    '/usr/share/mcollective/plugins/mcollective/application/package.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/application/package.rb";
    '/usr/share/mcollective/plugins/mcollective/application/nettest.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/application/nettest.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/filemgr.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/filemgr.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/puppetca.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/puppetca.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/process.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/process.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/nettest.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/nettest.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/apt.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/apt.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/nrpe.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/nrpe.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/apt.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/apt.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/puppetca.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/puppetca.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/stomputil.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/stomputil.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/service.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/service.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/service.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/service.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/nrpe.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/nrpe.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/filemgr.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/filemgr.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/process.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/process.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/package.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/package.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/stomputil.ddl':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/stomputil.ddl";
    '/usr/share/mcollective/plugins/mcollective/agent/registration.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/registration.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/puppetral.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/puppetral.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/package.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/package.rb";
    '/usr/share/mcollective/plugins/mcollective/agent/nettest.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/agent/nettest.rb";
    '/usr/share/mcollective/plugins/mcollective/registration/meta.rb':
      ensure => present,
      source => "puppet:///modules/${module_name}/usr/share/mcollective/plugins/mcollective/registration/meta.rb";
  }

}
