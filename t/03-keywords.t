use v6.c;

use lib '.';

use Test;
use Parser::SQL::Grammar::Tokens;

use 03-keywords;

for @keywords -> $k {
  my $km = $k.substr(0, *-1);

  ok    $k ~~ /^<keyword>/, "$k passes <keyword>";
  ok    $k eq $/<keyword>{$k}, "$k passes <$k> in <keywords>";
  nok  $km ~~ /^<keyword>/, "$km fails <keyword>";
  ok    $k ~~ /^<keywords_sp>/, "$k passes <keywords_sp>";
  ok    $k eq $/<keywords>, "$k passes <$k> in <keywords_sp>"
  nok  $km ~~ /^<keywords_sp>/, "$k failed <keywords_sp>";
};

for @keywords_sp -> $k {
  my $km = $k.substr(0, *-1);

   ok $k ~~ /^<keywords_sp>/, "$k passes <keywords_sp>";
  nok $k ~~ /^<keywords_sp>/, "$km fails <keywords_sp>";
}
