use v6.c;

grammar DDLGrammar {
  token TOP { <CREATE_ST> }

  token EQ          { 'EQ' || '='  }
  token GE          { 'GE' || '>=' }
  token GT          { 'GT' || '>' }
  token LE          { 'LE' || '<=' }
  token LT          { 'LT' || '<' }
  token NE          { 'NE' || '<>' }

  token AND2        { '&&' }
  token BIT_NOT     { '~' }
  token MINUS       { '-' }
  token NOT_OP      { '!' }
  token OR2         { '||' }
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


  token ACCOUNT            { 'ACCOUNT' }
  token ACTION             { 'ACTION' }
  token ADD                { 'ADD' }
  token ADDDATE	           { 'ADDDATE' }
  token ALGORITHM          { 'ALGORITHM' }
  token ALL                { 'ALL' }
  token ALWAYS             { 'ALWAYS' }
  token AND                { 'AND' }
  token ANY                { 'ANY' }
  token AS                 { 'AS' }
  token ASC                { 'ASC' }
  token ASCII              { 'ASCII' }
  token BETWEEN            { 'BETWEEN' }
  token BIGINT		         { 'BIGINT' }
  token BINARY		         { 'BINARY' }
  token BIT		             { 'BIT' }
  token BLOB		           { 'BLOB' }
  token BOOL		           { 'BOOL' }
  token BOOLEAN		         { 'BOOLEAN' }
  token BOTH               { 'BOTH' }
  token BTREE              { 'BTREE' }
  token BY                 { 'BY' }
  token BYTE		           { 'BYTE' }
  token CASCADE            { 'CASCADE' }
  token CHAR               { 'CHAR' }
  token CHARSET            { 'CHARSET' }
  token CHECK              { 'CHECK' }
  token CHECKSUM           { 'CHECKSUM' }
  token CIPHER             { 'CIPHER' }
  token COLLATE            { 'COLLATE' }
  token COLUMNS            { 'COLUMNS' }
  token COMMENT            { 'COMMENT' }
  token COMPACT            { 'COMPACT' }
  token COMPRESSED         { 'COMPRESSED' }
  token COMPRESSION        { 'COMPRESSION' }
  token CONNECTION         { 'CONNECTION' }
  token CONSTRAINT         { 'CONSTRAINT' }
  token CREATE             { 'CREATE' }
  token CURDATE	           { 'CURDATE' }
  token CURRENT	           { 'CURRENT' }
  token CURTIME            { 'CURTIME' }
  token DATA               { 'DATA' }
  token DATABASE           { 'DATABASE' }
  token DATE	             { 'DATE' }
  token DATE               { 'DATE' }
  token DATETIME		       { 'DATETIME' }
  token DECIMAL		         { 'DECIMAL' }
  token DEFAULT            { 'DEFAULT' }
  token DELETE             { 'DELETE' }
  token DESC               { 'DESC' }
  token DIRECTORY          { 'DIRECTORY' }
  token DISK               { 'DISK' }
  token DIV                { 'DIV' }
  token DOUBLE		         { 'DOUBLE' }
  token DYNAMIC            { 'DYNAMIC' }
  token ENCRYPTION         { 'ENCRYPTION'   }
  token ENGINE             { 'ENGINE' }
  token ENUM		           { 'ENUM' }
  token ESCAPE             { 'ESCAPE' }
  token EXISTS             { 'EXISTS' }
  token EXPIRE             { 'EXPIRE' }
  token EXTRACT            { 'EXTRACT' }
  token FALSE              { 'FALSE' }
  token FIRST              { 'FIRST' }
  token FIXED              { 'FIXED' }
  token FLOAT		           { 'FLOAT' }
  token FOR		             { 'FOR' }
  token FOREIGN            { 'FOREIGN' }
  token FROM	             { 'FROM' }
  token FULL               { 'FULL' }
  token FULLTEXT           { 'FULLTEXT' }
  token GENERATED          { 'GENERATED' }
  token GEOMETRY		       { 'GEOMETRY' }
  token GEOMETRYCOLLECTION { 'GEOMETRYCOLLECTION' }
  token GET		             { 'GET' }
  token GRANT              { 'GRANT' }
  token GROUP              { 'GROUP' }
  token HASH               { 'HASH' }
  token HOST               { 'HOST' }
  token IDENT		           { 'IDENT' }
  token IF                 { 'IF' }
  token IGNORE		         { 'IGNORE' }
  token IN                 { 'IN' }
  token INDEX              { 'INDEX' }
  token INSERT		         { 'INSERT' }
  token INT		             { 'INT' }
  token INTERNAL           { 'INTERNAL' }
  token INTERVAL           { 'INTERVAL' }
  token IS                 { 'IS' }
  token ISSUER             { 'ISSUER' }
  token JSON		           { 'JSON' }
  token JSON		           { 'JSON' }
  token KEY                { 'KEY' }
  token LAST               { 'LAST' }
  token LEADING		         { 'LEADING' }
  token LEFT		           { 'LEFT' }
  token LESS               { 'LESS' }
  token LIKE               { 'LIKE' }
  token LINEAR             { 'LINEAR' }
  token LINESTRING		     { 'LINESTRING' }
  token LIST               { 'LIST' }
  token LOCK               { 'LOCK' }
  token LOGFILE            { 'LOGFILE' }
  token LONG		           { 'LONG' }
  token LONGBLOB		       { 'LONGBLOB' }
  token LONGTEXT		       { 'LONGTEXT' }
  token MATCH              { 'MATCH' }
  token MEDIUMBLOB		     { 'MEDIUMBLOB' }
  token MEDIUMINT		       { 'MEDIUMINT' }
  token MEDIUMTEXT		     { 'MEDIUMTEXT' }
  token MEMORY             { 'MEMORY' }
  token MOD                { 'MOD' }
  token MULTILINESTRING		 { 'MULTILINESTRING' }
  token MULTIPOINT		     { 'MULTIPOINT' }
  token MULTIPOLYGON		   { 'MULTIPOLYGON' }
  token NATIONAL		       { 'NATIONAL' }
  token NCHAR		           { 'NCHAR' }
  token NEVER              { 'NEVER' }
  token NO                 { 'NO' }
  token NODEGROUP          { 'NODEGROUP' }
  token NONE               { 'NONE' }
  token NOT                { 'NOT' }
  token NOW                { 'NOW' }
  token NULL               { 'NULL' }
  token NUMERIC		         { 'NUMERIC' }
  token NVARCHAR		       { 'NVARCHAR' }
  token ON                 { 'ON' }
  token OPTION             { 'OPTION' }
  token OPTIONS            { 'OPTIONS' }
  token OR                 { 'OR' }
  token OWNER              { 'OWNER' }
  token PARSER             { 'PARSER' }
  token PARTIAL            { 'PARTIAL' }
  token PARTITION          { 'PARTITION' }
  token PARTITIONS         { 'PARTITIONS'   }
  token PASSWORD           { 'PASSWORD' }
  token POINT		           { 'POINT' }
  token POLYGON		         { 'POLYGON' }
  token PORT               { 'PORT' }
  token POSITION		       { 'POSITION' }
  token PRECISION		       { 'PRECISION' }
  token PRIMARY            { 'PRIMARY' }
  token RANGE              { 'RANGE' }
  token REAL		           { 'REAL' }
  token REDOFILE           { 'REDOFILE' }
  token REDUNDANT          { 'REDUNDANT' }
  token REFERENCES         { 'REFERENCES'   }
  token REGEXP             { 'REGEXP' }
  token REPLACE		         { 'REPLACE' }
  token REQUIRE            { 'REQUIRE' }
  token RESTRICT           { 'RESTRICT' }
  token RIGHT	             { 'RIGHT' }
  token RTREE              { 'RTREE' }
  token SELECT		         { 'SELECT' }
  token SERIAL             { 'SERIAL' }
  token SERVER             { 'SERVER' }
  token SET                { 'SET' }
  token SIGNED		         { 'SIGNED' }
  token SIMPLE             { 'SIMPLE' }
  token SMALLINT		       { 'SMALLINT' }
  token SOCKET             { 'SOCKET' }
  token SOUNDS             { 'SOUNDS' }
  token SPACIAL            { 'SPACIAL' }
  token SSL                { 'SSL' }
  token STORAGE            { 'STORAGE' }
  token STORED             { 'STORED' }
  token SUBDATE		         { 'SUBDATE' }
  token SUBJECT            { 'SUBJECT' }
  token SUBPARTITION       { 'SUBPARTITION' }
  token SUBPARTITIONS      { 'SUBPARTITIONS' }
  token SUBSTRING		       { 'SUBSTRING' }
  token SYSDATE		         { 'SYSDATE' }
  token TABLE              { 'TABLE' }
  token TABLESPACE         { 'TABLESPACE ' }
  token TEMPORARY          { 'TEMPORARY'  }
  token TEXT		           { 'TEXT' }
  token THAN               { 'THAN' }
  token TIME               { 'TIME' }
  token TIMESTAMP		       { 'TIMESTAMP' }
  token TIMESTAMP		       { 'TIMESTAMP' }
  token TIMESTAMP          { 'TIMESTAMP' }
  token TINYBLOB		       { 'TINYBLOB' }
  token TINYINT		         { 'TINYINT' }
  token TINYTEXT		       { 'TINYTEXT' }
  token TRAILING		       { 'TRAILING' }
  token TRIM		           { 'TRIM' }
  token TRUE               { 'TRUE' }
  token TYPE               { 'TYPE' }
  token UNDOFILE           { 'UNDOFILE'  }
  token UNICODE            { 'UNICODE' }
  token UNION              { 'UNION' }
  token UNIQUE             { 'UNIQUE' }
  token UNKNOWN            { 'UNKNOWN' }
  token UNLOCK             { 'UNLOCK' }
  token UNSIGNED		       { 'UNSIGNED' }
  token UPDATE             { 'UPDATE' }
  token USER               { 'USER' }
  token USING              { 'USING' }
  token UTC		             { 'UTC' }
  token UTC		             { 'UTC' }
  token UTC		             { 'UTC' }
  token VALUE              { 'VALUE' }
  token VALUES             { 'VALUES' }
  token VARBINARY		       { 'VARBINARY' }
  token VARCHAR		         { 'VARCHAR' }
  token VARYING		         { 'VARYING' }
  token VIRTUAL            { 'VIRTUAL' }
  token WAIT               { 'WAIT' }
  token WITH               { 'WITH' }
  token WRAPPER            { 'WRAPPER' }
  token X509               { 'X509' }
  token XOR                { 'XOR' }
  token ZEROFILL		       { 'ZEROFILL' }

  token AUTO_INC                 { 'AUTO_INCREMENT' }
  token AVG_ROW_LENGTH           { 'AVG_ROW_LENGTH' }
  token COLUMN_FORMAT            { 'COLUMN_FORMAT' }
  token CURRENT_USER		         { 'CURRENT_USER' }
  token DATE_ADD		             { 'DATE_ADD' }
  token DATE_SUB		             { 'DATE_SUB' }
  token DELAY_KEY_WRITE          { 'DELAY_KEY_WRITE' }
  token EXTENT_SIZE              { 'EXTENT_SIZE' }
  token GET_FORMAT		           { 'GET_FORMAT' }
  token IDENT_QUOTED		         { 'IDENT_QUOTED' }
  token INITIAL_SIZE             { 'INITIAL_SIZE' }
  token INSERT_METHOD            { 'INSERT_METHOD' }
  token JSON_SEPARATOR		       { 'JSON_SEPARATOR' }
  token JSON_UNQ_SEPEARATOR		   { 'JSON_UNQ_SEPEARATOR' }
  token KEY_BLOCK_SIZE           { 'KEY_BLOCK_SIZE' }
  token MAX_CONNECTIONS_PER_HOUR { 'MAX_CONNECTIONS_PER_HOUR' }
  token MAX_QUERIES_PER_HOUR     { 'MAX_QUERIES_PER_HOUR' }
  token MAX_ROWS                 { 'MAX_ROWS' }
  token MAX_SIZE                 { 'MAX_SIZE' }
  token MAX_UPDATES_PER_HOUR     { 'MAX_UPDATES_PER_HOUR' }
  token MAX_USER_CONNECTIONS     { 'MAX_USER_CONNECTIONS' }
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
  token TIMESTAMP_ADD	           { 'TIMESTAMP_ADD' }
  token TIMESTAMP_DIFF	         { 'TIMESTAMP_DIFF' }
  token UNDO_BUFFER_SIZE         { 'UNDO_BUFFER_SIZE' }
  token UTC_DATE		             { 'UTC_DATE' }
  token UTC_TIME		             { 'UTC_TIME' }
  token UTC_TIMESTAMP		         { 'UTC_TIMESTAMP' }

  token ulong_num {
    <number> | <hex_num>
  }

  token bin_num {
    [
      'B'  [ <[01]>+ || "'" <[01]>+ "'" ]
      |
      '0b' [ <[01]>+ || "'" <[01]>+ "'" ]
    ]
  }

  token hex_num {
    '0'? 'X' [
      <[0123456789ABCDEF]>+ || "'" <[0123456789ABCDEF]>+ "'"
    ]
  }

  token number {
    \d+
  }

  token num           { <[+-]>? <whole=.number> [ '.' <dec=.number> ]? }
  token signed_number { <[+-]>? <number> }

  token ident {
    # Can Identifier consist of a sole _, @ or #?
    :my token valid_id { <:Letter + [ _ @ # ]> <[ \w _ @ # $ ]>* }
    <valid_id>
    # What should <IDENT_QUOTED> be?
  }

  token field_ident {
    [ <table_ident>? '.' ]? <field_id=.ident>
  }

  token order_dir  { <ASC> || <DESC> }

  token simple_ident {
    <ident> || <keyword>
  }

  token table_ident {
    [ <ns_ident=.ident> '.' || '.' ]? <tbl_ident=.ident>
  }

  token text {
      # Are double quotes allowed as text strings?
      "'" ( <-[']>+ ) "'" | '"' ( <-["]>+ ) '"'
  }

  token underscore_charset {
    '_' <ident>
  }

  rule alter_algo_option {
    <ALGORITHM> <EQ>? [ <DEFAULT> || <ident> ]
  }

  rule alter_lock_option {
    <LOCK> <EQ>? [ <DEFAULT> || <ident> ]
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

  rule charset {
    [ <CHAR> <SET> | <CHARSET> ]
  }

  rule escape {
    <ESCAPE> <simple_expr>
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

  rule expr_list {
    <expr> [ ',' <expr> ]*
  }

  rule generated_always { <GENERATED> <ALWAYS> }

  rule index_lock_algo {
    [
      <alter_lock_option> <alter_algo_option>?
      |
      <alter_algo_option> <alter_lock_option>?
    ]
  }

  rule if_not_exists    { <IF> <NOT> <EXISTS> }

  rule literal {
    <underscore_charset>? <text>
    |
    'N'<text>
    |
    <num>
    |
    [ <DATE> || <TIME> || <TIMESTAMP> ] <text>
    |
    [ <NULL> || <FALSE> || <TRUE> ]
    |
    <underscore_charset>? [ <hex_num> || <bin_num> ]
  }

  rule lock_expire_opts {
    [
      <ACCOUNT> [ <UNLOCK> || <LOCK> ]
      |
      <PASSWORD> <EXPIRE> [
        <INTERVAL> <num> <DAY>
        |
        [ <NEVER> || <DEFAULT> ]
      ]
    ]
  }

  rule predicate {
    :my rule _in_expr { <IN> '(' [ <subselect> | <expr_list> ] ')' }
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

  rule row_types {
    [ <DEFAULT> || <FIXED> || <DYNAMIC> || <COMPRESSED> || <REDUNDANT> || <COMPACT> ]
  }

  rule _key_function_call {
    [
      <CHAR> '(' <expr_list> [ USING <charset_name=.ident> ]? ')'
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

  rule _nonkey_function_call {
    :my token _precision { '(' <num> ')'  };
    [
      [ <ADDDATE> || <SUBDATE> ] '(' <expr> ',' [
        <expr> | <INTERVAL> <expr> <interval>
      ]
      |
      [ <DATE_ADD> | <DATE_SUB> ] '(' <expr> ',' <INTERVAL> <expr> <interval>
      |
      [
        <EXTRACT> '(' <interval> <FROM>
        |
        [
          <GET_FORMAT> [ <DATE> || <TIME> || <TIMESTAMP> || <DATETIME> ]
          |
          [ <TIMESTAMP_ADD> || <TIMESTAMP_DIFF> ] '(' <interval_time_stamp> ','
          <expr>
        ] ','
        |
        <POSITION> '(' <bit_expr> <IN>
        |
        <SUBSTRING> '(' <expr> [
          ',' [ <expr> ',' ]?
          |
          <FROM> [ <expr> <FOR> ]?
        ]
      ] <expr>
    ] ')'
    |
    [ <CURDATE> || <UTC_DATE> ] [ '(' ')' ]?
    |
    [ <CURTIME> || <SYSDATE> || <UTC_TIME> || <UTC_TIMESTAMP> ] <_precision>?
    |
    <NOW> <_precision>?
  }

  rule simple_expr {
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
      <COLLATE> <ident> || <text>
      |
      <OR2> <simple_expr>
    ]
    |
    <literal>
    |
    <parm_marker>
    |
    <variable>
    |
    <sum_expr>
    |
    [ <PLUS> || <MINUS> || <BIT_NOT> || <NOT> || <NOT_OP> || <BINARY> ]
    <simple_expr>
    #|
    #...
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
        <MAX_ROWS> || <MIN_ROWS>       || <AUTO_INC>        || <AVG_ROW_LENGTH> ||
        <CHECKSUM> || <TABLE_CHECKSUM> || <DELAY_KEY_WRITE> || <KEY_BLOCK_SIZE>
      ] <EQ>? <num>
      |
      [
        <PASSWORD> || <COMMENT> || <COMPRESSION> || <ENCRYPTION> ||
        [ <DATA> | <INDEX> ] <DIRECTORY> || <CONNECTION>
      ] <EQ>? <text>
      |
      [
        <PACK_KEYS> || <STATS_AUTO_RECALC> || <STATS_PERSISTENT> |
        <STATS_SAMPLE_PAGES>
      ] <EQ>? [ <number> || <DEFAULT> ]
      |
      <ROW_FORMAT> <EQ>? <row_types>
      |
      <UNION> <EQ>? '(' <table_list>? ')'
      |
      <DEFAULT>? <charset> <EQ>? [ <char_id=.ident> || <char_txt=.text> ]
      |
      <DEFAULT>? <COLLATE> <EQ>? [ <collate_id=.ident> || <collate_txt=.text> ]
      |
      <INSERT_METHOD> <EQ>? [ <NO> || <FIRST> || <LAST> ]
      |
      <TABLESPACE> <EQ>? <ts_ident=.ident>
      |
      <STORAGE> [ <DISK> || <MEMORY> ]
    ]
  }

  rule check_constraint {
    <CHECK> '(' <expr> ')'
  }

  rule collate_explicit {
    <COLLATE> [ <collate_id=.ident> || <collate_txt=.text> ]
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
      <AS> '(' <expr> ')'
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

  rule type {
    [
      [ <INT> || <TINYINT> || <SMALLINT> || <MEDIUMINT> || <BIGINT> || <YEAR> ]
      [ '(' <num> ')' ]?
      |
      [ <REAL> | <DOUBLE> <PRECISION>? ]
      |
      [ <FLOAT> || <DECIMAL> || <NUMERIC> || <FIXED> ]
      [
        '(' [
          [ <number> ]
          |
          [ <m=.number> ',' <d=.number> ]
        ')' ]
      ]? $<options>=[ <SIGNED> || <UNSIGNED> || <ZEROFILL> ]*
      |
      [
        |
        [ <BIT> || <BINARY> ] '(' <num> ')'
        |
        [ <BOOL> || <BOOLEAN> ]
        |
        [
          [ <CHAR> || <VARCHAR> ] '(' <num> ')'
          |
          <TINYTEXT>
          |
          <TEXT> [ '(' <num> ')' ]?
          |
          <MEDIUMTEXT>
          |
          <LONGTEXT>
          |
          [ <ENUM> || <SET> ] '(' <text> [ ',' <text> ]* ')'
        ]
        [
          [ <ASCII> <BINARY> ] | [<BINARY> <ASCII> ]
          |
          [ <UNICODE> <BINARY> ] | [ <BINARY> <UNICODE> ]
          |
          <BYTE>
          |
          <charset> [ <ident> || <text> ] <BINARY>?
          |
          <BINARY>? <charset> [ <ident> || <text> ]
        ]
      ]
      |
      [
        [ <NCHAR> | <NATIONAL> <CHAR> ] [ '(' <num> ')' ]?
        |
        [
          <NATIONAL>  [ <VARCHAR> ] | [ <CHAR> <VARYING> ]
          |
          <NVARCHAR>
          |
          <NCHAR> [ <VARCHAR> || <VARYING> ]
        ]
      ] <BINARY>?
      |
      <DATE>
      |
      [ <TIME> || <TIMESTAMP> || <DATETIME> ] [ '(' <num> ')' ]?
      |
      <TINYBLOB>
      |
      <BLOB> [ '(' <num> ')' ]?
      |
      [
        <GEOMETRY>           ||
        <GEOMETRYCOLLECTION> ||
        <POINT>              ||
        <MULTIPOINT>         ||
        <LINESTRING>         ||
        <MULTILINESTRING>    ||
        <POLYGON>            ||
        <MULTIPOLYGON>
      ]
      |
      [ <MEDIUMBLOB> || <LONGBLOB> ]
      |
      <LONG> [
        <VARBINARY>
        |
        [ <CHAR> <VARYING> | <VARCHAR> ]? <BINARY>?
      ]
      |
      <SERIAL>
      |
      <JSON>
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

  rule create_database_opts {
    <default_collation> | <default_charset>
  }

  rule create_partitioning {
    <PARTITION> <BY> <part_type_def>
    [<PARTITIONS> <number>]?  <sub_part>?
    [ '(' <part_definition> [ [ ',' <part_definition> ]* ]? ')' ]?
  }

  rule default_charset {
    <DEFAULT>? <charset> <EQ>? [ <ident> || <text> ]
  }

  rule default_collation {
    <DEFAULT>? <COLLATE> <EQ> [ <ident> || <text> ]
  }

  rule delete_option {
    [
      <RESTRICT>
      |
      <CASCADE>
      |
      <SET> [ <NULL> || <DEFAULT> ]
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
    [ <ident> || '"' <ident> '"' || "'" <ident> "'" ]
  }

  rule key_alg {
    [ <USING> || <TYPE> ] [ <BTREE> || <RTREE> || <HASH> ]
  }

  rule key_list {
    <ident> [ '(' <num> ')' ]?  <order_dir>
  }

  rule key_lists {
    <key_list> [ ',' <key_list> ]*
  }

  rule key_or_index {
    [ <KEY> || <INDEX> ]
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
      <STORAGE>? <ENGINE> <EQ>? [ <storage_id=.ident> || <storage_txt=.text> ]
      |
      [ <WAIT> || <NO_WAIT> ]
      |
      <COMMENT> <EQ>? <comment_txt=.text>
    ]
  }

  rule match_clause {
    <MATCH> [ <FULL> || <PARTIAL> || <SIMPLE> ]
  }

  rule normal_key_options {
    [ <all_key_opt> || <key_alg> ]?
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
    <MAX_VALUE> || <part_value_item>
  }

  rule part_value_expr_item {
    <MAX_VALUE> || <bit_expr>
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
      [ <USER> || <HOST> || <DATABASE> || <OWNER> || <PASSWORD> || <SOCKET> ]
      <text>
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

  rule sub_part {
    <SUBPARTITION> <BY> <LINEAR>?
    [
      <HASH> '(' <bit_expr> ')'
      |
      <KEY> <key_alg>? '(' <ident> [ ',' <ident> ]* ')'
    ] [ <SUBPARTITIONS> <number> ]?
  }

  rule create3 {
    [ <REPLACE> || <IGNORE> ]? <AS>? [
      <create_select> <union_clause>?
      |
      '(' <create_select> ')' <union_opt>
    ]
  }

  rule CREATE_ST {
    <CREATE> [
        <TEMPORARY>? <TABLE> <if_not_exists>? <table_ident> [
          '(' [
            <create_field_list> ')' <create_table_opts>? <create_partitioning>? <create3>?
            |
            <create_partitioning>? <create_select> ')' <union_opt>
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
          [ <server_ident=.ident> || <server_text=.text> ]
          <FOREIGN> <DATA> <WRAPPER>
          [ <fdw_ident=.ident> || <fdw_text=.text> ]
          <OPTIONS>
          '(' <server_opts> ')'
    ]
  }



  rule create_select {
    { die "{ &?ROUTINE.name } NYI }" }
  }

  rule union_clause {
    . { die "{ &?ROUTINE.name } NYI }" }
  }

  rule union_opt {
    . { die "{ &?ROUTINE.name } NYI }" }
  }

  rule subselect {
    . { die "{ &?ROUTINE.name } NYI }" }
  }



};
