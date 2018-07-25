v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

# WHEN REFACTORING, ALL TESTS THAT INCLUDE THE <EQ> TOKEN MUST ADD A test
# REPLACING EQ WITH = FOR COMPLETENESS!!!

my $count;
for Parser::SQL::Grammar::DDLGrammar.^methods(:local).map( *.name ).sort {
  diag $_;
  when <
    _con_function_call
    _gen_function_call
    _gorder_clause
    _into
    _join_table
    _key_function_call
    _nonkey_function_call
    _when_clause
    attribute
    bit_expr
    bool_pri
    check_constraint
    col_def
    create_field_list
    create_partitioning
    create_select
    create_table_opt2
    create3
    derived_table_list
    escape
    expr
    expr_list
    field_def
    field_list_item
    field_spec
    from_clause
    group_clause
    having_clause
    key_def
    now
    order_clause
    order_expr
    order_or_limit
    part_definition
    part_func_max
    part_type_def
    part_value_expr_item
    part_value_item
    part_values_in
    predicate
    query_spec
    references
    select_init
    select_item
    select_item_list
    select_option
    select_paren
    select_paren_derived
    select_part2
    select_part2_derived
    simple_expr
    sum_expr
    sub_part
    subselect
    table_expression
    table_factor
    table_ref
    type
    udf_expr
    union_list
    variable
    where_clause
    where_expr
  >.any {
    pass "<$_> evaluated in a separate test.";
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

  when '_limits' {
    for (
      'MAX_QUERIES_PER_HOUR',
      'MAX_UPDATES_PER_HOUR',
      'MAX_CONNECTIONS_PER_HOUR',
      'MAX_USER_CONNECTIONS'
    ) -> $term {
      my $t = "$term 17";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ /( $( $term ) )/;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # <KEY_BLOCK_SIZE> <EQ>? <num> | <COMMENT> <text>
  when 'all_key_opt' {
    my $t = 'KEY_BLOCK_SIZE EQ 11';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> with full syntax";

    $t ~~ s /EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without 'EQ'";

    $t ~~ s /\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without '=' or 'EQ'";

    $t.substr-rw( (^$t.chars).pick, 1 ) = ('a'..'z').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";

    $t = "COMMENT 'text_comment'";
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without 'EQ'";

    $t ~~ / ( 'COMMENT' ) /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  # <ALGORITHM> <EQ>? $<o>=[ <DEFAULT> || <_ident> ]
  when 'alter_algo_option' {
    for <DEFAULT @identifier> -> $term {
      my $t = "ALGORITHM EQ $term";

      ok
        ( my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "'$t' passes <$_> with full syntax";

      ok $s<o> eq $term, "Match<o> equals '$term'.";

      $t ~~ s / 'EQ ' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without 'EQ'";

      $t ~~ / ( 'ALGORITHM' ) /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'alter_lock_option' {
    for <DEFAULT @identifier> -> $term {
      my $t = "LOCK EQ $term";

      ok
        ( my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "'$t' passes <$_> with full syntax";

      ok $s<o> eq $term, "Match<o> equals '$term'.";

      $t ~~ s / 'EQ ' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without 'EQ'";

      $t ~~ / ( 'LOCK' ) /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'charset' {
    for ('CHAR SET', 'CHARSET') -> $term {
      my $t = $term;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$term' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'charset_name_or_default' {
    for ('@identifier', "'text string'", 'BINARY', 'DEFAULT') -> $term {
      my $t = $term;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$term' passes <$_>";

      if / 'BINARY' | 'DEFAULT' / {
        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }
  }

  when 'collate_explicit' {
    for ('@identifier', "'text string'") -> $term {
      my $t = "COLLATE $term";

      ok
        ( my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ) ),
        "'$term' passes <$_>";

      ok $s<o> eq $term, "Match<o> equals '$term'";

      $t ~~ / ( 'COLLATE' ) /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # <PRIMARY> <KEY> | <UNIQUE> <key_or_index>
  when 'constraint_key_type' {
    my $t = 'PRIMARY KEY';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ ' KEY' //;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' fails <$_> without KEY";

    for <KEY INDEX> -> $term {
      $t = "UNIQUE $term";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$term' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'connect_opts' {
    # from _limits
    for <
      MAX_QUERIES_PER_HOUR
      MAX_UPDATES_PER_HOUR
      MAX_CONNECTIONS_PER_HOUR
      MAX_USER_CONNECTIONS
    > -> $term {
      my $t = "WITH $term 17";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without 'EQ'";

      $t ~~ / ( 'WITH ' $term ) /;
      my $tm := $t.substr-rw(0, $0.to);
      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # <default_collation> | <default_charset>
  when 'create_database_opts' {
    for ('@ident1', "'text string'") -> $term-o {
      for ('CHAR SET', 'CHARSET') -> $term-i {
        my $t = (my $t0 = "DEFAULT $term-i EQ $term-o");

        my $s;
        ok
          $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_>";
        ok $s<default_charset>, "Match<default_charset> is defined";

        $t ~~ s/ 'DEFAULT ' //;
        ok
          $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_> without DEFAULT";
        ok $s<default_charset>, "Match<default_charset> is defined";

        ($t = $t0) ~~ s/ 'EQ ' //;
        ok
          $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_> without EQ";
        ok $s<default_charset>, "Match<default_charset> is defined";

        ($t = $t0) ~~ s/ [ 'DEFAULT' | 'EQ' ] //;
        ok
          $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_> without DEFAULT and EQ";
        ok $s<default_charset>, "Match<default_charset> is defined";

        $t ~~ /( 'CHAR SET' || 'CHARSET' )/;
        my $tm := $t.substr-rw($0.from, $0.to - $0.from);
        $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }

    for ('@ident1', "'text string'") -> $term {
      my $t = (my $t0 = "DEFAULT COLLATE EQ $term");

      ok
        (my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "'$t' passes <$_>";
      ok $s<default_collation>, "Match<default_collation> is defined";

      $t ~~ s/ 'DEFAULT ' //;
      ok
        $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without DEFAULT";
      ok $s<default_collation>, "Match<default_collation> is defined";

      ($t = $t0) ~~ s/ 'EQ ' //;
      ok
        $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without EQ";
      ok $s<default_collation>, "Match<default_collation> is defined";

      ($t = $t0) ~~ s/ [ 'DEFAULT' | 'EQ' ] //;
      ok
        $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without DEFAULT and EQ";
      ok $s<default_collation>, "Match<default_collation> is defined";

      $t ~~ /( 'COLLATE' )/;
      my $tm := $t.substr-rw($0.from, $0.to - $0.from);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'constraint' {
    # An evil way to initialize and set two variables. I LIKE IT!
    my $t = (my $t0 = 'CONSTRAINT ns.table.field');

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ 'ns' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ '.table' / table /;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ 'table' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ '.field' / field /;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    # This will not work via parsing. It must be caught and thrown in the action
    # class
    #($t = $t0) ~~ s/ 'field' //;
    #nok
    #  Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
    #  "Trailing '.' fails <$_>";
  }

  when 'create_table_opt' {
  }

  when 'create_table_opts' {
  }

  # <DEFAULT>? <charset> <EQ>? [ <_ident> || <text> ]
  when 'default_charset' {
    for ('@ident1', "'text string'") -> $term-o {
      for ('CHAR SET', 'CHARSET') -> $term-i {
        my $t = (my $t0 = "DEFAULT $term-i EQ $term-o");

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_>";

        $t ~~ s/ 'DEFAULT ' //;
        ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without DEFAULT";

        ($t = $t0) ~~ s/ 'EQ ' //;
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_> without EQ";

        ($t = $t0) ~~ s/ [ 'DEFAULT' | 'EQ' ] //;
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_> without DEFAULT and EQ";

        $t ~~ /( 'CHAR SET' || 'CHARSET' )/;
        my $tm := $t.substr-rw($0.from, $0.to - $0.from);
        $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }
  }

  # <DEFAULT>? <charset> <EQ>? [ <_ident> || <text> ]
  when 'default_collation' {
    for ('@ident1', "'text string'") -> $term {
      my $t = (my $t0 = "DEFAULT COLLATE EQ $term");

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ s/ 'DEFAULT ' //;
      ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without DEFAULT";

      ($t = $t0) ~~ s/ 'EQ ' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without EQ";

      ($t = $t0) ~~ s/ [ 'DEFAULT' | 'EQ' ] //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without DEFAULT and EQ";

      $t ~~ /( 'COLLATE' )/;
      my $tm := $t.substr-rw($0.from, $0.to - $0.from);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'delete_option' {
    for <RESTRICT CASCADE SET NO> -> $term {
      when $term eq <RESTRICT CASCADE>.any {
        my $t = $term;

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_>";

        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }

      when $term eq 'SET' {
        for <NULL DEFAULT> -> $term-i {
          my $t = "$term $term-i";

          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
            "'$t' passes <$_>";

          $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
          nok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
            "Mutated '$t' fails <$_>";
        }
      }

      when $term eq 'NO' {
        my $t = "$term ACTION'";

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";

        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }
  }

  # <COLUMNS> [
  #   $<t>=[ <TERMINATED> || <OPTIONALLY>? <ENCLOSED> || <ESCAPED> ]
  #   <BY> $<s>=<text_string>
  # ]+
  when 'field_term' {
    for ('TERMINATED', 'OPTIONALLY ENCLOSED', 'ESCAPED') -> $term {
      my $t = "COLUMNS $term BY 'text string'";
      my $s;

      ok
        ( $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "'$t' passes <$_>";

      ok $s<t>.trim eq $term, "Match<t> equals $term";
      ok $s<s>.trim eq "'text string'", "Match<s> equals \"'test string'\"";

      if $t ~~ /OPTIONALLY/ {
        $t ~~ s/ 'OPTIONALLY ' //;

        ok
          ( $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
          "'$t' passes <$_> without OPTIONALLY";

        ok $s<t>.trim eq 'ENCLOSED', "Match<t> equals $term";
        ok $s<s>.trim eq "'text string'", "Match<s> equals \"'test string'\"";
      }

      # So far, this is the best way to write this.
      $t ~~ / ('COLUMNS ' [ 'TERMINATED' | 'ENCLOSED' | 'ESCAPED' ] ' BY') /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('a'..'z').pick;
      nok
        ( $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # [ <all_key_opt> | <WITH> <PARSER> <ident_sys> ]?
  when 'fulltext_key_opt' {
    # <all_key_opt>

    for ('@ident', '"text string"', 'field') -> $term {
      my $t = "WITH PARSER $term";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      my $r = $(<WITH PARSER>.pick);
      $t ~~ / ( $r ) /;
      my $tm := $t.substr-rw($0.from, $0.to - $0.from);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        (my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'gcol_attr' {
    for ('UNIQUE KEY', "COMMENT 'text comment'", 'NOT NULL', 'PRIMARY KEY') -> $t0 {
      my $t = $t0;

      # Why does given when not work here. Is it because we are in one already?
      # That shouldn't be.
      if $t0 eq 'UNIQUE KEY' {
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";

        $t ~~ s/ ' KEY' //;
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_> without the KEY";

        # Odd failure if the Y in KEY is replace with a number. PLEASE
        # circle back and check this.
        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      } elsif $t0 ~~ /^ 'COMMENT' / {
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";

        $t ~~ / ( 'COMMENT' ) /;
        my $tm := $t.substr-rw(0, $0.to);
        $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      } elsif $t0 eq 'NOT NULL' {
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_>";

        $t ~~ s/ 'NOT '//;
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_> without the NOT";

        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      } elsif $t0 eq 'PRIMARY KEY' {
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";

        $t ~~ s/ 'PRIMARY ' //;
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>without the PRIMARY";

        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }
  }

  # Considfer moving to tokens as a rule.
  when 'generated_always' {
    my $t = (my $t0 = 'GENERATED ALWAYS');

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    # This defeats the unlikely case where neither string results in any
    # change.
    while $t eq $t0 {
      $t ~~ s/ $( ('GENERATED ', ' ALWAYS').pick ) //;
    }
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' fails <$_>";
  }

  when 'grant_opts' {
    my $t = 'GRANT OPTION';
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";


    $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";

    # from <_limits>
    for (
      'MAX_QUERIES_PER_HOUR',
      'MAX_UPDATES_PER_HOUR',
      'MAX_CONNECTIONS_PER_HOUR',
      'MAX_USER_CONNECTIONS'
    ) -> $term {
      my $t = "$term 17";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ /( $( $term ) )/;
      my $tm := $t.substr-rw(0, $0.to);
      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'index_lock_algo' {
    my $t = 'ALGORITHM EQ DEFAULT LOCK EQ DEFAULT';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s:g/ 'EQ '//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without EQ";

    $t = 'LOCK EQ DEFAULT ALGORITHM EQ DEFAULT';
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s:g/ 'EQ '//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without EQ";

    # Compound test. No negatives necessary... yet.
  }

  when 'if_not_exists' {
    my $t = 'IF NOT EXISTS';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_>";

    $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  when 'key_alg' {
    for <USING TYPE> -> $term-o {
      for <BTREE RTREE HASH> -> $term-i {
        my $t = "$term-o $term-i";

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_>";

        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }
  }

  # <_ident> [ '(' <num> ')' ]?  <order_dir>
  when 'key_list' {
    for <ASC DESC> -> $term {
      my $t = "\@identifier (18) $term";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ s/ '(18) ' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without number specification";

      $t ~~ /( $term )/;
      my $tm := $t.substr-rw($0.from, $0.to - $0.from);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # <key_list>+ % ','
  when 'key_lists' {
    for <ASC DESC> -> $term-o {
      for <DESC ASC> -> $term-i {
        my $t = "\@ident1 (19) $term-o, \@ident2 (20) $term-i";

        ok
          (my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ) ),
          "'$t' passes <$_>";

        ok $s<key_list>.elems == 2, "Match<key_list> contains 2 items";

        # No negative test required.
      }
    }
  }

  # <LIMIT> <limit_options> [ [ ',' || <OFFSET> ] <limit_options> ]?
  when 'limit_clause' {
    for <@ident ? 15> -> $term-o {
      for <, OFFSET> -> $term-m {
        for <@ident2 ? 16> -> $term-i {
          my $t = "LIMIT $term-o $term-m $term-i";

          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
            "'$t' passes <$_>";

          if $t ~~ /\,/ {
            $t ~~ s/ ' ,' /,/;
            ok
              Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
              "'$t' passes <$_>";
          }

        }
      }

      my $t = "LIMIT $term-o";
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ / ( 'LIMIT' )/;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # <underscore_charset>? <text>
  # ||
  # 'N'<text>
  # ||
  # <num>
  # ||
  # [ <DATE> | <TIME>  | <TIMESTAMP> ] <text>
  # ||
  # [ <NULL> | <FALSE> | <TRUE> ]
  # ||
  # <underscore_charset>? [ <hex_num> || <bin_num> ]
  when 'literal' {
    # <underscore_charset>? <text>
    {
      my $t = "_latin1 'text string'";
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ s/ '_latin1' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without charset";

      # No negative test written - Possible to replace quotes? Revisit.
    }

    # 'N'<text>
    {
      my $t = 'N"text String"';

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      # No negative test possible without replacing the quotes. Revisit.
    }

    # <num>
    {
      my $t = '22';
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1) = ('a'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }

    # [ <DATE> | <TIME>  | <TIMESTAMP> ] <text>
    for <DATE TIME TIMESTAMP> -> $term {
      my $t = "$term 'date string'";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";
      ok $/<text> eq "'date string'", 'Match<text> matches "date string"';

      $t ~~ /( $( $term ) )/;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }

    # [ <NULL> | <FALSE> | <TRUE> ]
    for <NULL FALSE TRUE> -> $term {
      my $t = $term;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }


    # <underscore_charset>? [ <hex_num> || <bin_num> ]
    for <0xdeadbeef 0b10010101> -> $term {
      my $t = "_latin1 $term";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ s/ '_latin1' //;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without charset";

      # Mutate outside hexidecimal or binary
      $t.substr-rw( (^$t.chars).pick, 1 ) = ('g'..'z').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # <LINES> [ $<t>=[ <TERMINATED> || <STARTING> ] <BY> $<s>=<text_string> ]+
  when 'line_term' {
    for <TERMINATED STARTING> -> $term {
      my $t = "LINES $term BY 'text string'";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ / ('LINES' \s+ $term \s+ 'BY') /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'load_data_charset' {
    for ('CHAR SET', 'CHARSET') -> $term-o {
      for ('@identifier', "'text string'", 'BINARY', 'DEFAULT') -> $term-i {
        my $t = "$term-o $term-i";

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";

        if / ( 'BINARY' | 'DEFAULT' ) / {
          my $tm := $t.substr-rw($0.from, $0.to - $0.from);
          $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
          nok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
            "Mutated '$t' fails <$_>";
        }
      }
    }
  }

  # <lf_group_id=ident>
  # <ADD> [
  #   <UNDOFILE> <file_txt=text>
  #   |
  #   <REDOFILE> <file_text=text>
  # ]
  # [ <logfile_group_option> [ ','? <logfile_group_option> ]* ]?
  when 'logfile_group_info' {
    for <@logfile @logf1le> -> $term-o {
      for <UNDOFILE REDOFILE> -> $term-i {
        my $t = (my $t0 = "$term-o ADD $term-i 'file text'");

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";

        $t ~~ /( $term-i )/;
        my $tm := $t.substr-rw($0.from, $0.to - $0.from);
        $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";

        ($t = $t0) ~~ /( 'ADD' )/;
        $tm := $t.substr-rw($0.from, $0.to - $0.from);
        $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";

        $t = "$t0 INITIAL_SIZE = 23, MAX_SIZE EQ 24 UNDO_BUFFER_SIZE 25";
        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";
        ok
          $/<logfile_group_option>.elems == 3,
          'Match<logfile_group_option> has 3 elements';
      }
    }
  }

  # <INITIAL_SIZE> <EQ>? [ <num> || <ident_sys> ]
  # |
  # <MAX_SIZE> <EQ>? [ <num> || <ident_sys> ]
  # |
  # <EXTENT_SIZE> <EQ>? [ <num> || <ident_sys> ]
  # |
  # <UNDO_BUFFER_SIZE> <EQ>? [ <num> || <ident_sys> ]
  # |
  # <REDO_BUFFER_SIZE> <EQ>? [ <num> || <ident_sys> ]
  # |
  # <NODEGROUP> <EQ>? <num>
  # |
  # <STORAGE>? <ENGINE> <EQ>? [ <storage_txt=text> || <storage_id=ident> ]  ]
  # |
  # [ <WAIT> || <NO_WAIT> ]
  # |
  # <COMMENT> <EQ>? <comment_txt=text>
  when 'logfile_group_option' {
    for <
      INITIAL_SIZE
      MAX_SIZE
      EXTENT_SIZE
      UNDO_BUFFER_SIZE
      REDO_BUFFER_SIZE
      NODEGROUP
      ENGINE
      WAIT
      NO_WAIT
      COMMENT
    > -> $term-o {
      my $rule = $_;

      given $term-o {
        when 'ENGINE' {
          my $t = (my $t0 = "STORAGE $term-o EQ \@ident, 'text'");

          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_>";
          ok $/<STORAGE>, 'Match<STORAGE> is set';
          ok $/<EQ>, 'Match<EQ> is set';

          $t ~~ s/STORAGE//;
          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_> without STORAGE";

          $t ~~ s/EQ//;
          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_> without STORAGE and EQ";

          ($t = $t0) ~~ s/EQ//;
          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_> with STORAGE and without EQ";
        }

        when <WAIT NO_WAIT>.any {
          my $t = $term-o;

          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_>";

          $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
          nok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "Mutated '$t' fails <$_>";
        }

        when 'NODEGROUP' {
          my $t = "$term-o EQ 20";

          # Refactor below for reuse for the remaining rule tests in this block.
          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_>";

          $t ~~ s/EQ//;
          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_> without EQ";

          $t ~~ / ( $term-o ) /;
          my $tm := $t.substr-rw(0, $0.to);
          $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
          nok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "Mutated '$t' fails <$_>";
        }

        when 'COMMENT' {
          my $t = "$term-o EQ 'text string'";

          # See comment for NODEGROUP
          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_>";

          $t ~~ s/EQ//;
          ok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "'$t' passes <$_> without EQ";

          $t ~~ / ( $term-o ) /;
          my $tm := $t.substr-rw(0, $0.to);
          $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
          nok
            Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
            "Mutated '$t' fails <$_>";
        }

        default {
          my @p = <21 @ident>;

          for @p -> $term-i {
            my $t = "$term-o EQ $term-i";

            # See comment for NODEGROUP
            ok
              Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
              "'$t' passes <$_>";

            $t ~~ s/EQ//;
            ok
              Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
              "'$t' passes <$_> without EQ";

            $t ~~ / ( $term-o ) /;
            my $tm := $t.substr-rw(0, $0.to);
            $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
            nok
              Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($rule) ),
              "Mutated '$t' fails <$_>";
          }
        }
      }
    }
  }

  # <ACCOUNT> [ <UNLOCK> || <LOCK> ]
  # |
  # <PASSWORD> <EXPIRE> [
  #   <INTERVAL> <num> <DAY>
  #   |
  #   [ <NEVER> || <DEFAULT> ]
  # ]
  when 'lock_expire_opts' {
    for <UNLOCK LOCK> -> $term {
      my $t = "ACCOUNT $term";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }

    {
      my $t0 = 'PASSWORD EXPIRE';
      my $t1 = (my $t = "$t0 INTERVAL 12 DAY");

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ / ( ' 12' ) /;
      my $tm := $t.substr-rw(0, $0.from - 1);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";

      $t = $t1;
      for <NEVER DEFAULT> -> $term {
        $t = "$t0 $term";

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
          "'$t' passes <$_>";

        $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }
  }

  when 'match_clause' {
    for <FULL PARTIAL SIMPLE> -> $term {
      my $t = "MATCH $term";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }


  # <all_key_opt> || <key_alg>
  when 'normal_key_options' {
    # From <all_key_opt>
    my $t = 'KEY_BLOCK_SIZE EQ 29';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> with full syntax";

    $t ~~ s /EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without 'EQ'";

    $t ~~ s /\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without '=' or 'EQ'";

    $t.substr-rw( (^$t.chars).pick, 1 ) = ('a'..'z').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";

    $t = "COMMENT 'text_comment'";
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without 'EQ'";

    $t ~~ / ( 'COMMENT' ) /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";

    # From <key_alg>
    for <USING TYPE> -> $term-o {
      for <BTREE RTREE HASH> -> $term-i {
        my $t = "$term-o $term-i";

        ok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "'$t' passes <$_>";

        $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
        nok
          Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
          "Mutated '$t' fails <$_>";
      }
    }
  }

  when 'on_update_delete' {
  }

  when 'part_field_list' {
    my $t = "'text string', BEGIN, \@ident";
    ok
      ( my $s = Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ) ),
      "'$t' passes <$_>";

    ok
      $s<_ident> ~~ Array && +$s<_ident> == 3,
      "'$t' contains three elements";

    ok
      $s<_ident>[0] eq "'text string'",
      "First element matched by <$_><part_field> is 'text string'";

    ok
      $s<_ident>[1] eq 'BEGIN',
      "Second element matched by <$_><part_field> is 'BEGIN'";

    ok
      $s<_ident>[2] eq '@ident',
      "Third element matched by <$_><part_field> is '\@ident'";

    # No failure mode for this item.
  }

  # <PROCEDURE> <ANALYSE> '(' [ <num> [ ',' <num> ]? ]? ')'
  when 'procedure_analyse_clause' {
    my $t = 'PROCEDURE ANALYSE (13, 14)';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    # Since number spec is optional, not capable of testing this without
    # an Action class.
    $t ~~ s/ ', 14' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ '13' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without number spec";

    $t ~~ s / <[( )]> //;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' fails <$_> without parens";
  }

  # '(' <_ident>+ % ',' ')'
  when 'ref_list' {

  }

  # <REQUIRE> [
  #   <require_list_element> [ <AND>? <require_list_element> ]*
  #   |
  #   [ <SSL> || <X509> || <NONE> ]
  # ]
  when 'require_clause' {
    my $t = <SUBJECT ISSUER CIPHER>.join(' "require text" AND ');
    $t = "REQUIRE $t \"require text\"";

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    ok
      $/<require_list_element>.elems == 3,
      'Match<require_list_element> has 3 items';
    # Trim to remove extraneous whitespace.
    ok
      $/<require_list_element>[0].trim eq 'SUBJECT "require text"',
      'First element of Match<require_list_element> has the correct value';
    ok
      $/<require_list_element>[1].trim eq 'ISSUER "require text"',
      'Second element of Match<require_list_element> has the correct value';
    ok
      $/<require_list_element>[2].trim eq 'CIPHER "require text"',
      'Third element of Match<require_list_element> has the correct value';

    $t ~~ s:g/'AND '//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without AND";
  }

  # [ <SUBJECT> | <ISSUER> | <CIPHER> ] <text>
  when 'require_list_element' {
    for <SUBJECT ISSUER CIPHER> -> $term {
      my $t = "$term 'require text'";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_> without number spec";

      $t ~~ / ( $( "$term " ) )/;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'select_lock_type' {
    for ('FOR UPDATE', 'LOCK IN SHARE MODE') -> $term {
      my $t = $term;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_> without number spec";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'server_option' {
  }

  when 'server_opts' {
  }

  when 'simple_ident_nospvar' {
    my $t = 'ns.table.field';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ 'ns' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ '.table' /table/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ 'table' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ '.field' /field/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    # Leading dot in namespace and trailing dot on match will need to be caught
    # in the action class.
  }

  when 'table_alias' {
    for <AS EQ> -> $term {
      my $t = "$term newtable";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ / ($term) /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'table_list' {
    my $t = 'ns1.table1, ns2.table2, .table3';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    ok $/<table_ident>.elems == 3, "There are 3 tables referenced";
    ok
      $/<table_ident>[0] eq 'ns1.table1',
      "First table referenced is 'ns1.table1'";
    ok
      $/<table_ident>[1].trim eq 'ns2.table2',
      "First table referenced is 'ns2.table2'";
    ok
      $/<table_ident>[2].trim eq '.table3',
      "First table referenced is '.table3'";
  }

  when 'table_wild' {
    # Test
    my $t = 'table.*';
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    # Failure
    $t = 'table.';
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' fails <$_>";
  }

  # <ts_name=_ident> <ADD> <DATAFILE> <df_name=text>
  # [ <USE> <LOGFILE> <GROUP> <grp_name=_ident> ]?
  # <tablespace_option_list>
  when 'tablespace_info' {
  }

  # local <_ts_option> = [
  #   <ts_initial_size>     |
  #   <ts_autoextend_size>  |
  #   <ts_max_size>         |
  #   <ts_extent_size>      |
  #   <ts_nodegroup>        |
  #   <ts_engine>           |
  #   <ts_wait>             |
  #   <ts_comment>          |
  #   <ts_file_block_size>
  # ]
  # <_ts_option>* % ','
  when 'tablespace_option_list' {
    my $t = qq:to/TEST/;
AUTOEXTEND_SIZE EQ 27,
COMMENT EQ "text string",
EXTENT_SIZE EQ 28,
FILE_BLOCK_SIZE EQ 29
TEST

    # First test of multiline string, but this should work due the default
    # behavior of any rule.
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Multi-line tablespace option string passes <$_>";

    ok
      $/<_ts_option>.elems == 4,
      'Match<_ts_option> has 4 elements';
    ok
      $/<_ts_option>[0] eq 'AUTOEXTEND_SIZE EQ 27',
      "First Match<...><_ts_option> matches 'AUTOEXTEND_SIZE EQ 27'";
    ok
      $/<_ts_option>[1] eq 'COMMENT EQ "text string"',
      'Second Match<...><_ts_option> matches "COMMENT EQ \'text string\'"';
    ok
      $/<_ts_option>[2] eq 'EXTENT_SIZE EQ 28',
      'Third Match<...><_ts_option> matches \'EXTENT_SIZE EQ 28\'';
    # Eliminate embeddded newline.
    ok
      $/<_ts_option>[3].chomp eq 'FILE_BLOCK_SIZE EQ 29',
      'Fourth Match<...><_ts_option> matches \'FILE_BLOCK_SIZE EQ 29\'';
  }

  # <AUTOEXTEND_SIZE> <EQ>? <number>
  when 'ts_autoextend_size' {
    my $t = 'AUTOEXTEND_SIZE EQ 26';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without EQ";

    $t ~~ s/\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without = or EQ";

    $t ~~ / ('AUTOEXTEND_SIZE') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  # <COMMENT> <EQ>? <text_string>
  when 'ts_comment' {
    my $t = 'COMMENT EQ "text string"';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without EQ";

    $t ~~ s/\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without EQ";

    $t ~~ / ('COMMENT') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  # <STORAGE>? <ENGINE> <EQ>? $<engine>=[ <text> || <_ident> ]
  when 'ts_engine' {
    for ('"this is text"', '@identifier') -> $term {
      my $t = "STORAGE ENGINE EQ $term";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_>";

      ok $/<engine> eq $term, "Match<engine> matches '$term'";

      $t ~~ s/EQ/=/;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_> with '=' instead of 'EQ'";

      $t ~~ s/\=//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_> without '=' or 'EQ'";

      $t ~~ s/'STORAGE '//;
      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_> without STORAGE";

      $t ~~ / ('ENGINE') /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  # <EXTENT_SIZE> <EQ>? <number>
  when 'ts_extent_size' {
    my $t = "EXTENT_SIZE EQ 27";

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> with '=' instead of 'EQ'";

    $t ~~ s/\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without '=' or 'EQ'";

    $t ~~ / ('EXTENT_SIZE') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  # <FILE_BLOCK_SIZE> <EQ>? <number>
  when 'ts_file_block_size' {
    my $t = 'FILE_BLOCK_SIZE EQ 28';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> with '=' instead of 'EQ'";

    $t ~~ s/\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without '=' or 'EQ'";

    $t ~~ / ('FILE_BLOCK_SIZE') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  # <INITIAL_SIZE> <EQ>? <number>
  when 'ts_initial_size' {
    my $t = 'INITIAL_SIZE EQ 29';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> with '=' instead of 'EQ'";

    $t ~~ s/\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without '=' or 'EQ'";

    $t ~~ / ('INITIAL_SIZE') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  when 'ts_max_size' {
    my $t = 'MAX_SIZE EQ 30';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> with '=' instead of 'EQ'";

    $t ~~ s/\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without '=' or 'EQ'";

    $t ~~ / ('MAX_SIZE') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  when 'ts_nodegroup' {
    my $t = 'NODEGROUP EQ 30';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/EQ/=/;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> with '=' instead of 'EQ'";

    $t ~~ s/\=//;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_> without '=' or 'EQ'";

    $t ~~ / ('NODEGROUP') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "Mutated '$t' fails <$_>";
  }

  when 'ts_wait' {
    for <WAIT NO_WAIT> -> $term {
      my $t =  $term;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "Mutated '$t' fails <$_>";
    }
  }

  when 'row_types' {
    for <DEFAULT FIXED DYNAMIC COMPRESSED REDUNDANT COMPACT> -> $term {
      my $t = $term;

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' passes <$_>";

      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
      nok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
        "'$t' fails <$_>";
    }
  }

  when 'use_partition' {
    my $t = 'PARTITION (@identifier, "text string", field)';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    ok
      $/<using_list><_ident> == 3,
      'Match<using_list><ident> has 3 items';
    ok
      $/<using_list><_ident>[0] eq '@identifier',
      "First item in Match...<_ident> matches '\@identifier'";
    ok
      $/<using_list><_ident>[1] eq '"text string"',
      "Second item in Match...<_ident> matches '\"text string\"'";
    ok
      $/<using_list><_ident>[2] eq 'field',
      "Third item in Match...<_ident> matches 'field'";

    $t ~~ / ('PARTITION') /;
    my $tm := $t.substr-rw(0, $0.to);
    $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('0'..'9').pick;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' fails <$_>";
  }

  # <_ident>+ % ','
  when 'using_list' {
    my $t = '@identifier, "text string", field';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    ok $/<_ident> == 3, 'Match<ident> has 3 items';
    ok
      $/<_ident>[0] eq '@identifier',
      "First item in Match...<_ident> matches '\@identifier'";
    ok
      $/<_ident>[1] eq '"text string"',
      "Second item in Match...<_ident> matches '\"text string\"'";
    ok
      $/<_ident>[2] eq 'field',
      "Third item in Match...<_ident> matches 'field'";
  }

}
