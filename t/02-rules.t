use v6.c;

use Test;
use Parser::SQL::Grammar::Tokens;

for Parser::SQL::Grammar::Tokens::EXPORT::DEFAULT::.keys.sort -> $s {
  next unless $s ~~ ! /^\&_?<[A..Z0..9]>+/;

  diag $s;

  given (S/^\&// given $s) {

    when 'all_or_any' {
      # ::("&<name>") allows for you to execute a rule called <name>.
      #ok 'ALL' ~~ ::("&{$_}"), "ALL passes &$_";
      #ok 'ANY' ~~ ::("&{$_}"), "ANY passes &$_";
      ok 'ALL' ~~ /^<all_or_any>/, "ALL passes <all_or_any>";
      ok 'ANY' ~~ /^<all_or_any>/, "ANY passes <all_or_any>";
    }

    when 'and' {
      ok  '&&' ~~ /^<and>/, '&& passes <and>';
      nok '&+' ~~ /^<and>/, '&+ FAILS <and>';
    }

    when 'bin_num' {
      # Rules must be unanchored due to failures of unknown origin.
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
        ok  $o ~~ /^<bit_ops>/, "{$o} passes <bit_ops>";
        my $fo = $o ~ ']';
        nok '++' ~~ /^<bit_ops>/, "{$fo} FAILS <bit_ops>";
      }
    }

    when 'comp_ops' {
      my @co = <EQ GE GT LE LT NE>;
      @co.push: '=', '>=', '>', '<=', '<', '<>';
      for @co -> $o {
        ok $o ~~ /^<comp_ops>/, "{$o} passes <comp_ops>";
      }
    }

    when 'field_ident' {
      ok "table.field" ~~ /^<field_ident>/, "table.field passes <field_ident>";
      ok "field" ~~ /^<field_ident>/, "field passes <field_ident>";
      ok ".field" ~~ /^<field_ident>/, ".field passes <field_ident>";

      ok
        "namespace.table.field" ~~ /^<field_ident>/,
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
      ok "0xdeadBEeF" ~~ /^<hex_num>/, "0xdeadBEeF passes <hex_num>";
      ok "0XbEeFDeAd" ~~ /^<hex_num>/, "0XbEeFDeAd passes <hex_num>";
      ok "x3af" ~~ /^<hex_num>/, "x3af passes <hex_num>";
      ok "XfA3" ~~ /^<hex_num>/, "XfA3 passes <hex_num>";

      nok "fae" ~~ /^<hex_num>/, "fae FAILS <hex_num>";
      nok "123" ~~ /^<hex_num>/, "123 FAILS <hex_num>";
      nok "0x213efg" ~~ /^<hex_num>/, "0x213efg FAILS <hex_num>";
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

    when 'key_or_index' {
      for <KEY INDEX> -> $s {
        my $sm = "a{$s}b";
         ok $s ~~ /^<key_or_index>/,  " $s passes <key_or_index>";
        nok $sm ~~ /^<key_or_index>/, "$sm FAILS <key_or_index>";
      }
    }

    when 'keyword' | 'keyword_sp' {
      pass "Tested in 03-keywords.t";
    }

    when 'limit_options' {
      my $m = "\@identifier" ~~ /^<limit_options>/;

      ok
        $/<limit_options><_ident>.Str eq "\@identifier",
        'Atypical identifier matches <limit_options>';

      $m = '?' ~~ /^<limit_options>/;
      ok
        $/<limit_options><PARAM_MARK>.Str eq '?',
        'Parameter marker matches <limit_options>';

      $m = '1' ~~ /^<limit_options>/;
      ok
        $/<limit_options><num>.Str eq '1',
        'Numeric value matches <limit_options>';
    }

    when 'not' {
      ok  '<>' ~~ /^<not>/, '<> passes <not>';
      nok '><' ~~ /^<not>/, '>< FAILS <not>';
    }

    when 'or' {
      ok  '||' ~~ /^<or>/, '|| passes <or>';
      nok '|' ~~ /^<or>/,  '| FAILS <or>';
    }

    when 'query_spec_option' {
      for <
        ALL
        STRAIGHT_JOIN
        HIGH_PRIORITY
        DISTINCT
        SQL_SMALL_RESULT
        SQL_BIG_RESULT
        SQL_BUFFER_RESULT
        SQL_CALC_FOUND_ROWS
      > -> $w {
        my $tw = $w.substr(0, *-1);

        ok
          $w ~~ /^<query_spec_option>/,
          "$w matches <query_spec_option>";

        nok
          $tw ~~ /^<query_spec_option>/,
          "$tw does not match <query_spec_option>";
      }
    }

    when 'select_alias' {
      my $m =  'AS table_alias' ~~ /^<select_alias>/;

      ok
        'AS' eq $m<select_alias><AS>.Str,
        'AS token discovered by <select_alias>';

      ok
        'table_alias' eq $m<select_alias><_ident>.Str,
        'table_alias successfully detected';

      $m = '@identifier' ~~ /^<select_alias>/;
      nok
       $m<select_alias><AS>.defined,
       'no false positive on AS token';

      ok
       '@identifier' eq $m<select_alias><_ident>.Str,
       '@identifier properly detected in <select_alias><_ident>';

      $m = '"identifier"' ~~ /^<select_alias>/;
      ok
        $m ~~ /^<select_alias>/,
        'Double quoted string detected in <select_alias>';

      $m = "'identifier'" ~~ /^<select_alias>/;
      ok
        $m ~~ /^<select_alias>/,
        'Single quoted string detected in <select_alias>';
    }

    when 'num' {
      my $m;
      sub test(Str $s) {
       $m = $s ~~ /^<num>/;
      }

      ok test('+123'), '+123 passes <num>';
      ok test('-123'), '-123 passes <num>';

      ok $m<num><whole>.Str eq '123', '123 is whole number portion';
      ok $m<num><s>.Str eq '-', 'Sign of last number is "-"';

      ok test("3.14156"), '3.14156 passes <num>';
      ok $m<num><whole>.Str eq '3', '3 is whole number portion';
      ok $m<num><dec>.Str eq '14156', '14156 is decimal portion';
      ok test('-867.5309'), '-867.5309 passes <num>';

      nok test('3.14.156'), '3.14.156 FAILS <num>';
    }

    when 'number' {
       ok '123456' ~~ /^<number>/, '123456 passes <number>';

      #cw: Ideally this should FAIL number, but it is too generic for the
      #    rule to parse. This is one situation where we must depend on
      #    greater grammar to handle the failure.
      #nok '123abc' ~~ /^<number>/, '123abc FAILS <number>';
    }

    when 'order_dir' {
      ok  'ASC' ~~ /^<order_dir>/, 'ASC passes <order_dir>';
      nok 'ARC' ~~ /^<order_dir>/, 'ARC FAILS <order_dir>';

      ok  'DESC' ~~ /^<order_dir>/, 'DESC passes <order_dir>';
      nok 'DISC' ~~ /^<order_dir>/, 'DISC FAILS <order_dir>';
    }

    when 'plus_minus' {
      ok  '+' ~~ /^<plus_minus>/, '+ passes <plus_minus>';
      ok  '-' ~~ /^<plus_minus>/, '- passes <plus_minus>';
      nok '*' ~~ /^<plus_minus>/, '* FAILS <plus_minus>';
    }

    when 'signed_number' {
      ok "123" ~~ /^<signed_number>/, "123 passes <signed number>";
      ok "+123" ~~ /^<signed_number>/, "+123 passes <signed_number>";
      ok "-123" ~~ /^<signed_number>/, "-123 passes <signed_number>";
      nok "*123" ~~ /^<signed_number>/, "*123 FAILS <signed_number>";
    }

    when 'simple_ident_q' {
      ok
        'schema.table.field' ~~ /^<simple_ident_q>/,
        '"schema.table.field" passes <simple_ident_q>';

      nok
        ',schema.table.field' ~~ /^<simple_ident_q>/,
        '",schema.table.field" fails <simple_ident_q>';

      ok
        '.table.field' ~~ /^<simple_ident_q>/,
        '".table.field" passes <simple_ident_q>';

      nok
        ',table,field' ~~ /^<simple_ident_q>/,
        '",table.field" fails <simple_ident_q>';

      ok
        'table.field' ~~ /^<simple_ident_q>/,
        '"table.field" passes <simple_ident_q>';

      nok
        ',table.field' ~~ /^<simple_ident_q>/,
        '",table.field" fails <simple_ident_q>';

      ok
        '.field' ~~ /^<simple_ident_q>/,
        '".field" passes <simlpe_ident_q>';

      nok
        ',field' ~~ /^<simple_ident_q>/,
        '",field" fails <simlpe_ident_q>';

      ok
        'field' ~~ /^<simple_ident_q>/,
        '"field" fails <simple_ident_q>';
    }

    when 'text' {
      ok '"this is text"' ~~ /^<text>/, '"this is text" passes <text>';
      ok "'this is mo text'" ~~ /^<text>/, "'this is mo text' passes <text>";

      nok "this is text" ~~ /^<text>/, "Unquoted 'this is text' FAILS <text>";
      nok '"this is text\'' ~~ /^<text>/, "Mismatched quote FAILS <text>";
      nok "'this is text\"" ~~ /^<text>/, "2nd mismatch quote FAILS <text>";
    }

    when 'union_opt' {
      for <DISTINCT ALL> -> $m {
        my $km = $m.substr(0, *-1);

          ok $m ~~ /^<union_opt>/, "$m matches <union_opt>";
        nok $km ~~ /^<union_opt>/, "$km fails <union_opt>";
      }
    }

  }
}
