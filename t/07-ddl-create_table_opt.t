use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

plan 226;

my ($s, $sm);
my $rule = 'create_table_opt';
my $ident = False;

# $<t_ti>=[
#   <ENGINE>
#   ||
#   <DEFAULT>? [ <charset> || <COLLATE> ]
# ] <EQ>? $<o>=[ <text> || <_ident> ]
for ('ENGINE', 'CHAR SET', 'CHARSET', 'COLLATE') -> $term-o {
  for ("'text string'", '@ident') -> $term-i {
    my $to = $term-o;
    $to = "DEFAULT $to" unless $term-o eq 'ENGINE';
    my $t = "$to EQ $term-i";

    ($s, $sm) = test-and-mutate($t, :rx( /($term-o)/ ), :$rule, :$ident);
    ok $s<t_ti>.trim eq $to, "Match<t_ti> is defined and properly set to '$to'";
    ok $s<o> eq $term-i, "Match<text> is set and equals \"$term-i\"";
    unless $term-o eq 'ENGINE' {
      $t ~~ s/'DEFAULT '//;
      $s = basic($t, $rule, :text("'$t' matches <$rule> without DEFAULT") );
      ok $s<t_ti>.trim eq $term-o, "Match<t_ti> is defined and properly set to '$term-o'";
    }
    $t ~~ s/'EQ'//;
    test( $t, :$rule, :$ident, :text("'$t' passes <$rule> without EQ") );
  }
}

# $<t_number>=[
#   <MAX_ROWS>        |
#   <MIN_ROWS>        |
#   <AUTO_INC>        |
#   <AVG_ROW_LENGTH>  |
#   <CHECKSUM>        |
#   <TABLE_CHECKSUM>  |
#   <DELAY_KEY_WRITE> |
#   <KEY_BLOCK_SIZE>
# ] <EQ>? <number>
for <
  MAX_ROWS
  MIN_ROWS
  AUTO_INC
  AVG_ROW_LENGTH
  CHECKSUM
  TABLE_CHECKSUM
  DELAY_KEY_WRITE
  KEY_BLOCK_SIZE
> -> $term {
  my $t = "$term EQ 1";

  ($s, $sm) = test-and-mutate($t, :$rule, :rx(/ ($term) /), :$ident);
  ok $s<t_number>.trim eq $term, 'Match<t_number> is defined and properly set';
  ok $s<number> == 1, 'Match<num> is set and equals 1';
  $t ~~ s/'EQ '//;
  basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
}

# $<t_text>=[
#   <PASSWORD>    |
#   <COMMENT>     |
#   <COMPRESSION> |
#   <ENCRYPTION>  |
#   [ <DATA> | <INDEX> ] <DIRECTORY>
# ] <EQ>? <text>
for <
  PASSWORD
  COMMENT
  COMPRESSION
  ENCRYPTION
  DATA
  INDEX
> -> $term0 {
  my $term = $term0;
  $term ~= ' DIRECTORY' if $term0 eq <DATA INDEX>.any;
  my $t = "$term EQ 'just another perl hacker'";

  ($s, $sm) = test-and-mutate($t, :$rule, :rx(/ ($term) /), :$ident);
  ok $s<t_text>.trim eq $term, 'Match<t_text> is defined and properly set.';
  ok
    $s<text> eq "'just another perl hacker'",
    'Match<text> is set and equals \'just another perl hacker\'';
  $t ~~ s/'EQ '//;
  basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
}

# $<t_o>=[
#   <PACK_KEYS>         |
#   <STATS_AUTO_RECALC> |
#   <STATS_PERSISTENT>  |
#   <STATS_SAMPLE_PAGES>
# ] <EQ>? $<o>=[ <number> || <DEFAULT> ]
for <
  PACK_KEYS
  STATS_AUTO_RECALC
  STATS_PERSISTENT
  STATS_SAMPLE_PAGES
> -> $term-o {
  for ('2', 'DEFAULT') -> $term-i {
    my $t = "$term-o EQ $term-i";

    ($s, $sm) = test-and-mutate($t, :$rule, :rx(/ ($term-o) /), :$ident);
    ok $s<t_o>.trim eq $term-o, 'Match<t_o> is defined and properly set';
    ok $s<o> eq $term-i, "Match<o> is set and equals $term-i";
    $t ~~ s/'EQ '//;
    basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
  }
}

# <ROW_FORMAT> <EQ>? <row_types>
test-row_types("ROW_FORMAT EQ ", :$rule, :eq);

# <UNION> <EQ>? '(' <table_list>? ')'
test-table_list('UNION EQ (%s)', :$rule);
test-table_list('UNION (%s)', :$rule);
basic-and-mutate('UNION()', $rule, :rx(/ ('UNION') /) );

# <INSERT_METHOD> <EQ>? $<o>=[ <NO> | <FIRST> | <LAST> ]
for <NO FIRST LAST> -> $term {
  my $t = "INSERT_METHOD EQ $term";

  ($s, $sm) = test-and-mutate($t, :$rule, :rx(/ ('INSERT_METHOD') /), :$ident);
  ok $s<o> eq $term, "Match<o> is set and equals $term";
  $t ~~ s/'EQ '//;
  basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
}

# <TABLESPACE> <EQ>? <ts_ident=ident>
for <tablespace @a_table_space_name 'quoted_name' "double_quoted_name"> -> $term {
  my $t = "TABLESPACE EQ $term";

  ($s, $sm) = test-and-mutate($t, :$rule, :rx(/ ('TABLESPACE') /), :$ident);
  ok $s<ts_ident> eq $term, "Match<ts_ident> is set and equals '$term'";
  $t ~~ s/'EQ '//;
  basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
}

# <STORAGE> $<o>=[ <DISK> | <MEMORY> ]
for <DISK MEMORY> -> $term {
  ($s, $sm) = test-and-mutate( "STORAGE $term", :$rule, :rx(/ ('STORAGE') /), :$ident );
  ok $s<o> eq $term, "Match<o> is set and equals '$term'";
}
