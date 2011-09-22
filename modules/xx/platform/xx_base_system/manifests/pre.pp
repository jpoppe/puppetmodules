# Class: pre
#
# This class provides the pre stage for xx_base_system
#
# == Actions
#
# Sets the extlookup datadir based on the module name, configures apt
# repositories and ssh
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'xx_base_system::pre':; }
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
class xx_base_system::pre () {

  $extlookup_datadir    = inline_template("<%= Puppet::Node::Environment.current.module('${module_name}').path %>/extdata")
  $extlookup_precedence = ["hosts/%{fqdn}", "%{zone}-%{location}", "%{location}", inline_template("<%= if defined? @location then location.gsub(/[^a-z\s]/, \"\") end%>"), 'default']

  #File['/var/lib/puppet/var/private.gpg'] -> Class['apt::sources']

  class {
    'apt':;
    'apt::sources':
      servers => extlookup('aptrepos');
  }

  #apt::key { 'private':
  #  source => "puppet:///modules/${module_name}/repository.gpg",
  #  keyid  => '123456';
  #}

  class { 'ssh':; }

  # Export our keys for collection on other hosts within same domain/cluster
  @@sshkey {
    "${fqdn}-dsa":
      host_aliases => [$fqdn, $hostname, $ipaddress],
      key          => $sshdsakey,
      type         => dsa,
      tag          => $domain;
    "${fqdn}-rsa":
      host_aliases => [$fqdn, $hostname, $ipaddress],
      key          => $sshrsakey,
      type         => rsa,
      tag          => $domain;
  }

  # Only collect keys for knownhosts, for hosts we can actually reach (hence, usually same domain only)
  # Force relation on openssh-client so /etc/ssh exists before dealing with ssh_known_hosts
  Package['openssh-client'] -> Sshkey <<| tag == $domain |>>

  # Purge any ssh key we do not know about (unmanaged keys)
  resources { 'sshkey': purge => true }

  # default users
  User<| title == 'root' |> { password => extlookup('rootpw') }

}
