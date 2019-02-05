use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my $rule = '_key_function_call';

sub basic-test($t, $r = $rule) {
  basic($t, $r, :text("'$t' passes <{ $r }>") );
}

# [
#   <CHAR> '(' <expr_list> [ <USING> <charset_name=ident> ]? ')'

basic-test( "CHAR ( 1, 2, 3, 4 USING latin1)" );
basic-test( "CHAR (1, 2, 3, 4) " );
basic-test( "CHAR(1, 2, 3, var)" );
basic-test( "CHAR(1, 2,3, var)"  );

# BOOM! "ns" matches EXPR but does not catch the rest of string. This was
# not apparent in isolated tesdts.
basic-test( "CHAR(1, 2, ns.field, var)" );

#   ||
#   [
#     [ <DATE> | <DAY> | <HOUR> | <MINUTE> | <MONTH> | <SECOND> |
#       <TIME> | <YEAR>
#     ]
#     ||
#     [
#       <INSERT> '(' <expr> ',' <expr> ','
#       ||
#       [ <LEFT> | <RIGHT> ] '('
#     ] <expr> ','
#     ||
#     <TIMESTAMP> '(' [ <expr> ',' ]?
#     ||
#     <TRIM> '(' [
#       <expr>
#       ||
#       [ <LEADING> | <TRAILING> | <BOTH> ] <expr>?
#     ] <FROM>
#   ] <expr>
#   ||
#   <USER> '('
#   ||
#   <INTERVAL> '(' <expr> ',' <expr> [ ',' <expr_list> ]?
# ] ')'
# ||
# <CURRENT_USER> [ '(' ')' ]?
