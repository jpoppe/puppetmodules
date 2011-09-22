# Class: postfix::hash
#
# Creates postfix hashed "map" files. It will create "${name}", and then
# build "${name}.db" using the "postmap" command. The map file can then be
# referred to using postfix::config.
#
# == Parameters
#
# [*name*]
#   name of the map file.
#
# == Requires
#
# Class["postfix"]
#
# == Examples
#
#   postfix::hash { '/etc/postfix/virtual': }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define postfix::hash () {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  file { $name:
    ensure  => present,
    mode    => '0600',
    require => Package['postfix'];
  }
    
  file { "${name}.db":
    ensure  => present,
    mode    => '0600',
    require => [File[$name], Exec["generate ${name}.db"]];
  }
    
  exec {"generate ${name}.db":
    command     => "postmap ${name}",
    path        => ['/usr/bin', '/usr/sbin'],
    subscribe   => File[$name],
    refreshonly => true,
    require     => Package['postfix'];
  }

}

