use v6.c;

use Test;
use Parser::SQL::Grammar::Tokens;

my @syms;

plan 577;

# cw: Adapt for testing harness.
for Parser::SQL::Grammar::Tokens::EXPORT::DEFAULT::.keys.sort -> $s {
  next unless $s ~~ /^\&_?<[A..Z0..9]>+/;
  # Operators will be checked in another test.
  next if $s eq <
    &SHIFT_L
    &SHIFT_R
  >.any();

  my $token = ::($s);

  die "Regex '{ $s }' does not exist'!" unless $token ~~ Routine;

  my $m;
  if $token.WHY.leading -> $symbol {
    $m = $symbol;
    $m.subst('\\', '', :g);
    $m .= substr(1, * - 1) if $m.starts-with("'") && $m.ends-with("'");
  } else {
    $m = $s;
    $m ~~ s/^\&//;
    # If any symbols start with an underscore, this will need to be rethought.
    $m ~~ s/^_//;
  }


  #diag "$m ( $s )";

  ok ( $m ~~ ::($s) ), "<{$s}> Passes";
}
