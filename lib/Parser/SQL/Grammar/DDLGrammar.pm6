use v6.c;

use Parser::SQL::Grammar::Tokens;

grammar Parser::SQL::Grammar::DDLGrammar {
  token TOP { <CREATE_ST> }

  rule alter_algo_option {
    <ALGORITHM> <EQ>? $<o>=[ <DEFAULT> || <_ident> ]
  }

  rule alter_lock_option {
    <LOCK> <EQ>? $<o>=[ <DEFAULT> || <_ident> ]
  }

  rule attribute {
    <NOT>? <NULL>
    ||
    <DEFAULT> $<o>=[ <now> || <num> || <literal> ]
    ||
    <ON> <UPDATE> <now>
    ||
    <AUTO_INC>
    ||
    <SERIAL> <DEFAULT> <VALUE>
    ||
    <PRIMARY>? <KEY>
    ||
    <UNIQUE> <KEY>?
    ||
    <COMMENT> <comment_txt=text>
    ||
    <COLLATE> [ <collate_id=ident> || <collate_txt=text> ]
    ||
    <COLUMN_FORMAT> $<o>=[ <DEFAULT> | <FIXED> | <DYNAMIC> ]
    ||
    <STORAGE> $<o>=[ <DEFAULT> | <DISK> | <MEMORY> ]
  }

  rule bit_expr {
    <bit_expr> [
      <bit_ops> <bit_expr>
      |
      <plus_minus> [
        <bit_expr>
        |
        <INTERNAL> <expr> <interval>
      ]
    ]
    |
    <simple_expr>
  }

  rule bool_pri {
    <predicate> [
      <IS> <not2>? <NULL>
      |
      <comp_ops> [
        <predicate>
        |
        <all_or_any> '(' <subselect> ')'
      ]
    ]?
  }

  rule charset {
    <CHAR> <SET> | <CHARSET>
  }

  rule charset_name_or_default {
    <BINARY> || <DEFAULT> || <text> || <_ident>
  }

  rule create_select {
    <SELECT> <select_option>* <select_item_list> <table_expression>
  }

  rule derived_table_list {
    [ <table_ref> | '(' <_ident> <table_ref> ')' ]* % ','
  }

  rule escape {
    <ESCAPE> <simple_expr>
  }

  rule expr {
    [
      <expr> [ <or> | <XOR> | <and> ]
      ||
      <NOT>
    ] <expr>
    ||
    <bool_pri> [ <IS> <not2>? [ <TRUE> | <FALSE> | <UNKNOWN> ] ]?
  }

  rule expr_list {
    <expr>+ % ','
  }

  rule field_term {
    <COLUMNS> [
      $<t>=[ <TERMINATED> | <OPTIONALLY>? <ENCLOSED> | <ESCAPED> ]
      <BY> $<s>=<text_string>
    ]+
  }

  rule from_clause {
    <FROM> [ <derived_table_list> || <DUAL> ]
  }

  rule generated_always {
    <GENERATED> <ALWAYS>
  }

  rule group_clause {
    <GROUP> <BY> <order_expr>+ % ',' [ <WITH_CUBE> | <WITH_ROLLUP> ]?
  }

  rule having_clause {
    <HAVING> <expr>
  }

  rule index_lock_algo {
    <alter_lock_option> <alter_algo_option>?
    |
    <alter_algo_option> <alter_lock_option>?
  }

  rule if_not_exists {
    <IF> <NOT> <EXISTS>
  }

  rule limit_clause {
    <LIMIT> <limit_options> [ [ ',' | <OFFSET> ] <limit_options> ]?
  }

  rule line_term {
    <LINES> [ $<t>=[ <TERMINATED> | <STARTING> ] <BY> $<s>=<text_string> ]+
  }

  rule literal {
    <underscore_charset>? <text>
    ||
    'N'<text>
    ||
    <num>
    ||
    [ <DATE> | <TIME>  | <TIMESTAMP> ] <text>
    ||
    [ <NULL> | <FALSE> | <TRUE> ]
    ||
    <underscore_charset>? [ <hex_num> || <bin_num> ]
  }

  rule load_data_charset {
    <charset> <charset_name_or_default>
  }

  rule lock_expire_opts {
    <ACCOUNT> [ <UNLOCK> | <LOCK> ]
    |
    <PASSWORD> <EXPIRE> [
      <INTERVAL> <num> <DAY>
      |
      [ <NEVER> | <DEFAULT> ]
    ]
  }

  rule order_expr    {
    <expr> <order_dir>
  }

  rule order_clause {
    <ORDER> <BY> <order_expr>+ % ','
  }

  rule order_or_limit {
    <order_clause> <limit_clause>?
    |
    <limit_clause>
  }

  rule predicate {
    :my rule _in_expr { <IN> '(' [ <subselect> || <expr_list> ] ')' }
    [
      <AND> <bit_expr> <BETWEEN> <not2>?
      |
      <bit_expr>
    ]
    [
      <_in_expr>
      |
      <not2> [
        <_in_expr>
        |
        <LIKE> <simple_expr> <escape>?
        |
        <REGEXP> <bit_expr>
      ]
      |
      [ <SOUNDS> <LIKE> | <REGEXP> ] <bit_expr>
      |
      <LIKE> <simple_expr> <escape>?
    ]?
  }

  rule procedure_analyse_clause {
    <PROCEDURE> <ANALYSE> '(' [ <num> [ ',' <num> ]? ]? ')'
  }

  rule query_spec {
    <SELECT> <select_part2_derived> <table_expression>
    |
    '(' <select_paren_derived> ')' <order_or_limit>?
  }

  rule select_item {
    <table_wild> | <expr> <select_alias>
  }

  rule select_item_list {
    [ <select_item> || '*' ] [ ',' <select_item>+ % ',' ]?
  }

  rule select_lock_type {
    <FOR> <UPDATE>
    |
    <LOCK> <IN> <SHARE> <MODE>
  }

  rule select_option {
    <query_spec_option> || <SQL_NO_CACHE> || <SQL_CACHE>
  }

  rule select_paren_derived {
    <SELECT> <select_part2_derived> <table_expression>
    |
    '(' <select_paren_derived> ')'
  }

  rule _into {
    :my rule __select_var_ident { '@'? [ <_ident> | <text> ] }
    <INTO> [
      <OUTFILE> <text> <load_data_charset>? <field_term>? <line_term>?
      |
      <DUMPFILE> <text>
      |
      <__select_var_ident>+ % ','
    ]
  }

  rule select_part2 {
    <select_option> <select_item_list>
    [
      <order_clause>? <limit_clause>?
      |
      <_into>
      |
      <_into>?
        <from_clause>
        <where_clause>?
        <group_clause>?
        <having_clause>?
        <order_clause>?
        <limit_clause>?
        <procedure_analyse_clause>?
        <_into>?
        <select_lock_type>?
    ]
  }

  rule select_part2_derived {
    <query_spec_option>? <select_item_list>
  }

  rule simple_ident_nospvar {
    <_ident> | <simple_ident_q>
  }

  rule table_alias {
    [ <AS> || <EQ> ] <_ident>
  }

  rule table_expression {
    <from_clause>?
    <where_clause>?
    <group_clause>?
    <having_clause>?
    <order_clause>?
    <limit_clause>?
    <procedure_analyse_clause>?
    <select_lock_type>?
  }

  rule table_factor {
    <table_ident> <use_partition>? <table_alias>? <key_def>?
    ||
    <SELECT> <select_option>* <select_item_list> <table_expression>
    ||
    '(' <derived_table_list> <order_or_limit>?
    [ <UNION> <union_opt>? <query_spec> ]*
    ')' <table_alias>?
  }

  rule _join_table {
    :my rule __onexpr { <ON> <expr> };
    <table_ref> [
      [ <INNER> || <CROSS> ]? <JOIN> <table_ref> [
        <__onexpr>
        ||
        <USING> '(' <using_list> ')'
      ]?
      ||
      <STRAIGHT_JOIN> <table_factor> <__onexpr>?
      ||
      <NATURAL> [ [ <LEFT> || <RIGHT> ] <OUTER>? ]? <JOIN> <table_factor>
      ||
      [ <LEFT> || <RIGHT> ] <OUTER>? <JOIN> [
       <table_ref> <__onexpr>
       ||
       <table_factor> <USING> '(' <using_list> ')'
     ]
    ]
  }

  rule table_ref {
    <table_factor> | <_join_table>
  }

  rule table_wild {
    <_ident> '.' [ <_ident> '.' ]? '*'
  }

  rule where_clause {
    <WHERE> <expr>
  }

  token row_types {
    <DEFAULT> | <FIXED> | <DYNAMIC> | <COMPRESSED> | <REDUNDANT> | <COMPACT>
  }

  rule _cast_type {
    [ <BINARY> | <NCHAR> ] [ '(' <number> ')' ]?
    |
    <CHAR> [ '(' <number> ')' ]? <BINARY>?
    |
    [ <SIGNED> | <UNSIGNED> ] <INT>?
    |
    <DATE>
    |
    [ <TIME> | <DATETIME> ] [ '(' <number> ')' ]?
    |
    <DECIMAL> [
      '(' [
        <m=number> [ ',' <d=number> ]?
      ] ')'
    ]?
    |
    <JSON>
  }

  rule __ws_list_item { <number> <!before '-'> <order_dir>? <REVERSE>? };
  rule __ws_nweights  { '(' <number> ')' };

  rule __ws_levels {
    <LEVEL> $<ws_list>=[
      <__ws_list_item>+ % ','
      ||
      <number> '-' <number>
    ]
  }

  rule _con_function_call {
    [
      [
        [ <ASCII>   || <CHARSET> || <COLLATION> || <MICROSECOND> || <PASSWORD> ||
          <QUARTER> || <REVERSE> ] '('
        |
        [
          [ <IF> || <REPLACE> ] '('  <expr> ','
          |
          [ <MOD> || <REPEAT> || <TRUNCATE> ] '('
        ] <expr> ','
        |
        [ <FORMAT>  '(' <expr> ','
          |
          <WEEK> '('
        ] <expr> ','?
      ] <expr>
      ||
      <COALESCE> '(' <expr_list>
      ||
      [ <DATABASE> || <ROW_COUNT> ] '('
      ||
      <WEIGHT_STRING> '(' <expr> [
        <__ws_levels>?
        ||
        ',' <number> ',' <number> ',' <number>
        ||
        <AS> [
          <CHAR> <__ws_nweights> <__ws_levels>?
          ||
          <BINARY> <__ws_nweights>
        ]
      ]
      ||
      [ <CONTAINS> || <POINT> ] '(' <expr> ',' <expr>
      ||
      <GEOMETRYCOLLECTION> '(' <expr_list>?
      ||
      [ <LINESTRING> || <MULTILINESTRING> || <MULTIPOINT> || <MULTIPOLYGON> ||
        <POLYGON> ]
      '(' <expr_list>
    ] ')'
  }

  rule _key_function_call {
    [
      <CHAR> '(' <expr_list> [ USING <charset_name=ident> ]? ')'
      |
      [
        [ <DATE> || <DAY> || <HOUR> || <MINUTE> || <MONTH> || <SECOND> ||
          <TIME> || <YEAR>
        ]
        |
        [
          <INSERT> '(' <expr> ',' <expr> ','
          |
          [ <LEFT> || <RIGHT> ] '('
        ] <expr> ','
        |
        <TIMESTAMP> '(' [ <expr> ',' ]?
        |
        <TRIM> '(' [
          <expr>
          |
          [ <LEADING> || <TRAILING> || <BOTH> ] <expr>?
        ] <FROM>
      ] <expr>
      |
      <USER> '('
      |
      <INTERVAL> '(' <expr> ',' <expr> [ ',' <expr_list> ]?
    ] ')'
    |
    <CURRENT_USER> [ '(' ')' ]?
  }

  rule _gen_function_call {
    [
      <ident_sys> '(' <udf_expr>+ % ','
      |
      <_ident> '.' <_ident> '(' <expr_list>
    ] ')'
  }

  rule _nonkey_function_call {
    :my token _precision { '(' <num> ')'  };
    [
      [ <ADDDATE> || <SUBDATE> ] '(' <expr> ',' [
        <expr> | <INTERVAL> <expr> <interval>
      ]
      ||
      [ <DATE_ADD> | <DATE_SUB> ] '(' <expr> ',' <INTERVAL> <expr> <interval>
      ||
      [
        <EXTRACT> '(' <interval> <FROM>
        ||
        [
          <GET_FORMAT> [ <DATE> || <TIME> || <TIMESTAMP> || <DATETIME> ]
          ||
          [ <TIMESTAMP_ADD> || <TIMESTAMP_DIFF> ] '(' <interval_time_stamp> ','
          <expr>
        ] ','
        ||
        <POSITION> '(' <bit_expr> <IN>
        ||
        <SUBSTRING> '(' <expr> [
          ',' [ <expr> ',' ]?
          ||
          <FROM> [ <expr> <FOR> ]?
        ]
      ] <expr>
    ] ')'
    ||
    [ <CURDATE> || <UTC_DATE> ] [ '(' ')' ]?
    ||
    [ <CURTIME> || <SYSDATE> || <UTC_TIME> || <UTC_TIMESTAMP> ] <_precision>?
    ||
    <NOW> <_precision>?
  }

  rule _when_clause {
    <WHEN> <when_expr=expr> <THEN> <then_expr=expr>
  }

  rule simple_expr {
    :my rule _ident_list { <simple_ident>+ % ',' };
    <simple_ident> [ <JSON_SEPARATOR> || <JSON_UNQ_SEPEARATOR> ] <text>
    |
    <_key_function_call>
    |
    <_nonkey_function_call>
    |
    <_gen_function_call>
    |
    <_con_function_call>
    |
    <simple_expr> [
      <COLLATE> [ <_ident> || <text> ]
      ||
      <OR2> <simple_expr>
    ]
    |
    <literal>
    |
    <PARAM_MARK>
    |
    <variable>
    |
    <sum_expr>
    |
    [ <PLUS> || <MINUS> || <BIT_NOT> || <NOT> || <NOT_OP> || <BINARY> ]
    <simple_expr>
    |
    [
      '(' [ <subselect> | <expr> [ ',' <expr_list> ]* ]
      |
      <ROW> '(' <expr> ',' <expr_list>
      |
      <EXISTS> '(' <subselect>
      |
      <MATCH> [  <_ident_list> | '(' <_ident_list> ')' ] <AGAINST> '('
      <bit_expr> [
        [ <IN> <NATURAL> <LANGUAGE> <MODE> ]?
        [ <WITH> <QUERY> <EXPANSION> ]?
        ||
        <IN> <BOOLEAN> <MODE>
      ]
      <CAST> '(' <expr> <AS> <_cast_type> ')'
      |
      <DEFAULT> '(' <simple_ident>
      |
      <VALUES> '(' <simple_ident_nospvar>
      |
      <CONVERT> '(' <EXPR> [
        ',' <_cast_type>
        ||
        <USING> <charset_name=.ident>
      ]
    ] ')'
    |
    '(' <_ident> <expr> ')'
    |
    <CASE> <expr>?
    <_when_clause>+
    [ <ELSE> <else_expr=.expr> ]? <END>
    |
    <INTERVAL> <expr> <interval> '+' <expr>
  }

  my rule _gorder_clause {
    <ORDER> <BY> <order_expr>+ % ','
  }

  rule sum_expr {
    :my rule _in_sum_expr { <ALL>? <expr> }
    [
      [
        $<op>=[ <AVG> || <MIN> || <MAX> || <SUM> ] '(' <DISTINCT>?
        |
        $<op>=[ <BIT_AND>     || <BIT_OR>      || <BIT_XOR> || <STD> ||
                <VARIANCE>    || <STDDEV_SAMP> || <VAR_SAMP> ]
      '('
     ] <_in_sum_expr>
     |
     <GROUP_CONCAT> '(' <DISTINCT>? <expr_list> <_gorder_clause>?
     [ <SEPARATOR> <text> ]?
     |
     <COUNT> '(' [ <ALL>? | <_in_sum_expr> | <DISTINCT> <expr_list> ]
   ] ')'
 }

  rule table_list {
    <table_ident>+ % ','
  }

  rule udf_expr {
    <expr> <select_alias>
  }

  rule use_partition {
    <PARTITION> '(' <using_list> ')'
  }

  rule using_list {
    <_ident>+ % ','
  }

  rule variable {
    '@' [
      [ <_ident> | <text> ] [ <SET> <expr> ]?
      |
      '@' [ <GLOBAL> || <LOCAL> || <SESSION> ] '.'
      [ <_ident> | <text> ] [ '.' <_ident> ]?
    ]
  }

  rule create_table_opts {
    <create_table_opt>+ % ','
  }

  rule create_table_opt {
    <ENGINE> <EQ>? $<o>=[ <_ident> || <text> ]
    ||
    $<t_num>=[
      <MAX_ROWS>        |
      <MIN_ROWS>        |
      <AUTO_INC>        |
      <AVG_ROW_LENGTH>  |
      <CHECKSUM>        |
      <TABLE_CHECKSUM>  |
      <DELAY_KEY_WRITE> |
      <KEY_BLOCK_SIZE>
    ] <EQ>? <num>
    ||
    $<t_txt>=[
      <PASSWORD>    |
      <COMMENT>     |
      <COMPRESSION> |
      <ENCRYPTION>  |
      [ <DATA> | <INDEX> ] <DIRECTORY>
    ] <EQ>? <text>
    ||
    $<t_o>=[
      <PACK_KEYS>         |
      <STATS_AUTO_RECALC> |
      <STATS_PERSISTENT>  |
      <STATS_SAMPLE_PAGES>
    ] <EQ>? $<o>=[ <number> || <DEFAULT> ]
    ||
    <ROW_FORMAT> <EQ>? <row_types>
    ||
    <UNION> <EQ>? '(' <table_list>? ')'
    ||
    <DEFAULT>? <charset> <EQ>? $<o>=[ <text> || <_ident> ]
    ||
    <DEFAULT>? <COLLATE> <EQ>? $<o>=[ <text> || <_ident> ]
    ||
    <INSERT_METHOD> <EQ>? $<o>=[ <NO> | <FIRST> | <LAST> ]
    ||
    <TABLESPACE> <EQ>? <ts_ident=ident>
    ||
    <STORAGE> $<o>=[ <DISK> | <MEMORY> ]
  }

  rule check_constraint {
    <CHECK> '(' <expr> ')'
  }

  rule collate_explicit {
    <COLLATE> $<o>=[ <_ident> || <text> ]
  }

  rule constraint {
    <CONSTRAINT> <field_ident>
  }

  rule create_field_list {
    <field_list_item>+ % ','
  }

  rule field_list_item {
    <col_def> | <key_def>
  }

  rule field_def {
    <type> [
      <attribute>?
      |
      <collate_explicit>?
      <generated_always>?
      <AS> '(' <expr> ')'
      [ <VIRTUAL> || <STORED> ]?
      [ <gcol_attr>+ ]?
    ]
  }

  rule field_spec {
    <field_ident> <field_def>
  }

  rule gcol_attr {
    <UNIQUE> <KEY>?
    |
    <COMMENT> <text>
    |
    <not2>? <NULL>
    |
    <PRIMARY>? <KEY>
  }

  rule now {
    <NOW> || <signed_literal>
  }

  rule col_def {
    <field_spec> [ <check_constraint>? | <references> ]
  }

  rule key_def {
    <key_or_index> <_ident>? <key_alg> '(' <key_lists> ')' <normal_key_options>?
    |
    <FULLTEXT> <key_or_index>? <_ident>? '(' <key_lists> ')'
    <fulltext_key_opt>?
    |
    <SPACIAL> <key_or_index>? <_ident>? '(' <key_lists> ')'
    <spacial_key_opt>?
    |
    <constraint>? [
      <constraint_key_type> <_ident>? <key_alg> '(' <key_lists> ')' <normal_key_options>?
      |
      <FOREIGN> <KEY> <_ident>? '(' <key_lists> ')' <references>
      |
      <check_constraint>
    ]
  }

  rule part_field_list {
    <_ident>+ % ','
  }

  rule part_type_def {
    <LINEAR>? [
      <KEY> [ <ALGORITHM> <EQ> <num> ]?
      '(' <part_field_list> ')'
      |
      <HASH> '(' <bit_expr> ')'
    ]
    |
    [ <RANGE> || <LIST> ] [
      '(' <bit_expr> ')' | <COLUMNS> '(' <part_field_list> ')'
    ]
  }

  rule type {
    $<t>=[ <INT> | <TINYINT> | <SMALLINT> | <MEDIUMINT> | <BIGINT> | <YEAR> ]
    [ '(' <num> ')' ]?
    ||
    $<t>=[ <REAL> | <DOUBLE> <PRECISION>? ]
    ||
    $<t>=[ <FLOAT> | <DECIMAL> | <NUMERIC> | <FIXED> ]
    [
      '(' [ <m=number> ] ')'
      ||
      '(' [ <m=number> ',' <d=number> ] ')'
    ]? [ $<o>=[ <SIGNED> | <UNSIGNED> | <ZEROFILL> ] ]*
    ||
    $<t>=[ <BIT> | <BINARY> ] '(' <num> ')'
    ||
    $<t>=[ <BOOL> | <BOOLEAN> ]
    ||
    [
      $<t>=[ <CHAR> | <VARCHAR> ] '(' <num> ')'
      |
      <t=TINYTEXT>
      |
      <t=TEXT> [ '(' <num> ')' ]?
      |
      <t=MEDIUMTEXT>
      |
      <t=LONGTEXT>
      |
      $<t>=[ <ENUM> | <SET> ] '(' <text>+ % ',' ')'
    ]
    $<b>=[
      [ <ASCII> <BINARY>? ] || [<BINARY> <ASCII> ]
      |
      [ <UNICODE> <BINARY>? ] || [ <BINARY> <UNICODE> ]
      |
      <BYTE>
      |
      <charset> [ <text> || <_ident> ] <BINARY>?
      |
      <BINARY>? <charset> [ <text> || <_ident> ]
    ]?
    ||
    [
      $<t>=[ <NCHAR> | <NATIONAL> <CHAR> ] [ '(' <num> ')' ]?
      |
      [
        $<t>=[ <NATIONAL>  [ <VARCHAR> ] | [ <CHAR> <VARYING> ] ]
        |
        <t=NVARCHAR>
        |
        $<t>=[ <NCHAR> [ <VARCHAR> | <VARYING> ] ]
      ]
    ] <BINARY>?
    ||
    <t=DATE>
    ||
    $<t>=[ <TIME> | <TIMESTAMP> | <DATETIME> ] [ '(' <num> ')' ]?
    ||
    <t=TINYBLOB>
    ||
    <t=BLOB> [ '(' <num> ')' ]?
    ||
    $<t>=[
      <GEOMETRY>           |
      <GEOMETRYCOLLECTION> |
      <POINT>              |
      <MULTIPOINT>         |
      <LINESTRING>         |
      <MULTILINESTRING>    |
      <POLYGON>            |
      <MULTIPOLYGON>
    ]
    ||
    $<t>=[ <MEDIUMBLOB> | <LONGBLOB> ]
    ||
    <t=LONG> $<o>=[
      <VARBINARY>
      |
      [ <CHAR> <VARYING> | <VARCHAR> ]? <b=BINARY>?
    ]
    ||
    <t=SERIAL>
    ||
    <t=JSON>
  }

  # XXX - Check this for completeness
  rule all_key_opt {
    <KEY_BLOCK_SIZE> <EQ>? <num> | <COMMENT> <text>
  }

  rule constraint_key_type {
    <PRIMARY> <KEY> | <UNIQUE> <key_or_index>
  }

  rule connect_opts {
    <WITH> <_limits>
  }

  rule create_database_opts {
    <default_collation> | <default_charset>
  }

  rule create_partitioning {
    <PARTITION> <BY> <part_type_def>
    [<PARTITIONS> <number>]?  <sub_part>?
    [ '(' <part_definition>+ % ',' ')' ]?
  }

  rule default_charset {
    <DEFAULT>? <charset> <EQ>? [ <_ident> || <text> ]
  }

  rule default_collation {
    <DEFAULT>? <COLLATE> <EQ>? [ <_ident> || <text> ]
  }

  rule delete_option {
    <RESTRICT>
    |
    <CASCADE>
    |
    <SET> [ <NULL> | <DEFAULT> ]
    |
    <NO> <ACTION>
  }

  rule fulltext_key_opt {
    [ <all_key_opt> || <WITH> <PARSER> <ident_sys> ]
  }

  rule grant_opts {
    <GRANT> <OPTION> | <_limits>
  }

  rule key_alg {
    [ <USING> | <TYPE> ]
    [ <BTREE> | <RTREE> | <HASH> ]
  }

  rule key_list {
    <_ident> [ '(' <num> ')' ]?  <order_dir>
  }

  rule key_lists {
    <key_list>+ % ','
  }

  rule _limits {
    [
      <MAX_QUERIES_PER_HOUR>     |
      <MAX_UPDATES_PER_HOUR>     |
      <MAX_CONNECTIONS_PER_HOUR> |
      <MAX_USER_CONNECTIONS>
    ] <num>
  }

  rule logfile_group_info {
    <lf_group_id=_ident> <ADD> [ <UNDOFILE> | <REDOFILE> ] <file_text=text>
    # Not using % here because of optional delimiter.
    [ <logfile_group_option> [ ','? <logfile_group_option> ]* ]?
  }

  rule logfile_group_option {
    <INITIAL_SIZE> <EQ>? [ <num> || <ident_sys> ]
    |
    <MAX_SIZE> <EQ>? [ <num> || <ident_sys> ]
    |
    <EXTENT_SIZE> <EQ>? [ <num> || <ident_sys> ]
    |
    <UNDO_BUFFER_SIZE> <EQ>? [ <num> || <ident_sys> ]
    |
    <REDO_BUFFER_SIZE> <EQ>? [ <num> || <ident_sys> ]
    |
    <NODEGROUP> <EQ>? <num>
    |
    <STORAGE>? <ENGINE> <EQ>? [ <storage_txt=text> || <storage_id=_ident> ]
    |
    [ <WAIT> || <NO_WAIT> ]
    |
    <COMMENT> <EQ>? <comment_txt=text>
  }

  rule match_clause {
    <MATCH> [ <FULL> | <PARTIAL> | <SIMPLE> ]
  }

  rule normal_key_options {
    <all_key_opt> || <key_alg>
  }

  rule on_update_delete {
    <ON> [
      <UPDATE> [ <delete_option> <ON> <UPDATE> ]?
      |
      <DELETE> [ <delete_option> <ON> <DELETE> ]?
    ] <delete_option>
  }

  rule part_definition {
    <PARTITION> <part_name=_ident>
    [
      <VALUES>
      [
        <LESS> <THAN> <part_func_max>
        ||
        <IN> <part_values_in>
      ]
    ]?
  }

  rule part_func_max {
    <MAX_VALUE> || <part_value_item>
  }

  rule part_value_expr_item {
    <MAX_VALUE> || <bit_expr>
  }

  rule part_value_item {
    '(' <part_value_expr_item>+ % ',' ')'
  }

  rule part_values_in {
    <part_value_item>
    |
    '(' <part_value_item>+ % ',' ')'
  }

  rule references {
    <REFERENCES> <table_ident> <ref_list>? <match_clause>? <on_update_delete>?
  }

  rule ref_list {
    '(' <_ident>+ % ',' ')'
  }

  rule require_clause {
    <REQUIRE> [
      # Not using % because of optional delimiter
      <require_list_element> [ <AND>? <require_list_element> ]*
      |
      [ <SSL> | <X509> | <NONE> ]
    ]
  }

  rule require_list_element {
    [ <SUBJECT> | <ISSUER> | <CIPHER> ] <text>
  }

  rule select_init {
    <SELECT> <select_part2> <union_list>?
    |
    '(' <select_paren> ')' <union_opt>?
  }

  rule select_paren {
    <SELECT> <select_part2>
    |
    '(' <select_paren> ')'
  }

  rule server_option {
    [ <USER> | <HOST> | <DATABASE> | <OWNER> | <PASSWORD> | <SOCKET> ]
    <text>
    ||
    <PORT> <num>
  }

  rule server_opts {
    <server_option>+ % ','
  }

  rule spacial_key_opt {
    <all_key_opt>
  }

  rule sub_part {
    <SUBPARTITION> <BY> <LINEAR>?
    [
      <HASH> '(' <bit_expr> ')'
      |
      <KEY> <key_alg>? '(' <_ident>+ % ',' ')'
    ] [ <SUBPARTITIONS> <number> ]?
  }

  rule tablespace_info {
    <ts_name=_ident> <ADD> <DATAFILE> <df_name=text>
    [ <USE> <LOGFILE> <GROUP> <grp_name=_ident> ]?
    <tablespace_option_list>
  }

  rule ts_initial_size {
    <INITIAL_SIZE> <EQ>? <number>
  }

  rule ts_autoextend_size {
    <AUTOEXTEND_SIZE> <EQ>? <number>
  }

  rule ts_comment {
    <COMMENT> <EQ>? <text_string>
  }

  rule ts_max_size {
    <MAX_SIZE> <EQ>? <number>
  }

  rule ts_extent_size {
    <EXTENT_SIZE> <EQ>? <number>
  }

  rule ts_nodegroup {
    <NODEGROUP> <EQ>? <ulong_num>
  }

  rule ts_engine {
    <STORAGE>? <ENGINE> <EQ>? $<engine>=[ <text> || <_ident> ]
  }

  rule ts_file_block_size {
    <FILE_BLOCK_SIZE> <EQ>? <number>
  }

  rule ts_wait {
    <WAIT> | <NO_WAIT>
  }

  rule tablespace_option_list {
    :my rule _ts_option {
      <ts_initial_size>     |
      <ts_autoextend_size>  |
      <ts_max_size>         |
      <ts_extent_size>      |
      <ts_nodegroup>        |
      <ts_engine>           |
      <ts_wait>             |
      <ts_comment>          |
      <ts_file_block_size>
    };
    <_ts_option>* % ','
  }

  rule create3 {
    [ <REPLACE> || <IGNORE> ]? <AS>? [
      <create_select> <union_list>?
      |
      '(' <create_select> ')' <union_opt>?
    ]
  }

  rule CREATE_ST {
    <_CREATE> [
        <TEMPORARY>? <TABLE> <if_not_exists>? <table_ident> [
          '(' [
            <create_field_list> ')' <create_table_opts>? <create_partitioning>? <create3>?
            |
            <create_partitioning>? <create_select> ')' <union_opt>?
            |
            <LIKE> <table_ident> ')'
          ]
          |
          <create_table_opts>? <create_partitioning>? <create3>?
          |
          <LIKE> <table_ident>
        ]
        |
        [
          <UNIQUE>? <INDEX> <idx_ident=_ident> <key_alg> 'ON' <table_ident> '(' <key_lists> ')' <normal_key_options>?
          |
          <FULLTEXT> <INDEX> <idx_ident=_ident> 'ON' <table_ident> '('
           <key_lists> ')' <fulltext_key_opt>?
          |
          <SPACIAL> <INDEX> <idx_ident=_ident> 'ON'  <table_ident> '('
           <key_lists> ')' <spacial_key_opt>?
        ] <index_lock_algo>?
        |
        <DATABASE> <if_not_exists>? <_ident> <create_database_opts>?
        |
        <USER> <if not exists>?
          <grant_opts>?
          <require_clause>
          <connect_opts>
          <lock_expire_opts>?
        |
        <LOGFILE> <GROUP> <logfile_group_info>
        |
        <TABLESPACE> <tablespace_info>
        |
        <SERVER>
          [ <server_ident=_ident> || <server_text=text> ]
          <FOREIGN> <DATA> <WRAPPER>
          [ <fdw_ident=_ident> || <fdw_text=text> ]
          <OPTIONS>
          '(' <server_opts> ')'
    ]
  }

  rule union_list {
    <UNION> <union_opt>? <select_init>
  }

  rule subselect {
    <union_opt>? <UNION>
    ||
    <query_spec>
  }

};

our sub MAIN is export {
  my $test = qq:to/SQL/;
  CREATE TABLE Persons (
      PersonID int,
      LastName varchar(255),
      FirstName varchar(255),
      Address varchar(255),
      City varchar(255)
  );
  SQL

  my $a = Parser::SQL::Grammar::DDLGrammar.parse($test);
  $a.gist.say;
}
