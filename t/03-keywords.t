use v6.c;

use lib 't';

use Test;
use Parser::SQL::Grammar::Tokens;

use keywords;

plan 810;

for @keywords -> $k {
  (my $kw = $k) ~~ s/^_//;
  my $bw = ('a'..'z').pick ~ $kw;

  ok   $kw ~~ /^<keyword>$/, "$kw passes <keyword>";
  ok   $kw eq $/<keyword>{$k}, "$kw passes <$kw> in <keywords>";
  nok  $bw ~~ /^<keyword>$/, "$bw fails <keyword>";
  #ok    $k ~~ /^<keyword_sp>/, "$k passes <keywords_sp>";
  #ok    $k eq $/<keyword_sp><keyword>, "$k passes <$k> in <keywords_sp>";
};

for @keywords_sp -> $k {
  (my $kw = $k) ~~ s/^_//;
  my $bw = ('a'..'z').pick ~ $kw;

   ok $kw ~~ /^<keyword_sp>$/, "$kw passes <keywords_sp>";
  nok $bw ~~ /^<keyword_sp>$/, "$bw fails <keywords_sp>";
}
