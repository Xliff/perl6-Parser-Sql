use v6.c;

use Test;

use Parser::SQL::Grammar::Tokens;
use Parser::SQL::Grammar::DDLGrammar;

unit package TestRoutines;

our @ord is export = <
  First Second Third Fourth Fifth Sixth Seventh Eighth Ninth Tenth
>;

sub basic($t, $rule, :$text, :$fail = False) is export {
  my $txt = $text // ($fail ?? "'$t' fails <$rule>" !! "'$t' passes <$rule>");
  my $s;

  if $fail {
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

sub basic-mutate($t0, $rule, :$rx, :$text, :$range = '0'..'9' ) is export {
  my $t = $t0;
  my $txt = $text // "Mutated '$t' fails <$rule>";
  my $tm;

  with $rx {
    my $r = $t ~~ $rx;
    $tm := $t.substr-rw($r.from, $r.to - $r.from);
  } else {
    $tm := $t;
  }
  $tm.substr-rw( (^$tm.chars).pick, 1 ) = ($range).pick;
  nok
    (my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ) ),
    $txt;
  $s;
}

sub basic-and-mutate($t, $rule, :$rx, :$range = '0'..'9' ) is export {
  basic($t, $rule);
  basic-mutate($t, $rule, :$rx, :$range);
}

sub test-limits($rule = '_limits', :$prefix) is export {
  for (
    'MAX_QUERIES_PER_HOUR',
    'MAX_UPDATES_PER_HOUR',
    'MAX_CONNECTIONS_PER_HOUR',
    'MAX_USER_CONNECTIONS'
  ) -> $term {
    my $t0 = "{ $prefix // '' }$term";
    my $t = "$t0 17";

    basic($t, $rule);
    basic-mutate($t, $rule, :rx(/( $( $t0 ) )/) );
  }
}
