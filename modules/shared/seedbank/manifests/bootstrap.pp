# Define: bootstrap
#
# This define prepares a seedbank bootstrap
#
# == Actions
#
# Prepare a seedbank bootstrap
#
# == Parameters
#
# None
#
# == Examples
#
#   seedbank::bootstrap { 'some_host' }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define seedbank::bootstrap () {

  exec { "/usr/bin/seedbank_setup ${name}":
    creates   => "/var/lib/tftpboot/seedbank/${name}",
    logoutput => on_failure,
    require   => Package['seedbank'];
  }

}
