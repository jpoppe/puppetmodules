# Define: repository
#
# This define manages a reprepo repository
#
# == Actions
#
# Install and configure a reprepo repository
#
# == Parameters
#
# [*basedir*]
#   Base directory for the repositories. Defaults to '/opt/repositories'
#
# [*source*]
#   Source directory with the configuration files for a repository
#
# [*type*]
#   Type of the repository, should be 'debian' or 'ubuntu'
#
# == Examples
#
#   reprepro::repository { 'sn-repo':
#     source => 'puppet:///modules/sn_seed/opt/repositories/debian/sn-repo/conf',
#     type   => 'debian';
#   } 
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define reprepro::repository (
  $basedir = '/opt/repositories',
  $source,
  $type
  ) {

  File {
    owner => 'repo',
    group => 'repo'
  }

  if ! defined (File[$basedir]) {

    file { $basedir:
      ensure => directory,
      mode   => '0755';
    }

  }

  if ! defined (File["${basedir}/${type}"]) {

    file { "${basedir}/${type}":
      ensure => directory,
      mode   => '0755';
    }

  }

  file {
    "${basedir}/${type}/${name}":
      ensure  => directory,
      mode    => '0755';
    "${basedir}/${type}/${name}/conf":
      ensure  => directory,
      source  => $source,
      recurse => true,
      purge   => true,
      force   => true;
  }

}
