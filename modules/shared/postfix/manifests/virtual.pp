# Class: postfix::virtual
#
# Manages content of the /etc/postfix/virtual map.
#
# == Parameters
#
# [*name*]
#   name of address postfix will lookup. See virtual(8).
#
# [*destination*]
#   where the emails will be delivered to. See virtual(8).
#
# == Requires
#
# Line function
#
# == Examples
#
#   postfix::virtual { 'user@example.com':
#     ensure      => 'present',
#     destination => 'root';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define postfix::virtual (
  $destination
  ) {

  line { "${name} ${destination}":
    ensure  => present,
    file    => '/etc/postfix/virtual',
    line    => "${name} ${destination}",
    notify  => Exec['generate /etc/postfix/virtual.db'],
    require => Package['postfix'];
  }

}
