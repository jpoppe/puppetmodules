# Class: sudoers
# 
# This class manages the Marktplaats base system
#
# == Actions
#
# Manage /etc/sudoers
#
# == Parameters
#
# [*sudo_entries*]
#   List with sudoers entries. Defaults to []
#
# == Examples
#
#   class { 'sudoers':
#     sudo_entries => [ 'noldap  ALL=(ALL) ALL', 'seedpimp ALL=(ALL) ALL' ];
#   }
#
# == Resources
#
# http://www.gratisoft.us/sudo/man/1.8.1/sudo.man.html
# http://www.gratisoft.us/sudo/readme_ldap.html
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class sudoers (
  $sudo_entries = []
  ) {

  file { '/etc/sudoers':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template('sudoers/etc/sudoers.erb');
  }

}
