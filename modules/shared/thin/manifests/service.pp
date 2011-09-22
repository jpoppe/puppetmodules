# Define: thin::service
#
# This define configures and starts a thin service
#
# == Actions
#
# Configure and start a thin service
#
# == Parameters
#
# [*user*]
#   User to run service as. Defaults to 'www-data'
#
# [*group*]
#   Group to run service as. Defaults to 'www-data'
#
# [*appdir*]
#   Ruby application directory.
#
# [*address*]
#   Address to bind to
#
# [*environment*]
#   Environment to run application in
#
# [*servers*]
#   Number of thin servers to start
#
# [*logfile*]
#   Path to logfile. Defaults to '/var/log/thin/${name}.log' if not defined
#
# [*pidfile*]
#   Path to pidfile. Defaults to '/var/run/thin/${name}.pid' if not defined
#
# == Notes
#
# /var/log/thin and /var/run/thin are only writable by www-data. If you specify
# another user, make sure you point logfile and pidfile to directories that are
# writable by that user.
# 
# == Examples
#
#   thin::service { 'someservice':
#     appdir => '/path/to/some/ruby/app';
#   }
#
# or
#
#   thin::service { 'someservice':
#     user        => 'someuser',
#     group       => 'somegroup',
#     address     => '1.2.3.4',
#     environment => 'development',
#     servers     => '4',
#     logfile     => '/var/log/someservice.log',
#     pidfile     => '/var/run/someservice.pid';
#   }
#
# == Authors
#
# Lex van Roon <lvanroon@ebay.com>
#
define thin::service (
  $user        = 'www-data',
  $group       = 'www-data',
  $appdir,
  $address     = '0.0.0.0',
  $environment = 'production',
  $servers     = '1',
  $logfile     = undef,
  $pidfile     = undef
  ) {

  if $logfile {
    $app_logfile = $logfile
  } else {
    $app_logfile = "/var/log/thin/${name}.log"
  }

  if $pidfile {
    $app_pidfile = $pidfile
  } else {
    $app_pidfile = "/var/run/thin/${name}.log"
  }

  file {
    "/etc/thin/${name}.yaml":
      ensure  => present,
      content => template('thin/etc/thin/service.yaml.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['thin'],
      notify  => Service['thin'];
  }

}
