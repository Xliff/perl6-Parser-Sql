use v6.c;

use Test;

use Parser::SQL::Grammar::Tokens;
use Parser::SQL::Grammar::DDLGrammar;

unit package TestRoutines;

sub basic($t, $rule, :$text, :$fail) is export {
  my $txt = $text // ($fail ?? "'$t' fails <$rule>" !! "'$t' passes <$rule>");
  my $s;

  if $fail // False {
    nok
      ($s = Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($rule) ) ),
      $txt;
  } else {
    ok
      ($s = Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($rule) ) ),
      $txt;
  }
  $s;
}

sub basic-mutate($t0, $rule, :$rx, :$range = ('0'..'9') ) is export {
  my $t = $t0;
  my $tm;
  with $rx {
    $t ~~ $rx with $rx;
    $tm := $t.substr-rw($0.from, $0.to - $0.from);
  } else {
    $tm := $t;
  }
  $tm.substr-rw( (^$tm.chars).pick, 1 ) = ($range).pick;
  nok
    (my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ) ),
    "Mutated '$t' fails <$rule>";
  $s;
}
