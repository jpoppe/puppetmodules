# Class: sphinx
# 
# This class generates 
#
# == Parameters
#
# None
#
# == Actions
#
# Manage sphinx about Puppet in restructured text and Sphinx
#
# == Requirements
#
# An up to date version of Sphinx
#
# == Examples
#
# class { 'sphinx':; }
# sphinx::generate
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define sphinx::generate (
  $source_dir
  ) {

  File {
    owner => 'root',
    group => 'root'
  }

  file { "/usr/local/share/doc/${name}":
    ensure => directory,
    mode   => '0755';
  }

  exec { "rest_to_html_$name":
    command     => 'make html',
    logoutput   => true,
    cwd         => $source_dir,
    path        => ['/bin', '/usr/bin'],
    refreshonly => true,
    require     => Package['python-sphinx'];
  }

}
