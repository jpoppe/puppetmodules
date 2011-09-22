# Class: munin_basic
#
# This class configures basic Munin graphs
#
# == Actions
#
# Configure Munin
#
# == Parameters
#
# [*server_fqdn*]
#   Host to register this munin client on
#
# == Examples
#
#   class { 'xx_monitoring::munin_basic':; }
#
class xx_monitoring::munin_basic (
  $server_fqdn
  ) {

  class { 'munin':; }

  munin::register { $fqdn:
    server_fqdn => $server_fqdn;
  }

  munin::plugin {
    ['df', 'cpu', 'interrupts', 'load', 'memory', 'netstat', 'open_files',
    'processes', 'swap', 'uptime', 'users', 'vmstat', 'df_abs', 'forks',
    'df_inode', 'irqstats', 'entropy', 'open_inodes', 'iostat',
    'postfix_mailqueue', 'postfix_mailvolume', 'acpi']:;
  }

  $ifs = regsubst(split($interfaces, " |,"), "(.+)", "if_\\1")

  munin::plugin { $ifs: target => 'if_'; }

  $if_errs = regsubst(split($interfaces, " |,"), "(.+)", "if_err_\\1")

  munin::plugin { $if_errs: target => 'if_err_'; }

}
