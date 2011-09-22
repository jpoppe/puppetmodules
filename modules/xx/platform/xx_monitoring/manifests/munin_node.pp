# Class: munin_node
#
# This class configures Munin graphs for the Munin node
#
# == Actions
#
# Configure Munin
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'xx_monitoring::munin_node':; }
#
class xx_monitoring::munin_node () {

  class { 'munin':; }

  file { '/etc/munin/munin-conf.d/localhost.localdomain':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/etc/munin/munin-conf.d/localhost.localdomain";
  }

  munin::deploy {
    nagios_hosts:
      config => 'user root';
    nagios_svc:
      config => 'user root';
    nagios_perf_hosts:
      source => 'puppet:///modules/munin/usr/share/munin/plugins/nagios_perf',
      config => 'user root';
    nagios_perf_svc:
      source => 'puppet:///modules/munin/usr/share/munin/plugins/nagios_perf',
      config => 'user root';
  }

  munin::plugin {
    ['df', 'cpu', 'interrupts', 'load', 'memory', 'netstat', 'open_files',
    'processes', 'swap', 'uptime', 'users', 'vmstat', 'df_abs', 'forks',
    'df_inode', 'irqstats', 'entropy', 'open_inodes', 'iostat',
    'postfix_mailqueue', 'postfix_mailvolume', 'acpi']:;
  }

  munin::plugin {
    ['munin_update', 'munin_graph']:;
    ['apache_accesses', 'apache_processes',' apache_volume']:;
  }

  $ifs = regsubst(split($interfaces, " |,"), "(.+)", "if_\\1")

  munin::plugin { $ifs: target => 'if_'; }

  $if_errs = regsubst(split($interfaces, " |,"), "(.+)", "if_err_\\1")

  munin::plugin { $if_errs: target => 'if_err_'; }

  /*
  munin::deploy { 'apache_activity': }
  munin::deploy { 'tinydns': }
  munin::deploy { ['xen', 'xen-cpu', 'xen_memory', 'xen_mem', 'xen_vm', 'xen_vbd', 'xen_traffic_all']:
    config => 'user root';
  }
  */

}
