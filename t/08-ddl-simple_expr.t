use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = 'simple_expr';

sub basic_test($t) {
  basic($t, $rule, :text("'$t' passes <{ $rule }>") );
}

my @lit_ident = <2 ns.table.field table.field field @var>;
my @ops = <+ - / * BINARY>;
@ops.push: '<>';

for @lit_ident.reverse -> $oo {
  for @lit_ident -> $o is copy {
    for @ops -> $i {
      my $ts = "{ $o } {$i} { $oo }";
      basic_test($ts);
    }
  }
}

# <or2> <simple_expr>
basic_test("$_ || 2 + 2") for @lit_ident;

# <simple_ident> <JSON_SEP> <TEXT>
basic_test('"ns.field.name": "VALUE"');
