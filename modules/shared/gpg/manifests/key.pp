# Define: gpg::key
#
# Manage PGP keys
#
# == Parameters
#
# [*keyid*]
#   The PGP key id for this key. This parameter is mandatory
#
# [*source*]
#   The source for this key, if not defined the key will be fetched from the
#   keyservers. Defaults to undef
#
# [*user*]
#   User to run the commands from
#
# [*environment*]
#   Set this to the user home directory, e.g.; 'HOME=/home/repo'
#
# [*keyserver*]
#   The keyserver to fetch the key from. Defaults to hkp://subkeys.pgp.net
#
# == Examples
#
# Fetch a key from the keyserver:
#   gpg::key { 'medibuntu':
#     keyid => '0C5A2783';
#   }
#
# Use a pre-seeded key:
#   gpg::key { 'medibuntu':
#     source => '<content of ascii-armored PGP public key>',
#     keyid  => '0C5A2783';
#   }
#
# == Notes
#
# Export a public GPG key
#   gpg --export -a "<description>" > public.key 
#
# Export a private GPG key
#   gpg --export-secret-key -a "<description>" > private.key
#
# == Resources
#
# https://wiki.debian.org/Apt
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define gpg::key (
  $keyid,
  $source      = undef,
  $environment = undef,
  $user        = undef,
  $keyserver   = 'hkp://subkeys.pgp.net'
  ) {

  Exec {
    user        => $user ? { default => $user, undef => 'root' },
    environment => $environment ? { default => $environment, undef => 'HOME=/root' },
    path        => ['/bin', '/usr/bin']
  }

  if $source {

    file { "/var/lib/puppet/var/${name}.gpg":
      ensure => present,
      owner  => $user,
      group  => 'root',
      mode   => '0600',
      source => $source;
    }

    exec { "gpg --import /var/lib/puppet/var/${name}.gpg":
      unless    => "gpg --list-key ${keyid}",
      logoutput => on_failure,
      require   => File["/var/lib/puppet/var/${name}.gpg"];
    }

  } else {

    exec { "gpg --keyserver ${keyserver} --recv-keys ${keyid}":
      unless    => "gpg --list-key ${keyid}",
      logoutput => true;
    }

  }

}
