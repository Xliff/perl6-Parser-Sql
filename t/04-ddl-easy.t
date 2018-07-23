v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

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
    literal
    now
    order_clause
    order_expr
    order_or_limit
    part_type_def
    predicate
    query_spec
    row_types
    select_item
    select_item_list
    select_option
    select_paren_derived
    select_part2
    select_part2_derived
    simple_expr
    sum_expr
    table_expression
    table_factor
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

  when '_limits' {
    for <
      MAX_QUERIES_PER_HOUR
      MAX_UPDATES_PER_HOUR
      MAX_CONNECTIONS_PER_HOUR
      MAX_USER_CONNECTIONS
    > -> $term {
      my $t = "$term 17";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_> without 'EQ'";

      $t ~~ /^ ( $term ) /;
      my $tm := $t.substr-rw(0, $0.to);
      $t.substr-rw( (^$t.chars).pick, 1 ) = ('0'..'9').pick;
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

    $t ~~ s / 'EQ ' //;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
      "'$t' passes <$_> without 'EQ'";

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

  # Description has been expanded.
  # <DEFAULT>? <COLLATE> <EQ> [ <_ident> || <text> ]
  # |
  # <DEFAULT>? <charset> <EQ>? [ <_ident> || <text> ]
  when 'create_database_opts' {
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

  when 'grant_opts' {
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

  when 'key_list' {
  }

  when 'key_lists' {
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

  # <LINES> [ $<t>=[ <TERMINATED> || <STARTING> ] <BY> $<s>=<text_string> ]+
  when 'line_term' {
    for <TERMINATED STARTING> -> $term {
      my $t = "LINES $term BY 'text string'";

      ok
        Parser::SQL::Grammar::DDLGrammar.subparse( $t, :rule($_) ),
        "'$t' passes <$_>";

      $t ~~ / ('LINES' \s+ $term \s+ 'BY') /;
      my $tm := $t.substr-rw(0, $0.to);
      $tm.substr-rw( (^$tm.chars).pick, 1 ) = ('a'..'z').pick;
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
  # <STORAGE>? <ENGINE> <EQ>? [ <storage_id=ident> || <storage_txt=text> ]
  # |
  # [ <WAIT> || <NO_WAIT> ]
  # |
  # <COMMENT> <EQ>? <comment_txt=text>
  when 'logfile_group_option' {
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

  when 'row_types' {
  }

  when 'use_partition' {
  }

  when 'using_list' {
  }

  # Connect Opts in DDLGrammar

}
