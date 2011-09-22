# Class: sources
#
# Manages the sources.list file
#
# == Actions
#
#   Fills sources.list based on a template
#
# == Parameters
#
# [*servers*]
#   List of repositories
#
# == Examples
#
#   class { 'apt::sources':;
#     servers => [
#       'deb http://ftp.nl.debian.org/debian/ squeeze main non-free contrib',
#       'deb http://security.debian.org/ squeeze/updates main contrib non-free'
#     ];
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
class apt::sources (
  $servers = []
  ) {

  file { '/etc/apt/sources.list': 
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('apt/etc/apt/sources.list.erb'),
    notify  => Exec['/usr/bin/apt-get -qq update'];
  }

}
