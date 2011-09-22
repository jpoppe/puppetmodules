# Class: postfix
#
# This class provides a basic setup of postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# == Actions
#
# Install and configure postfix
#
# == Parameters
#
# [*smtp_listen*]
#   Address on which the smtp service will listen to. Defaults to 127.0.0.1
#
# [*root_mail_recipient*]
#   Who will recieve root's emails. Defaults to "nobody"
#
# == Examples
#
#   class { 'postfix':
#     smtp_listen         => '192.168.0.1'
#     root_mail_recipient => 'joe';
#   }
#
# == Resources
#
# http://www.postfix.org/documentation.html
# http://www.howtoforge.com/postfix_relaying_through_another_mailserver
#
# == Authors
#
# Jasper Poppe <jpoppe@ebay.com>
#
class postfix (
  $smtp_listen         = '127.0.0.1',
  $root_mail_recipient = 'nobody' 
  ) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  package { ['postfix', 'bsd-mailx']: ensure => installed; }

  service { 'postfix':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['postfix'];
  }

  file { '/etc/mailname':
    ensure  => present,
    content => "${fqdn}\n";
  }

  file { '/etc/aliases':
    ensure  => present,
    content => "# aliases\n",
    replace => false,
    notify  => Exec['newaliases'];
  }

  exec { 'newaliases':
    command     => '/usr/bin/newaliases',
    refreshonly => true,
    require     => Package['postfix'],
    subscribe   => File['/etc/aliases'];
  }

  file { 
    '/etc/postfix/master.cf':
      ensure  => present,
      content => template('postfix/etc/postfix/master.cf.erb'),
      notify  => Service['postfix'],
      require => Package['postfix'];
    '/etc/postfix/main.cf':
      ensure  => present,
      source  => 'puppet:///modules/postfix/etc/postfix/main.cf',
      replace => false,
      notify  => Service['postfix'],
      require => Package['postfix'];
  }

  postfix::config {
    'myorigin':
      value => $fqdn;
    'alias_maps':
      value => 'hash:/etc/aliases';
  }

  mailalias { 'root':
    recipient => $root_mail_recipient,
    notify    => Exec['newaliases'];
  }

}
