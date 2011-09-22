# Class: server
#
# This class installs and configures an rsync server
#
# == Actions
#
# Install and configure an rsync server
#
# == Parameters
#
# [*rsyncd_conf*]
#   The rsync configuration file
#
# == Examples
#
#   class { 'rsync::server':
#     rsyncd_conf => "puppet:///modules/${module_name}/etc/rsyncd.conf";
#   }
#
# == Resources
#
# http://everythinglinux.org/rsync/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class rsync::server (
  $rsyncd_conf
  ) {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  file {
    '/etc/default/rsync':
      source => 'puppet:///modules/rsync/etc/default/rsync',
      notify => Service['rsync'];
    '/etc/rsyncd.conf':
      source => $rsyncd_conf,
      notify => Service['rsync'];
  }

  service { 'rsync':
    hasstatus  => true,
    hasrestart => true,
    require    => Package['rsync'];
  }

}
