use v6.c;

use Parser::SQL::Grammar::Tokens;

my @syms;
my @rules;

Parser::SQL::Grammar::Tokens::EXPORT::DEFAULT::.keys.sort.map({
  if (/^\&_?<[A..Z0..9]>+/) {
    push @syms: $_
  } else {
    push @rules: $_
  }
});

# cw: Adapt for testing harness.
for @syms.sort -> $s {
  my $sym = $s;
  my $m = $sym;
  $m ~~ s/^\&//;
  $m ~~ s/^_//;
  # If any symbols start with an underscore, this will need to be rethought.
  my $pf = $m ~~ ::($sym);
  say "$m - Token <{$sym}> { $pf ?? "Passed" !! "Failed" }";
}
