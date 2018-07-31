use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

# <ENGINE> <EQ>? $<o>=[ <text> || <_ident> ]

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

# <UNION> <EQ>? '(' <table_list>? ')'

# <DEFAULT>? <charset> <EQ>? $<o>=[ <text> || <_ident> ]

# <DEFAULT>? <COLLATE> <EQ>? $<o>=[ <text> || <_ident> ]

# <INSERT_METHOD> <EQ>? $<o>=[ <NO> | <FIRST> | <LAST> ]

# <TABLESPACE> <EQ>? <ts_ident=ident>

# <STORAGE> $<o>=[ <DISK> | <MEMORY> ]
