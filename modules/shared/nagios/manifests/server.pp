# Class: server
#
# This class installs and configures a nagios server
#
# == Actions
#
# Install and configure a nagios server
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'nagios::server':; }
#
# == Resources
#
# http://www.nagios.org/documentation
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class nagios::server {

  Nagios_service {
    target    => '/etc/nagios3/conf.d/puppet_contacts.cfg',
    notify    => Service['nagios3'],
  }

   nagios_contactgroup {
    'Poppe':
      target  => '/etc/nagios3/conf.d/puppet_contactgroups.cfg',
      alias   => 'seedBank',
      members => 'Jasper';
  }

  nagios_contact {
    'Jasper':
      target                        => '/etc/nagios3/conf.d/puppet_contacts.cfg',
      alias                         => 'Jasper',
      service_notification_period   => '24x7',
      host_notification_period      => '24x7',
      service_notification_options  => 'w,u,c,r',
      host_notification_options     => 'd,r',
      service_notification_commands => 'notify-service-by-email',
      host_notification_commands    => 'notify-host-by-email',
      email                         => 'root@localhost';
  }

}
