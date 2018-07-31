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

# $<t_txt>=[
#   <PASSWORD>    |
#   <COMMENT>     |
#   <COMPRESSION> |
#   <ENCRYPTION>  |
#   [ <DATA> | <INDEX> ] <DIRECTORY>
# ] <EQ>? <text>

# $<t_o>=[
#   <PACK_KEYS>         |
#   <STATS_AUTO_RECALC> |
#   <STATS_PERSISTENT>  |
#   <STATS_SAMPLE_PAGES>
# ] <EQ>? $<o>=[ <number> || <DEFAULT> ]

# <ROW_FORMAT> <EQ>? <row_types>
test-row_types("ROW_FORMAT EQ ", :$rule, :eq);

# <UNION> <EQ>? '(' <table_list>? ')'
# cw: Reuse table-list test from 04-ddl-easy

# <DEFAULT>? <charset> <EQ>? $<o>=[ <text> || <_ident> ]

# <DEFAULT>? <COLLATE> <EQ>? $<o>=[ <text> || <_ident> ]

# <INSERT_METHOD> <EQ>? $<o>=[ <NO> | <FIRST> | <LAST> ]

# <TABLESPACE> <EQ>? <ts_ident=ident>

# <STORAGE> $<o>=[ <DISK> | <MEMORY> ]
for <DISK MEMORY> -> $term {
  ($s, $sm) = test-and-mutate( "STORAGE $term", :$rule, :rx(/ ('STORAGE') /), :!ident );
  ok $s<o> eq $term, "Match<o> is set and equals '$term'";
}
