# Class: devel
#
# This class installs the mysql-devel package
#
# == Actions
#
# Installs the mysql-devel package
#
# == Parameters
# None
#
# == Examples
#
#   mysql::devel { }
#
class mysql::devel () {

  package{ 'mysql-devel': ensure => present; }

}
