# Define: apt::key
#
# Manages an apt key
#
# == Parameters
#
# [*source*]
#   The source for this key, if not defined the key will be fetched from the
#   keyservers. Defaults to false
#
# [*keyid*]
#   The PGP key id for this key. This parameter is mandatory
#
# [*keyserver*]
#   The keyserver to fetch the key from. Defaults to hkp://subkeys.pgp.net
#
# == Examples
#
# Fetch a key from the keyserver:
#   apt::key { 'medibuntu':
#     keyid => '0C5A2783';
#   }
#
# Use a pre-seeded key:
#   apt::key { 'medibuntu':
#     source => '<content of ascii-armored PGP public key>',
#     keyid  => '0C5A2783';
#   }
#
# == Resources
#
# https://wiki.debian.org/Apt
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define apt::key (
  $keyid,
  $source    = undef,
  $keyserver = 'hkp://subkeys.pgp.net'
  ) {

  if $source {

    file { "/var/lib/puppet/var/${name}.gpg":
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $source;
    }

    exec { "apt-key add /var/lib/puppet/var/${name}.gpg":
      environment => 'HOME=/root',
      path        => ['/bin', '/usr/bin'],
      unless      => "apt-key adv --list-key ${keyid}",
      logoutput   => on_failure,
      require     => File["/var/lib/puppet/var/${name}.gpg"];
    }

  } else {

    exec { "gpg --keyserver ${keyserver} --recv-keys ${keyid} && gpg --export --armor ${keyid} | apt-key add -":
      environment => 'HOME=/root',
      path        => ['/bin', '/usr/bin'],
      unless      => "apt-key adv --list-key ${keyid}",
      logoutput   => on_failure;
    }

  }

}
