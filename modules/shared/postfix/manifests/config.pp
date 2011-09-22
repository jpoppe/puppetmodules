# Class: postfix::config
#
# Uses the "postconf" command to add/alter/remove options in postfix main
# configuation file (/etc/postfix/main.cf).
#
# == Parameters
#
# [*name*]
#   postconf variable name
#
# [*value*]
#   postconf variable value
#
# == Requires
#
# Class["postfix"]
#
# == Examples
#
#   postfix::config {
#     'virtual_alias_maps':
#       value => 'hash:/etc/postfix/virtual';
#     'transport_maps':
#       value => "hash:/etc/postfix/transport";
#     'smtp_use_tls':
#       value => 'yes';
#     'smtp_sasl_auth_enable':
#       value => 'yes';
#     'smtp_sasl_password_maps':
#       value => 'hash:/etc/postfix/my_sasl_passwords';
#     'relayhost':
#       value => '[mail.example.com]:587';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define postfix::config (
  $value
  ) {

  exec { "postconf -e ${name}='${value}'":
    path    => ['/usr/bin', '/usr/sbin'],
    unless  => "/bin/bash -c 'test \"x$(postconf -h ${name})\" == \"x${value}\"'",
    notify  => Service['postfix'],
    require => File['/etc/postfix/main.cf'];
  }

}
