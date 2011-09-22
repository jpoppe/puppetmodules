# Class: puppet_master::server_final
#
# This class performs the final steps for a puppetmaster
#
# == Actions
#
# Perform the final steps for a puppetmaster
#
# == Parameters
#
# [*puppet_ca*]
#   Host that will be the puppet CA server, if this variable is not set
#   the Puppet Master will also be the CA server
#
# [*puppetmaster_conf*]
#   Content for puppetmaster.conf
#
# [*amq_password*]
#   The ActiveMQ password for the Puppet queue, if this password has not been set
#   the Puppet Master will be configured without queueing support
#
# == Examples
#
#   class { 'puppet_master::server_final':
#     puppet_ca         => 'puppetca001.a.c.m.e',
#     puppetmaster_conf => 'some_module/etc/puppet/puppetmaster.conf';
#   }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class puppet_master::server_final (
  $puppet_ca,
  $puppetmaster_conf,
  $amq_password
  ) { 

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  # Check if the (non official Puppet) value is in the Puppet Master configuration
  $ca_self = inline_template('<%= %x{grep ca_self /etc/puppet/puppetmaster.conf}.chomp %>')

  if $puppet_ca and $settings::ca == true {

    # Check from the Puppet Master if Puppet CA is reachable
    $ca_reachable = inline_template('<%= 
      require "socket"
      require "openssl"

      begin
        sslsock = OpenSSL::SSL::SSLSocket.new(TCPSocket.new(puppet_ca, 8140), OpenSSL::SSL::SSLContext.new()).connect
        sslsock.close
      rescue
        "connection error"
      else
        cert = OpenSSL::X509::Certificate.new(sslsock.peer_cert)
        cert.subject.to_s.split(/=/)[-1] == cert.issuer.to_s.split(/ /)[-1] ? "ca" : "server"
      end
    %>')

    # Check if the CA is reachable and if the bootstrap Puppet Master config is there
    if ($ca_reachable == 'ca' and $ca_self) {

      $ca        = 'false'
      $ca_server = $puppet_ca

      file { '/var/lib/puppet/ssl':
        ensure  => directory,
        recurse => true,
        purge   => true,
        force   => true,
        require => File['/etc/puppet/puppetmaster.conf'],
        notify  => Exec['/var/lib/puppet/var/deploycert.rb'];
      }

      # This will generate new certificates during the run, without running the puppet agent
      exec { '/var/lib/puppet/var/deploycert.rb':
        refreshonly => true,
        logoutput   => true,
        notify      => Service['puppetmaster'];
      }

      file { '/etc/puppet/puppetmaster.conf':
        ensure  => present,
        content => template($puppetmaster_conf);
      }

    }

  } else {

    if $puppet_ca {
      $ca        = 'false'
    } else {
      $ca        = 'true'
    }

    $ca_server = $puppet_ca

    file { '/etc/puppet/puppetmaster.conf':
      ensure  => present,
      content => template($puppetmaster_conf);
    }

  }

}
