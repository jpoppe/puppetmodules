# == Define: alternatives::update
#
# Manage Debian/Ubuntu alternatives
#
# == Parameters
#
# [*target*]
#   Where the alternative points to
#
# == Examples
#
#   alternatives::update { 'editor':
#     target => '/usr/bin/vim.basic';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define alternatives::update ($target) {

  exec { "update-alternatives --set ${name} ${target}":
    unless => "test /etc/alternatives/${name} -ef ${target}",
    path   => ['/usr/bin', '/usr/sbin'];
  }

}
