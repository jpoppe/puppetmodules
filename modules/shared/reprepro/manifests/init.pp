# Class: reprepro
# 
# This class installs the reprepro package and manages repository configurations
#
# == Actions
#
# Install reprepro
#
# == Parameters
#
# [*password*]
#   password for the reprepro user
#
# == Notes
#
# gpg --keyserver subkeys.pgp.net --recv F1D53D8C4F368D5D
# gpg --export --armor F1D53D8C4F368D5D | apt-key add -
#
# Alternative keyserver: wwwkeys.eu.pgp.net  
#
# == Examples
#
#   class { 'reprepo':; }
#
#   reprepro::repository { 'sn-repo':
#     source => 'puppet:///modules/sn_seed/opt/repositories/debian/sn-repo/conf',
#     type   => 'debian';
#   } 
#
# == Resources
#
# http://mirrorer.alioth.debian.org/
# https://91.211.73.63/dokuwiki/doku.php?id=guides:debs:reprepro
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class reprepro (
  $password = '$6$ttKzNm45$R78kZ1/WCOrH/N.AG83e.hatIiZOfKwnsq6CSiLdxZ/72B3rWO2sXXGrvWgf2Gmhns4OtrMpo8lo.d76pSWNx0'
  ) {

  File {
    owner => 'root',
    group => 'root'
  }

  package { 'reprepro': ensure => present; }

  user { 'repo':
    ensure     => present,
    managehome => true,
    uid        => '201',
    gid        => '201',
    comment    => 'reprepro user',
    home       => '/home/repo',
    password   => $password,
    shell      => '/bin/bash'
  }

  group { 'repo':
    ensure => present,
    gid    => '201';
  }

  file { '/usr/local/bin/rep.py':
    source => "puppet:///modules/${module_name}/usr/local/bin/rep.py",
    mode   => '0755';
  }

}
