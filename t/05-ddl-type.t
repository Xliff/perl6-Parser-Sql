use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

plan 642;

sub MAIN {
  my $s;

  #$<t>=[ <INT> || <TINYINT> | <SMALLINT> | <MEDIUMINT> | <BIGINT> | <YEAR> ]
  test-number-spec($_, 1) for <INT TINYINT SMALLINT MEDIUMINT BIGINT YEAR>;

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
          test-number-spec($_, 6);
        }

        when 'VARCHAR' {
          $t ~= '(7)';
          ($s) = test-and-mutate( $t, :rx(/ ($term-o) /), :!ident );
          ok $s<number> eq '7', 'Character number specification equals 7';
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


    if $t ~~ (
      /'NCHAR'/,
      /'NATIONAL CHAR VARYING'/
    ).none {
      ($s) = test-and-mutate( $t, :rx(/ ($term) /), :ident($term) );
    } else {
      $s = test($t, :ident($term) );
    }
    ok $s<number> eq '9', 'Character number specification equals 9';
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
  test-and-mutate($_) for <LONGBLOB MEDIUMBLOB>;
  test('LONG VARBINARY');

  for ('CHAR VARYING', 'VARCHAR') -> $term {
    my $t = "LONG $term BINARY";

    test-and-mutate( $t, :rx(/ ('LONG') /), :ident('LONG') );
    $t ~~ s/ ($term) //;
    test($t, :text("'$t' passes without '$term'"), :!ident);
    $t ~~ s/'BINARY'//;
    test($t, :text("'$t' passes without BINARY"), :!ident);
  }

  test-and-mutate($_) for <SERIAL JSON>;
}
