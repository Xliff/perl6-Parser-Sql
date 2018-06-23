use v6.c;

use Test;
use Parser::SQL::Grammar::Tokens;

my @syms;

# cw: Adapt for testing harness.
for Parser::SQL::Grammar::Tokens::EXPORT::DEFAULT::.keys.sort -> $s {
  next unless $s ~~ /^\&_?<[A..Z0..9]>+/;
  # Operators will be checked in another test.
  next if $s eq <
    &AND2
    &BIT_AND
    &BIT_NOT
    &BIT_OR
    &MINUS
    &MINUS
    &NOT_OP
    &OR2
    &PARAM_MARK
    &PLUS
    &SHIFT_L
    &SHIFT_R
  >.any();

  my $m = $s;
  $m ~~ s/^\&//;
  # If any symbols start with an underscore, this will need to be rethought.
  $m ~~ s/^_//;
  
  ok ( $m ~~ ::($s) ), "<{$s}> Passes";
}
