# This define creates Tomcat instances
#
# == Parameters
#
# [*namevar*]
#   The namevar is used for the name of the instance, can only contain a-z, A-Z, 0-9 and _ characters
#
# [*httpconnector_port*]
#   The http port on wich the tomcat serves the http web server
#
# [*jmx_port*]
#   When undefined the jmx_port value is httpconnector_port + 1
#
# [*shutdown_port*]
#   Port number on which this server waits for a shutdown command, 
#   When undefined the shutdown_port value is httpconnector_port + 2
#
# [*redirect_port*]
#   When undefined the shutdown_port value is httpconnector_port + 3
#
# [*ajp_port*]
#   ajp connector
#   When undefined the ajp_port value is httpconnector_port + 4
#
# [*startmemory*]
#   Defines the minimum memory heap size (-Xms)
# 
# [*maxmemory*]
#   Defines the maximum memory heap size (-Xmx)
# 
# [*maxpermsize*]
#   Permanent generation
#
# [*service_enable*]
#   Defines whether the tomcat service will be started at boot, 
#
# [*service_state*]
#   Defines whether the service should be running or not.
#
# [*maxthreads*]
#   The maximum number of request processing threads
#
# == Notes
#
# If Tomcat is running in a NAT network setup use the following Java parameter:
#  catalina_aopts => "-Djava.rmi.server.hostname=${ipaddress}",
#
# == Examples
#
#  class['java'] -> Class['tomcatmulti']
#  
#  class {
#    'java':;
#    'tomcatmulti':;     
#  }
#
#  tomcatmulti::instance {
#    'frontend':
#      httpconnector_port => '8080',
#      https_proxy        => 'ntd.marktplaats.nl',
#      jmx_port           => '7001',
#      shutdown_port      => '8081',
#      redirect_port      => '8012',
#      ajp_port           => '8002',
#      startmemory        => '512m',
#      maxmemory          => '1g',
#      service_enable     => 'true',
#      user               => 'tomcat',
#      password           => 'tomcat';
#    'backend':
#       httpconnector_port => '8090';
#    'api':
#       httpconnector_port => '8100';
#    '6009':
#       httpconnector_port => '6009';
#  }
#
# == Resources
#
# http://tomcat.apache.org/tomcat-6.0-doc/index.html
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
define tomcatmulti::instance (
  $httpconnector_port  = undef,
  $jmx_port            = undef,
  $shutdown_port       = undef,
  $redirect_port       = undef,
  $ajp_port            = undef,
  $proxy_port          = '443',
  $rmiregistry_port    = undef,
  $rmiserver_port      = undef,
  $startmemory         = '512m',
  $maxmemory           = '1024m',
  $maxpermsize         = '128m',
  $service_state       = 'running',
  $service_enable      = 'true',
  $java_home           = '/usr/lib/jvm/java-6-sun',
  $user                = 'tomcat',
  $password            = 'tomcat123',
  $catalina_aopts      = '',
  $https_proxy         = '',
  $proxy_scheme        = 'https',
  $logfile_days        = '14',
  $shell_commands      = 'ulimit -n 32768',
  $maxthreads          = '200',
  $system_policy       = 'puppet:///modules/tomcatmulti/etc/tomcatmulti/policy.d/01system.policy',
  $debian_policy       = 'puppet:///modules/tomcatmulti/etc/tomcatmulti/policy.d/02debian.policy',
  $catalina_policy     = 'puppet:///modules/tomcatmulti/etc/tomcatmulti/policy.d/03catalina.policy',
  $webapps_policy      = 'puppet:///modules/tomcatmulti/etc/tomcatmulti/policy.d/04webapps.policy',
  $local_policy        = 'puppet:///modules/tomcatmulti/etc/tomcatmulti/policy.d/50local.policy',
  $server_xml          = 'tomcatmulti/etc/tomcatmulti/server.xml.erb',
  $web_xml             = 'tomcatmulti/etc/tomcatmulti/web.xml.erb',
  $tomcat_users_xml    = 'tomcatmulti/etc/tomcatmulti/tomcat-users.xml.erb',
  $logging_properties  = 'tomcatmulti/etc/tomcatmulti/logging.properties.erb',
  $catalina_properties = 'tomcatmulti/etc/tomcatmulti/catalina.properties.erb',
  $context_xml         = 'tomcatmulti/etc/tomcatmulti/context.xml.erb'
  ) {

  File { 
    owner   => 'tomcat6',
    group   => 'tomcat6',
    mode    => '0644',
    before  => Service["tomcat-${name}"],
    notify  => Service["tomcat-${name}"],
    require => [Service['tomcat6'], Package['tomcat6', 'tomcat6-admin', 'tomcat6-extras']]
  }

  if ! ($name =~ /^[-\w]+$/) {
    fail('Instance names can only contain a-z, A-Z, 0-9, - and _ characters')
  }

  if ! ($httpconnector_port) {
    fail('$httpconnector_port is not set (the default for Tomcat is 8080)')
  }

  # dynamic ports
  $jmxport = $jmx_port                 ? { default => $jmx_port, undef => "${httpconnector_port + 1}" }
  $shutdownport = $shutdown_port       ? { default => $shutdown_port, undef => "${httpconnector_port + 2}" }
  $redirectport = $redirect_port       ? { default => $redirect_port, undef => "${httpconnector_port + 3}" }
  $ajpport = $ajp_port                 ? { default => $ajp_port, undef => "${httpconnector_port + 4}" }
  $rmiregistryport = $rmiregistry_port ? { default => $rmiregistry_port, undef => "${httpconnector_port + 5}" }
  $rmiserverport = $rmiserver_port     ? { default => $rmiserver_port, undef => "${httpconnector_port + 6}" }

  # Tomcat init script
  file {
    "/etc/init.d/tomcat-${name}":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('tomcatmulti/etc/init.d/tomcat.erb');
    "/etc/default/tomcatmulti.d/${name}":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      content => template('tomcatmulti/etc/default/tomcatmulti.d/default.erb');
  }

  service { "tomcat-${name}":
    hasstatus  => true,
    hasrestart => true,
    ensure     => $service_state,
    enable     => $service_enable;
  }

  # Log file cleanup
  file { "/etc/cron.daily/tomcat-${name}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('tomcatmulti/etc/cron.daily/tomcat.erb');
  }

  # Tomcat application directory structure
  file {
    "/var/lib/tomcatmulti/${name}":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/common":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/common/classes":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/server":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/server/classes":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/shared":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/shared/classes":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/conf":
      ensure => link,
      target => "/etc/tomcatmulti/${name}";
    "/etc/tomcatmulti/${name}":
      ensure => directory;
    "/etc/tomcatmulti/${name}/conf":
      ensure => directory;
    "/var/log/tomcatmulti/${name}":
      group  => 'adm',
      mode   => '0755',
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/logs":
      ensure => link,
      target => "/var/log/tomcatmulti/${name}";
    "/var/cache/tomcatmulti/${name}":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/work":
      ensure => link,
      target => "/var/cache/tomcatmulti/${name}";
    "/var/lib/tomcatmulti/${name}/webapps":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/webapps/ROOT":
      ensure => directory;
    "/var/lib/tomcatmulti/${name}/webapps/ROOT/META-INF":
      ensure => directory;
 }

  # Tomcat policy configuration
  file {
    "/etc/tomcatmulti/${name}/policy.d":
      owner  => 'root',
      ensure => directory;
    "/etc/tomcatmulti/${name}/policy.d/01system.policy":
      owner  => 'root',
      ensure => present,
      source => $system_policy;
    "/etc/tomcatmulti/${name}/policy.d/02debian.policy":
      owner  => 'root',
      ensure => present,
      source => $debian_policy;
    "/etc/tomcatmulti/${name}/policy.d/03catalina.policy":
      owner  => 'root',
      ensure => present,
      source => $catalina_policy;
    "/etc/tomcatmulti/${name}/policy.d/04webapps.policy":
      owner  => 'root',
      ensure => present,
      source => $webapps_policy;
    "/etc/tomcatmulti/${name}/policy.d/50local.policy":
      owner  => 'root',
      ensure => present,
      source => $local_policy;
  }

  # Tomcat configuration
  file {
    "/etc/tomcatmulti/${name}/Catalina":
      mode   => '0755',
      ensure => directory;
    "/etc/tomcatmulti/${name}/Catalina/localhost":
      mode   => '0755',
      ensure => directory;
    "/etc/tomcatmulti/${name}/Catalina/localhost/manager.xml":
      ensure => present,
      source => 'puppet:///modules/tomcatmulti/etc/tomcatmulti/Catalina/localhost/manager.xml';
    "/etc/tomcatmulti/${name}/Catalina/localhost/host-manager.xml":
      ensure => present,
      source => 'puppet:///modules/tomcatmulti/etc/tomcatmulti/Catalina/localhost/host-manager.xml';
    "/etc/tomcatmulti/${name}/server.xml":
      ensure  => present,
      content => template($server_xml);
    "/etc/tomcatmulti/${name}/web.xml":
      ensure  => present,
      content => template($web_xml);
    "/etc/tomcatmulti/${name}/tomcat-users.xml":
      mode    => '0640',
      ensure  => present,
      content => template($tomcat_users_xml);
    "/etc/tomcatmulti/${name}/logging.properties":
      ensure  => present,
      content => template($logging_properties);
    "/etc/tomcatmulti/${name}/catalina.properties":
      ensure  => present,
      content => template($catalina_properties);
    "/etc/tomcatmulti/${name}/context.xml":
      ensure  => present,
      content => template($context_xml);
    "/etc/tomcatmulti/${name}/jmxremote.password":
      ensure  => present,
      content => template('tomcatmulti/etc/tomcatmulti/jmxremote.password.erb');
    "/etc/tomcatmulti/${name}/jmxremote.access":
      ensure  => present,
      content => template('tomcatmulti/etc/tomcatmulti/jmxremote.access.erb');
  }

}
