use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = 'sum_expr';
my @expr = <7 'gg' "gg" ns.field6 field5 @var4>;

sub RZ (@a, @b is copy) {
  while @b < @a {
    @b.append: |@b;
  }
  @a Z @b;
}

sub basic-test($t, $r = $rule) {
  basic($t, $r, :text("'$t' passes <{ $r }>") );
}

plan 782;

# Prerequisite - Test <_gorder_clause>!
for RZ( @expr.pick(5), ('', 'ASC', 'DESC').pick(3) ) -> $p {
  basic-test( "ORDER BY { $p.join(' ') }", '_gorder_clause' );
}
for RZ( @expr.pick(5), ('', 'ASC', 'DESC').pick(3) ) xx 5 -> $p {
  basic-test( "ORDER BY { $p.join(', ') }", '_gorder_clause' );
}


# <GROUP_CONCAT> '('
#   <DISTINCT>?
#   <expr_list>
#   <_gorder_clause>?
#   [ <SEPARATOR> <text> ]?
for ('', 'DISTINCT') -> $d {
  my $t = "GROUP_CONCAT ({ $d } ";
  for @expr.pick xx 5 -> $el {
    for 0, 1 {
      my $oldt = $t;
      $t ~= " { $el.join(', ') } ";
      # <_gorder_clause>?
      # Optimize loop?! "(^5)" instead of "xx 5"
      for RZ( @expr.pick(5), ('', 'ASC', 'DESC').pick(3) ) xx 5 -> $p {
        my $oldt = $t;
        $t ~= "ORDER BY { $p.join(', ') }";
        for 0, 1 {
          # <SEPARATOR> <text>
          basic-test( "{ $t } )" ) unless $_;
          for ("'text'", '"text"') -> $tt {
            my $oldt = $t;
            $t ~= " SEPARATOR { $tt }";
            basic-test( "{ $t } )" );
            $t = $oldt;
          }
        }
        $t = $oldt;
      }
      $t = $oldt;
    }
  }
}

# $<op>=[ <AVG> || <MIN> || <MAX> || <SUM> ] '(' <DISTINCT>? <ALL>? <expr> ')'
for <AVG MIN MAX SUM> -> $f {
  for ('', 'DISTINCT ') -> $d {
    for 0, 1 {
      my $all = '';
      $all = 'ALL ' unless $_;
      for @expr -> $e {
        basic-test( "{ $f } ( { $d }{ $all }{ $e } )" );
      }
    }
  }
}

# $<op>=[
#   <BIT_AND>     |
#   <BIT_OR>      |
#   <BIT_XOR>     |
#   <STD>         |
#   <VARIANCE>    |
#   <STDDEV_SAMP> |
#   <VAR_SAMP>
# ] '(' <ALL>? <expr> ')'
for <BIT_AND BIT_OR BIT_XOR STD VARIANCE STDDEV_SAMP VAR_SAMP> -> $f {
  for 0, 1 {
    my $all = '';
    $all = 'ALL ' unless $_;
    for @expr -> $e {
      my $t = "{ $f } ( { $all }{ $e } )";
      basic-test($t);
      $t = $t.subst(' ( ', '(' );
      $t = $t.subst( ' )', ')' );
      basic-test($t);
    }
  }
}

# <COUNT> '(' [
#  <ALL>? '*'     |
#  <ALL>? <expr>  |
#  <DISTINCT> <expr_list>
# ] ')'
for (
  'ALL *',
  'ALL ' ~ @expr.pick,
  'DISTINCT ' ~ @expr.pick(3).join(', ')
) -> $a {
  my $t = "COUNT ( { $a } )";
  basic-test($t);
  if $t ~~ /'ALL'/ {
    $t ~~ s/'ALL '//;
    basic-test($t);
  }
  $t = $t.subst(' ( ', '(' );
  $t = $t.subst( ' )', ')' );
  $t ~~ s:g/ ', ' /,/;
  basic-test($t);
}
