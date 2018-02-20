use v6.c;

my $file = "DDLGrammar.pm6".IO.open or die "Can't open file!";
my @lines = $file.slurp-rest.lines;
my @output;

for @lines -> $l {
  my $line = $l;
  $line ~~ s:g/\t/  /;
  my regex tokenrule {
    ^ (\s+) 'token' \s+ $<method>=[ <[A..Z_]>+ ] (\s+) ( "\{ '" <[A..Z_]>+  "' \}" )
  }
  if $line ~~ &tokenrule {
    my $om = $/;
    my $sp = $om<method> ~~ / '_' / ?? 25 !! 19;
    if $om<method>.chars + $om[1].chars < $sp {
      $line ~~ s/<tokenrule>/  token { $om<method> }{ ' ' x ($sp - $om[1].chars - $om<method>.chars + 1) }{ $om[2] }/;
    }
    say $line;
  }
}
