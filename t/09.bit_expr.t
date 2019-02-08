use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = 'bit_expr';

constant RANDOM_PULLS   = 1800;
constant PULL_CHANCE_IN = 10;

sub basic-test($t, $r = $rule) {
  basic($t, $r, :text("'$t' passes <{ $r }>") );
}

plan 30744;

my $pulls-left = RANDOM_PULLS;
my @expr = <1 'aa' "aa" ns.field field @var>;
my @bit_ops = ('|', '&', '*', '/', '%', '^', '<<', '>>', 'DIV', 'MOD', '+', '-');
my @interval_ops = <+ ->;
my @interval = <DAY HOUR MICROSECOND MINUTE MONTH QUARTER SECOND WEEK YEAR>;

for @bit_ops X @bit_ops X @bit_ops -> ($o1, $o2, $o3)  {
  for @expr.pick(2) X @expr.pick(2) X @expr.pick(2) X @expr.pick(2)
    -> ($e1, $e2, $e3, $e4)
  {
    my $t = "{ $e1 } { $o1 } { $e2 } { $o2 } { $e3 } { $o3 } { $e4 }";
    my $s = basic-test($t);
    # Randomly pull out 3000 items for a deep structure test.
    if $pulls-left {
      unless (^PULL_CHANCE_IN).pick {
        ok [&&](
          $s.defined,
          $s<bit_expr>.defined,
          $s<bit_expr><bit_expr>.defined,
          $s<bit_expr><bit_expr><bit_expr>.defined
        ), 'Expression descends 4 levels';
        $pulls-left--;
      }
    }
  }
}

for @interval_ops -> $ii {
  for @interval -> $i {
    for @expr X @expr -> ($e1, $e2) {
      my $t = "{ $e1 } { $ii } INTERVAL { $e2 } { $i }";
      basic-test($t);
      $t ~~ s:g/\s"$ii"\s/$ii/;
      basic-test($t);
    }
  }
}
