use v6.c;

my @defined_rules;

sub checkfile($filename) {
  my $script = $filename.IO.open.slurp-rest or die "Cannot open file '$filename'";

  for ( $script ~~ m:g/'use' \s+ [ $<word>=\w+ ]+ % '::' ';'/ ) -> $m {
    checkfile($m<word>[*-1].Str ~ ".pm6");
  }

  my @used_rules = |(
    $script ~~ m:g/ <!after [ '#' \s* || '$' ]> '<' ( <[ _ \w ]>+ ) '>'/
  ).map( *[0].Str ).unique.sort;
  @defined_rules.push: |(
    $script ~~ m:g/ [ [ 'my' || 'our' ] \s+ ]? [ 'token' || 'rule' ] \s+ ( \w+ ) \s+ [ 'is export' \s+ ]?  '{'/;
  ).map( *[0].Str ).sort;

  #say "USED\n----\n{ @used_rules.join("\n") }\n";
  #say "DEF\n---\n{ @defined_rules.join("\n") }";

  for @used_rules {
    say "$_ in '$filename' not defined" if @defined_rules.none eq $_;
  }
}

sub MAIN (Str $filename) {
  checkfile($filename);
}
