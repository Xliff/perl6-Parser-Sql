use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

# This may have to become it's own separate test.
# <INTO> [
#   <OUTFILE> <text> <load_data_charset>? <field_term>? <line_term>?
#   |
#   <DUMPFILE> <text>
#   |
#   <__select_var_ident>+ % ','
# ]
for ('CHAR SET', 'CHARSET') -> $term-o {
  for <@ident 'text' BINARY, DEFAULT> -> $term-m {
    for ('TERMINATED', 'OPTIONALLY ENCLOSED', 'ESCAPED') -> $term-i {
      my $t0 = "OUTFILE 'sample' $term-o charset? $term-m COLUMNS $term-i BY 'text string'";

      # WORK HERE.
    }
  }
}
