v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

my $count;
for Parser::SQL::Grammar::DDLGrammar.^methods(:local).map( *.name ).sort {
  when <
    _con_function_call
    _gen_function_call
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
    pass 'Evaluated in a separate test.';
  }

  when '_cast_type' {

    # [ <BINARY> | <NCHAR> ] [ '(' <number> ')' ]?
    for <BINARY(2) NCHAR(2)> -> $t {
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> with number and no space";

      $t ~~ s/('(2)')/ $0/;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> with number and a space";

      $t ~~ s/('(2)'//;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without a number";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('a'..'z').pick;
      nok
      Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # <CHAR> [ '(' <number> ')' ]? <BINARY>?
    {
      my $t0 = "CHAR (3) BINARY";
      my $t = $t0;

      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/ ' ' <?before '('>//;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without a space before the number";

      $t ~~ s/'(3)'//;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without a number";

      ($t = $t0) ~~ s/' BINARY'/;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without 'BINARY'";

      $t = 'CHAR';
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without optional tokens";

      ($t = $t0).substr-rw( (^$t.chars).pick, 1 ) = ('a'..'z').pick;
      nok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # <SIGNED> | <UNSIGNED> ] <INT>?
    for <SIGNED UNSIGNED> -> $term {
      # PAUSE
      my $t0 = "$term INT";
      my $t  = $t0;

      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/' INT'//;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without 'INT' token";

      ($t = $t0).substr-rw( (^$t.chars).pick, 1 ) = ('a'..'z').pick;
      nok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # <DATE>
    # <JSON>
    for <DATE JSON> -> %t {
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "DATE passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1) = ('a'..'z').pick;
      nok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "Mutated string '$t' fails <$_>";
    }

    # [ <TIME> | <DATETIME> ] [ '(' <number> ')' ]?
    for <TIME DATETIME> -> $term {
      my $t0 = "$term (4)";
      my $t = $t0;

      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/ ' ' <?before '('>//;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without a space before the number";

      $t ~~ s/ '(4)'//;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without the number specification";

      ($t = $t0).substr-rw( (^$t.chars).pick, 1) = ('a'..'z').pick;
      nok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "Mutated '$t' fails <$_>";
    }

    # <DECIMAL> [
    #   '(' [
    #     <number>
    #     ||
    #     <m=.number> [ ',' <d=.number> ]?
    #   ] ')'
    # ]?
    $count = 0;
    for ('DECIMAL (5)', 'DECIMAL (5, 6)') -> $term {
      my $t0 = $term;

      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> with full syntax";

      $t ~~ s/ ' ' <?before '('>//;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without space before number specification";

      $t ~~ s/ '(5' ',6'? ')' //;
      ok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "'$t' passes <$_> without the number specification";

      if ($count++ == 1) {
        ok
          $/{$_}<m>.Str eq '5',
          "'5' detected in numerical specication by subrule <m>";
      } else {
        ok
          $/{$_}<m>.Str eq '5' && $/{$_}<d>
          "'5' and '6' detected in numerical specication by subrules <m> and <d>";
      }

      ($t = $t0).substr-rw( (^$t.chars).pick, 1) = ('a'..'z').pick;
      nok
        Parser::SQL::DDLGrammar.subparse( $t, rule($_) ),
        "Mutated '$t' fails <$_>";
    }
    
  }

  when '_gorder_clause' {
  }

  when '__ws_list_item' {
  }

  when '__ws_nweights' {
  }

  when '__ws_levels' {
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
