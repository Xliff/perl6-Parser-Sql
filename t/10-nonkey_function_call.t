use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = '_nonkey_function_call';

sub basic-test($t, $r = $rule) {
  basic($t, $r, :text("'$t' passes <{ $r }>") );
}

# :my token _precision { '(' <number> ')'  };

my @expr = <4 'bb' "bb" ns.field field @var>;
my @interval = <DAY HOUR MICROSECOND MINUTE MONTH QUARTER SECOND WEEK YEAR>;

# [ <ADDDATE> | <SUBDATE> ] '(' <expr> ',' [
#   <expr>
#   |
#   <INTERVAL> <expr> <interval>
# ] ')'
for <ADDDATE SUBDATE> -> $o {
  for @expr.pick(*) -> $e1 {
    for 0, 1 {
      for @expr.pick(*) -> $e2 {
        unless $_ {
          my $t = "{ $o } ( { $e1 }, { $e2 } )";
          basic-test($t);
          $t ~~ s:g/\s//;
          basic-test($t);
          next;
        }
        for @interval -> $ii {
          my $t = "{ $o } ( { $e1 }, INTERVAL { $e2 } { $ii } )";
          basic-test($t);
          $t ~~ s:g/', '/,/;
          $t ~~ s:g/'( '/(/;
          $t ~~ s:g/' )'/)/;
          $t ~~ s:g/<$o>\s/$o/;
          basic-test($t);
        }
      }
    }
  }
}

#   [ <DATE_ADD> | <DATE_SUB> ] '(' <expr> ',' <INTERVAL> <expr> <interval> ')'
for <DATE_ADD DATE_SUB> -> $o {
  for @expr.pick(*) -> $e1 {
    for @expr.pick(*) -> $e2 {
      for @interval -> $ii {
        my $t = "{ $o } ( { $e1 }, INTERVAL { $e2 } { $ii} )";
        basic-test($t);
        $t ~~ s:g/', '/,/;
        $t ~~ s:g/'( '/(/;
        $t ~~ s:g/' )'/)/;
        $t ~~ s:g/<$o>\s/$o/;
        basic-test($t);
      }
    }
  }
}

# <EXTRACT> '(' <interval> <FROM> <expr> ')'
for @interval -> $ii {
  for @expr.pick(*) -> $e {
    my $t = "EXTRACT ( { $ii } FROM { $e } )";
    basic-test($t);
    $t ~~ s:g/'( '/(/;
    $t ~~ s:g/' )'/)/;
    $t ~~ s:g/'EXTRACT '/EXTRACT/;
    basic-test($t);
  }
}

#  <GET_FORMAT> '(' [ <DATE> | <TIME> | <TIMESTAMP> | <DATETIME> ]
#  ',' <expr> ')'
for <DATE TIME TIMESTAMP DATETIME> -> $o {
  for @expr -> $e {
    my $t = "GET_FORMAT ( { $o }, $e )";
    basic-test($t);
    $t ~~ s:g/' ( '/(/;
    $t ~~ s:g/' )'/)/;
    $t ~~ s:g/', '/,/;
    basic-test($t);
  }
}

#  [ <TIMESTAMP_ADD> | <TIMESTAMP_DIFF> ] '(' <interval_time_stamp> ','
#  <expr> ',' <expr> ')'
for <TIMESTAMP_ADD TIMESTAMP_DIFF> -> $o {
  for @interval -> $ii {
    for @expr X @expr -> ($e1, $e2) {
      my $t = "{ $o } ( { $ii } , { $e1 } , { $e2 } )";
      basic-test($t);
      $t ~~ s:g/' ( '/(/;
      $t ~~ s:g/' )'/)/;
      $t ~~ s:g/' , '/,/;
      basic-test($t);
    }
  }
}

#  <POSITION> '(' <bit_expr> <IN> <expr> ')'

# <SUBSTRING> '(' <expr> [
#   ',' [ <expr> ',' ]?
#   ||
#   <FROM> [ <expr> <FOR> ]?
# ] <expr> ')'


# [ <CURDATE> | <UTC_DATE> ] [ '(' ')' ]?
for <CURDATE UTC_DATE> -> $i {
  my $t = "{ $i } ( )";
  basic-test($t);
  $t ~~ s:g/\s//;
  basic-test($t);
}

# [ <CURTIME> | <SYSDATE> | <UTC_TIME> | <UTC_TIMESTAMP> ] <_precision>?
for <CURTIME SYSDATE UTC_TIME UTC_TIMESTAMP> -> $i {
  my $t = "{ $i } ( 4 )";
  basic-test($t);
  $t ~~ s:g/\s//;
  basic-test($t);
}

# <NOW> <_precision>?
basic-test("NOW ( 4 )");
basic-test("NOW(4)");
