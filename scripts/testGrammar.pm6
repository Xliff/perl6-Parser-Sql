use v6.c;

my @defined_rules;
my %files_started;
my %sug_tokens;

sub checkfile($filename) {
  return if %files_started{$filename};
  say "Checking '$filename'...";
  %files_started{$filename}++;

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
    if @defined_rules.none eq $_ {
      when /^ <[A..Z_]>+ $/ {
        %sug_tokens{ /_/ ?? 'second' !! 'first' }.push: $_;
      }

      default {
        say "$_ in '$filename' not defined";
      }
    }
  }
  say "Done checking '$filename'";
}

sub MAIN (Str $filename) {
  checkfile($filename);

  if %sug_tokens {
    say "\nSUGGESTED TOKENS\n----------------\n";
    sub suggest_token($sp, $k) {
      my $td = "  our token {$k} is export";
      say "{ $td } { ' ' x $sp - $td.chars }\{ '$k' \}";
    }

    for @( %sug_tokens<first> ) -> $st {
      suggest_token(40, $st);
    }
    for @( %sug_tokens<second> ) -> $st {
      FIRST { say ''; }
      suggest_token(49, $st);
    }
  }
}
