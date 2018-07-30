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
    "(Mutated) '$t' fails <$rule>";
  $s;
}

sub basic-and-mutate($t, $rule, :$rx, :$range = '0'..'9' ) is export {
  (
    basic($t, $rule),
    basic-mutate($t, $rule, :$rx, :$range)
  );
}

sub test-limits($rule = '_limits', :$prefix) is export {
  for (
    'MAX_QUERIES_PER_HOUR',
    'MAX_UPDATES_PER_HOUR',
    'MAX_CONNECTIONS_PER_HOUR',
    'MAX_USER_CONNECTIONS'
  ) -> $term {
    my $t0 = "{ $prefix // '' }$term";
    my $t = "$t0 417";

    basic-and-mutate($t, $rule, :rx(/( $( $t0 ) )/) );
  }
}

sub test-literal($rule = 'literal') is export {
  # <underscore_charset>? <text>
  {
    my $t = "_latin1 'text string'";

    basic($t, $rule);
    $t ~~ s/ '_latin1' //;
    basic($t, $rule, :text("'$t' passes <$rule> without charset") );
    # No negative test written - Possible to replace quotes? Revisit.
  }

  # 'N'<text>
  {
    my $t = 'N"text String"';
    basic($t, $rule);
    # No negative test possible without replacing the quotes. Revisit.
  }

  # <num>
  {
    my $t = '22';
    # 'x' is not allowed in the range due to interpretation as
    # a hexidecimal literal.
    basic-and-mutate( $t, $rule, :range('a'..'w') );
  }

  # [ <DATE> | <TIME>  | <TIMESTAMP> ] <text>
  for <DATE TIME TIMESTAMP> -> $term {
    my $t = "$term 'date string'";
    my $s = basic($t, $rule);
    $s = $rule eq 'literal' ?? $s !! $s<literal>;

    ok $s<text> eq "'date string'", 'Match<text> matches "date string"';
    basic-mutate( $t, $rule, :rx(/( $( $term ) )/) );
  }

  # [ <NULL> | <FALSE> | <TRUE> ]
  for <NULL FALSE TRUE> -> $term {
    my $t = $term;

    basic($t, $rule);
    basic-mutate($t, $rule);
  }

  # <underscore_charset>? [ <hex_num> || <bin_num> ]
  for <0xdeadbeef 0b10010101> -> $term {
    my $t = "_latin1 $term";

    basic($t, $rule);
    $t ~~ s/ '_latin1' //;
    basic($t, $rule, :text("'$t' passes <$rule> without charset") );
    basic-mutate($t, $rule, :range('g'..'w') );;
  }
}
