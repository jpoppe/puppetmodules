# Class: java
# 
# This module installs Java
#
# == Actions
#
# Install Java runtime, Java SDK and Jmxterm (which actually should be
# packaged!)
#
# == Parameters
#
# [*jre*]
#   If true, install Java JRE. Defaults to true
#
# [*jdk*]
#   If true, install Java SDK. Defaults to false
#
# [*preferred*]
#   Path to the java binary used for alternatives
#
# == Examples
#
#  class { 'java':; }
#
# == Resources
#
# http://download.oracle.com/javase/6/docs/
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class java (
  $jre       = true,
  $jdk       = false,
  $preferred = '/usr/lib/jvm/java-6-sun/jre/bin/java'
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { ['openjdk-6-jre-headless', 'openjdk-6-jre-lib']: ensure => absent; }

  if $jre {

    file { '/var/cache/debconf/sun-java6-jre.seed':
      source => 'puppet:///modules/java/var/cache/debconf/sun-java6-jre.seed',
      ensure => present;
    }

    package { 'sun-java6-jre':
      ensure       => installed,
      responsefile => '/var/cache/debconf/sun-java6-jre.seed',
      require      => File ['/var/cache/debconf/sun-java6-jre.seed'],
      before       => Exec["update-alternatives --set java ${preferred}"];
    }

  }

  if $jdk {

    file { '/var/cache/debconf/sun-java6-jdk.seed':
      source => 'puppet:///modules/java/var/cache/debconf/sun-java6-jdk.seed',
      ensure => present;
    }

    package { 'sun-java6-jdk':
      ensure       => installed,
      responsefile => "/var/cache/debconf/sun-java6-jdk.seed",
      require      => File [ "/var/cache/debconf/sun-java6-jdk.seed" ],
      before       => Exec[ "update-alternatives --set java ${preferred}" ];
    }

  }

  exec { "update-alternatives --set java ${preferred}":
    unless => "test /etc/alternatives/java -ef ${preferred}",
    path   => ['/usr/bin', '/usr/sbin'];
  }

}
