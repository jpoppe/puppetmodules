# Class: sks
#
# This class installs and configures the sks gpg keyserver
#
# == Actions
#
# Install and configure sks
#
# == Parameters
#
# [*server_name*]
#   Name for this server, defaults to $fqdn
#
# [*recon_address*]
#   Address on which to bind the recon service. Defaults to '0.0.0.0'
#
# [*recon_port*]
#   Port on which to bind the recon service. Defaults to '11370'
#
# [*hkp_address*]
#   Address on which to bind the hkp service. Defaults to '0.0.0.0'
#
# [*hkp_port*]
#   Port on which to bind the hkp service. Defaults to '11371'
#
# [*pgp_admin*]
#   From address used voor synchronization emails with PKS. Defaults to 'eBay PGP Admin <pgp-admin@ebay.com>'
#
# [*sendmail_cmd*]
#   Sendmail command to use. Defaults to '/usr/lib/sendmail -t -oi'
#
# [*base_dir*]
#   Base directory under which the database will be built. Defaults to '/opt/sks'
#
# == Examples
#
#   class { 'sks':; }
#
# == Resources
#
# https://code.google.com/p/sks-keyserver/
# http://www.keysigning.org/sks/
#
# == Authors
#
# Lex van Roon <lvanroon@ebay.com>
#
class sks (
  $server_name   = $fqdn,
  $server_port   = '11371',
  $recon_address = '0.0.0.0',
  $recon_port    = '11370',
  $hkp_address   = '0.0.0.0',
  $hkp_port      = '11371',
  $pgp_admin     = 'eBay PGP Admin <pgp-admin@ebay.com>',
  $sendmail_cmd  = '/usr/lib/sendmail -t -oi',
  $base_dir      = '/opt/sks'
  ) {

  File {
    ensure  => 'present',
    owner   => 'debian-sks',
    group   => 'debian-sks',
    mode    => '0644',
    notify  => Service['sks'],
    require => Package['sks']
  }

  Package['sks'] -> Service['sks']

  package { 'sks': ensure => 'installed'; }

  file {
    "$base_dir":
      ensure => present;
    '/etc/default/sks':
      source  => "puppet:///modules/sks/etc/default/sks",
      owner   => 'root',
      group   => 'root';
    '/etc/sks/mailsync':
      source  => "puppet:///modules/sks/etc/sks/mailsync",
      owner   => 'root',
      group   => 'root';
    '/etc/sks/sksconf':
      content => template("sks/etc/sks/sksconf.erb"),
      owner   => 'root',
      group   => 'root';
    "$base_dir/www":
      ensure => 'directory',
      owner  => 'root',
      group  => 'root';
    "$base_dir/www/index.html":
      content => template("sks/var/lib/sks/www/index.html.erb"),
      owner   => 'root',
      group   => 'root';
    "$base_dir/www/keys.jpg":
      source => "puppet:///modules/sks/var/lib/sks/www/keys.jpg",
      owner  => 'root',
      group  => 'root';
    '/usr/local/bin/sks_import_dumps.sh':
      content => template('sks/usr/local/bin/sks_import_dumps.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0755';
    '/var/log/sks':
      ensure => 'directory';
  }

  exec { "Fix symlink for $base_dir":
    command => "/bin/rm -rf /var/lib/sks ; /bin/ln -s ${base_dir} /var/lib/sks",
    onlyif  => '/usr/bin/test ! -L /var/lib/sks',
    notify  => Service['sks'];
  } 

  exec { 'Initial import of database dumps':
    command => '/usr/bin/at -f /usr/local/bin/sks_import_dumps.sh now + 15 minutes',
    user    => 'debian-sks',
    onlyif  => "/usr/bin/test ! -f ${base_dir}/dump/sks-dump-0000.pgp",
    require => Package['sks'];
  }

  cron { 'sks_db_update':
    command => '/usr/local/bin/sks_import_dumps.sh',
    user    => 'debian-sks',
    hour    => '5',
    minute  => '14',
    weekday => '2';
  }

  service { 'sks':
    ensure     => 'running',
    hasrestart => 'true',
    require    => [Package['sks'], File ['/etc/default/sks', '/etc/sks/mailsync', '/etc/sks/sksconf']];
  }

}
