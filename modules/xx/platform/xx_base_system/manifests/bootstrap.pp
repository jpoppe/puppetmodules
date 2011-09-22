# Class: bootstrap
#
# This class manages the boostrap of puppet on a host
#
# == Actions
#
# Check Puppet version and process zones and locations
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'xx_base_system::bootstrap':; }
#
# == Authors
#
# GJ Moed <gmoed@ebay.com>
# Jasper Poppe <jpoppe@ebay.com
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class xx_base_system::bootstrap ( ) {

  if versioncmp($puppetversion, '2.6.8') < 0 {
    fail ("${hostname}: is running puppet ${puppetversion} while we require 2.6.8 or newer!")
  }

  if ($zone == '') or ($location == '') or ($zone == undef) or ($location == undef) {
    fail ("${hostname}: no zone or location fact found, no facts were synced, please check your pluginsync settings in puppet.conf!")
  }
  elsif (($zone == 'none') or ($location == 'none')) and ($fqdn !~ /\.(intern|db|man)\.marktplaats\.nl$/) {
    fail ("${hostname}: no zone or location fact found while most likely we detected new style naming convention!")
  } else {
    notify { "Zone/Location info:": withpath => false, message => "${hostname}: Running with zone '${zone}' & location '${location}' for fqdn '${fqdn}'."; }
  }

}
