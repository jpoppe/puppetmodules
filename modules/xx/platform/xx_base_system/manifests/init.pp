# Class: xx_base_system
#
# This class manages the SN base system
#
# == Actions
#
# Install and configure the SN base system
#
# == Parameters
#
# [*puppet_environment*]
#   Overrule the standard 'production' environment (during development and
#   testing only please)
#
# [*puppet_keepalive*]
#   Overrule the standard puppet keepalive function (during development and
#   testing only please)
#
# [*puppet_daemon*]
#   Overrule if the puppet daemon should be running (during development and
#   testing only please)
#
# [*sudo_entries*]
#   Override the sudo entries (during development and testing only please)
#
# == Notes
#
# This class should be used for every system.
# Actual config parameters should be maintained in external data (extlookup)
# This class uses staging! This class needs to be at the root of your config!
# Do NOT use it in IF constructs!
# Do NOT call it from other (sub)classes!
#
# == Examples
#
# For configs in production, please only use:
#   class { xx_base_system: }
#
# For configs during development and testing one can use something like:
#   class { xx_base_system:
#     puppet_daemon      => false,
#     puppet_environment => 'gjmoed',
#     puppet_keepalive   => false,
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com
# GJ Moed <gmoed@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class xx_base_system (
  $puppet_environment = 'production',
  $puppet_keepalive   = true,
  $puppet_daemon      = true,
  $postfix_local      = true,
  $sudo_entries       = ['seedbank ALL=(ALL) ALL']
  ) {

  # Define extra stages named bootstrap, pre and post, and define relation to standard main stage
  stage { [bootstrap, pre]: }
  Stage[bootstrap] -> Stage[pre] -> Stage[main]

  # Call predefined classes (see bottom of this manifest) and force execution order by staging
  # Additionally we add tags for easy access to only parts of the config (puppetd --tags=)
  class {
    'xx_base_system::bootstrap':
      stage => bootstrap,
      tag   => 'bootstrap';
    'xx_base_system::pre':
      stage => pre,
      tag   => 'pre';
  }

  class { 'bash':; }

  class { 'inetd':; }

  class { 'locate':; }

  class { 'sysstat':; }

  # Provide external csv data for zone and location dependent values (puppetmaster, ntp servers, etc. etc..)
  $extlookup_datadir = inline_template("<%= Puppet::Node::Environment.current.module('${module_name}').path %>/extdata")

  # In case we see a fqdn.csv, allow an override, otherwize we go with zone-localtion.csv, or location.csv (first with numeric part, otherwize without) and last possibly default.csv
  # For instance, put snmp_syslocation only in location.csv so you only have to enter it once instead of every zone-location combination!
  $extlookup_precedence = ["hosts/%{fqdn}", "%{zone}-%{location}", "%{location}", inline_template("<%= if defined? @location then location.gsub(/[^a-z\s]/, \"\") end%>"), 'default']

  # Ensure repo changes before dealing with any packages, and handle alternatives when done with packages
  Exec['/usr/bin/apt-get -qq update'] -> Package <| ensure == present |> -> Class['alternatives']

  # Install extlookup defined packages
  package { [extlookup('packages')]: ensure => installed; }

  class { 'puppet_client':
    puppetmaster       => extlookup('puppetmaster'),
    puppetca           => extlookup('puppetca'),
    usecacheonfailure  => false,
    pluginsync         => true,
    report             => true,
    keepalive          => $puppet_keepalive,
    maxmempct          => 20,
    puppet_environment => $puppet_environment,
    puppet_daemon      => $puppet_daemon;
  }

  class { 'ntp': servers => extlookup('ntpservers'); }

  class { 'postfix':; }

  if $postfix_local {

    postfix::config {
      'inet_interfaces':
        value =>  extlookup('postfix_interfaces');
      'relayhost':
        value => extlookup('postfix_relay');
    }

  }

  class { 'resolver':
    domainname  => $domain,
    searchpath  => extlookup('searchpath'),
    nameservers => extlookup('nameservers'),
    options     => ['timeout:1'];
  }

  class { 'nscd':; }

  class { 'sudoers':
    sudo_entries => $sudo_entries;
  }

  class { 'snmp':
    com2sec_readonly => extlookup('snmp_com2sec_readonly'),
    syslocation      => extlookup('snmp_syslocation'),
    syscontact       => extlookup('snmp_syscontact');
  }

  class { 'alternatives':; }

  alternatives::update { 'editor':
    target => '/usr/bin/vim.basic';
  }

  # Export our hostname, tagged with current domain and 'motd', for later collection on shellservers for displaying servers reachable from those shellservers
  #@@sharedarray { "${hostname}": tag => ["${domain}", 'motd'] }

  # The following is nice to enforce, but really, it should at least also be done during intial provisioning (FAI for instance) so it does not need a reboot
  file { '/etc/modprobe.d/disable_ipv6.conf':
    content => "blacklist ipv6\nalias net-pf-10 off\nalias ipv6 off\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644';
  }

}
