use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = 'simple_expr';

my @i = <+ - / * BINARY>;
@i.push: '<>';
my @o = <2 ns.table.field table.field field @var>;
for @o.reverse -> $oo {
  for @o -> $o is copy {
    for @i -> $i {
      my $ts = "{ $o } {$i} { $oo }";
      diag "Testing '$ts'";
      basic($ts, $rule, :text("'$ts' passes <{ $rule }>") );
    }
  }
}
