# Class: nagios_basic
#
# This class configures a system for basic nagios monitoring
#
# == Actions
#
# Configure nagios monitoring
#
# == Parameters
#
# [*allowed_hosts*]
#   Hosts allowed to connect to NRPE
#
# == Examples
#
#   class { 'xx_monitoring::nagios_basic':
#     allowed_hosts => '10.1.2.0/24';
#   }
#
class xx_monitoring::nagios_basic (
  $allowed_hosts
  ) {

  class {
    'nagios::target':;
    'nagios::nrpe':
      allowed_hosts => $allowed_hosts,
      checks        => "puppet:///modules/${module_name}/etc/nagios/nrpe.d/checks.cfg";
  }

}
