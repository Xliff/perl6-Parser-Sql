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
    <EQ> || <GE> || <GT> || <LE> || <LT> || <NE>
  }

  token ACTION      { 'ACTION' }
  token ADD         { 'ADD' }
  token ALGORITHM   { 'ALGORITHM' }
  token ALL         { 'ALL' }
  token ALWAYS      { 'ALWAYS' }
  token AND         { 'AND' }
  token ANY         { 'ANY' }
  token AS          { 'AS' }
  token ASC         { 'ASC' }
  token BETWEEN     { 'BETWEEN' }
  token BTREE       { 'BTREE' }
  token BY          { 'BY' }
  token CASCADE     { 'CASCADE' }
  token CHAR        { 'CHAR' }
  token CHARSET     { 'CHARSET' }
  token CHECK       { 'CHECK' }
  token CHECKSUM    { 'CHECKSUM' }
  token CIPHER      { 'CIPHER' }
  token COLLATE     { 'COLLATE' }
  token COLUMNS     { 'COLUMNS' }
  token COMMENT     { 'COMMENT' }
  token COMPACT     { 'COMPACT' }
  token COMPRESSED  { 'COMPRESSED' }
  token COMPRESSION { 'COMPRESSION' }
  token CONNECTION  { 'CONNECTION' }
  token CONSTRAINT  { 'CONSTRAINT' }
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
  token HOST        { 'HOST' }
  token GENERATED   { 'GENERATED' }
  token GRANT       { 'GRANT' }
  token GROUP       { 'GROUP' }
  token IF          { 'IF' }
  token IN          { 'IN' }
  token INTERNAL    { 'INTERNAL' }
  token INDEX       { 'INDEX' }
  token IS          { 'IS' }
  token ISSUER      { 'ISSUER' }
  token KEY         { 'KEY' }
  token LAST        { 'LAST' }
  token LESS        { 'LESS' }
  token LIKE        { 'LIKE' }
  token LINEAR      { 'LINEAR' }
  token LIST        { 'LIST' }
  token LOGFILE     { 'LOGFILE' }
  token MATCH       { 'MATCH' }
  token MOD         { 'MOD' }
  token MEMORY      { 'MEMORY' }
  token NO          { 'NO' }
  token NODEGROUP   { 'NODEGROUP' }
  token NONE        { 'NONE' }
  token NOT         { 'NOT' }
  token NOW         { 'NOW' }
  token NULL        { 'NULL' }
  token ON          { 'ON' }
  token OPTION      { 'OPTION' }
  token OR          { 'OR' }
  token OWNER       { 'OWNER' }
  token PARSER      { 'PARSER' }
  token PARTIAL     { 'PARTIAL' }
  token PARTITION   { 'PARTITION' }
  token PARTITIONS  { 'PARTITIONS' }
  token PASSWORD    { 'PASSWORD' }
  token PORT        { 'PORT' }
  token PRIMARY     { 'PRIMARY' }
  token RANGE       { 'RANGE' }
  token REDOFILE    { 'REDOFILE' }
  token REDUNDANT   { 'REDUNDANT' }
  token REGEXP      { 'REGEXP' }
  token REFERENCES  { 'REFERENCES' }
  token REQUIRE     { 'REQUIRE' }
  token RESTRICT    { 'RESTRICT' }
  token RTREE       { 'RTREE' }
  token SERVER      { 'SERVER' }
  token SERIAL      { 'SERIAL' }
  token SET         { 'SET' }
  token SIMPLE      { 'SIMPLE' }
  token SOCKET      { 'SOCKET' }
  token SOUNDS      { 'SOUNDS' }
  token SPACIAL     { 'SPACIAL' }
  token SSL         { 'SSL' }
  token STORAGE     { 'STORAGE' }
  token STORED      { 'STORED' }
  token SUBJECT     { 'SUBJECT' }
  token TABLE       { 'TABLE' }
  token TABLESPACE  { 'TABLESPACE' }
  token TEMPORARY   { 'TEMPORARY' }
  token THAN        { 'THAN' }
  token TRUE        { 'TRUE' }
  token TYPE        { 'TYPE' }
  token UPDATE      { 'UPDATE' }
  token UNION       { 'UNION' }
  token UNIQUE      { 'UNIQUE' }
  token UNKNOWN     { 'UNKNOWN' }
  token USER        { 'USER' }
  token VALUE       { 'VALUE' }
  token VALUES      { 'VALUES' }
  token VIRTUAL     { 'VIRTUAL' }
  token UNDOFILE    { 'UNDOFILE' }
  token USING       { 'USING' }
  token WAIT        { 'WAIT' }
  token WITH        { 'WITH' }
  token X509        { 'X509' }
  token XOR         { 'XOR' }

  token AUTO_INC                 { 'AUTO_INCREMENT' }
  token AVG_ROW_LENGTH           { 'AVG_ROW_LENGTH' }
  token COLUMN_FORMAT            { 'COLUMN_FORMAT' }
  token DELAY_KEY_WRITE          { 'DELAY_KEY_WRITE' }
  token EXTENT_SIZE              { 'EXTENT_SIZE' }
  token INITIAL_SIZE             { 'INITIAL_SIZE' }
  token INSERT_METHOD            { 'INSERT_METHOD' }
  token KEY_BLOCK_SIZE           { 'KEY_BLOCK_SIZE' }
  token MAX_CONNECTIONS_PER_HOUR { 'MAX_CONNECTIONS_PER_HOUR' }
  token MAX_SIZE                 { 'MAX_SIZE' }
  token MAX_QUERIES_PER_HOUR     { 'MAX_QUERIES_PER_HOUR' }
  token MAX_UPDATES_PER_HOUR     { 'MAX_UPDATES_PER_HOUR' }
  token MAX_USER_CONNECTIONS     { 'MAX_USER_CONNECTIONS' }
  token MAX_ROWS                 { 'MAX_ROWS' }
  token MAX_VALUE                { 'MAX_VALUE' }
  token MIN_ROWS                 { 'MIN_ROWS' }
  token NO_WAIT                  { 'NO_WAIT' }
  token PACK_KEYS                { 'PACK_KEYS' }
  token REDO_BUFFER_SIZE         { 'REDO_BUFFER_SIZE' }
  token ROW_FORMAT               { 'ROW_FORMAT' }
  token STATS_AUTO_RECALC        { 'STATS_AUTO_RECALC' }
  token STATS_PERSISTENT         { 'STATS_PERSISTENT' }
  token STATS_SAMPLE_PAGES       { 'STATS_SAMPLE_PAGES' }
  token TABLE_CHECKSUM           { 'TABLE_CHECKSUM' }
  token UNDO_BUFFER_SIZE         { 'UNDO_BUFFER_SIZE' }


  token real_ulong_num {
    # ... Takes number or HEX
  }

  token number {
    \d+
  }

  token num           { <[+-]>? <whole=.number> [ '.' <dec=.number> ]? }
  token signed_number { <[+-]>? <number> }

  token ident {
    # Can Identifier consist of a sole _, @ or #?
    <:Letter + [ _ @ # ]> <[ \w _ @ # $ ]>*
  }

  token field_ident {
    [ <table_ident>? '.' ]? <field_id=.ident>
  }

  token order_dir  { <ASC> || <DESC> }

  token simple_ident {
    [ <schema_id=.ident> '.' || '.' ]? <obj_id=.ident> '.' <ident> ||
    <ident>
  }

  token table_ident {
    [ <ns_ident=.ident> '.' || '.' ]? <tbl_ident=.ident>
  }

  token text {
    [ "'" ( <-["]>+ ) "'" | "'" ( <-[']>+ ) "'"  ]
  }


  rule attribute {
    [
      <not>? <NULL>
      |
      <DEFAULT> [ <now> || <num> || <literal> ]
      |
      <ON> <UPDATE> <now>
      |
      <AUTO_INC>
      |
      <SERIAL> <DEFAULT> <VALUE>
      |
      <PRIMARY>? <KEY>
      |
      <UNIQUE> <KEY>?
      |
      <COMMENT> <comment_txt=.text>
      |
      <COLLATE> [ <collate_id=.ident> || <collate_txt=.text> ]
      |
      <COLUMN_FORMAT> [ <DEFAULT> || <FIXED> || <DYNAMIC> ]
      |
      <STORAGE> [ <DEFAULT> || <DISK> || <MEMORY> ]
    ]
  }

  rule charset {
    [ <CHAR> <SET> | <CHARSET> ]
  }

  rule generated_always { <GENERATED> <ALWAYS> }

  rule if_not_exists    { <IF> <NOT> <EXISTS> }

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
        <MAX_ROWS> | <MIN_ROWS>       | <AUTO_INC>        | <AVG_ROW_LENGTH> |
        <CHECKSUM> | <TABLE_CHECKSUM> | <DELAY_KEY_WRITE> | <KEY_BLOCK_SIZE>
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

  rule collate_explicit {
    <COLLATE> [ <collate_id=.ident> || <collate_txt=.text>
  }

  rule constraint {
    <CONSTRAINT> <field_ident>
  }

  rule create_field_list {
    <field_list_item> [ ',' <field_list_item> ]*
  }

  rule field_list_item {
    [ <col_def> | <key_def> ]
  }

  rule field_def {
    <type> [
      <attribute>?
      |
      <collate_explicit>?
      <generated_always>?
      <AS> '(' <generated_column_func> ')'
      [ <VIRTUAL> || <STORED> ]?
      [ <gcol_attr>+ ]?
    ]
  }

  rule field_spec {
    <field_ident> <field_def>
  }

  rule gcol_attr {
    [
      <UNIQUE> <KEY>?
      |
      <COMMENT> <text>
      |
      <not>? <NULL>
      |
      <PRIMARY>? <KEY>
    ]
  }

  rule now {
    <NOW> '(' <number> ')'
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

  rule part_field_list {
    <part_field=.ident> ')' [ ',' <part_field=.ident> ]?
  }

  rule part_type_def {
    [
      [
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
      ]
    ]
  }


  rule all_key_opt {
    [ <KEY_BLOCK_SIZE> <EQ>? <num> | <COMMENT> <text> ]
  }

  rule constraint_key_type {
    [ <PRIMARY> <KEY> | <UNIQUE> <key_or_index> ]
  }

  rule connect_opts {
    <WITH> <_limits>
  }

  rule create_partitioning {
    <PARTITION> <BY> <part_type_def>
    [<PARTITIONS> <number>]?  <sub_part>?
    [ '(' <part_definition> [ [ ',' <part_definition> ]* ]? ')' ]?
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

  rule grant_opts {
    <GRANT> <OPTION> | <_limits>?
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

  rule _limits {
    [
      <MAX_QUERIES_PER_HOUR>    ||
      <MAX_UPDATES_PER_HOUR>    ||
      <MAX_CONNECTIONS_PER_HOUR ||
      MAX_USER_CONNECTIONS>
    ] <num>
  }

  rule logfile_group_info {
    <lf_group_id=.ident>
    <ADD> [
      <UNDOFILE> <file_txt=.text>
      |
      <REDOFILE> <file_text=.text>
    ]
    [ <logfile_group_option> [ ','? <logfile_group_option> ]* ]?
  }

  rule logfile_group_option {
    [
      <INITIAL_SIZE> <EQ>? [ <num> | <ident_sys> ]
      |
      <MAX_SIZE> <EQ>? [ <num> | <ident_sys> ]
      |
      <EXTENT_SIZE> <EQ>? [ <num> | <ident_sys> ]
      |
      <UNDO_BUFFER_SIZE> <EQ>? [ <num> | <ident_sys> ]
      |
      <REDO_BUFFER_SIZE> <EQ>? [ <num> | <ident_sys> ]
      |
      <NODEGROUP> <EQ>? <num>
      |
      <STORAGE>? <ENGINE> <EQ>? [ <storage_id=.ident> || <storage_txt=.text> ]
      |
      [ <WAIT> | <NO_WAIT> ]
      |
      <COMMENT> <EQ>? <comment_txt=.text>
    ]
  }




  rule match_clause {
    <MATCH> [ <FULL> | <PARTIAL> | <SIMPLE> ]
  }

  rule normal_key_options {
    [ <all_key_opt> | <key_alg> ]?
  }

  rule on_update_delete {
    <ON> [
      <UPDATE> [ <delete_option> <ON> <UPDATE> ]?
      |
      <DELETE> [ <delete_option> <ON> <DELETE> ]?
    ] <delete_option>
  }

  rule part_definition {
    <PARTITION> <part_name=.ident>
    [ <VALUES>
      [
        <LESS> <THAN> <part_func_max>
        |
        <IN> <part_values_in>
      ]
    ]?
  }

  rule part_func_max {
    <MAX_VALUE> | <part_value_item>
  }

  rule part_value_expr_item {
    <MAX_VALUE> | <bit_expr>
  }

  rule part_value_item {
    '(' <part_value_expr_item> [ [ ',' <part_value_expr_item> ]* ]? ')'
  }

  rule part_values_in {
    <part_value_item>
    |
    '(' <part_value_item> [ ',' <part_value_item> ]* ')'
  }

  rule references {
    <REFERENCES> <table_ident> <ref_list>? <match_clause>? <on_update_delete>?
  }

  rule ref_list {
    [ '(' <ident> [ ',' <ident> ]* ')' ]?
  }

  rule require_clause {
    <REQUIRE> [
      <require_list_element> [ [ <AND>? <require_list_element> ]* ]?
      |
      [ <SSL> || <X509> || <NONE> ]
    ]
  }

  rule require_list_element {
    [ <SUBJECT> || <ISSUER> || <CIPHER> ] <text>
  }

  rule server_option {
    [
      [
        <USER>
        ||
        <HOST>
        ||
        <DATABASE>
        ||
        <OWNER>
        ||
        <PASSWORD>
        ||
        <SOCKET>
      ] <text>
      |
      <PORT> <num>
    ]
  }


  rule server_opts {
    <server_option> [ ',' <server_option> ]*
  }

  rule spacial_key_opt {
    <all_key_opt>?
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
          #<clear_privs>
          <grant_opts>
          <require_clause>
          <connect_opts>
          <lock_expire_opts>?
        |
        <LOGFILE> <GROUP> <logfile_group_info>
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

  rule subselect {
    . { die "{ &?ROUTINE.name } NYI }" }
    #...
  }

  rule simple_expr {
    # WHEEEEE!
    #...
    .
  }

};
