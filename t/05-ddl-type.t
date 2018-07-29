use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

plan 482;

sub test($t, :$text, :$ident = True) {
  my $i = $t;
  my $s = basic($t, 'type', :$text);
  $i = $ident unless $ident ~~ Bool;
  ok $s<t>.trim eq $i, "Match<t> returns the correct value of '$i'" if $ident;
  $s;
}

sub test-mutate($t, :$rx, :$range = '0'..'9') {
  basic-mutate($t, 'type', :$rx, :$range);
}

sub test-and-mutate($t, :$rx, :$range = '0'..'9', :$ident = True;) {
  my ($s) = basic-and-mutate($t, 'type', :$rx, :$range);
  my $i = $t;
  $i = $ident unless $ident ~~ Bool;
  ok $s<t>.trim eq $i, "Match<t> returns the correct value of '$i'" if $ident;
  $s;
}

my $s;

#$<t>=[ <INT> || <TINYINT> | <SMALLINT> | <MEDIUMINT> | <BIGINT> | <YEAR> ]
for <INT TINYINT SMALLINT MEDIUMINT BIGINT YEAR> -> $term {
  my $t = "$term (1)";
  ($s) = test-and-mutate(  $t, :rx(/ ($term) /), :ident($term) );
  $t ~~ s/' (1)'//;
  test( $t, :text("'$t' passes rule without number spec"), :!ident );
}

#$<t>=[ <REAL> | <DOUBLE> <PRECISION>? ]
test-and-mutate('REAL');
test('DOUBLE PRECISION');
test-and-mutate('DOUBLE');

for <FLOAT DECIMAL NUMERIC FIXED> -> $term-o {
  for ('(2, 3)', '(4)') -> $term-m {
    for <SIGNED UNSIGNED ZEROFILL> -> $term-i {
      my $t = "$term-o $term-m $term-i";
      $s = test( $t, :ident($term-o) );
      if $term-m eq '(2, 3)' {
        ok $s<m> eq '2', 'Match<m> equals 2';
        ok $s<d> eq '3', 'Match<d> equals 3';
      } else {
        ok $s<m> eq '4', 'Match<m> equals 4';;
      }
      ok $s<o>.trim eq $term-i, "Match<o> equals '$term-i'";
      test-mutate( $t, :rx(/ ($term-o) /) );
    }
  }
}

$s = test('FLOAT SIGNED ZEROFILL UNSIGNED', :!ident);
# Action class needs to catch this and throw an exception.
diag $s.gist;
ok $s<o>.elems == 3, 'Match<o> for "FLOAT SIGNED ZEROFILL UNSIGNED" has 3 elements';

for <BIT BINARY> -> $term {
  $s = test-and-mutate( "{ $term }(5)", :rx(/ ($term) /), :!ident );
  ok $s<t> eq $term, 'Match<t> has the correct value';
}

test-and-mutate('BOOL');
test-and-mutate('BOOLEAN');

for <CHAR VARCHAR TINYTEXT TEXT MEDIUMTEXT LONGTEXT ENUM SET> -> $term-o {
  for (
    'ASCII BINARY',
    'BINARY ASCII',
    'UNICODE BINARY',
    'BINARY UNICODE',
    'BYTE',
    'CHARSET "charset" BINARY',
    'BINARY CHAR SET "charset"'
  ) -> $term-i {
    my $t = $term-o;

    given $term-o {
      when <CHAR VARCHAR TEXT>.any {
        $t ~= "(6)";
        ($s) = test-and-mutate( $t, :rx(/ ($term-o) /), :!ident );
        ok $s<num> eq '6', "Character number specification equals 6";
      }

      when /TEXT$/ {
        test-and-mutate($term-o);
      }

      when <ENUM SET>.any {
        $t ~= '("e1", "e2", "e3", "e4")';
        ($s) = test-and-mutate( $t, :rx(/ ($term-o) /), :!ident );
        ok $s<text>.elems == 4, "Match<text> item has 4 elements";
      }
    }

    $t ~= " $term-i";
    $s = test($t, :!ident);
    ok $s<b> eq $term-i, "Optional binary option '$term-o' detected";
    if $t ~~ /' BINARY'$/ {
      $t ~~ s/' BINARY'$// ;
      test($t, :text("'$t' still passes <type> with optional BINARY token removed"), :!ident);
    }
  }
}
