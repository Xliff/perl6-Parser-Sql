use v6.c;

my $script = "DDLGrammar.pm6".IO.open.slurp-rest;

my @used_rules = $script ~~ m:g/ <!after '#' \s*> '<' ( <[ _ \w ]>+ ) '>'/;
my @defined_rules = $script ~~ m:g/ [ 'token' || 'rule' ] \s+ ( \w+ ) \s+ '{'/;

@used_rules = @used_rules.map( *[0].Str ).unique.sort;
@defined_rules = @defined_rules.map( *[0].Str ).sort;

#say "USED\n----\n{ @used_rules.join("\n") }\n";
#say "DEF\n---\n{ @defined_rules.join("\n") }";

for @used_rules {
  say "$_ not defined" if @defined_rules.none eq $_;
}
