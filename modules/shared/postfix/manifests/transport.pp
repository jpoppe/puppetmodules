# Class: postfix::transport
#
# Manages content of the /etc/postfix/transport map.
#
# == Parameters
#
# [*name*]
#   name of address postfix will lookup. See transport(5).
#
# [*destination*]
#   where the emails will be delivered to. See transport(5).
#
# == Requires
#
# Line function
#
# == Examples
#
#   postfix::transport { 'mailman.example.com':
#     destination => 'mailman';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define transport (
  $destination
  ) {

  line { "${name} ${destination}":
    ensure  => present,
    file    => '/etc/postfix/transport',
    line    => "${name} ${destination}",
    notify  => Exec['generate /etc/postfix/transport.db'],
    require => Package['postfix'],
  }

}
