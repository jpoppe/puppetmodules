# Class: bash
#
# This class manages the default Bash settings
#
# == Parameters
#
# None
#
# == Actions
#
# Enable /etc/profile.d support
# Clear the screen after logging out
# Install and enable bash completion
# Set the hostname in screen when you log in
#
# == Requirements
#
# - Bash
#
# == Examples
#
#   class { 'bash':; }
#
# == Resources
#
# http://www.gnu.org/software/bash/manual/bashref.html
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class bash () {

  File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  package { 'bash-completion': ensure => present; }

  exec { '/bin/echo -e "\nif [ -d /etc/profile.d ]; then for i in /etc/profile.d/*; do . \$i; done; fi; unset i" >> /etc/profile':
    unless => '/bin/grep -qF "if [ -d /etc/profile.d ]; then for i in /etc/profile.d/*; do . \$i; done; fi; unset i" /etc/profile';
  }

  file {
    '/etc/profile.d':
      ensure => directory,
      mode   => '0755';
    '/etc/profile.d/bash-completion':
      source => 'puppet:///modules/bash/etc/profile.d/bash-completion';
    '/etc/profile.d/screenhostname':
      source => 'puppet:///modules/bash/etc/profile.d/screenhostname';
    '/etc/bash.bash_logout':
      source => 'puppet:///modules/bash/etc/bash.bash_logout';
  }

}
