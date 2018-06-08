use v6.c;

use Test;
use Parser::SQL::Grammar::Tokens;

for <
  ACCOUNT
  ASCII
  ALWAYS
  BACKUP
  BEGIN
  BYTE
  CACHE
  CHARSET
  CHECKSUM
  CLOSE
  COMMENT
  COMMIT
  CONTAINS
  DEALLOCATE
  DO
  END
  EXECUTE
  FLUSH
  FOLLOWS
  FORMAT
  GROUP_REPLICATION
  HANDLER
  HELP
  HOST
  INSTALL
  LANGUAGE
  NO
  OPEN
  OPTIONS
  OWNER
  PARSER
  PARSE_GCOL_EXPR
  PORT
  PRECEDES
  PREPARE
  REMOVE
  REPAIR
  RESET
  RESTORE
  ROLLBACK
  SAVEPOINT
  SECURITY
  SERVER
  SHUTDOWN
  SIGNED
  SOCKET
  SLAVE
  SONAME
  START
  STOP
  TRUNCATE
  UNICODE
  UNINSTALL
  WRAPPER
  XA
  UPGRADE
> -> $k {
  my $km = $k.substr(0, *-1);
  ok    $k ~~ /<keyword>/, "$k passes <{$k}>";
  nok  $km ~~ /<keyword>/, "'$km' fails <{$k}>";
}
