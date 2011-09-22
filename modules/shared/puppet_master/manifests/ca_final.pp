# Class: puppet_master::ca_final
#
# This class performs the final steps for a puppet CA
#
# == Actions
#
# Perform the final steps for a puppet CA
#
# == Parameters
#
#   None
#
# == Examples
#
#   class { 'puppet_master::ca_final':; }
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
# == Credits
#
# Roeland van de Pol <rvandepol@ebay.com>
#
class puppet_master::ca_final () {

  # Check if the Puppet Master is also the CA server
  if ($settings::ca) {

    # Check from the Puppet Master if this node is already a CA server
    $self_ca = inline_template('<%= 
      require "socket"
      require "openssl"

      begin
        sslsock = OpenSSL::SSL::SSLSocket.new(TCPSocket.new(fqdn, 8140), OpenSSL::SSL::SSLContext.new()).connect
        sslsock.close
      rescue
        "connection error"
      else
        cert = OpenSSL::X509::Certificate.new(sslsock.peer_cert)
        cert.subject.to_s.split(/=/)[-1] == cert.issuer.to_s.split(/ /)[-1] ? "ca" : "server"
      end
    %>')

    # Remove the SSL certificates if this node is not yet a Puppet CA
    if $self_ca != 'ca' {

      file { '/var/lib/puppet/ssl':
        ensure  => directory,
        recurse => true,
        purge   => true,
        force   => true;
      }

    }

  }

}
