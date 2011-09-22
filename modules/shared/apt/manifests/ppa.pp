# Define: ppa
#
# Define a ppa
#
# == Actions
#
# Add a ppa archive
#
# == Parameters
# None
#
# == Examples
#
# apt::ppa {
#   'dnjl/ppa':; 
#   'dnjl/network':; 
#   'dnjl/multimedia':; 
#   'dnjl/virtualization':;
# }
#
# == Resources
#
# http://en.wikipedia.org/wiki/Personal_Package_Archive
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define apt::ppa () {

  $repo       = regsubst($name, '\.', '_', G)
  $repository = regsubst($repo, '/', '-', G)

  exec { $name:
    command => "add-apt-repository ppa:${name}",
    unless  => "test -f /etc/apt/sources.list.d/${repository}-${lsbdistcodename}.list",
    path    => ['/bin', '/usr/bin'],
    notify  => Exec['/usr/bin/apt-get -qq update'];
  }

}
