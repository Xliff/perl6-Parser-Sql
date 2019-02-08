use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = '_key_function_call';

sub basic-test($t, $r = $rule) {
  basic($t, $r, :text("'$t' passes <{ $r }>") );
}

plan 685;

# <CHAR> '(' <expr_list> [ <USING> <charset_name=ident> ]? ')'
basic-test( "CHAR ( 1, 2, 3, 4 USING latin1)" );
basic-test( "CHAR (1, 2, 3, 4) " );
basic-test( "CHAR(1, 2, 3, var)" );
basic-test( "CHAR(1, 2,3, var)"  );
basic-test( "CHAR(1, 2, ns.field, var)" );
basic-test( "CHAR('a', \"a\", 1, 2)" );

my @expr = <2 'aa' "aa" ns.field field @var>;
# [ <DATE> | <DAY> | <HOUR> | <MINUTE> | <MONTH> | <SECOND> |
#   <TIME> | <YEAR>
# ] '(' <expr> ')'
for <DATE DAY HOUR MINUTE MONTH SECOND TIME YEAR> -> $o {
  for @expr -> $i {
    basic-test( "{ $o } ({ $i })" );
    basic-test( "{ $o }({ $i })"  );
  }
}

# [
#   <INSERT> '(' <expr> ',' <expr> ','
#   ||
#   [ <LEFT> | <RIGHT> ] '('
# ] <expr> ',' <expr> ')'
for <INSERT LEFT RIGHT> -> $o {
  for @expr -> $i {
    my $r = $o eq 'INSERT' ?? 4 !! 2;
    my $t = ($i xx $r).join(', ');
    basic-test("{ $o } ({ $t })");
    $t ~~ s:g/\s//;
    basic-test("{ $o }({ $t })");
  }
}

# <TIMESTAMP> '(' [ <expr> ',' ]? <expr> ')'
for 2, 1 -> $m {
  for @expr.pick(*)  {
    my $t = "TIMESTAMP ({ ($_ xx $m).join(', ') })";
    basic-test($t);
    $t ~~ s:g/\s//;
    basic-test($t);
  }
}

# <TRIM> '(' [
#   [
#     <expr>
#     ||
#     [ <LEADING> | <TRAILING> | <BOTH> ] <expr>?
#   ] <FROM>
# ]? <expr> ')'
for @expr.pick(*) -> $e1 {
  for 0, 1 {
    if $_ == 0 {
      my $t = "TRIM ({ $e1 })";
      basic-test($t);
      $t ~~ s:g/'TRIM '/TRIM/;
      basic-test($t);
      next;
    }
    for @expr.pick(*) -> $e2 {
      for 0, 1 {
        if $_ == 0 {
          my $t = "TRIM ({ $e1 } FROM { $e2 })";
          basic-test($t);
          $t ~~ s:g/'TRIM '/TRIM/;
          basic-test($t);
          next;
        }

        for <LEADING TRAILING BOTH> -> $op {
          my $t = "TRIM ( { $op } { $e1 } FROM { $e2 })";
          basic-test($t);
          $t ~~ s:g/'TRIM '/TRIM/;
          basic-test($t);
          $t = "TRIM ( { $op } FROM { $e2 })";
          basic-test($t);
          $t ~~ s:g/'TRIM '/TRIM/;
          basic-test($t);
        }
      }
    }
  }
}

#   <USER> '(' ')'
basic-test('USER ()');
basic-test('USER()');
basic-test('USER( )');

#   <INTERVAL> '(' <expr> ',' <expr> [ ',' <expr_list> ]? ')'

# <CURRENT_USER> [ '(' ')' ]?
basic-test('CURRENT_USER ()');
basic-test('CURRENT_USER()');
basic-test('CURRENT_USER( )');
basic-test('CURRENT_USER');
