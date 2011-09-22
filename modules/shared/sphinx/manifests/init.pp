# Class: sphinx
# 
# This class installs Sphinx
#
# == Parameters
#
# None
#
# == Actions
#
# Install Sphinx
#
# == Requirements
#
# An up to date version of Sphinx
#
# == Examples
#
# class { 'sphinx':; }
#
# == Resources
#
# http://sphinx.pocoo.org/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class sphinx () {

  File {
    owner => 'root',
    group => 'root'
  }

  package { 'python-sphinx': ensure => present; }

  file {
    '/usr/local/share/doc':
      ensure => directory,
      mode   => '0755';
    '/usr/local/share/doc/src':
      ensure => directory,
      mode   => '0755';
  }

}
