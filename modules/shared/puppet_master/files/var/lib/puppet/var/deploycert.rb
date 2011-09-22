#!/usr/bin/ruby1.8
require 'puppet/ssl/host'
Puppet.settings.parse
Puppet.settings.use :main, :agent, :ssl

Puppet::SSL::Host.ca_location = :remote
Host = Puppet::SSL::Host.new
Host.generate

#!/usr/bin/env ruby
require 'puppet/ssl/host'
Puppet.settings.parse
Puppet.settings.use :main, :agent, :ssl

Puppet::SSL::Host.ca_location = :remote
Host = Puppet::SSL::Host.new

begin
  Host.generate
rescue
  puts "deploycert.rb: failed to generate SSL certificate, please check if the CA in /etc/puppet/puppet.conf is reachable"
end
