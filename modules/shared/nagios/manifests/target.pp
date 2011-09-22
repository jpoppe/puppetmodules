# Class: target
#
# This class configures a host in nagios
#
# == Actions
#
# Add a host to nagios
#
# == Parameters
#
# [*contact_groups*]
#   Contact group belonging to this host. Defaults to 'Admins'
#
# == Todo
#
# Fix base/debian.png lowercase operatingsystem
#
# == Examples
#
#   class { 'nagios::target': }
#
#   class { 'nagios::target': contact_groups => 'SomeGroup'; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class nagios::target (
    $contact_groups = 'Admins'
    ) {
  
  Nagios_service {
    target      => '/etc/nagios3/conf.d/puppet_service.cfg',
    host_name       => $hostname,
    notify          => Service['nagios3'],
    contact_groups  => $contactgroups
  }

  @@nagios_host { $hostname:
    target  => '/etc/nagios3/conf.d/puppet_host.cfg',
    ensure  => present,
    alias   => $hostname,
    address => $ipaddress,
    use     => 'generic-host',
    notify  => Service['nagios3'];
  }

  @@nagios_hostextinfo { $hostname:
    target          => '/etc/nagios3/conf.d/puppet_hostextinfo.cfg',
    ensure          => present,
    icon_image_alt  => $operatingsystem,
    icon_image      => "base/debian.png",
    statusmap_image => "base/debian.gd2",
    notify          => Service['nagios3'];
  }

  @@nagios_service {
    "check_disk_all_${hostname}":
      use                 => 'generic-service',
      service_description => 'Disk Space',
      check_command       => 'check_nrpe_1arg!check_disk_all';
    "check_load_${hostname}":
      use                 => 'generic-service',
      service_description => 'Current Load',
      check_command       => 'check_nrpe_1arg!check_load';
    "check_procs_total_${hostname}":
      use                 => 'generic-service',
      service_description => 'Processes Total',
      check_command       => 'check_nrpe_1arg!check_procs_total';
    "check_procs_zombie_${hostname}":
      use                 => 'generic-service',
      service_description => 'Processes Zombie',
      check_command       => 'check_nrpe_1arg!check_procs_zombie';
    "check_ssh_local${hostname}":
      use                 => 'generic-service',
      service_description => 'SSH Local',
      check_command       => 'check_nrpe_1arg!check_ssh_local';
    "check_swap${hostname}":
      use                 => 'generic-service',
      service_description => 'Swap Usage',
      check_command       => 'check_nrpe_1arg!check_swap';
    "check_user${hostname}":
      use                 => 'generic-service',
      service_description => 'Current Users',
      check_command       => 'check_nrpe_1arg!check_users';
    "check_apt${hostname}":
      use                 => 'generic-service',
      service_description => 'Check apt',
      check_command       => 'check_nrpe_1arg!check_apt';
    "check_mailq${hostname}":
      use                 => 'generic-service',
      service_description => 'Mailq',
      check_command       => 'check_nrpe_1arg!check_mailq';
    "check_dns${hostname}":
      use                 => 'generic-service',
      service_description => 'Dns',
      check_command       => 'check_nrpe_1arg!check_dns';
    #"check_procs_nscd${hostname}":
    #  use                 => 'generic-service',
    #  service_description => 'Nscd Process',
    #  check_command       => 'check_nrpe_1arg!check_procs_nscd';
    "check_procs_ntpd${hostname}":
      use                 => 'generic-service',
      service_description => 'Ntpd Process',
      check_command       => 'check_nrpe_1arg!check_procs_ntpd';
    "check_procs_inetd${hostname}":
      use                 => 'generic-service',
      service_description => 'Inetd Process',
      check_command       => 'check_nrpe_1arg!check_procs_inetd';
    "check_procs_syslog${hostname}":
      use                 => 'generic-service',
      service_description => 'Syslog Process',
      check_command       => 'check_nrpe_1arg!check_procs_syslog';
    "check_smtp${hostname}":
      use                 => 'generic-service',
      service_description => 'Smtp',
      check_command       => 'check_nrpe_1arg!check_smtp';
    "check_ntp${hostname}":
      use                 => 'generic-service',
      service_description => 'Ntp',
      check_command       => 'check_nrpe_1arg!check_ntp';
    #"check_ldap${hostname}":
    #  use                 => 'generic-service',
    #  service_description => 'Ldap',
    #  check_command       => 'check_nrpe_1arg!check_ldap';
  }

}
