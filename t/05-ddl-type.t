use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

plan 573;

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
  my ($s, $sm) = basic-and-mutate($t, 'type', :$rx, :$range);
  my $i = $t;
  $i = $ident unless $ident ~~ Bool;
  ok $s<t>.trim eq $i, "Match<t> returns the correct value of '$i'" if $ident;
  $s;
}

sub test-number-spec($t, $count) {
  my $txt = "{ $t }({ $count })";

  my ($s) = test-and-mutate( $txt, :rx(/ ($t) /), :ident($t) );
  ok $s<num> eq $count.Str, "Time number specification equals $count";
  $t ~~ s/"($count)"//;
  test($txt, :text("'$t' passes <type> without number spec"), :!ident);
}

sub MAIN {
  my $s;

  #$<t>=[ <INT> || <TINYINT> | <SMALLINT> | <MEDIUMINT> | <BIGINT> | <YEAR> ]
  for <INT TINYINT SMALLINT MEDIUMINT BIGINT YEAR> -> $term {
    my $t = "$term (1)";
    ($s) = test-and-mutate( $t, :rx(/ ($term) /), :ident($term) );
    $t ~~ s/' (1)'//;
    test( $t, :text("'$t' passes rule without number spec"), :!ident );
  }

  #$<t>=[ <REAL> | <DOUBLE> <PRECISION>? ]
  test-and-mutate('REAL');
  test('DOUBLE PRECISION');
  test-and-mutate('DOUBLE');

  # $<t>=[ <FLOAT> | <DECIMAL> | <NUMERIC> | <FIXED> ]
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
        when <CHAR TEXT>.any {
          $t ~= "(6)";
          ($s) = test-and-mutate( $t, :rx(/ ($term-o) /), :!ident );
          ok $s<num> eq '6', 'Character number specification equals 6';
          $t ~~ s/'(6)'//;
          test($t, :text("'$t' passes <type> without number spec"), :!ident);
        }

        when 'VARCHAR' {
          $t ~= '(7)';
          ($s) = test-and-mutate( $t, :rx(/ ($term-o) /), :!ident );
          ok $s<num> eq '7', 'Character number specification equals 7';
          $t ~~ s/'VARCHAR'/CHAR VARYING/;
          test($t, :text('CHAR VARYING in place of VARCHAR passes <type>'), :!ident);
          # XXX - Investigate why this does not succeed.
          #test-mutate( $t, :rx(/ ('CHAR VARYING') /) );
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
      ok $s<b> eq $term-i, "Optional binary option '$term-i' detected";
      if $t ~~ /' BINARY'$/ {
        $t ~~ s/' BINARY'$// ;
        test($t, :text("'$t' still passes <type> with optional BINARY token removed"), :!ident);
      }
    }
  }

  for (
    'NATIONAL CHAR VARYING',
    'NATIONAL CHAR',
    'NATIONAL VARCHAR',
    'NCHAR VARCHAR',
    'NCHAR VARYING',
    'NCHAR',
    'NVARCHAR'
  ) -> $term {
    my $t = "$term (9) BINARY";
    my $t0 = $t;

    ($s) = test-and-mutate( $t, :rx(/ ($term) /), :ident($term) );
    ok $s<num> eq '9', 'Character number specification equals 9';
    $t ~~ s/'(9) '//;
    test($t, :text("'$t' passes <type> without number spec"), :!ident);
    $t ~~ s/'BINARY'//;
    test($t, :text("'$t' passes <type> without spec or BINARY"), :!ident);
    ($t = $t0) ~~ s/'(9) '//;
    test($t, :text("'$t' passes <type> with number spec and without BINARY"), :!ident);
  }

  test-and-mutate('DATE');
  test-number-spec($_, 10) for <TIME TIMESTAMP DATETIME>;
  test-and-mutate('TINYBLOB');
  test-number-spec('BLOB', 11);
  test-and-mutate($_) for <
    GEOMETRY
    GEOMETRYCOLLECTION
    LINESTRING
    MULTILINESTRING
    MULTIPOINT
    MULTIPOLYGON
    POINT
    POLYGON
  >;

  # $<t>=[ <MEDIUMBLOB> | <LONGBLOB> ]

}
