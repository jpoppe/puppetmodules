# Class: resolver
#
# This class manages /etc/resolv.conf
#
# == Actions
#
# Configures the /etc/resolv.conf file according to parameters
#
# == Parameters
#
# [*domainname*]
#   The default domain. Defaults to $domain
#
# [*searchpath*]
#   List of domains to search
#
# [*nameservers*]
#   List of nameservers to search
#
# [*options*]
#   List of resolver options
#
# == Actions
#
# Configures the /etc/resolv.conf file according to parameters
#
# == Examples
#
#   class { resolver:
#     domainname  => 'intern.marktplaats.nl',
#     searchpath  => [ 'intern.marktplaats.nl', 'man.marktplaats.nl', 'db.marktplaats.nl', 'marktplaats.nl' ],
#     nameservers => [ '10.32.99.101', '10.32.99.102', '10.32.4.3', '10.32.4.4' ],
#     options     => [ 'timeout:1' ],
#   }
#
# == Authors
#
# GJ Moed <gmoed@ebay.com>
#
class resolver (
  $domainname = $domain,
  $searchpath,
  $nameservers,
  $options
  ) {

  file { '/etc/resolv.conf':
    path    => '/etc/resolv.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('resolver/etc/resolv.conf.erb');
  }

}
