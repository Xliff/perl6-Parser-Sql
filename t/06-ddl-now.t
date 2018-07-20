use v6.c;

use Parser::SQL::Grammars::DDLGrammar;

for <literal now> {

  # <signed_literal> needs an equivalent.
  
  # <underscore_charset>? <text>
  # |
  # 'N'<text>
  # |
  # <num>
  # |
  # [ <DATE> || <TIME> || <TIMESTAMP> ] <text>
  # |
  # [ <NULL> || <FALSE> || <TRUE> ]
  # |
  # <underscore_charset>? [ <hex_num> || <bin_num> ]
  when 'literal' {
  }

  # <NOW> || <signed_literal>
  when 'now' {
    #my $t = 'NOW';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/\s//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without separating space";

    $t ~~ s/ '(12)' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without separating space";

    $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }
}
