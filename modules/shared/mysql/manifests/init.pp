# Class: mysql
# 
# This class manages the installation and configuration of mysql
#
# == Parameters
#
# [*client_package*]
#   Client package to use. Can be 'percona' and undef. Defaults to undef
#
# == Actions
#
#   Configure and install mysql
#
# == Examples
#
#   class { 'mysql':; }
#
#   class { 'mysql':
#     client_package => 'percona';
#   }
#
# == Resources
#
# http://dev.mysql.com/doc/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class mysql (
  $client_package = undef
  ) {

  $package = $client_package ? { percona => 'percona-server-client-5.1', default => 'mysql-client-5.1' }

  package { $package: ensure => present; }

}

