use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = '_con_function_call';
my @expr = <5 'ee' "ee" ns.field4 field3 @var2>;

sub basic-test($t, $r = $rule) {
  basic($t, $r, :text("'$t' passes <{ $r }>") );
}

sub loop-test($t is copy) {
  basic-test($t);
  $t ~~ s:g/\s//;
  basic-test($t);
}

plan 1372;

# [
#   <ASCII>       |
#   <CHARSET>     |
#   <COLLATION>   |
#   <MICROSECOND> |
#   <PASSWORD>    |
#   <QUARTER>     |
#   <REVERSE>
# ] '(' <expr> ')'
for @expr -> $e {
  for <ASCII CHARSET COLLATION MICROSECOND PASSWORD QUARTER REVERSE> -> $o {
    my $t = "{ $o } ( { $e } )";
    loop-test($t);
  }
}

# [ <IF> | <REPLACE> ] '('  <expr> ',' <expr> ',' <expr>  ')'
for @expr.pick(5) -> $e1 {
  for @expr.pick(5) -> $e2 {
    for @expr.pick(5) -> $e3 {
      for <IF REPLACE> -> $i {
        my $t = "{ $i } ( { $e1 }, { $e2 }, { $e3 } )";
        loop-test($t);
      }
    }
  }
}

# [ <MOD> | <REPEAT> | <TRUNCATE> ] '(' <expr> ',' <expr> ')'
for @expr.pick(5) -> $e1 {
  for @expr.pick(5) -> $e2 {
    for <MOD REPEAT TRUNCATE> -> $i {
      my $t = "{ $i } ( { $e1 }, { $e2 } )";
      loop-test($t);
    }
  }
}

# <FORMAT>  '(' [ <expr> ',' ]? <expr> ',' <expr> ')'
for @expr.pick(5) -> $e1 {
  my $t0 = "FORMAT ( { $e1 }";
  for @expr.pick(5) -> $e2 {
    for 0, 1 -> $o {
      unless $o {
       loop-test( "{ $t0 }, $e2 )" );
       next;
      }
      for @expr.pick(5) -> $e3 {
        loop-test( "{ $t0 }, $e2, $e3 )" )
      }
    }
  }
}

# <WEEK> '(' [ <expr> ',' ]? <expr> ')'
{
  for @expr.pick(5) -> $e1 {
    my $t0 = "WEEK ( { $e1 }";
    for 0, 1 -> $o {
      unless $o {
        loop-test( "{ $t0 } )" );
        next;
      }
      for @expr.pick(5) -> $e2 {
        loop-test( "{ $t0 }, $e2 )" )
      }
    }
  }
}

#  <COALESCE> '(' <expr_list> ')'
basic-test("COALESCE ({ @expr.pick(5).join(', ') } )");
basic-test("COALESCE({ @expr.pick(5).join(',') })");

# [ <DATABASE> | <ROW_COUNT> ] '(' ')'
basic-test('DATABASE ( )');
basic-test('DATABASE()');
basic-test('ROW_COUNT ( )');
basic-test('ROW_COUNT()');

{
  my $t0;

  sub test_with_ws_levels {
    # <LEVEL> $<ws_list>=[
    #   <__ws_list_item>+ % ','
    #   ||
    #   <number> '-' <number>
    # ]
    my $t = "{ $t0 } LEVEL ";
    for 0, 1 {
      when 0 {
        for <1 10 20> -> $n {
          for <ASC DESC> -> $ad {
            for ('', 'REVERSE') -> $r {
              basic-test("{ $t } { ($n, $ad, $r).join(' ') } )");
            }
          }
        }
      }
      when 1 {
        basic-test("{ $t } 1 - 10 )");
      }
    }
  }

  # <WEIGHT_STRING> '(' <expr> [
  # ...
  for @expr.pick(5) -> $e {
    $t0 = "WEIGHT_STRING ( { $e }";
    for ^3 {
      # ...
      # <__ws_levels>? ')'
      when 0 {
        loop-test("{ $t0 } )");
        test_with_ws_levels;
      }
      # ...
      # ',' <ulong_num> ',' <ulong_num> ',' <ulong_num> ')'
      when 1 {
        loop-test("{ $t0 }, { @valid_ulong_numbers.pick(3).join(', ') } )");
      }
      # ...
      # <AS> [
        # <CHAR> <__ws_nweights> <__ws_levels>?
        # ||
        # <BINARY> <__ws_nweights>
      # ] ')'
      when 2 {
        $t0 = "{ $t0 } AS ";
        for <CHAR BINARY> {
          my $t0-old = $t0;
          $t0 = "{ $t0 } { $_ }( 5 ";
          basic-test( "{ $t0 } ) )" );
          $t0 ~= " )";
          test_with_ws_levels if $_ eq 'CHAR';
          $t0 = $t0-old;
        }
      }
    }
  }
}

# [ <CONTAINS> | <POINT> ] '(' <expr> ',' <expr> ')'
for <CONTAINS POINT> -> $o {
  for @expr.pick(5) X @expr.pick(5) -> ($e1, $e2) {
    loop-test("{ $o } ( { $e1 }, { $e2 } )" );
  }
}

# <GEOMETRYCOLLECTION> '(' <expr_list>? ')'
# [
  # <LINESTRING>      |
  # <MULTILINESTRING> |
  # <MULTIPOINT>      |
  # <MULTIPOLYGON>    |
  # <POLYGON>
# ] '(' <expr_list> ')'
for <
  GEOMETRYCOLLECTION
  LINESTRING
  MULTILINESTRING
  MULTIPOINT
  MULTIPOLYGON
  POLYGON
> -> $o {
  loop-test("{ $o } ( { @expr.pick(5).join(', ') } )" );
}
