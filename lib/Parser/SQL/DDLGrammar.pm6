use v6.c;

grammar DDLGrammar {
  token TOP { <CREATE_ST> }

  token EQ          { 'EQ' || '='  }
  token GE          { 'GE' || '>=' }
  token GT          { 'GT' || '>' }
  token LE          { 'LE' || '<=' }
  token LT          { 'LT' || '<' }
  token NE          { 'NE' || '<>' }

  token MINUS       { '-' }
  token PLUS        { '+' }
  token SHIFT_L     { '<<' }
  token SHIFT_R     { '>>' }

  # Interval symbols
  token DAY		      { 'DAY' }
  token WEEK		    { 'WEEK' }
  token HOUR		    { 'HOUR' }
  token MINUTE		  { 'MINUTE' }
  token MONTH		    { 'MONTH' }
  token QUARTER		  { 'QUARTER' }
  token SECOND		  { 'SECOND' }
  token MICROSECOND	{ 'MICROSECOND' }
  token YEAR		    { 'YEAR' }

  token DAY_HOUR		       { 'DAY_HOUR' }
  token DAY_MICROSECOND		 { 'DAY_MICROSECOND' }
  token DAY_MINUTE		     { 'DAY_MINUTE' }
  token DAY_SECOND		     { 'DAY_SECOND' }
  token HOUR_MICROSECOND	 { 'HOUR_MICROSECOND' }
  token HOUR_MINUTE		     { 'HOUR_MINUTE' }
  token HOUR_SECOND		     { 'HOUR_SECOND' }
  token MINUTE_MICROSECOND { 'MINUTE_MICROSECOND' }
  token MINUTE_SECOND		   { 'MINUTE_SECOND' }
  token SECOND_MICROSECOND { 'SECOND_MICROSECOND' }
  token YEAR_MONTH         { 'YEAR_MONTH' }

  token interval {
    [
      <interval_time_stamp> ||
      <DAY_HOUR>            ||
      <DAY_MICROSECOND>     ||
      <DAY_MINUTE>          ||
      <DAY_SECOND>          ||
      <HOUR_MICROSECOND>    ||
      <HOUR_MINUTE>         ||
      <HOUR_SECOND>         ||
      <MINUTE_MICROSECOND>  ||
      <MINUTE_SECOND>       ||
      <SECOND_MICROSECOND>  ||
      <YEAR_MONTH>
    ]
  }

  token interval_time_stamp {
    [
      <DAY>    || <WEEK>        || <HOUR> || <MINUTE> || <MONTH> || <QUARTER> ||
      <SECOND> || <MICROSECOND> || <YEAR>
    ]
  }

  token all_or_any { <ALL> || <ANY> }
  token and        { <AND> || '&&' }
  token not        { <NOT> || '<>' }
  token or         {  <OR> || '||' }
  token plus_minus { <PLUS> || <MINUS> }

  token bit_ops {
    '|' || '&' || '*' || '/' || '%' || '^' ||
    <SHIFT_L> || <SHIFT_R> || <DIV> || <MOD>
  }

  token comp_ops {
    <EQ> || <GE> || <Gt> || <LE> || <LT> || <NE>
  }

  token ALL         { 'ALL' }
  token AND         { 'AND' }
  token ANY         { 'ANY' }
  token ACTION      { 'ACTION' }
  token ASC         { 'ASC' }
  token BETWEEN     { 'BETWEEN' }
  token BTREE       { 'BTREE' }
  token CASCADE     { 'CASCADE' }
  token CHAR        { 'CHAR' }
  token CHARSET     { 'CHARSET' }
  token COMMENT     { 'COMMENT' }
  token COMPACT     { 'COMPACT' }
  token COMPRESSED  { 'COMPRESSED' }
  token COMPRESSION { 'COMPRESSION' }
  token CONNECTION  { 'CONNECTION' }
  token CREATE      { 'CREATE' }
  token DATA        { 'DATA' }
  token DATABASE    { 'DATABASE' }
  token DEFAULT     { 'DEFAULT' }
  token DELETE      { 'DELETE' }
  token DESC        { 'DESC' }
  token DIRECTORY   { 'DIRECTORY' }
  token DISK        { 'DISK' }
  token DIV         { 'DIV' }
  token DYNAMIC     { 'DYNAMIC' }
  token ENCRYPTION  { 'ENCRYPTION' }
  token ENGINE      { 'ENGINE' }
  token ESCAPE      { 'ESCAPE' }
  token EXISTS      { 'EXISTS' }
  token FALSE       { 'FALSE' }
  token FIRST       { 'FIRST' }
  token FIXED       { 'FIXED' }
  token FOREIGN     { 'FOREIGN' }
  token FULL        { 'FULL' }
  token FULLTEXT    { 'FULLTEXT' }
  token HASH        { 'HASH' }
  token GROUP       { 'GROUP' }
  token IF          { 'IF' }
  token IN          { 'IN' }
  token INTENRAL    { 'INTERNAL' }
  token IS          { 'IS' }
  token INDEX       { 'INDEX' }
  token KEY         { 'KEY' }
  token LAST        { 'LAST' }
  token LIKE        { 'LIKE' }
  token LOGFILE     { 'LOGFILE' }
  token MATCH       { 'MATCH' }
  token mode        { 'MOD' }
  token MEMORY      { 'MEMORY' }
  token NO          { 'NO' }
  token NOT         { 'NOT' }
  token NULL        { 'NULL' }
  token ON          { 'ON' }
  token OR          { 'OR' }
  token PARTIAL     { 'PARTIAL' }
  token PASSWORD    { 'PASSWORD' }
  token PRIMARY     { 'PRIMARY' }
  token REDUNDANT   { 'REDUNDANT' }
  token REGEXP      { 'REGEXP' }
  token REFERENCES  { 'REFERENCES' }
  token RESTRICT    { 'RESTRICT' }
  token RTREE       { 'RTREE' }
  token SERVER      { 'SERVER' }
  token SET         { 'SET' }
  token SIMPLE      { 'SIMPLE' }
  token SOUNDS      { 'SOUNDS' }
  token SPACIAL     { 'SPACIAL' }
  token STORAGE     { 'STORAGE' }
  token TABLE       { 'TABLE' }
  token TABLESPACE  { 'TABLESPACE' }
  token TEMPORARY   { 'TEMPORARY' }
  token TRUE        { 'TRUE' }
  token TYPE        { 'TYPE' }
  token UPDATE      { 'UPDATE' }
  token UNION       { 'UNION' }
  token UNIQUE      { 'UNIQUE' }
  token UNKNOWN     { 'UNKNOWN' }
  token USER        { 'USER' }
  token USING       { 'USING' }
  token XOR         { 'XOR' }


  token INSERT_METHOD      { 'INSERT_METHOD' }
  token PACK_KEYS          { 'PACK_KEYS' }
  token ROW_FORMAT         { 'ROW_FORMAT' }
  token STATS_AUTO_RECALC  { 'STATS_AUTO_RECALC' }
  token STATS_PERSISTENT   { 'STATS_PERSISTENT' }
  token STATS_SAMPLE_PAGES { 'STATS_SAMPLE_PAGES' }

  token table_ident {
    <ns_ident=.ident>? ( '.' )? <tbl_ident=.ident>
  }

  token number { \d+ }
  token num    { <[+-]>? <whole=.number> [ '.' <dec=.number> ]? }

  token ident {
    # Can Identifier consist of a sole _, @ or #?
    <:Letter + [ _ @ # ]> <[ \w _ @ # $ ]>*
  }

  token text {
    [ "'" ( <-["]>+ ) "'" | "'" ( <-[']>+ ) "'"  ]
  }

  rule if_not_exists { <IF> <NOT> <EXISTS> }

  rule charset {
    [ <CHAR> <SET> | <CHARSET> ]
  }

  rule row_types {
    [ <DEFAULT> | <FIXED> | <DYNAMIC> | <COMPRESSED> | <REDUNDANT> | <COMPACT> ]
  }

  rule table_list {
    <table_ident> [ ',' <table_ident> ]*
  }

  rule create_table_opts {
    <create_table_opt> [ ',' <create_table_opt> ]*
  }

  rule create_table_opt {
    [
      <ENGINE> <EQ>? [ <engine_id=.itent> | <engine_txt=.text> ]
      |
      [
        <MAX_ROWS> | <MIN_ROWS>      | <AUTO_INC>        | <AVG_ROW_LENGTH> |
        <CHECKSUM> | <TABLE_CHECSUM> | <DELAY_KEY_WRITE> | <KEY_BLOCK_SIZE>
      ] <EQ>? <num>
      |
      [
        <PASSWORD> | <COMMENT> | <COMPRESSION> | <ENCRYPTION> |
        [ <DATA> | <INDEX> ] <DIRECTORY> |
        <CONNECTION>
      ] <EQ>? <text>
      |
      [
        <PACK_KEYS> | <STATS_AUTO_RECALC> | <STATS_PERSISTENT> |
        <STATS_SAMPLE_PAGES>
      ] <EQ>? [ <number> | <DEFAULT> ]
      |
      <ROW_FORMAT> <EQ>? <row_types>
      |
      <UNION> <EQ>? '(' <table_list>? ')'
      |
      <DEFAULT>? <charset> <EQ>? [ <char_id=.ident> | <char_txt=.text> ]
      |
      <DEFAULT>? <COLLATE> <EQ>? [ <collate_id=.ident> | <collate_txt=.text> ]
      |
      <INSERT_METHOD> <EQ>? [ <NO> | <FIRST> | <LAST> ]
      |
      <TABLESPACE> <EQ>? <ts_ident=.ident>
      |
      <STORAGE> [ <DISK> | <MEMORY> ]
    ]
  }

  rule check_constraint {
    <CHECK> '(' <expr> ')'
  }

  rule create_field_list {
    <field_list_item> [ ',' <field_list_item> ]*
  }

  rule field_list_item {
    [ <col_def> | <key_def> ]
  }

  rule col_def {
    <field_spec> [ <check_constraint>? | <references> ]
  }

  rule key_def {
    <key_or_index> <ident>? <key_alg> '(' <key_lists> ')' <normal_key_options>
    |
    <FULLTEXT> <key_or_index>? <ident>? '(' <key_lists> ')'
    <fulltext_key_opt>
    |
    <SPACIAL> <key_or_index>? <ident>? '(' <key_lists> ')'
    <spacial_key_opt>
    |
    <constraint>? [
      <constraint_key_type> <ident>? <key_alg> '(' <key_lists> ')' <normal_key_options>
      |
      <FOREIGN> <KEY> <ident>? '(' <key_lists> ')' <references>
      |
      <check_constraint>
    ]
  }



  rule all_key_opt {
    [ <KEY_BLOCK_SIZE> <EQ>? <num> | <COMMENT> <text> ]
  }

  rule constraint_key_type {
    [ <PRIMARY> <KEY> | <UNIQUE> <key_or_index> ]
  }

  rule delete_option {
    [
      <RESTRICT>
      |
      <CASCADE>
      |
      <SET> [ <NULL> | <DEFAULT> ]
      |
      <NO> <ACTION>
    ]
  }

  rule fulltext_key_opt {
    [ <all_key_opt> | <WITH> <PARSER> <ident_sys> ]?
  }

  rule normal_key_options {
    [ <all_key_opt> | <key_alg> ]?
  }

  rule spacial_key_opt {
    <all_key_opt>?
  }

  rule ident_sys {
    [ <ident> | '"' <ident> '"' | "'" <ident> "'" ]
  }

  rule key_alg {
    [ <USING> | <TYPE> ] [ <BTREE> | <RTREE> | <HASH> ]
  }

  rule key_list {
    <ident> [ '(' <num> ')' ]?  <order_dir>
  }

  rule key_lists {
    <key_list> [ ',' <key_list> ]*
  }

  rule key_or_index {
    [ <KEY> | <INDEX> ]
  }

  rule match_clause {
    <MATCH> [ <FULL> | <PARTIAL> | <SIMPLE> ]
  }

  rule on_update_delete {
    <ON> [
      <UPDATE> [ <delete_option> <ON> <UPDATE> ]?
      |
      <DELETE> [ <delete_option> <ON> <DELETE> ]?
    ] <delete_option>
  }

  rule order_dir {
    [ <ASC> | <DESC> ]
  }

  rule references {
    <REFERENCES> <table_ident> <ref_list>? <match_clause>? <on_update_delete>?
  }

  rule ref_list {
    [ '(' <ident> [ ',' <ident> ]* ')' ]?
  }

  rule CREATE_ST {
    <CREATE> [
        <TEMPORARY>? <TABLE> <if_not_exists>? <table_ident> [
          '(' [
            <create_field_list> ')' <create_table_opts>? <create_partitioning>? <create3>
            |
            <LIKE> <table_ident> ')'
          ]
          |
          <create_table_opts>? <create_partitioning>? <create3>
          |
          <LIKE> <table_ident>
        ]
        |
        [
          <UNIQUE>? <INDEX> <idx_ident=.ident> <key_alg> 'ON' <table_ident> '(' <key_lists> ')' <normal_key_options>
          |
          <FULLTEXT> <INDEX> <idx_ident=.ident> 'ON' <table_ident> '('
           <key_lists> ')' <fulltext_key_opt>
          |
          <SPACIAL> <INDEX> <idx_ident=.ident> 'ON'  <table_ident> '('
           <key_lists> ')' <spacial_key_opt>
        ] <index_lock_algo>?
        |
        <DATABASE> <if_not_exists>? <ident> <create_database_opts>?
        |
        <USER> <if not exists>?
          <clear_privs>
          <grant_opts>
          <require_opts>
          <connect_opts>
          <lock_expire_opts>?
        |
        <LOGFILE> <GROUP> <log_group>
        |
        <SERVER>
          [ <server_ident=.ident> | <server_text=.text> ]
          <FOREIGN> <DATA> 'WRAPPER'
          [ <fdw_ident=.ident> | <fdw_text=.text> ]
          'OPTIONS'
          '(' <server_opts> ')'
    ]
  }

  rule expr {
    [
      [
        <expr> [ <or> | <XOR> | <and> ]
        |
        <NOT>
      ] <expr>
      |
      <bool_pri> [ <IS> <not>? [ <TRUE> | <FALSE> | <UNKNOWN> ] ]?
    ]
  }

  rule bit_expr {
    [
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
    ]
  }

  rule bool_pri {
    <predicate> [
      <IS> <not>? <NULL>
      |
      <comp_ops> [
        <predicate>
        |
        <all_or_any> '(' <subselect> ')'
      ]
    ]?
  }

  rule escape {
    <ESCAPE> <simple_expr>
  }

  rule expr_list {
    <expr> [ ',' <expr> ]*
  }

  rule _in_expr {
    <IN> '(' [
      <subselect>
      |
      <expr_list>
    ] ')'
  }

  rule predicate {
    [
      <AND> <bit_expr> <BETWEEN> <not>?
      |
      <bit_expr>
    ]
    [
      <_in_expr>
      |
      <not> [
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

  simple_expr {
    # WHEEEEE!
    #...
  }

};
