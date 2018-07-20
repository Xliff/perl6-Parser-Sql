v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

my $count;
for Parser::SQL::Grammar::DDLGrammar.^methods(:local).map( *.name ).sort {
  when <
    _con_function_call
    _gen_function_call
    _gorder_clause
    _join_table
    _key_function_call
    _nonkey_function_call
    _when_clause
    attribute
    bit_expr
    bool_pri
    check_constraint
    col_def
    create_select
    create_table_opt
    create_table_opts
    escape
    expr
    expr_list
    field_def
    field_spec
    having_clause
    key_def
    literal
    part_type_def
    predicate
    query_spec
    row_types
    select_item
    select_item_list
    select_paren_derived
    select_part2
    select_part2_derived
    simple_expr
    sum_expr
    table_expression
    table_ref
    type
    udf_expr
    variable
  >.any {
    pass "<$_> evaluated in a separate test.";
  }

  when '_cast_type' {

    # [ <BINARY> | <NCHAR> ] [ '(' <number> ')' ]?
    for <BINARY(2) NCHAR(2)> -> $t0 {
      my $t = $t0;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> with number and no space";

      $t ~~ s/('(2)')/ $0/;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> with number and a space";

      $t ~~ s/'(2)'//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without a number";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # <CHAR> [ '(' <number> ')' ]? <BINARY>?
    {
      my $t0 = "CHAR (3) BINARY";
      my $t = $t0;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/ ' ' <?before '('>//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without a space before the number";

      $t ~~ s/'(3)'//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without a number";

      ($t = $t0) ~~ s/' BINARY'//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without 'BINARY'";

      $t = 'CHAR';
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without optional tokens";

      # Only mutate the first 4 characters.
      ($t = $t0).substr-rw( (^4).pick, 1 ) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # <SIGNED> | <UNSIGNED> ] <INT>?
    for <SIGNED UNSIGNED> -> $term {
      # PAUSE
      my $t0 = "$term INT";
      my $t  = $t0;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/' INT'//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without 'INT' token";

      # Mutate only the $term portion of the string.
      ($t = $t0).substr-rw( (^$term.chars).pick, 1 ) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # <DATE>
    # <JSON>
    for <DATE JSON> -> $t0 {
      my $t = $t0;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "DATE passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # [ <TIME> | <DATETIME> ] [ '(' <number> ')' ]?
    for <TIME DATETIME> -> $term {
      my $t0 = "$term (4)";
      my $t = $t0;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/ ' ' <?before '('>//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without a space before the number";

      $t ~~ s/ '(4)'//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without the number specification";

      # Mutate only the $term part of the string.
      ($t = $t0).substr-rw( (^$term.chars).pick, 1) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }

    # <DECIMAL> [
    #   '(' [
    #     <m=number> [ ',' <d=number> ]?
    #   ] ')'
    # ]?
    $count = 0;
    for ('DECIMAL (5)', 'DECIMAL (5, 6)') -> $term {
      my $t0 = $term;
      my $t = $t0;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/ ' ' <?before '('>//;
      ok
        ( my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "'$t' passes <$_> without space before number specification";

      if (++$count == 1) {
        ok
          $s.defined && $s<m>.Str eq '5',
          "'5' detected in numerical specication by subrule <m>";
      } else {
        ok
          $s<m>.Str eq '5' && $s<d>.Str eq '6',
          "'5' and '6' detected in numerical specication by subrules <m> and <d>";
      }

      $t ~~ s/ '(5' ',6'? ')' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without the number specification";

      # Test only the DECIMAL portion of the string.
      ($t = $t0).substr-rw( (^'DECIMAL'.chars).pick, 1 ) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }

  }

  when '__ws_list_item' {

    # <number> <order_dir>? <REVERSE>?
    for <ASC DESC> -> $term {
      my $t = "7 $term REVERSE";

      # Test REVERSE
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> with REVERSE";

      # Remove REVERSE and test match
      $t ~~ s/ 'REVERSE' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without REVERSE";

      # Remove $term and test.
      $t ~~ s/ $term //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without $term";

      # Mutate number and test failure.
      $t.substr-rw(0, 1) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }

  }


  when '__ws_nweights' {

    my $t = '(8)';
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_>";

    $t.substr-rw( (^$t.chars).pick, 1 ) = ('a'..'z').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";

  }

  # <LEVEL> $<ws_list> = [
  #   <__ws_list_item>+ %  ','
  #   |
  #   <number> '-' <number>
  # ]
  when '__ws_levels' {

    # Test multiple list items
    $count = 1;
    for (
      'LEVEL 9 ASC, 10 ASC REVERSE',
      'LEVEL 9-10 ASC REVERSE',
    ) -> $term {
      my $t = (my $t0 = $term);

      # test full $term
      ok
        ( my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "'$t' passes <$_> with full variant syntax";

      ok
        $s<ws_list>.trim eq ($count == 1) ??
          '9 ASC, 10 ASC REVERSE' !! '9-10 ASC REVERSE',
        "Match<ws_list> contains proper items: '$s<ws_list>'";

      # test multiple items with no reverse ($count == 1)
      $t ~~ s/ ' ASC REVERSE' / ASC/;
      ok
        ($s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "'$t' passes <$_> without REVERSE";

      ok
        $s<ws_list>.trim eq ($count == 1) ??
          '9 ASC, 10 ASC' !! '9-10 ASC',
        "Match<ws_list> contains proper items: '$s<ws_list>'";

      if $count++ == 2 {
        # ws_list_item cannot be tested with a mutation becuase it will
        # still match if subsequent list items do not match.
        #
        # Could test the first match, or mutate LEVEL. Should put that
        # to a vote if anyone else gets involved.

        # Test mutated range
        $t ~~ / ('LEVEL 9-10') /;
        my $tm := $t.substr-rw($0.from, $0.to - $0.from);
        $tm.substr-rw( (^$tm.chars).pick, 1) = ('a'..'z').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }

  }

  when '_into' {
  }

  when 'all_key_opt' {
  }

  when 'alter_algo_option' {
  }

  when 'alter_lock_option' {
  }

  when 'charset' {
  }

  when 'charset_name_or_default' {
  }

  when 'collate_explicit' {
  }

  when 'constraint_key_type' {
  }

  when 'constraint' {
  }

  when 'create_field_list' {
  }

  when 'derived_table_list' {
  }

  when 'field_list_item' {
  }

  when 'field_term' {
  }

  when 'from_clause' {
  }

  when 'gcol_attr' {
  }

  # Considfer moving to tokens as a rule.
  when 'generated_always' {
  }

  when 'index_lock_algo' {
  }

  when 'if_not_exists' {
  }

  when 'limit_clause' {
  }

  when 'line_term' {
  }

  when 'load_data_charset' {
  }

  when 'lock_expire_opts' {
  }

  when 'now' {
  }

  when 'order_expr' {
  }

  when 'part_field_list' {
  }

  when 'procedure_analyse_clause' {
  }

  when 'select_lock_type' {
  }

  when 'select_option' {
  }

  when 'simple_ident_nospvar' {
  }

  when 'table_alias' {
  }

  when 'table_list' {
  }

  when 'table_wild' {
  }

  when 'row_types' {
  }

  when 'use_partition' {
  }

  when 'using_list' {
  }

  # Connect Opts in DDLGrammar

}
