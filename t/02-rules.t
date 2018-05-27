use v6.c;

use Test;
use Parser::SQL::Grammar::Tokens;

my @syms;

# cw: Adapt for testing harness.
for Parser::SQL::Grammar::Tokens::EXPORT::DEFAULT::.keys.sort -> $s {
  next unless $s ~~ ! /^\&_?<[A..Z0..9]>+/;

  diag $s;

  given (S/^\&// given $s) {
    when 'and' {
      ok  '&&' ~~ /<and>/, '&& passes <and>';
      nok '&+' ~~ /<and>/, '&+ FAILS <and>';
    }

    when 'bin_num' {
      ok "0b00110101" ~~ /<bin_num>/, "binary literal 0b00110101 passes";
      ok "0B10110" ~~ /<bin_num>/, "binary literal 0B10110 passes";
      my $qb = sprintf "0b\'%s\'", 101;
      ok $qb ~~ /<bin_num>/, "binary literal $qb passes";
      $qb = sprintf "0B\'%s\'", 111;
      ok $qb ~~ /<bin_num>/, "binary literal $qb passes";
      nok "11011" ~~ /<bin_num>/, "Literal '11011' fails";
      nok "10210" ~~ /<bin_num>/, "Literal '10210' fails";
    }

    when 'bit_ops' {
      my @bo = <| & * / % ^ DIV MOD>;
      @bo.push: '<<', '>>';
      for @bo -> $o {
       ok  $o ~~ /<bit_ops>/, "{$o} passes <bit_ops>";
       my $fo = $o ~ ']';
       nok '++' ~~ /<bit_ops>/, "{$fo} FAILS <bit_ops>";
     }
    }

    when 'comp_ops' {
      my @co = <EQ GE GT LE LT NE>;
      @co.push: '=', '>=', '>', '<=', '<', '<>';
      for @co -> $o {
        ok $o ~~ /<comp_ops>/, "{$o} passes <comp_ops>";
      }
    }

    when 'field_ident' {
      ok "table.field" ~~ /<field_ident>/, "table.field passes <field_ident>";
      ok "field" ~~ /<field_ident>/, "field passes <field_ident>";
      ok ".field" ~~ /<field_ident>/, ".field passes <field_ident>";

      ok
        "namespace.table.field" ~~ /<field_ident>/,
        "namespace.table.field passes <field_ident>";

      # cw: These possibilities might fail in the greater grammar, but not in
      # isolation. Can leave for later.
      #nok
      #  "table:field" ~~ /<field_ident>/,
      #  "table:field FAILS <field_ident>";
      #my $m = "table:field" ~~ /<field_ident>/;
      #nok
      #  "namespace:table:field" ~~ /<field_ident>/,
      #  "namespace:table:field fails <field_ident>";
    }

    when 'not' {
      ok  '<>' ~~ /<not>/, '<> passes <not>';
      nok '><' ~~ /<not>/, '>< FAILS <not>';
    }

    when 'or' {
      ok  '||' ~~ /<or>/, '|| passes <or>';
      nok '|' ~~ /<or>/,  '| FAILS <or>';
    }

    when 'plus_minus' {
      ok  '+' ~~ /<plus_minus>/, '+ passes <plus_minus>';
      ok  '-' ~~ /<plus_minus>/, '- passes <plus_minus>';
      nok '*' ~~ /<plus_minus>/, '* FAILS <plus_minus>';
    }

    when '_given_id' {
    }

    when 'all_or_any' {
      ok 'ALL' ~~ ::("&{$_}"), "ALL passes &$_";
      ok 'ANY' ~~ ::("&{$_}"), "ANY passes &$_";
    }

    when 'interval_time_stamp' {
      for <
        DAY
        HOUR
        MICROSECOND
        MINUTE
        MONTH
        QUARTER
        SECOND
        WEEK
        YEAR
      > -> $is {
        ok $is ~~ /<interval_time_stamp>/, "$is passes <interval_time_stamp>";
      }
    }


  }
}