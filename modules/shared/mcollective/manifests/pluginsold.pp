# Class: pluginsold
#
# This class installs MCollective plugins
#
# == Actions
#
# Install MCollective plugins
#
# == Parameters
#
# None
#
# == Notes
#
# Make sure to keep the documentation up-to-date during development of this
# module.
#
# == Examples
#
#   class { 'mcollective::pluginsold':; }
#
class mcollective::pluginsold {

    include mcollective::plugin::facter
    include mcollective::plugin::service
    include mcollective::plugin::package
    include mcollective::plugin::nrpe
    include mcollective::plugin::iptables
    include mcollective::plugin::puppetd
    include mcollective::plugin::filemgr
    #include mcollective::plugin::process

}
