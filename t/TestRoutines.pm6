use v6.c;

use Test;

use Parser::SQL::Grammar::Tokens;
use Parser::SQL::Grammar::DDLGrammar;

unit package TestRoutines;

sub basic($t, $rule, :$text) is export {
  my $txt = $text // "'$t' passes <$rule>";
  ok
    (my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($rule) ) ),
    $txt;
  $s;
}

sub basic-mutate($t, $rule, :$rx, :$range = ('0'..'9') ) is export {
  $t ~~ $rx with $rx;
  my $tm := $t.substr-rw($0.from, $0.to - $0.from);
  $tm.substr-rw( (^$tm.chars).pick, 1 ) = $range.pick;
  nok
    (my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ) ),
    "'$t' fails <$rule>";
  $s;
}
