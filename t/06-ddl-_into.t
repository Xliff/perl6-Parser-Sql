use v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

use lib 't';
use TestRoutines;

plan 556;

my ($s, $d);

# This may have to become it's own separate test.
# <INTO> [
#   <OUTFILE> <text> <load_data_charset>? <field_term>? <line_term>?
#   |
#   <DUMPFILE> <text>
#   |
#   $<sv>=[ <text> || <_ident> ]+ % ','
# ]
($s, $d) = basic-and-mutate("INTO OUTFILE 'sample'", '_into', :rx(/ ('INTO') /));
my $of_test = False;
for ('CHAR SET', 'CHARSET') -> $term-o {
  for <@ident 'text' BINARY DEFAULT> -> $term-mo {
    my $load_charset = "$term-o $term-mo";

    for ('TERMINATED', 'OPTIONALLY ENCLOSED', 'ESCAPED') -> $term-mi {
      my $field_term = "COLUMNS $term-mi BY 'field term'";

      for <TERMINATED STARTING> -> $term-i {
        my ($t, $t0, @extras);
        my $line_term = "LINES $term-i BY 'line term'";
        $t = $t0 = "INTO OUTFILE 'sample' $load_charset $field_term $line_term";

        if $term-mi ~~ /OPTIONALLY/ {
          $t ~~ s/'OPTIONALLY'//;
          basic($t, '_into', :text("'$t' passes <_into> without OPTIONALLY") );
        }

        $t = $t0;
        ($s, my $d) = basic-and-mutate($t, '_into', :rx(/ ('INTO') /) );
        unless $of_test {
          ok $s<OUTFILE>, "Match<OUTFILE> is set.";
          $of_test = True;
        }

        # A lot of tests to do here, so be smart about it.
        my @p = (^3).eager.combinations.grep(*.elems);
        my %extras = (
          0 => [
            { $s<load_data_charset> eq $load_charset },
            "'$t' passes <_into> with Match<load_data_charset> properly set."
          ],

          1 => [
            { $s<field_term> eq $field_term },
            "'$t' passes <_into> with Match<field_term> properly set."
          ],

          2 => [
            { $s<line_term> eq $line_term },
            "'$t' passes <_into> with Match<line_term> properly set."
          ]
        );

        for @p -> $p {
          $t = $t0;
          if 0 == $p.any {
            $t ~~ s/"$load_charset "//;
            %extras<0>:delete;
          }
          if 1 == $p.any {
            $t ~~ s/"$field_term "//;
            %extras<1>:delete;
          }
          if 2 == $p.any {
            $t ~~ s/$line_term//;
            %extras<2>:delete;
          }

          unless +$p == 3 {
            $s = basic($t, '_into') ;
            ok (do $_[0]), $_[1] for %extras.values;
          }
        }
      }
    }
  }
}

($s, $d) = basic-and-mutate("INTO DUMPFILE 'sample'", '_into', :rx(/ ('INTO') /));
# WTF? There shouldn't be a capture! -- But it does return a list. And that's a problem.
ok $s<DUMPFILE>, 'Match<DUMPFILE> is set';

my @ids = ('@ident1', '@ident2', '@@ident3', '"this text string"');
$s = basic("INTO { @ids.join(', ') }", '_into');
ok $s<sv>.elems == 4, "Match<sv> contains 4 elements";
ok $s<sv>[$_] eq @ids[$_], "{ @ord[$_] } element of Match<sv> is '{ @ids[$_] }'"
  for (^@ids.elems);
