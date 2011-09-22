# == Define: repo
#
# Defines an apt repository
#
# == Actions
#
# Define an apt repository and optionally fetch or preseed a PGP key
#
# == Parameters:
#
# [*url*]
#   The url pointing to the repository
#
# [*branches*]
#   Which branches to use of the repository
#
# [*keyid*]
#   The keyid that is uses to sign packages in this repository
#
# [*distro*]
#   Distro to add this repository for. Defaults to $lsbdistcodename
#
# == Examples
#
#   apt::repo { 'multimedia':
#     url      => 'http://www.debian-multimedia.org',
#     branches => 'main non-free',
#     keyid    => '1F41B907';
#   }
#
#   apt::repo { 'backports':
#     url      => 'http://backports.debian.org/debian-backports',
#     branches => 'main',
#     distro   => 'squeeze-backports';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define apt::repo (
  $url,
  $branches,
  $keyid    = undef,
  $distro   = $lsbdistcodename
  ) {

  file { $name:
    ensure  => present,
    path    => "/etc/apt/sources.list.d/$name.list",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "deb ${url} ${distro} ${branches}\n",
    notify  => Exec['/usr/bin/apt-get -qq update'];
  }

  if $keyid {

    apt::key { "${name}":
      keyid => $keyid;
    }

  }

}
