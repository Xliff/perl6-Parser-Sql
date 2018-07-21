v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

my $count;
for Parser::SQL::Grammar::DDLGrammar.^methods(:local).map( *.name ).sort {
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
    order_clause
    order_expr
    order_or_limit
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

    $t ~~ s/ '.field' / field /;
    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    ($t = $t0) ~~ s/ 'field' //;
    nok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "Trailing '.' fails <$_>";
  }

  when 'create_field_list' {
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

  when 'derived_table_list' {
  }

  when 'field_list_item' {
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

  when 'from_clause' {
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
    my $t = 'GENERATED ALWAYS';

    ok
      Parser::SQL::Grammar::DDLGrammar.subparse( $t , :rule($_) ),
      "'$t' passes <$_>";

    $t ~~ s/ $( ('GENERATED ', ' ALWAYS').pick ) //;
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

  when 'limit_clause' {
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
