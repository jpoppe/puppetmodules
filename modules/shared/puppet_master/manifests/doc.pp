# Class: doc
#
# This class generates puppet documentation, based on modules and manifests
#
# == Actions
#
# Generate puppet documentation
#
# == Parameters
#
# None
#
# == Examples
#
#   class { 'puppet_master::doc':; }
#
# == Resources
#
# https://projects.puppetlabs.com/projects/1/wiki/Puppet_Manifest_Documentation
# http://rdoc.sourceforge.net/doc/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class puppet_master::doc () {

  $command = 'puppet doc --all --mode rdoc --trace --modulepath /etc/puppet/modules/shared:/etc/puppet/modules/sn --manifestdir /etc/puppet/manifests --outputdir /var/lib/puppet/puppetdoc.new; rm -rf /var/lib/puppet/puppetdoc; mv /var/lib/puppet/puppetdoc.new /var/lib/puppet/puppetdoc'

  exec { $command:
    creates   => '/var/lib/puppet/puppetdoc',
    path      => ['/bin', '/usr/bin'],
    logoutput => true;
  }

  cron { 'generate_puppetdoc':
    command => $command,
    user    => 'root',
    minute  => '*/60',
    require => Package['puppet'];
  }

}
