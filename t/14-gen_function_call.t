use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;
use keywords;

my $rule = '_gen_function_call';
my @idents = <ns.function function>;
my @expr = <6 'ff' "ff" ns.field5 field4 @var3>;
my @aliases = ('a AS b', 'c d');

sub basic-test($t, $r = $rule) {
  basic($t, $r, :text("'$t' passes <{ $r }>") );
}

sub loop-test($t is copy) {
  basic-test($t);
  $t ~~ s:g/\s//;
  basic-test($t);
}

plan 24;

for 0, 1 {
  when 0 {
    # <ident_sys> '(' <udf_expr>+ % ',' ')'
    my @idents = <var @var @@var @$varvar 'quoted' "double_quoted">;
    @idents.append: @keywords.pick(5);
    for @idents -> $i {
      loop-test("{ $i } ( { @aliases.pick(*).join(', ') } ) ");
    }
  }
  when 1 {
    # <_ident> '.' <_ident> '(' <expr_list>
    loop-test( "ns.function ( { @expr.pick(*).join(', ') } ) )" );
  }
}
