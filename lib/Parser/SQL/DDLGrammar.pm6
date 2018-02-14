use v6.c;

grammar DDLGrammar {
  token TOP { }

  token EQ          { '=' }

  token ASC         { 'ASC' }
  token BTREE       { 'BTREE' }
  token CHAR        { 'CHAR' }
  token CHARSET     { 'CHARSET' }
  token COMMENT     { 'COMMENT' }
  token COMPACT     { 'COMPACT' }
  token COMPRESSED  { 'COMPRESSED' }
  token COMPRESSION { 'COMPRESSION' }
  token CONNECTION  { 'CONNECTION' }
  token DATA        { 'DATA' }
  token DATABASE    { 'DATABASE' }
  token DEFAULT     { 'DEFAULT' }
  token DESC        { 'DESC' }
  token DIRECTORY   { 'DIRECTORY' }
  token DISK        { 'DISK' }
  token DYNAMIC     { 'DYNAMIC' }
  token ENCRYPTION  { 'ENCRYPTION' }
  token ENGINE      { 'ENGINE' }
  token EXISTS      { 'EXISTS' }
  token FIRST       { 'FIRST' }
  token FIXED       { 'FIXED' }
  token FOREIGN     { 'FOREIGN' }
  token FULL        { 'FULL' }
  token FULLTEXT    { 'FULLTEXT' }
  token HASH        { 'HASH' }
  token GROUP       { 'GROUP' }
  token IF          { 'IF' }
  token INDEX       { 'INDEX' }
  token KEY         { 'KEY' }
  token LAST        { 'LAST' }
  token LIKE        { 'LIKE' }
  token LOGFILE     { 'LOGFILE' }
  token MATCH       { 'MATCH' }
  token MEMORY      { 'MEMORY' }
  token NO          { 'NO' }
  token NOT         { 'NOT' }
  token ON          { 'ON' }
  token PARTIAL     { 'PARTIAL' }
  token PASSWORD    { 'PASSWORD' }
  token PRIMARY     { 'PRIMARY' }
  token REDUNDANT   { 'REDUNDANT' }
  token REFERENCES  { 'REFERENCES' }
  token RTREE       { 'RTREE' }
  token SERVER      { 'SERVER' }
  token SET         { 'SET' }
  token SIMPLE      { 'SIMPLE' }
  token SPACIAL     { 'SPACIAL' }
  token STORAGE     { 'STORAGE' }
  token TABLE       { 'TABLE' }
  token TABLESPACE  { 'TABLESPACE' }
  token TEMPORARY   { 'TEMPORARY' }
  token TYPE        { 'TYPE' }
  token UNION       { 'UNION' }
  token UNIQUE      { 'UNIQUE' }
  token USER        { 'USER' }
  token USING       { 'USING' }


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

  rule EXISTS { <IF> <NOT> <EXISTS> }

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
        <MAX_ROWS> | <MIN_ROWS>      | <AUTO_INC>       | <AVG_ROW_LENGTH> |
        <CHECKSUM> | <TABLE_CHECSUM> | <DELAY_KEY_WRITE | <KEY_BLOCK_SIZE>
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
      <DEFAULT>? <charset> <EQ>? [ <char_id=.ident | <char_txt=.text> ]
      |
      <DEFAULT>? <COLLATE> <EQ>? [ <collate_id=.ident | <collate_txt=.text> ]
      |
      <INSERT_METHOD> <EQ>? [ <NO> | <FIRST> | <LAST> ]
      |
      <TABLESPACE> <EQ>? <ts_ident=.ident>
      |
      <STORAGE> [ <DISK> | <MEMORY> ]
    ]
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
    #...
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
    'CREATE' [
        <TEMPORARY>? <TABLE> <EXISTS>? <table_ident> [
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
        <DATABASE> <EXISTS>? <ident> <create_database_opts>?
        |
        <USER> <exists>?
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

};
