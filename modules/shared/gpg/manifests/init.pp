# Class: gpg
# 
# This class manages the configuration of GPG keys
#
# == Actions
#
# Manage gpg keys
#
# == Parameters
#
#   None
#
# == Examples
#   
#   class { 'gpg': }
#
# == Resources
#
# http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html
# http://www.gentoo.org/doc/en/gnupg-user.xml
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class gpg () {

  package { 'gnupg-agent': ensure => present; }

}
