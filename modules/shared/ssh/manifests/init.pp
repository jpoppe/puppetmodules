# Class: ssh
# 
# This class installs and configures ssh
#
# == Actions
#
# Install and configure ssh
#
# == Parameters
#
# [*ssh_config*]
#   Specify a global configuration file for the SSH client
#
# [*sshd_config*]
#   Specify a global configuration file for the SSH server
#
# == Examples
#
# class { 'ssh':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class ssh (
  $ssh_config  = undef,
  $sshd_config = undef
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { ['openssh-client', 'openssh-server']: ensure => present; }

  if $ssh_config {

    file { '/etc/ssh/ssh_config':
      source => $ssh_config;
    }

  }

  if $sshd_config {

    file { '/etc/sshd/sshd_config':
      source => $sshd_config;
    }

  }

  service { ssh:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true;
  }

}
