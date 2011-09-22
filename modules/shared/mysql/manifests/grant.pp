# Define: mysql::grant
#
# This define creates a mysql grant
#
# == Actions
#
# Create a mysql grant
#
# == Parameters
#
# [*grant*]
#   Right to grant
#
# [*user*]
#   User to grant rights to
#
# [*host*]
#   Host where the user logs in from
#
# [*database*]
#   Database to perform grant on
#
# [*table*]
#   Table to set grant on
# [*issuer*]
#   Certificate issuer when using SSL. Defaults to undef
#
# [*subject*]
#   Certificate subject when using SSL. Defaults to undef
#
# [*requires*]
#   Create the grant after this resource
#
# == Examples
#
#   mysql::grant { 'somedb_select_sometable':
#     grant    => 'SELECT',
#     database => 'somedb',
#     table    => 'sometable',
#     user     => 'someuser';
#   }
#
#   mysql::grant { 'somedb_all':
#     grant    => 'SELECT',
#     database => 'somedb',
#     table    => '*',
#     user     => 'someuser';
#   }
#
#   mysql::grant { 'somedb_all':
#     grant    => 'SELECT',
#     database => 'somedb',
#     table    => '*',
#     user     => 'someuser';
#     issuer   => '/CN=Some CA',
#     subject  => '/CN=some.host.name';
#   }
#
define mysql::grant (
  $right,
  $user,
  $host      = 'localhost',
  $database,
  $table,
  $issuer    = undef,
  $subject   = undef,
  $requires
  ) {

  if $issuer and $subject {

    exec { "Grant ${right} on ${database}.${table} to ${user}@${host}":
      command   => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"GRANT ${right} ON ${database}.${table} TO ${user}@\'${host}\' REQUIRE ISSUER \'${issuer}\' AND SUBJECT \'${subject}\'\"",
      unless    => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"SHOW GRANTS FOR ${user}@\'${host}\'\" | grep \'${right} ON \' | grep \'${database}\' | grep -q \'${table}\'",
      require   => $requires,
      logoutput => on_failure;
    }

  } else {

    exec { "Grant ${right} on ${database}.${table} to ${user}@${host}":
      command   => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"GRANT ${right} ON ${database}.${table} TO ${user}@\'${host}\'\"",
      unless    => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -B -e \"SHOW GRANTS FOR ${user}@\'${host}\'\" | grep \'${right} ON \' | grep \'${database}\' | grep -q \'${table}\'",
      require   => $requires,
      logoutput => on_failure;
    }

  }

}
