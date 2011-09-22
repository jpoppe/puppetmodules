# Class: rsync
#
# This class installs rsync
#
# == Actions
#
# Install the rsync package
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'rsync':; }
#
# == Resources
#
# http://www.samba.org/ftp/rsync/rsync.html
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class rsync () {

  package { 'rsync': ensure => installed; }

}
