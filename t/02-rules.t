use v6.c;

use Test;
use Parser::SQL::Grammar::Tokens;

for Parser::SQL::Grammar::Tokens::EXPORT::DEFAULT::.keys.sort -> $s {
  next unless $s ~~ ! /^\&_?<[A..Z0..9]>+/;

  diag $s;

  given (S/^\&// given $s) {

    when 'all_or_any' {
      ok 'ALL' ~~ ::("&{$_}"), "ALL passes &$_";
      ok 'ANY' ~~ ::("&{$_}"), "ANY passes &$_";
    }

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

    when 'hex_num' {
      ok "0xdeadBEeF" ~~ /<hex_num>/, "0xdeadBEeF passes <hex_num>";
      ok "0XbEeFDeAd" ~~ /<hex_num>/, "0XbEeFDeAd passes <hex_num>";
      ok "x3af" ~~ /<hex_num>/, "x3af passes <hex_num>";
      ok "XfA3" ~~ /<hex_num>/, "XfA3 passes <hex_num>";

      nok "fae" ~~ /<hex_num>/, "fae FAILS <hex_num>";
      nok "123" ~~ /<hex_num>/, "123 FAILS <hex_num>";
      nok "0x213efg" ~~ /<hex_num>/, "0x213efg FAILS <hex_num>";
    }

    when 'ident_sys' {
      my $m;
      sub test(Str $s) {
       $m = $s ~~ /^<ident_sys>/;
      }

      ok
        test("\@identifier"),
        "\@identifier matches <ident_sys>";

      ok
        test("\@\@why_would_you_use_this_name"),
        "\@\@why_would_you_use_this_name matches <ident_sys>";

      ok
        test("\@\$please__no"),
        "\@\$please__no matches <ident_sys>";

      ok
        test("#\@now_you_are_hurting_me"),
        "#\@now_you_are_hurting_me matches <ident_sys>";

      test("REMOVE");
      ok
        $m<ident_sys><keyword>,
        "REMOVE keyword matches <ident_sys>";

      ok
        test('"quoted_identifier"'),
        '"quoted_identifier" matches <ident_sys>';

      ok
        test("'quoted_identifier'"),
        "'quoted_identifier' MATCHES <ident_sys>";

      ok
        test("__ident"), "__ident matches <ident_sys>";

      nok test("\!not"), "!not FAILS <ident_sys>";
      nok test("\$dolla"), "\$dolla FAILS <ident_sys>";
      nok test("0\@notavar"), "0\@notavar FAILS <ident_sys>";
      nok test("\%caseabeer"), "\%caseabeer FAILS <ident_sys>";
      nok test("'misquoted\""), "'misquoted\" FAILS <ident_sys>";
      nok test("\"misquoted2'"), "\"misquoted2\' FAILS <ident_sys>";
    }

    when 'interval' {
      my @syms = <
        DAY_HOUR
        DAY_MICROSECOND
        DAY_MINUTE
        DAY_SECOND
        HOUR_MICROSECOND
        HOUR_MINUTE
        HOUR_SECOND
        MINUTE_MICROSECOND
        MINUTE_SECOND
        SECOND_MICROSECOND
        YEAR_MONTH
      >;

      for @syms -> $s {
        my $sm = "a{$s}b";

         ok $s ~~ /^<interval>/,  " $s passes <interval>";
        nok $sm ~~ /^<interval>/, "$sm FAILS <interval>";
      }
    }


    # cw: Ideally, we'd mix these. That can be a TODO for later.

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
      > -> $s {
        my $sm = "a{$s}b";

          ok $s ~~ /^<interval_time_stamp>/, " $s passes <interval_time_stamp>";
        nok $sm ~~ /^<interval_time_stamp>/, "$sm FAILS <interval_time_stamp>";
      }
    }

    when 'not' {
      ok  '<>' ~~ /<not>/, '<> passes <not>';
      nok '><' ~~ /<not>/, '>< FAILS <not>';
    }

    when 'or' {
      ok  '||' ~~ /<or>/, '|| passes <or>';
      nok '|' ~~ /<or>/,  '| FAILS <or>';
    }

    when 'order_dir' {
      ok  'ASC' ~~ /<order_dir>/, 'ASC passes <order_dir>';
      nok 'ARC' ~~ /<order_dir>/, 'ARC FAILS <order_dir>';

      ok  'DESC' ~~ /<order_dir>/, 'DESC passes <order_dir>';
      nok 'DISC' ~~ /<order_dir>/, 'DISC FAILS <order_dir>';
    }

    when 'plus_minus' {
      ok  '+' ~~ /<plus_minus>/, '+ passes <plus_minus>';
      ok  '-' ~~ /<plus_minus>/, '- passes <plus_minus>';
      nok '*' ~~ /<plus_minus>/, '* FAILS <plus_minus>';
    }

  }
}
