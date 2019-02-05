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

# Introduced in 04-ddl-easy
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

# Originated in 04-ddl-easy. Used in:
#   07-ddl-create_table_opt
sub test-row_types($prefix = '', :$rule = 'row_types', :$rx, :$eq = False) is export {
  for <DEFAULT FIXED DYNAMIC COMPRESSED REDUNDANT COMPACT> -> $term {
    my $t = "{ $prefix }$term";
    basic-and-mutate($t, $rule, :$rx);
    if $eq {
      my $eq_sym = $eq !~~ Bool ?? $eq !! 'EQ';
      $t ~~ s/$eq_sym//;
      basic($t, $rule);
    }
  }
}

# Originated in 04-ddl-easy. Used in:
#   07-ddl-create_table_opt
sub test-table-list($template = '%s', :$rule = 'table_list') is export {
  my $t = sprintf($template, 'ns1.table1, ns2.table2, .table3');

  my $s0 = basic($t, $rule);
  my $s = $rule eq 'table_list' ?? $s0 !! $s0<table_list>;

  diag $s0;

  ok $s<table_ident>.elems == 3, "There are 3 tables referenced";
  ok
    $s<table_ident>[0] eq 'ns1.table1',
    "First table referenced is 'ns1.table1'";
  ok
    $s<table_ident>[1].trim eq 'ns2.table2',
    "First table referenced is 'ns2.table2'";
  ok
    $s<table_ident>[2].trim eq '.table3',
    "First table referenced is '.table3'";
  $s;
}

# Introduced in 05-ddl-type
sub test($t, :$rule = 'type', :$text, :$ident = True) is export {
  my $i = $t;
  my $s = basic($t, $rule, :$text);
  $i = $ident unless $ident ~~ Bool;
  ok $s<t>.trim eq $i, "Match<t> returns the correct value of '$i'" if $ident;
  $s;
}

sub test-mutate($t, :$rule = 'type', :$rx, :$range = '0'..'9') is export {
  basic-mutate($t, $rule, :$rx, :$range);
}

sub test-and-mutate($t, :$rule = 'type', :$rx, :$range = '0'..'9', :$ident = True)
  is export
{
  my ($s, $sm) = basic-and-mutate($t, $rule, :$rx, :$range);
  my $i = $t;
  $i = $ident unless $ident ~~ Bool;
  ok $s<t>.trim eq $i, "Match<t> returns the correct value of '$i'" if $ident;
  $s;
}

sub test-number-spec($t, $count, :$rule = 'type') is export {
  my $txt = "{ $t }({ $count })";
  my ($s) = test-and-mutate( $txt, :rx(/ ($t) /), :$rule, :ident($t) );
  ok $s<number> eq $count.Str, "Time number specification equals $count";
  $t ~~ s/"($count)"//;
  test($txt, :text("'$t' passes <type> without number spec"), :!ident);
}
