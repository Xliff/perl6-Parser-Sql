use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

my ($s, $sm);
my $rule = 'create_table_opt';
my $ident = False;

# <ENGINE> <EQ>? $<o>=[ <text> || <_ident> ]
for ("'text string'", '@ident') -> $term {
  my $t = "ENGINE EQ $term";

  ($s, $sm) = test-and-mutate($t, :rx( /'ENGINE'/ ), :$rule, :$ident);
  ok $s<ENGINE> eq 'ENGINE', "Match<ENGINE> is defined and properly set.";
  ok $s<o> eq $term, "Match<text> is set and equals \"$term\"";
  $t ~~ s/'EQ'//;
  test( $t, :$rule, :$ident, :text("'$t' passes <$rule> without EQ") );
}

# $<t_num>=[
#   <MAX_ROWS>        |
#   <MIN_ROWS>        |
#   <AUTO_INC>        |
#   <AVG_ROW_LENGTH>  |
#   <CHECKSUM>        |
#   <TABLE_CHECKSUM>  |
#   <DELAY_KEY_WRITE> |
#   <KEY_BLOCK_SIZE>
# ] <EQ>? <num>
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
  ok $s<num> == 1, 'Match<num> is set and equals 1';
  $t ~~ s/'EQ '//;
  basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
}


# $<t_txt>=[
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
    my $t = "$term-o $term-i";

    ($s, $sm) = test-and-mutate($t, :$rule, :rx(/ ($term-o) /), :$ident);
    ok $s<o> eq $term-i, "Match<o> is set and equals $term-o";
    $t ~~ s/'EQ '//;
    basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
  }
}

# <ROW_FORMAT> <EQ>? <row_types>
test-row_types("ROW_FORMAT EQ ", :$rule, :eq);

# <UNION> <EQ>? '(' <table_list>? ')'
# cw: Reuse table-list test from 04-ddl-easy

# <DEFAULT>? <charset> <EQ>? $<o>=[ <text> || <_ident> ]

# <DEFAULT>? <COLLATE> <EQ>? $<o>=[ <text> || <_ident> ]

# <INSERT_METHOD> <EQ>? $<o>=[ <NO> | <FIRST> | <LAST> ]
for <NO FIRST LAST> -> $term {
  my $t = "INSERT_METHOD EQ $term";

  ($s, $sm) = test-and-mutate($t, :$rule, :rx(/ ('INSERT_METHOD') /), :$ident);
  ok $s<o> eq $term, "Match<o> is set and equals $term";
  $t ~~ s/'EQ '//;
  basic($t, $rule, :text("'$t' passes <$rule> without EQ") );
}

# <TABLESPACE> <EQ>? <ts_ident=ident>

# <STORAGE> $<o>=[ <DISK> | <MEMORY> ]
for <DISK MEMORY> -> $term {
  ($s, $sm) = test-and-mutate( "STORAGE $term", :$rule, :rx(/ ('STORAGE') /), :$ident );
  ok $s<o> eq $term, "Match<o> is set and equals '$term'";
}
