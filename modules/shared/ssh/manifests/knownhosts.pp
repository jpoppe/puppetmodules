# Class: knownhosts
#
# This class manages the knownhosts file
#
# == Actions
#
# Purge current knownhosts and manage them through puppet
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'ssh::knownhosts':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class ssh::knownhosts () {

  # Export the SSH public key from a fact variable to the central database
  @@sshkey { 
    "${fqdn}-dsa":
      host_aliases => [$fqdn, $hostname, $ipaddress],
      key          => $sshdsakey,
      type         => dsa;
    "${fqdn}-rsa":
      host_aliases => [$fqdn, $hostname, $ipaddress],
      key          => $sshrsakey,
      type         => rsa;
  
  }

  # Realize the exported resources with this tag
  Sshkey <<| tag == 'knownhosts' |>>

  # Make sure all known_hosts entries are managed by puppet
  resources { 'sshkey': purge => true }

}
