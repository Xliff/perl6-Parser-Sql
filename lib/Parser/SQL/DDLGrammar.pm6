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
  token BIT_AND		  { '&' }
  token BIT_NOT     { '~' }
  token BIT_OR		  { '|' }
  token BIT_XOR		  { 'XOR' }
  token MINUS       { '-' }
  token NOT_OP      { '!' }
  token OR2         { '||' }
  token PLUS        { '+' }
  token SHIFT_L     { '<<' }
  token SHIFT_R     { '>>' }

  token PARAM_MARK  { '?' }

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
  token AFTER { 'AFTER' }
  token AGAINST		         { 'AGAINST' }
  token AGGREGATE { 'AGGREGATE' }
  token ALGORITHM          { 'ALGORITHM' }
  token ALL                { 'ALL' }
  token ALWAYS             { 'ALWAYS' }
  token ANALYSE { 'ANALYSE' }
  token AND                { 'AND' }
  token ANY                { 'ANY' }
  token AS                 { 'AS' }
  token ASC                { 'ASC' }
  token ASCII              { 'ASCII' }
  token AT { 'AT' }
  token AVG		             { 'AVG' }
  token BACKUP             { 'BACKUP' }
  token BEGIN              { 'BEGIN' }
  token BETWEEN            { 'BETWEEN' }
  token BIGINT		         { 'BIGINT' }
  token BINARY		         { 'BINARY' }
  token BINLOG { 'BINLOG' }
  token BIT		             { 'BIT' }
  token BLOB		           { 'BLOB' }
  token BLOCK { 'BLOCK' }
  token BOOL		           { 'BOOL' }
  token BOOLEAN		         { 'BOOLEAN' }
  token BOTH               { 'BOTH' }
  token BTREE              { 'BTREE' }
  token BY                 { 'BY' }
  token BYTE		           { 'BYTE' }
  token CACHE              { 'CACHE' }
  token CASCADE            { 'CASCADE' }
  token CASCADED { 'CASCADED' }
  token CASE		           { 'CASE' }
  token CAST		           { 'CAST' }
  token CHAIN { 'CHAIN' }
  token CHANGED { 'CHANGED' }
  token CHANNEL { 'CHANNEL' }
  token CHAR               { 'CHAR' }
  token CHARSET            { 'CHARSET' }
  token CHECK              { 'CHECK' }
  token CHECKSUM           { 'CHECKSUM' }
  token CIPHER             { 'CIPHER' }
  token CLIENT { 'CLIENT' }
  token CLOSE              { 'CLOSE' }
  token COALESCE		       { 'COALESCE' }
  token CODE { 'CODE' }
  token COLLATE            { 'COLLATE' }
  token COLLATION		       { 'COLLATION' }
  token COLUMNS            { 'COLUMNS' }
  token COMMENT            { 'COMMENT' }
  token COMMIT             { 'COMMIT' }
  token COMMITTED { 'COMMITTED' }
  token COMPACT            { 'COMPACT' }
  token COMPLETION { 'COMPLETION' }
  token COMPRESSED         { 'COMPRESSED' }
  token COMPRESSION        { 'COMPRESSION' }
  token CONCURRENT { 'CONCURRENT' }
  token CONNECTION         { 'CONNECTION' }
  token CONSISTENT { 'CONSISTENT' }
  token CONSTRAINT         { 'CONSTRAINT' }
  token CONTAINS		       { 'CONTAINS' }
  token CONTEXT { 'CONTEXT' }
  token CONVERT		         { 'CONVERT' }
  token COUNT		           { 'COUNT' }
  token CPU { 'CPU' }
  token CREATE             { 'CREATE' }
  token CUBE { 'CUBE' }
  token CURDATE	           { 'CURDATE' }
  token CURRENT	           { 'CURRENT' }
  token CURTIME            { 'CURTIME' }
  token DATA               { 'DATA' }
  token DATABASE           { 'DATABASE' }
  token DATAFILE { 'DATAFILE' }
  token DATE	             { 'DATE' }
  token DATETIME		       { 'DATETIME' }
  token DEALLOCATE         { 'DEALLOCATE' }
  token DECIMAL		         { 'DECIMAL' }
  token DEFAULT            { 'DEFAULT' }
  token DEFINER { 'DEFINER' }
  token DELETE             { 'DELETE' }
  token DESC               { 'DESC' }
  token DIAGNOSTICS { 'DIAGNOSTICS' }
  token DIRECTORY          { 'DIRECTORY' }
  token DISABLE { 'DISABLE' }
  token DISCARD { 'DISCARD' }
  token DISK               { 'DISK' }
  token DISTINCT		       { 'DISTINCT' }
  token DIV                { 'DIV' }
  token DO                 { 'DO' }
  token DOUBLE		         { 'DOUBLE' }
  token DUMPFILE { 'DUMPFILE' }
  token DUPLICATE { 'DUPLICATE' }
  token DYNAMIC            { 'DYNAMIC' }
  token ELSE		           { 'ELSE' }
  token ENABLE { 'ENABLE' }
  token ENCRYPTION         { 'ENCRYPTION'   }
  token END		             { 'END' }
  token ENDS { 'ENDS' }
  token ENGINE             { 'ENGINE' }
  token ENGINES { 'ENGINES' }
  token ENUM		           { 'ENUM' }
  token ERROR { 'ERROR' }
  token ERRORS { 'ERRORS' }
  token ESCAPE             { 'ESCAPE' }
  token EVENT { 'EVENT' }
  token EVENTS { 'EVENTS' }
  token EVERY { 'EVERY' }
  token EXCHANGE { 'EXCHANGE' }
  token EXECUTE            { 'EXECUTE' }
  token EXISTS             { 'EXISTS' }
  token EXPANSION		       { 'EXPANSION' }
  token EXPIRE             { 'EXPIRE' }
  token EXPORT { 'EXPORT' }
  token EXPR		           { 'EXPR' }
  token EXTENDED { 'EXTENDED' }
  token EXTRACT            { 'EXTRACT' }
  token FALSE              { 'FALSE' }
  token FAST { 'FAST' }
  token FAULTS { 'FAULTS' }
  token FILE { 'FILE' }
  token FILTER { 'FILTER' }
  token FIRST              { 'FIRST' }
  token FIXED              { 'FIXED' }
  token FLOAT		           { 'FLOAT' }
  token FLUSH              { 'FLUSH' }
  token FOLLOWS            { 'FOLLOWS' }
  token FOR		             { 'FOR' }
  token FOREIGN            { 'FOREIGN' }
  token FORMAT	           { 'FORMAT' }
  token FOUND { 'FOUND' }
  token FROM	             { 'FROM' }
  token FULL               { 'FULL' }
  token FULLTEXT           { 'FULLTEXT' }
  token FUNCTION { 'FUNCTION' }
  token GENERAL { 'GENERAL' }
  token GENERATED          { 'GENERATED' }
  token GEOMETRY		       { 'GEOMETRY' }
  token GEOMETRYCOLLECTION { 'GEOMETRYCOLLECTION' }
  token GET		             { 'GET' }
  token GLOBAL	           { 'GLOBAL' }
  token GRANT              { 'GRANT' }
  token GRANTS { 'GRANTS' }
  token GROUP              { 'GROUP' }
  token HANDLER            { 'HANDLER' }
  token HASH               { 'HASH' }
  token HELP               { 'HELP' }
  token HOST               { 'HOST' }
  token HOSTS { 'HOSTS' }
  token IDENT		           { 'IDENT' }
  token IDENTIFIED { 'IDENTIFIED' }
  token IF                 { 'IF' }
  token IGNORE		         { 'IGNORE' }
  token IMPORT { 'IMPORT' }
  token IN                 { 'IN' }
  token INDEX              { 'INDEX' }
  token INDEXES { 'INDEXES' }
  token INTERVAL            { 'INTERVAL' }
  token INSERT		         { 'INSERT' }
  token INSTALL            { 'INSTALL' }
  token INSTANCE { 'INSTANCE' }
  token INT		             { 'INT' }
  token INTERNAL           { 'INTERNAL' }
  token INVOKER { 'INVOKER' }
  token IO { 'IO' }
  token IPC { 'IPC' }
  token IS                 { 'IS' }
  token ISOLATION { 'ISOLATION' }
  token ISSUER             { 'ISSUER' }
  token JSON		           { 'JSON' }
  token KEY                { 'KEY' }
  token LANGUAGE		       { 'LANGUAGE' }
  token LAST               { 'LAST' }
  token LEADING		         { 'LEADING' }
  token LEAVES { 'LEAVES' }
  token LEFT		           { 'LEFT' }
  token LESS               { 'LESS' }
  token LEVEL		           { 'LEVEL' }
  token LIKE               { 'LIKE' }
  token LINEAR             { 'LINEAR' }
  token LINESTRING		     { 'LINESTRING' }
  token LIST               { 'LIST' }
  token LOCAL		           { 'LOCAL' }
  token LOCK               { 'LOCK' }
  token LOCKS { 'LOCKS' }
  token LOGFILE            { 'LOGFILE' }
  token LOGS { 'LOGS' }
  token LONG		           { 'LONG' }
  token LONGBLOB		       { 'LONGBLOB' }
  token LONGTEXT		       { 'LONGTEXT' }
  token MASTER { 'MASTER' }
  token MATCH              { 'MATCH' }
  token MAX		             { 'MAX' }
  token MEDIUM { 'MEDIUM' }
  token MEDIUMBLOB		     { 'MEDIUMBLOB' }
  token MEDIUMINT		       { 'MEDIUMINT' }
  token MEDIUMTEXT		     { 'MEDIUMTEXT' }
  token MEMORY             { 'MEMORY' }
  token MERGE { 'MERGE' }
  token MIGRATE { 'MIGRATE' }
  token MIN		             { 'MIN' }
  token MOD                { 'MOD' }
  token MODE		           { 'MODE' }
  token MODIFY { 'MODIFY' }
  token MULTILINESTRING		 { 'MULTILINESTRING' }
  token MULTIPOINT		     { 'MULTIPOINT' }
  token MULTIPOLYGON		   { 'MULTIPOLYGON' }
  token MUTEX { 'MUTEX' }
  token NAME { 'NAME' }
  token NAMES { 'NAMES' }
  token NATIONAL		       { 'NATIONAL' }
  token NATURAL	           { 'NATURAL' }
  token NCHAR		           { 'NCHAR' }
  token NDBCLUSTER { 'NDBCLUSTER' }
  token NEVER              { 'NEVER' }
  token NEW { 'NEW' }
  token NEXT { 'NEXT' }
  token NO                 { 'NO' }
  token NODEGROUP          { 'NODEGROUP' }
  token NONE               { 'NONE' }
  token NOT                { 'NOT' }
  token NOW                { 'NOW' }
  token NULL               { 'NULL' }
  token NUMBER { 'NUMBER' }
  token NUMERIC		         { 'NUMERIC' }
  token NVARCHAR		       { 'NVARCHAR' }
  token OFFSET { 'OFFSET' }
  token ON                 { 'ON' }
  token ONE { 'ONE' }
  token ONLY { 'ONLY' }
  token OPEN               { 'OPEN' }
  token OPTION             { 'OPTION' }
  token OPTIONS            { 'OPTIONS' }
  token OR                 { 'OR' }
  token ORDER              { 'ORDER' }
  token OWNER { 'OWNER' }
  token PAGE { 'PAGE' }
  token PARSER             { 'PARSER' }
  token PARTIAL            { 'PARTIAL' }
  token PARTITION          { 'PARTITION' }
  token PARTITIONING { 'PARTITIONING' }
  token PARTITIONS         { 'PARTITIONS'   }
  token PASSWORD           { 'PASSWORD' }
  token PHASE { 'PHASE' }
  token PLUGIN { 'PLUGIN' }
  token PLUGINS { 'PLUGINS' }
  token POINT		           { 'POINT' }
  token POLYGON		         { 'POLYGON' }
  token PORT               { 'PORT' }
  token POSITION		       { 'POSITION' }
  token PRECEDES           { 'PRECEDES' }
  token PRECISION		       { 'PRECISION' }
  token PREPARE            { 'PREPARE' }
  token PRESERVE { 'PRESERVE' }
  token PREV { 'PREV' }
  token PRIMARY            { 'PRIMARY' }
  token PRIVILEGES { 'PRIVILEGES' }
  token PROCESS { 'PROCESS' }
  token PROCESSLIST { 'PROCESSLIST' }
  token PROFILE { 'PROFILE' }
  token PROFILES { 'PROFILES' }
  token PROXY { 'PROXY' }
  token QUERY		           { 'QUERY' }
  token QUICK { 'QUICK' }
  token RANGE              { 'RANGE' }
  token READ_ONLY { 'READ_ONLY' }
  token REAL		           { 'REAL' }
  token REBUILD { 'REBUILD' }
  token RECOVER { 'RECOVER' }
  token REDOFILE           { 'REDOFILE' }
  token REDUNDANT          { 'REDUNDANT' }
  token REFERENCES         { 'REFERENCES'   }
  token REGEXP             { 'REGEXP' }
  token RELAY { 'RELAY' }
  token RELAYLOG { 'RELAYLOG' }
  token RELOAD { 'RELOAD' }
  token REMOVE             { 'REMOVE' }
  token REORGANIZE { 'REORGANIZE' }
  token REPAIR             { 'REPAIR' }
  token REPEAT		         { 'REPEAT' }
  token REPEATABLE { 'REPEATABLE' }
  token REPLACE		         { 'REPLACE' }
  token REPLICATION { 'REPLICATION' }
  token REQUIRE            { 'REQUIRE' }
  token RESET              { 'RESET' }
  token RESOURCES { 'RESOURCES' }
  token RESTORE            { 'RESTORE' }
  token RESTRICT           { 'RESTRICT' }
  token RESUME { 'RESUME' }
  token RETURNS { 'RETURNS' }
  token REVERSE		         { 'REVERSE' }
  token RIGHT	             { 'RIGHT' }
  token ROLLBACK           { 'ROLLBACK' }
  token ROLLUP { 'ROLLUP' }
  token ROTATE { 'ROTATE' }
  token ROUTINE { 'ROUTINE' }
  token ROW		             { 'ROW' }
  token ROWS { 'ROWS' }
  token RTREE { 'RTREE' }
  token SAVEPOINT          { 'SAVEPOINT' }
  token SCHEDULE { 'SCHEDULE' }
  token SCHEMA_NAME { 'SCHEMA_NAME' }
  token SECURITY           { 'SECURITY' }
  token SELECT		         { 'SELECT' }
  token SEPARATOR		       { 'SEPARATOR' }
  token SERIAL             { 'SERIAL' }
  token SERIALIZABLE { 'SERIALIZABLE' }
  token SERVER             { 'SERVER' }
  token SESSION	           { 'SESSION' }
  token SET                { 'SET' }
  token SHARE { 'SHARE' }
  token SHUTDOWN           { 'SHUTDOWN' }
  token SIGNED		         { 'SIGNED' }
  token SIMPLE             { 'SIMPLE' }
  token SLAVE              { 'SLAVE' }
  token SLOW { 'SLOW' }
  token SMALLINT		       { 'SMALLINT' }
  token SNAPSHOT { 'SNAPSHOT' }
  token SOCKET             { 'SOCKET' }
  token SONAME             { 'SONAME' }
  token SOUNDS             { 'SOUNDS' }
  token SOURCE { 'SOURCE' }
  token SPACIAL            { 'SPACIAL' }
  token SSL                { 'SSL' }
  token STACKED { 'STACKED' }
  token START              { 'START' }
  token STARTS { 'STARTS' }
  token STATUS { 'STATUS' }
  token STD		             { 'STD' }
  token STOP               { 'STOP' }
  token STORAGE            { 'STORAGE' }
  token STORED             { 'STORED' }
  token STRING { 'STRING' }
  token SUBDATE		         { 'SUBDATE' }
  token SUBJECT            { 'SUBJECT' }
  token SUBPARTITION       { 'SUBPARTITION' }
  token SUBPARTITIONS      { 'SUBPARTITIONS' }
  token SUBSTRING		       { 'SUBSTRING' }
  token SUM		             { 'SUM' }
  token SUPER { 'SUPER' }
  token SUSPEND { 'SUSPEND' }
  token SWAPS { 'SWAPS' }
  token SWITCHES { 'SWITCHES' }
  token SYSDATE		         { 'SYSDATE' }
  token TABLE              { 'TABLE' }
  token TABLES { 'TABLES' }
  token TABLESPACE         { 'TABLESPACE ' }
  token TEMPORARY          { 'TEMPORARY'  }
  token TEMPTABLE { 'TEMPTABLE' }
  token TEXT		           { 'TEXT' }
  token THAN               { 'THAN' }
  token THEN		           { 'THEN' }
  token TIME               { 'TIME' }
  token TIMESTAMP		       { 'TIMESTAMP' }
  token TINYBLOB		       { 'TINYBLOB' }
  token TINYINT		         { 'TINYINT' }
  token TINYTEXT		       { 'TINYTEXT' }
  token TRAILING		       { 'TRAILING' }
  token TRANSACTION { 'TRANSACTION' }
  token TRIGGERS { 'TRIGGERS' }
  token TRIM		           { 'TRIM' }
  token TRUE               { 'TRUE' }
  token TRUNCATE		       { 'TRUNCATE' }
  token TYPE               { 'TYPE' }
  token TYPES { 'TYPES' }
  token UDF_RETURNS { 'UDF_RETURNS' }
  token UNCOMMITTED { 'UNCOMMITTED' }
  token UNDEFINED { 'UNDEFINED' }
  token UNDOFILE           { 'UNDOFILE'  }
  token UNICODE            { 'UNICODE' }
  token UNINSTALL          { 'UNINSTALL' }
  token UNION              { 'UNION' }
  token UNIQUE             { 'UNIQUE' }
  token UNKNOWN            { 'UNKNOWN' }
  token UNLOCK             { 'UNLOCK' }
  token UNSIGNED		       { 'UNSIGNED' }
  token UNTIL { 'UNTIL' }
  token UPDATE             { 'UPDATE' }
  token UPGRADE            { 'UPGRADE' }
  token USE_FRM { 'USE_FRM' }
  token USER               { 'USER' }
  token USING              { 'USING' }
  token UTC		             { 'UTC' }
  token VALIDATION { 'VALIDATION' }
  token VALUE              { 'VALUE' }
  token VALUES             { 'VALUES' }
  token VARBINARY		       { 'VARBINARY' }
  token VARCHAR		         { 'VARCHAR' }
  token VARIABLES { 'VARIABLES' }
  token VARIANCE		       { 'VARIANCE' }
  token VARYING		         { 'VARYING' }
  token VIEW { 'VIEW' }
  token VIRTUAL            { 'VIRTUAL' }
  token WAIT               { 'WAIT' }
  token WARNINGS { 'WARNINGS' }
  token WHEN		           { 'WHEN' }
  token WITH               { 'WITH' }
  token WITHOUT { 'WITHOUT' }
  token WORK { 'WORK' }
  token WRAPPER            { 'WRAPPER' }
  token X509               { 'X509' }
  token XA                 { 'XA' }
  token XID { 'XID' }
  token XML { 'XML' }
  token XOR                { 'XOR' }
  token ZEROFILL		       { 'ZEROFILL' }


  token YEAR_SYMACTION { 'YEAR_SYMACTION' }
  token AUTO_INC                 { 'AUTO_INC' }
  token AUTOEXTEND_SIZE { 'AUTOEXTEND_SIZE' }
  token AVG_ROW_LENGTH           { 'AVG_ROW_LENGTH' }
  token CATALOG_NAME { 'CATALOG_NAME' }
  token CLASS_ORIGIN { 'CLASS_ORIGIN' }
  token COLUMN_FORMAT            { 'COLUMN_FORMAT' }
  token COLUMN_NAME { 'COLUMN_NAME' }
  token CONSTRAINT_CATALOG { 'CONSTRAINT_CATALOG' }
  token CONSTRAINT_NAME { 'CONSTRAINT_NAME' }
  token CONSTRAINT_SCHEMA { 'CONSTRAINT_SCHEMA' }
  token CURRENT_USER		         { 'CURRENT_USER' }
  token CURSOR_NAME { 'CURSOR_NAME' }
  token DATE_ADD		             { 'DATE_ADD' }
  token DATE_SUB		             { 'DATE_SUB' }
  token DEFAULT_AUTH { 'DEFAULT_AUTH' }
  token DELAY_KEY_WRITE          { 'DELAY_KEY_WRITE' }
  token DES_KEY_FILE { 'DES_KEY_FILE' }
  token EXTENT_SIZE              { 'EXTENT_SIZE' }
  token FILE_BLOCK_SIZE { 'FILE_BLOCK_SIZE' }
  token GET_FORMAT		           { 'GET_FORMAT' }
  token GROUP_CONCAT		         { 'GROUP_CONCAT' }
  token GROUP_REPLICATION        { 'GROUP_REPLICATION' }
  token IDENT_QUOTED		         { 'IDENT_QUOTED' }
  token IGNORE_SERVER_IDS { 'IGNORE_SERVER_IDS' }
  token INITIAL_SIZE             { 'INITIAL_SIZE' }
  token INSERT_METHOD            { 'INSERT_METHOD' }
  token JSON_SEPARATOR		       { 'JSON_SEPARATOR' }
  token JSON_UNQ_SEPEARATOR		   { 'JSON_UNQ_SEPEARATOR' }
  token KEY_BLOCK_SIZE           { 'KEY_BLOCK_SIZE' }
  token MASTER_AUTO_POSITION { 'MASTER_AUTO_POSITION' }
  token MASTER_CONNECT_RETRY { 'MASTER_CONNECT_RETRY' }
  token MASTER_DELAY { 'MASTER_DELAY' }
  token MASTER_HEARTBEAT_PERIOD { 'MASTER_HEARTBEAT_PERIOD' }
  token MASTER_HOST { 'MASTER_HOST' }
  token MASTER_LOG_FILE { 'MASTER_LOG_FILE' }
  token MASTER_LOG_POS { 'MASTER_LOG_POS' }
  token MASTER_PASSWORD { 'MASTER_PASSWORD' }
  token MASTER_PORT { 'MASTER_PORT' }
  token MASTER_RETRY_COUNT { 'MASTER_RETRY_COUNT' }
  token MASTER_SERVER_ID { 'MASTER_SERVER_ID' }
  token MASTER_SSL { 'MASTER_SSL' }
  token MASTER_SSL_CA { 'MASTER_SSL_CA' }
  token MASTER_SSL_CAPATH { 'MASTER_SSL_CAPATH' }
  token MASTER_SSL_CERT { 'MASTER_SSL_CERT' }
  token MASTER_SSL_CIPHER { 'MASTER_SSL_CIPHER' }
  token MASTER_SSL_CRL { 'MASTER_SSL_CRL' }
  token MASTER_SSL_CRLPATH { 'MASTER_SSL_CRLPATH' }
  token MASTER_SSL_KEY { 'MASTER_SSL_KEY' }
  token MASTER_TLS_VERSION { 'MASTER_TLS_VERSION' }
  token MASTER_USER { 'MASTER_USER' }
  token MAX_CONNECTIONS_PER_HOUR { 'MAX_CONNECTIONS_PER_HOUR' }
  token MAX_QUERIES_PER_HOUR     { 'MAX_QUERIES_PER_HOUR' }
  token MAX_ROWS                 { 'MAX_ROWS' }
  token MAX_SIZE                 { 'MAX_SIZE' }
  token MAX_UPDATES_PER_HOUR     { 'MAX_UPDATES_PER_HOUR' }
  token MAX_USER_CONNECTIONS     { 'MAX_USER_CONNECTIONS' }
  token MAX_VALUE                { 'MAX_VALUE' }
  token MESSAGE_TEXT { 'MESSAGE_TEXT' }
  token MIN_ROWS                 { 'MIN_ROWS' }
  token MYSQL_ERRNO { 'MYSQL_ERRNO' }
  token NO_WAIT                  { 'NO_WAIT' }
  token PACK_KEYS                { 'PACK_KEYS' }
  token PARSE_GCOL_EXPR          { 'PARSE_GCOL_EXPR' }
  token PLUGIN_DIR { 'PLUGIN_DIR' }
  token REDO_BUFFER_SIZE         { 'REDO_BUFFER_SIZE' }
  token RELAY_LOG_FILE { 'RELAY_LOG_FILE' }
  token RELAY_LOG_POS { 'RELAY_LOG_POS' }
  token RELAY_THREAD { 'RELAY_THREAD' }
  token REPLICATE_DO_DB { 'REPLICATE_DO_DB' }
  token REPLICATE_DO_TABLE { 'REPLICATE_DO_TABLE' }
  token REPLICATE_IGNORE_DB { 'REPLICATE_IGNORE_DB' }
  token REPLICATE_IGNORE_TABLE { 'REPLICATE_IGNORE_TABLE' }
  token REPLICATE_REWRITE_DB { 'REPLICATE_REWRITE_DB' }
  token REPLICATE_WILD_DO_TABLE { 'REPLICATE_WILD_DO_TABLE' }
  token REPLICATE_WILD_IGNORE_TABLE { 'REPLICATE_WILD_IGNORE_TABLE' }
  token RETURNED_SQLSTATE { 'RETURNED_SQLSTATE' }
  token ROW_COUNT		             { 'ROW_COUNT' }
  token ROW_FORMAT               { 'ROW_FORMAT' }
  token SQL_AFTER_GTIDS { 'SQL_AFTER_GTIDS' }
  token SQL_AFTER_MTS_GAPS { 'SQL_AFTER_MTS_GAPS' }
  token SQL_BEFORE_GTIDS { 'SQL_BEFORE_GTIDS' }
  token SQL_BUFFER_RESULT { 'SQL_BUFFER_RESULT' }
  token SQL_CACHE { 'SQL_CACHE' }
  token SQL_NO_CACHE { 'SQL_NO_CACHE' }
  token SQL_THREAD { 'SQL_THREAD' }
  token STATS_AUTO_RECALC        { 'STATS_AUTO_RECALC' }
  token STATS_PERSISTENT         { 'STATS_PERSISTENT' }
  token STATS_SAMPLE_PAGES       { 'STATS_SAMPLE_PAGES' }
  token STDDEV_SAMP		           { 'STDDEV_SAMP' }
  token SUBCLASS_ORIGIN { 'SUBCLASS_ORIGIN' }
  token TABLE_CHECKSUM           { 'TABLE_CHECKSUM' }
  token TABLE_NAME { 'TABLE_NAME' }
  token TIMESTAMP_ADD	           { 'TIMESTAMP_ADD' }
  token TIMESTAMP_DIFF	         { 'TIMESTAMP_DIFF' }
  token UNDO_BUFFER_SIZE         { 'UNDO_BUFFER_SIZE' }
  token UTC_DATE		             { 'UTC_DATE' }
  token UTC_TIME		             { 'UTC_TIME' }
  token UTC_TIMESTAMP		         { 'UTC_TIMESTAMP' }
  token VAR_SAMP		             { 'VAR_SAMP' }
  token WEIGHT_STRING		         { 'WEIGHT_STRING' }

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

  token field_ident { [ <table_ident>? '.' ]? <field_id=.ident> }

  token order_dir  { <ASC> || <DESC> }

  token ident      { <ident_sys> || <keyword> }

  token ident_sys {
    # Can Identifier consist of a sole _, @ or #?
    :my token valid_id { <:Letter + [ _ @ # ]> <[ \w _ @ # $ ]>* }
    <valid_id>
    # YYY: Verify that this is IDENT_QUOTED
    ||
    '"' <ident> '"' || "'" <ident> "'"
  }

  token keyword {
    <keyword_sp> || <ACCOUNT>  || <ASCII>     || <ALWAYS>   || <BACKUP>   ||
    <BEGIN>      || <BYTE>     || <CACHE>     || <CHARSET>  || <CHECKSUM> ||
    <CLOSE>      || <COMMENT>  || <COMMIT>    || <CONTAINS> ||
    <DEALLOCATE> || <DO>       || <END>       || <EXECUTE>  || <FLUSH>    ||
    <FOLLOWS>    || <FORMAT>   ||
    <GROUP_REPLICATION>        || <HANDLER>   || <HELP>     || <HOST>     ||
    <INSTALL>    || <LANGUAGE> || <NO>        || <OPEN>     || <OPTIONS>  ||
    <OWNER>      || <PARSER>   ||
    <PARSE_GCOL_EXPR>          || <PORT>      || <PRECEDES> || <PREPARE>  ||
    <REMOVE>     || <REPAIR>   || <RESET>     || <RESTORE>  || <ROLLBACK> ||
    <SAVEPOINT>  || <SECURITY> || <SERVER>    || <SHUTDOWN> || <SIGNED>   ||
    <SOCKET>     || <SLAVE>    || <SONAME>    || <START>    || <STOP>     ||
    <TRUNCATE>   || <UNICODE>  || <UNINSTALL> || <WRAPPER>  || <XA>       ||
    <UPGRADE>
  }

  token keyword_sp {
    <ACTION>      || <ADDDATE>   || <AFTER>   || <AGAINST>   || <AGGREGATE>  ||
    <ALGORITHM>   || <ANALYSE>   || <ANY>     || <AT>        || <AUTO_INC>   ||
    <AUTOEXTEND_SIZE>            || <AVG_ROW_LENGTH>         || <AVG>        ||
    <BINLOG>      || <BIT>       || <BLOCK>   || <BOOL>      || <BOOLEAN>    ||
    <BTREE>       || <CASCADED>  || <CATALOG_NAME>           || <CHAIN>      ||
    <CHANGED>     || <CHANNEL>   || <CIPHER>  ||
    <CLASS_ORIGIN>               || <CLIENT>  || <COALESCE>  || <CODE>       ||
    <COLLATION>   || <COLUMN_FORMAT>          || <COLUMN_NAME>               ||
    <COLUMNS>     || <COMMITTED> || <COMPACT> ||<COMPLETION> || <COMPRESSED> ||
    <COMPRESSION> || <CONCURRENT>             || <CONNECTION>                ||
    <CONSISTENT>  || <CONSTRAINT_CATALOG>     || <CONSTRAINT_NAME>           ||
    <CONSTRAINT_SCHEMA>                       || <CONTEXT>   || <CPU>        ||
    <CUBE>        || <CURRENT>   || <CURSOR_NAME>            || <DATA>       ||
    <DATAFILE>    || <DATE>      || <DATETIME>               || <DAY>        ||
    <DEFAULT_AUTH>               || <DEFINER> || <DELAY_KEY_WRITE>           ||
    <DES_KEY_FILE>               || <DIAGNOSTICS>            || <DIRECTORY>  ||
    <DISABLE>     || <DISCARD>   || <DISK>    || <DUMPFILE>  || <DUPLICATE>  ||
    <DYNAMIC>     || <ENABLE>    || <ENCRYPTION>             || <ENDS>       ||
    <ENGINE>      || <ENGINES>   || <ENUM>    || <ERROR>     || <ERRORS>     ||
    <ESCAPE>      || <EVENT>     || <EVENTS>  || <EVERY>     || <EXCHANGE>   ||
    <EXPANSION>   || <EXPIRE>    || <EXPORT>  || <EXTENDED>  ||
    <EXTENT_SIZE> || <FAST>      || <FAULTS>  || <FILE_BLOCK_SIZE>           ||
    <FILE>        || <FILTER>    || <FIRST>   || <FIXED>     || <FOUND>      ||
    <FULL>        || <FUNCTION>  || <GENERAL> || <GEOMETRY>  ||
    <GEOMETRYCOLLECTION>         || <GET_FORMAT>             || <GLOBAL>     ||
    <GRANTS>      || <HASH>      || <HOSTS>   || <HOUR>      || <IDENTIFIED> ||
    <IGNORE_SERVER_IDS>          || <IMPORT>  || <INDEXES>   ||
    <INITIAL_SIZE>               || <INSERT_METHOD>          || <INSTANCE>   ||
    <INVOKER>     || <IO>        || <IPC>     || <ISOLATION> || <ISSUER>     ||
    <JSON>        || <KEY_BLOCK_SIZE>         || <LAST>      || <LEAVES>     ||
    <LESS>        || <LEVEL>     || <LINESTRING>             || <LIST>       ||
    <LOCAL>       || <LOCKS>     || <LOGFILE> || <LOGS>      ||
    <MASTER_AUTO_POSITION>       || <MASTER_CONNECT_RETRY>                   ||
    <MASTER_DELAY>               || <MASTER_HEARTBEAT_PERIOD>                ||
    <MASTER_HOST>                || <MASTER_LOG_FILE>                        ||
    <MASTER_LOG_POS>             || <MASTER_PASSWORD>                        ||
    <MASTER_PORT>                || <MASTER_RETRY_COUNT>                     ||
    <MASTER_SERVER_ID>           || <MASTER_SSL_CA>                          ||
    <MASTER_SSL_CAPATH>          || <MASTER_SSL_CERT>                        ||
    <MASTER_SSL_CIPHER>          || <MASTER_SSL_CRL>                         ||
    <MASTER_SSL_CRLPATH>         || <MASTER_SSL_KEY>                         ||
    <MASTER_SSL>                 || <MASTER_TLS_VERSION>                     ||
    <MASTER_USER>                ||
    <MASTER>                     || <MAX_CONNECTIONS_PER_HOUR>               ||
    <MAX_QUERIES_PER_HOUR>       || <MAX_ROWS>               || <MAX_SIZE>   ||
    <MAX_UPDATES_PER_HOUR>       || <MAX_USER_CONNECTIONS>   || <MEDIUM>     ||
    <MEMORY>      || <MERGE>     || <MESSAGE_TEXT>           ||
    <MICROSECOND> || <MIGRATE>   || <MIN_ROWS>               || <MINUTE>     ||
    <MODE>        || <MODIFY>    || <MONTH>   || <MULTILINESTRING>           ||
    <MULTIPOINT>  || <MULTIPOLYGON>           || <MUTEX>    || <MYSQL_ERRNO> ||
    <NAME>        || <NAMES>     || <NATIONAL>              || <NCHAR>       ||
    <NDBCLUSTER>  || <NEVER>     || <NEW>     || <NEXT>     || <NO_WAIT>     ||
    <NODEGROUP>   || <NONE>      || <NUMBER>  || <NVARCHAR> || <OFFSET>      ||
    <ONE>         || <ONLY>      || <PACK_KEYS>             || <PAGE>        ||
    <PARTIAL>     || <PARTITIONING>           || <PARTITIONS>                ||
    <PASSWORD>    || <PHASE>     || <PLUGIN_DIR>            || <PLUGIN>      ||
    <PLUGINS>     || <POINT>     || <POLYGON> || <PRESERVE> || <PREV>        ||
    <PRIVILEGES>  || <PROCESS>   || <PROCESSLIST>           || <PROFILE>     ||
    <PROFILES>    || <PROXY>     || <QUARTER> || <QUERY>    || <QUICK>       ||
    <READ_ONLY> ||
    <REBUILD> ||
    <RECOVER> ||
    <REDO_BUFFER_SIZE> ||
    <REDOFILE> ||
    <REDUNDANT> ||
    <RELAY_LOG_FILE> ||
    <RELAY_LOG_POS> ||
    <RELAY_THREAD> ||
    <RELAY> ||
    <RELAYLOG> ||
    <RELOAD> ||
    <REORGANIZE> ||
    <REPEATABLE> ||
    <REPLICATE_DO_DB> ||
    <REPLICATE_DO_TABLE> ||
    <REPLICATE_IGNORE_DB> ||
    <REPLICATE_IGNORE_TABLE> ||
    <REPLICATE_REWRITE_DB> ||
    <REPLICATE_WILD_DO_TABLE> ||
    <REPLICATE_WILD_IGNORE_TABLE> ||
    <REPLICATION> ||
    <RESOURCES> ||
    <RESUME> ||
    <RETURNED_SQLSTATE> ||
    <RETURNS> ||
    <REVERSE> ||
    <ROLLUP> ||
    <ROTATE> ||
    <ROUTINE> ||
    <ROW_COUNT> ||
    <ROW_FORMAT> ||
    <ROW> ||
    <ROWS> ||
    <RTREE> ||
    <SCHEDULE> ||
    <SCHEMA_NAME> ||
    <SECOND> ||
    <SERIAL> ||
    <SERIALIZABLE> ||
    <SESSION> ||
    <SHARE> ||
    <SIMPLE> ||
    <SLOW> ||
    <SNAPSHOT> ||
    <SOUNDS> ||
    <SOURCE> ||
    <SQL_AFTER_GTIDS> ||
    <SQL_AFTER_MTS_GAPS> ||
    <SQL_BEFORE_GTIDS> ||
    <SQL_BUFFER_RESULT> ||
    <SQL_CACHE> ||
    <SQL_NO_CACHE> ||
    <SQL_THREAD> ||
    <STACKED> ||
    <STARTS> ||
    <STATS_AUTO_RECALC> ||
    <STATS_PERSISTENT> ||
    <STATS_SAMPLE_PAGES> ||
    <STATUS> ||
    <STORAGE> ||
    <STRING> ||
    <SUBCLASS_ORIGIN> ||
    <SUBDATE> ||
    <SUBJECT> ||
    <SUBPARTITION> ||
    <SUBPARTITIONS> ||
    <SUPER> ||
    <SUSPEND> ||
    <SWAPS> ||
    <SWITCHES> ||
    <TABLE_CHECKSUM> ||
    <TABLE_NAME> ||
    <TABLES> ||
    <TABLESPACE> ||
    <TEMPORARY> ||
    <TEMPTABLE> ||
    <TEXT> ||
    <THAN> ||
    <TIME> ||
    <TIMESTAMP_ADD> ||
    <TIMESTAMP_DIFF> ||
    <TIMESTAMP> ||
    <TRANSACTION> ||
    <TRIGGERS> ||
    <TYPE> ||
    <TYPES> ||
    <UDF_RETURNS> ||
    <UNCOMMITTED> ||
    <UNDEFINED> ||
    <UNDO_BUFFER_SIZE> ||
    <UNDOFILE> ||
    <UNKNOWN> ||
    <UNTIL> ||
    <USE_FRM> ||
    <USER> ||
    <VALIDATION> ||
    <VALUE> ||
    <VARIABLES> ||
    <VIEW> ||
    <WAIT> ||
    <WARNINGS> ||
    <WEEK> ||
    <WEIGHT_STRING> ||
    <WITHOUT> ||
    <WORK> ||
    <X509> ||
    <XID> ||
    <XML> ||
    <YEAR_SYMACTION> ||
    <YEAR>
  }

  token simple_ident {
    <ident> || <simple_ident_q>
  }

  token simple_ident_q {
    [ <ident>? '.' ]? <ident> '.' <ident>
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

  token select_alias {
    <AS>? [ <ident> || <text> ]
  }

  rule select_item {
      <table_wild> | <expr> <select_alias>
  }

  rule simple_ident_nospvar {
    <ident> | <simple_ident_q>
  }

  rule table_wild {
    <ident> '.' [ <ident> '.' ]? '*'
  }

  token row_types {
    [ <DEFAULT> || <FIXED> || <DYNAMIC> || <COMPRESSED> || <REDUNDANT> || <COMPACT> ]
  }

  rule _cast_type {
    [ <BINARY> || <NCHAR> ] [ '(' <number> ')' ]?
    |
    <CHAR> [ '(' <number> ')' ]? <BINARY>?
    |
    [ <SIGNED> || <UNSIGNED> ] <INT>?
    |
    <DATE>
    |
    [ <TIME> || <DATETIME> ] [ '(' <number> ')' ]?
    |
    <DECIMAL> [ '(' <number> ')' || [ <m=.number> ',' <d=.number> ] ]?
    |
    <JSON>
  }

  rule __ws_list_item { <number> <order_dir>? <REVERSE>? };
  rule __ws_nweights  { '(' <number> ')' };

  rule __ws_levels {
    <LEVEL> ? $<ws_list> = [
      <__ws_list_item> [ ',' <__ws_list_item> ]*
      |
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
      |
      <COALESCE> '(' <expr_list>
      |
      [ <DATABASE> || <ROW_COUNT> ] '('
      |
      <WEIGHT_STRING> '(' <expr> [
        <__ws_levels>?
        |
        ',' <number> ',' <number> ',' <number>
        |
        <AS> [
          <CHAR> <__ws_nweights> <__ws_levels>?
          |
          <BINARY> <__ws_nweights>
        ]
      ]
      |
      [ <CONTAINS> || <POINT> ] '(' <expr> ',' <expr>
      |
      <GEOMETRYCOLLECTION> '(' <expr_list>?
      |
      [ <LINESTRING> || <MULTILINESTRING> || <MULTIPOINT> || <MULTIPOLYGON> ||
        <POLYGON> ]
      '(' <expr_list>
    ] ')'
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

  rule _gen_function_call {
    [
      <ident_sys> '(' <udf_expr> [ ',' <udf_expr> ]*
      |
      <ident> '.' <ident> '(' <expr_list>
    ] ')'
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

  rule _when_clause {
    <WHEN> <when_expr=.expr> <THEN> <then_expr=.expr>
  }

  rule simple_expr {
    :my rule _ident_list { <simple_ident> [ ',' <simple_ident> ]* };
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
        |
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
        |
        <USING> <charset_name=.ident>
      ]
    ] ')'
    |
    '(' <ident> <expr> ')'
    |
    <CASE> <expr>?
    <_when_clause> [ <_when_clause>]*
    [ <ELSE> <else_expr=.expr> ]? <END>
    |
    <INTERVAL> <expr> <interval> '+' <expr>
  }

  my rule _gorder_clause {
    <ORDER> <BY> <_order_expr> [ ',' <_order_expr> ]*
  }

  my rule _order_expr    { <expr> <order_dir> }

  rule sum_expr {
    :my rule _in_sum_expr   { <ALL>? <expr> }
    [
      [
        [ <AVG> || <MIN> || <MAX> || <SUM> ] '(' <DISTINCT>?
        |
        [ <BIT_AND>     || <BIT_OR>   || <BIT_XOR> || <STD> || <VARIANCE> ||
          <STDDEV_SAMP> || <VAR_SAMP> ]
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
    <table_ident> [ ',' <table_ident> ]*
  }

  rule udf_expr {
    <expr> <select_alias>
  }

  rule variable {
    '@' [
      [ <ident> | <text> ] [ <SET> <expr> ]?
      |
      '@' [ <GLOBAL> || <LOCAL> || <SESSION> ] '.'
      [ <ident> | <text> ] [ '.' <ident> ]?
    ]
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

  token key_alg {
    [ <USING> || <TYPE> ] [ <BTREE> || <RTREE> || <HASH> ]
  }

  rule key_list {
    <ident> [ '(' <num> ')' ]?  <order_dir>
  }

  rule key_lists {
    <key_list> [ ',' <key_list> ]*
  }

  token key_or_index {
     <KEY> || <INDEX>
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
