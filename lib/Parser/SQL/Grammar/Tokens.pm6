use v6.c;

unit module Parser::SQL::Grammar::Tokens;

our token EQ is export          { «'EQ'» || '='  }
our token GE is export          { «'GE'» || '>=' }
our token LE is export          { «'LE'» || '<=' }
our token GT is export          { «'GT'» || '>' }
our token LT is export          { «'LT'» || '<' }
our token NE is export          { «'NE'» || '<>' }

our token AND2 is export        { '&&' }
our token BIT_AND is export		  { '&' }
our token BIT_NOT is export     { '~' }
our token BIT_OR is export		  { '|' }
our token BIT_XOR is export		  { «'XOR'» }
our token MINUS is export       { '-' }
our token NOT_OP is export      { '!' }
our token NOT2                  { '<>' }
our token OR2 is export         { '||' }
our token PLUS is export        { '+' }
our token SHIFT_L is export     { '<<' }
our token SHIFT_R is export     { '>>' }

our token PARAM_MARK is export  { '?' }

# Interval symbols
our token DAY is export		      { 'DAY' }
our token WEEK is export		    { 'WEEK' }
our token HOUR is export		    { 'HOUR' }
our token MINUTE is export		  { 'MINUTE' }
our token MONTH is export		    { 'MONTH' }
our token QUARTER is export		  { 'QUARTER' }
our token SECOND is export		  { 'SECOND' }
our token MICROSECOND is export	{ 'MICROSECOND' }
our token YEAR is export		    { 'YEAR' }

our token DAY_HOUR is export		       { 'DAY_HOUR' }
our token DAY_MICROSECOND is export		 { 'DAY_MICROSECOND' }
our token DAY_MINUTE is export		     { 'DAY_MINUTE' }
our token DAY_SECOND is export		     { 'DAY_SECOND' }
our token HOUR_MICROSECOND is export	 { 'HOUR_MICROSECOND' }
our token HOUR_MINUTE is export		     { 'HOUR_MINUTE' }
our token HOUR_SECOND is export		     { 'HOUR_SECOND' }
our token MINUTE_MICROSECOND is export { 'MINUTE_MICROSECOND' }
our token MINUTE_SECOND is export		   { 'MINUTE_SECOND' }
our token SECOND_MICROSECOND is export { 'SECOND_MICROSECOND' }
our token YEAR_MONTH is export         { 'YEAR_MONTH' }

our token interval_time_stamp is export {
    <DAY>         |
    <HOUR>        |
    <MICROSECOND> |
    <MINUTE>      |
    <MONTH>       |
    <QUARTER>     |
    <SECOND>      |
    <WEEK>        |
    <YEAR>
}

our token interval is export {
    <interval_time_stamp> |
    <DAY_HOUR>            |
    <DAY_MICROSECOND>     |
    <DAY_MINUTE>          |
    <DAY_SECOND>          |
    <HOUR_MICROSECOND>    |
    <HOUR_MINUTE>         |
    <HOUR_SECOND>         |
    <MINUTE_MICROSECOND>  |
    <MINUTE_SECOND>       |
    <SECOND_MICROSECOND>  |
    <YEAR_MONTH>
}

our token ACCOUNT is export            { 'ACCOUNT' }
our token ACTION is export             { 'ACTION' }
our token ADD is export                { 'ADD' }
our token ADDDATE is export            { 'ADDDATE' }
our token AFTER is export              { 'AFTER' }
our token AGAINST is export            { 'AGAINST' }
our token AGGREGATE is export          { 'AGGREGATE' }
our token ALGORITHM is export          { 'ALGORITHM' }
our token ALL is export                { 'ALL' }
our token ALWAYS is export             { 'ALWAYS' }
our token ANALYSE is export            { 'ANALYSE' }
our token AND is export                { 'AND' }
our token ANY is export                { 'ANY' }
our token AS is export                 { 'AS' }
our token ASC is export                { 'ASC' }
our token ASCII is export              { 'ASCII' }
our token AT is export                 { 'AT' }
our token AVG is export                { 'AVG' }
our token BACKUP is export             { 'BACKUP' }
our token BEGIN is export              { 'BEGIN' }
our token BETWEEN is export            { 'BETWEEN' }
our token BIGINT is export             { 'BIGINT' }
our token BINARY is export             { 'BINARY' }
our token BINLOG is export             { 'BINLOG' }
our token BIT is export                { 'BIT' }
our token BLOB is export               { 'BLOB' }
our token BLOCK is export              { 'BLOCK' }
our token BOOL is export               { 'BOOL' }
our token BOOLEAN is export            { 'BOOLEAN' }
our token BOTH is export               { 'BOTH' }
our token BTREE is export              { 'BTREE' }
our token BY is export                 { 'BY' }
our token BYTE is export               { 'BYTE' }
our token CACHE is export              { 'CACHE' }
our token CASCADE is export            { 'CASCADE' }
our token CASCADED is export           { 'CASCADED' }
our token CASE is export               { 'CASE' }
our token CAST is export               { 'CAST' }
our token CHAIN is export              { 'CHAIN' }
our token CHANGED is export            { 'CHANGED' }
our token CHANNEL is export            { 'CHANNEL' }
our token CHAR is export               { 'CHAR' }
our token CHARSET is export            { 'CHARSET' }
our token CHECK is export              { 'CHECK' }
our token CHECKSUM is export           { 'CHECKSUM' }
our token CIPHER is export             { 'CIPHER' }
our token CLIENT is export             { 'CLIENT' }
our token CLOSE is export              { 'CLOSE' }
our token COALESCE is export           { 'COALESCE' }
our token CODE is export               { 'CODE' }
our token COLLATE is export            { 'COLLATE' }
our token COLLATION is export          { 'COLLATION' }
our token COLUMNS is export            { 'COLUMNS' }
our token COMMENT is export            { 'COMMENT' }
our token COMMIT is export             { 'COMMIT' }
our token COMMITTED is export          { 'COMMITTED' }
our token COMPACT is export            { 'COMPACT' }
our token COMPLETION is export         { 'COMPLETION' }
our token COMPRESSED is export         { 'COMPRESSED' }
our token COMPRESSION is export        { 'COMPRESSION' }
our token CONCURRENT is export         { 'CONCURRENT' }
our token CONNECTION is export         { 'CONNECTION' }
our token CONSISTENT is export         { 'CONSISTENT' }
our token CONSTRAINT is export         { 'CONSTRAINT' }
our token CONTAINS is export           { 'CONTAINS' }
our token CONTEXT is export            { 'CONTEXT' }
our token CONVERT is export            { 'CONVERT' }
our token COUNT is export              { 'COUNT' }
our token CPU is export                { 'CPU' }
our token _CREATE is export            { 'CREATE' }
our token CROSS is export              { 'CROSS' }
our token CUBE is export               { 'CUBE' }
our token CURDATE is export            { 'CURDATE' }
our token CURRENT is export            { 'CURRENT' }
our token CURTIME is export            { 'CURTIME' }
our token DATA is export               { 'DATA' }
our token DATABASE is export           { 'DATABASE' }
our token DATAFILE is export           { 'DATAFILE' }
our token DATE is export               { 'DATE' }
our token DATETIME is export           { 'DATETIME' }
our token DEALLOCATE is export         { 'DEALLOCATE' }
our token DECIMAL is export            { 'DECIMAL' }
our token DEFAULT is export            { 'DEFAULT' }
our token DEFINER is export            { 'DEFINER' }
our token DELETE is export             { 'DELETE' }
our token DESC is export               { 'DESC' }
our token DIAGNOSTICS is export        { 'DIAGNOSTICS' }
our token DIRECTORY is export          { 'DIRECTORY' }
our token DISABLE is export            { 'DISABLE' }
our token DISCARD is export            { 'DISCARD' }
our token DISK is export               { 'DISK' }
our token DISTINCT is export           { 'DISTINCT' }
our token DIV is export                { 'DIV' }
our token DO is export                 { 'DO' }
our token DOUBLE is export             { 'DOUBLE' }
our token DUAL is export               { 'DUAL' }
our token DUMPFILE is export           { 'DUMPFILE' }
our token DUPLICATE is export          { 'DUPLICATE' }
our token DYNAMIC is export            { 'DYNAMIC' }
our token ELSE is export               { 'ELSE' }
our token ENABLE is export             { 'ENABLE' }
our token ENCLOSED is export           { 'ENCLOSED' }
our token ENCRYPTION is export 		     { 'ENCRYPTION' }
our token END is export                { 'END' }
our token ENDS is export               { 'ENDS' }
our token ENGINE is export             { 'ENGINE' }
our token ENGINES is export            { 'ENGINES' }
our token ENUM is export               { 'ENUM' }
our token ERROR is export              { 'ERROR' }
our token ERRORS is export             { 'ERRORS' }
our token ESCAPE is export             { 'ESCAPE' }
our token ESCAPED is export            { 'ESCAPED' }
our token EVENT is export              { 'EVENT' }
our token EVENTS is export             { 'EVENTS' }
our token EVERY is export              { 'EVERY' }
our token EXCHANGE is export           { 'EXCHANGE' }
our token EXECUTE is export            { 'EXECUTE' }
our token EXISTS is export             { 'EXISTS' }
our token EXPANSION is export          { 'EXPANSION' }
our token EXPIRE is export             { 'EXPIRE' }
our token _EXPORT is export            { 'EXPORT' }
our token EXPR is export               { 'EXPR' }
our token EXTENDED is export           { 'EXTENDED' }
our token EXTRACT is export            { 'EXTRACT' }
our token FALSE is export              { 'FALSE' }
our token FAST is export               { 'FAST' }
our token FAULTS is export             { 'FAULTS' }
our token FILE is export               { 'FILE' }
our token FILTER is export             { 'FILTER' }
our token FIRST is export              { 'FIRST' }
our token FIXED is export              { 'FIXED' }
our token FLOAT is export              { 'FLOAT' }
our token FLUSH is export              { 'FLUSH' }
our token FOLLOWS is export            { 'FOLLOWS' }
our token FOR is export                { 'FOR' }
our token FOREIGN is export            { 'FOREIGN' }
our token FORMAT is export             { 'FORMAT' }
our token FOUND is export              { 'FOUND' }
our token FROM is export               { 'FROM' }
our token FULL is export               { 'FULL' }
our token FULLTEXT is export           { 'FULLTEXT' }
our token FUNCTION is export           { 'FUNCTION' }
our token GENERAL is export            { 'GENERAL' }
our token GENERATED is export          { 'GENERATED' }
our token GEOMETRY is export           { 'GEOMETRY' }
our token GEOMETRYCOLLECTION is export { 'GEOMETRYCOLLECTION' }
our token GET is export                { 'GET' }
our token GLOBAL is export             { 'GLOBAL' }
our token GRANT is export              { 'GRANT' }
our token GRANTS is export             { 'GRANTS' }
our token GROUP is export              { 'GROUP' }
our token HANDLER is export            { 'HANDLER' }
our token HASH is export               { 'HASH' }
our token HAVING is export             { 'HAVING' }
our token HELP is export               { 'HELP' }
our token HOST is export               { 'HOST' }
our token HOSTS is export              { 'HOSTS' }
our token IDENT is export              { 'IDENT' }
our token IDENTIFIED is export         { 'IDENTIFIED' }
our token IF is export                 { 'IF' }
our token IGNORE is export             { 'IGNORE' }
our token IMPORT is export             { 'IMPORT' }
our token IN is export                 { 'IN' }
our token INDEX is export              { 'INDEX' }
our token INDEXES is export            { 'INDEXES' }
our token INNER is export              { 'INNER' }
our token INSERT is export             { 'INSERT' }
our token INSTALL is export            { 'INSTALL' }
our token INSTANCE is export           { 'INSTANCE' }
our token INT is export                { 'INT' }
our token INTERNAL is export           { 'INTERNAL' }
our token INTERVAL is export           { 'INTERVAL' }
our token INTO is export               { 'INTO' }
our token INVOKER is export            { 'INVOKER' }
our token IO is export                 { 'IO' }
our token IPC is export                { 'IPC' }
our token IS is export                 { 'IS' }
our token ISOLATION is export          { 'ISOLATION' }
our token ISSUER is export             { 'ISSUER' }
our token JOIN is export               { 'JOIN' }
our token JSON is export               { 'JSON' }
our token KEY is export                { 'KEY' }
our token LANGUAGE is export           { 'LANGUAGE' }
our token LAST is export               { 'LAST' }
our token LEADING is export            { 'LEADING' }
our token LEAVES is export             { 'LEAVES' }
our token LEFT is export               { 'LEFT' }
our token LESS is export               { 'LESS' }
our token LEVEL is export              { 'LEVEL' }
our token LIKE is export               { 'LIKE' }
our token LIMIT is export              { 'LIMIT' }
our token LINEAR is export             { 'LINEAR' }
our token LINES is export              { 'LINES' }
our token LINESTRING is export         { 'LINESTRING' }
our token LIST is export               { 'LIST' }
our token LOCAL is export              { 'LOCAL' }
our token LOCK is export               { 'LOCK' }
our token LOCKS is export              { 'LOCKS' }
our token LOGFILE is export            { 'LOGFILE' }
our token LOGS is export               { 'LOGS' }
our token LONG is export               { 'LONG' }
our token LONGBLOB is export           { 'LONGBLOB' }
our token LONGTEXT is export           { 'LONGTEXT' }
our token MASTER is export             { 'MASTER' }
our token MATCH is export              { 'MATCH' }
our token MAX is export                { 'MAX' }
our token MEDIUM is export             { 'MEDIUM' }
our token MEDIUMBLOB is export         { 'MEDIUMBLOB' }
our token MEDIUMINT is export          { 'MEDIUMINT' }
our token MEDIUMTEXT is export         { 'MEDIUMTEXT' }
our token MEMORY is export             { 'MEMORY' }
our token MERGE is export              { 'MERGE' }
our token MIGRATE is export            { 'MIGRATE' }
our token MIN is export                { 'MIN' }
our token MOD is export                { 'MOD' }
our token MODE is export               { 'MODE' }
our token MODIFY is export             { 'MODIFY' }
our token MULTILINESTRING is export    { 'MULTILINESTRING' }
our token MULTIPOINT is export         { 'MULTIPOINT' }
our token MULTIPOLYGON is export       { 'MULTIPOLYGON' }
our token MUTEX is export              { 'MUTEX' }
our token NAME is export               { 'NAME' }
our token NAMES is export              { 'NAMES' }
our token NATIONAL is export           { 'NATIONAL' }
our token NATURAL is export            { 'NATURAL' }
our token NCHAR is export              { 'NCHAR' }
our token NDBCLUSTER is export         { 'NDBCLUSTER' }
our token NEVER is export              { 'NEVER' }
our token NEW is export                { 'NEW' }
our token NEXT is export               { 'NEXT' }
our token NO is export                 { 'NO' }
our token NODEGROUP is export          { 'NODEGROUP' }
our token NONE is export               { 'NONE' }
our token NOT is export                { 'NOT' }
our token NOW is export                { 'NOW' }
our token NULL is export               { 'NULL' }
our token NUMBER is export             { 'NUMBER' }
our token NUMERIC is export            { 'NUMERIC' }
our token NVARCHAR is export           { 'NVARCHAR' }
our token OFFSET is export             { 'OFFSET' }
our token ON is export                 { 'ON' }
our token ONE is export                { 'ONE' }
our token ONLY is export               { 'ONLY' }
our token OPEN is export               { 'OPEN' }
our token OPTION is export             { 'OPTION' }
our token OPTIONALLY is export         { 'OPTIONALLY' }
our token OPTIONS is export            { 'OPTIONS' }
our token OR is export                 { 'OR' }
our token ORDER is export              { 'ORDER' }
our token OUTER is export              { 'OUTER' }
our token OUTFILE is export            { 'OUTFILE' }
our token OWNER is export              { 'OWNER' }
our token PAGE is export               { 'PAGE' }
our token PARSER is export             { 'PARSER' }
our token PARTIAL is export            { 'PARTIAL' }
our token PARTITION is export          { 'PARTITION' }
our token PARTITIONING is export       { 'PARTITIONING' }
our token PARTITIONS is export 		     { 'PARTITIONS' }
our token PASSWORD is export           { 'PASSWORD' }
our token PHASE is export              { 'PHASE' }
our token PLUGIN is export             { 'PLUGIN' }
our token PLUGINS is export            { 'PLUGINS' }
our token POINT is export              { 'POINT' }
our token POLYGON is export            { 'POLYGON' }
our token PORT is export               { 'PORT' }
our token POSITION is export           { 'POSITION' }
our token PRECEDES is export           { 'PRECEDES' }
our token PRECISION is export          { 'PRECISION' }
our token PREPARE is export            { 'PREPARE' }
our token PRESERVE is export           { 'PRESERVE' }
our token PREV is export               { 'PREV' }
our token PRIMARY is export            { 'PRIMARY' }
our token PRIVILEGES is export         { 'PRIVILEGES' }
our token PROCEDURE is export          { 'PROCEDURE' }
our token PROCESS is export            { 'PROCESS' }
our token PROCESSLIST is export        { 'PROCESSLIST' }
our token PROFILE is export            { 'PROFILE' }
our token PROFILES is export           { 'PROFILES' }
our token PROXY is export              { 'PROXY' }
our token QUERY is export              { 'QUERY' }
our token QUICK is export              { 'QUICK' }
our token RANGE is export              { 'RANGE' }
our token REAL is export               { 'REAL' }
our token REBUILD is export            { 'REBUILD' }
our token RECOVER is export            { 'RECOVER' }
our token REDOFILE is export           { 'REDOFILE' }
our token REDUNDANT is export          { 'REDUNDANT' }
our token REFERENCES is export         { 'REFERENCES' }
our token REGEXP is export             { 'REGEXP' }
our token RELAY is export              { 'RELAY' }
our token RELAYLOG is export           { 'RELAYLOG' }
our token RELOAD is export             { 'RELOAD' }
our token REMOVE is export             { 'REMOVE' }
our token REORGANIZE is export         { 'REORGANIZE' }
our token REPAIR is export             { 'REPAIR' }
our token REPEAT is export             { 'REPEAT' }
our token REPEATABLE is export         { 'REPEATABLE' }
our token REPLACE is export            { 'REPLACE' }
our token REPLICATION is export        { 'REPLICATION' }
our token REQUIRE is export            { 'REQUIRE' }
our token RESET is export              { 'RESET' }
our token RESOURCES is export          { 'RESOURCES' }
our token RESTORE is export            { 'RESTORE' }
our token RESTRICT is export           { 'RESTRICT' }
our token RESUME is export             { 'RESUME' }
our token RETURNS is export            { 'RETURNS' }
our token REVERSE is export            { 'REVERSE' }
our token RIGHT is export              { 'RIGHT' }
our token ROLLBACK is export           { 'ROLLBACK' }
our token ROLLUP is export             { 'ROLLUP' }
our token ROTATE is export             { 'ROTATE' }
our token ROUTINE is export            { 'ROUTINE' }
our token ROW is export                { 'ROW' }
our token ROWS is export               { 'ROWS' }
our token RTREE is export              { 'RTREE' }
our token SAVEPOINT is export          { 'SAVEPOINT' }
our token SCHEDULE is export           { 'SCHEDULE' }
our token SECURITY is export           { 'SECURITY' }
our token SELECT is export             { 'SELECT' }
our token SEPARATOR is export          { 'SEPARATOR' }
our token SERIAL is export             { 'SERIAL' }
our token SERIALIZABLE is export       { 'SERIALIZABLE' }
our token SERVER is export             { 'SERVER' }
our token SESSION is export            { 'SESSION' }
our token SET is export                { 'SET' }
our token SHARE is export              { 'SHARE' }
our token SHUTDOWN is export           { 'SHUTDOWN' }
our token SIGNED is export             { 'SIGNED' }
our token SIMPLE is export             { 'SIMPLE' }
our token SLAVE is export              { 'SLAVE' }
our token SLOW is export               { 'SLOW' }
our token SMALLINT is export           { 'SMALLINT' }
our token SNAPSHOT is export           { 'SNAPSHOT' }
our token SOCKET is export             { 'SOCKET' }
our token SONAME is export             { 'SONAME' }
our token SOUNDS is export             { 'SOUNDS' }
our token SOURCE is export             { 'SOURCE' }
our token SPACIAL is export            { 'SPACIAL' }
our token SSL is export                { 'SSL' }
our token STACKED is export            { 'STACKED' }
our token START is export              { 'START' }
our token STARTING is export           { 'STARTING' }
our token STARTS is export             { 'STARTS' }
our token STATUS is export             { 'STATUS' }
our token STD is export                { 'STD' }
our token STOP is export               { 'STOP' }
our token STORAGE is export            { 'STORAGE' }
our token STORED is export             { 'STORED' }
our token STRING is export             { 'STRING' }
our token SUBDATE is export            { 'SUBDATE' }
our token SUBJECT is export            { 'SUBJECT' }
our token SUBPARTITION is export       { 'SUBPARTITION' }
our token SUBPARTITIONS is export      { 'SUBPARTITIONS' }
our token SUBSTRING is export          { 'SUBSTRING' }
our token SUM is export                { 'SUM' }
our token SUPER is export              { 'SUPER' }
our token SUSPEND is export            { 'SUSPEND' }
our token SWAPS is export              { 'SWAPS' }
our token SWITCHES is export           { 'SWITCHES' }
our token SYSDATE is export            { 'SYSDATE' }
our token TABLE is export              { 'TABLE' }
our token TABLES is export             { 'TABLES' }
our token TABLESPACE is export 		     { 'TABLESPACE' }
our token TEMPORARY is export 		     { 'TEMPORARY' }
our token TEMPTABLE is export          { 'TEMPTABLE' }
our token TERMINATED is export         { 'TERMINATED' }
our token TEXT is export               { 'TEXT' }
our token THAN is export               { 'THAN' }
our token THEN is export               { 'THEN' }
our token TIME is export               { 'TIME' }
our token TIMESTAMP is export          { 'TIMESTAMP' }
our token TINYBLOB is export           { 'TINYBLOB' }
our token TINYINT is export            { 'TINYINT' }
our token TINYTEXT is export           { 'TINYTEXT' }
our token TRAILING is export           { 'TRAILING' }
our token TRANSACTION is export        { 'TRANSACTION' }
our token TRIGGERS is export           { 'TRIGGERS' }
our token TRIM is export               { 'TRIM' }
our token TRUE is export               { 'TRUE' }
our token TRUNCATE is export           { 'TRUNCATE' }
our token TYPE is export               { 'TYPE' }
our token TYPES is export              { 'TYPES' }
our token UNCOMMITTED is export        { 'UNCOMMITTED' }
our token UNDEFINED is export          { 'UNDEFINED' }
our token UNDOFILE is export 		       { 'UNDOFILE' }
our token UNICODE is export            { 'UNICODE' }
our token UNINSTALL is export          { 'UNINSTALL' }
our token UNION is export              { 'UNION' }
our token UNIQUE is export             { 'UNIQUE' }
our token UNKNOWN is export            { 'UNKNOWN' }
our token UNLOCK is export             { 'UNLOCK' }
our token UNSIGNED is export           { 'UNSIGNED' }
our token UNTIL is export              { 'UNTIL' }
our token UPDATE is export             { 'UPDATE' }
our token UPGRADE is export            { 'UPGRADE' }
our token USER is export               { 'USER' }
our token USING is export              { 'USING' }
our token UTC is export                { 'UTC' }
our token VALIDATION is export         { 'VALIDATION' }
our token VALUE is export              { 'VALUE' }
our token VALUES is export             { 'VALUES' }
our token VARBINARY is export          { 'VARBINARY' }
our token VARCHAR is export            { 'VARCHAR' }
our token VARIABLES is export          { 'VARIABLES' }
our token VARIANCE is export           { 'VARIANCE' }
our token VARYING is export            { 'VARYING' }
our token VIEW is export               { 'VIEW' }
our token VIRTUAL is export            { 'VIRTUAL' }
our token WAIT is export               { 'WAIT' }
our token WARNINGS is export           { 'WARNINGS' }
our token WHEN is export               { 'WHEN' }
our token WHERE is export              { 'WHERE' }
our token WITH is export               { 'WITH' }
our token WITHOUT is export            { 'WITHOUT' }
our token WORK is export               { 'WORK' }
our token WRAPPER is export            { 'WRAPPER' }
our token X509 is export 		           { 'X509' }
our token XA is export                 { 'XA' }
our token XID is export                { 'XID' }
our token XML is export                { 'XML' }
our token XOR is export                { 'XOR' }
our token ZEROFILL is export           { 'ZEROFILL' }


our token AUTO_INC is export                    { 'AUTO_INC' }
our token AUTOEXTEND_SIZE is export             { 'AUTOEXTEND_SIZE' }
our token AVG_ROW_LENGTH is export              { 'AVG_ROW_LENGTH' }
our token CATALOG_NAME is export                { 'CATALOG_NAME' }
our token CLASS_ORIGIN is export                { 'CLASS_ORIGIN' }
our token COLUMN_FORMAT is export               { 'COLUMN_FORMAT' }
our token COLUMN_NAME is export                 { 'COLUMN_NAME' }
our token CONSTRAINT_CATALOG is export          { 'CONSTRAINT_CATALOG' }
our token CONSTRAINT_NAME is export             { 'CONSTRAINT_NAME' }
our token CONSTRAINT_SCHEMA is export           { 'CONSTRAINT_SCHEMA' }
our token CURRENT_USER is export                { 'CURRENT_USER' }
our token CURSOR_NAME is export                 { 'CURSOR_NAME' }
our token DATE_ADD is export                    { 'DATE_ADD' }
our token DATE_SUB is export                    { 'DATE_SUB' }
our token DEFAULT_AUTH is export                { 'DEFAULT_AUTH' }
our token DELAY_KEY_WRITE is export             { 'DELAY_KEY_WRITE' }
our token DES_KEY_FILE is export                { 'DES_KEY_FILE' }
our token EXTENT_SIZE is export                 { 'EXTENT_SIZE' }
our token FILE_BLOCK_SIZE is export             { 'FILE_BLOCK_SIZE' }
our token GET_FORMAT is export                  { 'GET_FORMAT' }
our token GROUP_CONCAT is export                { 'GROUP_CONCAT' }
our token GROUP_REPLICATION is export           { 'GROUP_REPLICATION' }
our token HIGH_PRIORITY is export 		          { 'HIGH_PRIORITY' }
our token IDENT_QUOTED is export                { 'IDENT_QUOTED' }
our token IGNORE_SERVER_IDS is export           { 'IGNORE_SERVER_IDS' }
our token INITIAL_SIZE is export                { 'INITIAL_SIZE' }
our token INSERT_METHOD is export               { 'INSERT_METHOD' }

our token JSON_SEPARATOR is export              { ':' }
our token JSON_UNQ_SEPEARATOR is export         { ',' }

our token KEY_BLOCK_SIZE is export              { 'KEY_BLOCK_SIZE' }
our token MASTER_AUTO_POSITION is export        { 'MASTER_AUTO_POSITION' }
our token MASTER_CONNECT_RETRY is export        { 'MASTER_CONNECT_RETRY' }
our token MASTER_DELAY is export                { 'MASTER_DELAY' }
our token MASTER_HEARTBEAT_PERIOD is export     { 'MASTER_HEARTBEAT_PERIOD' }
our token MASTER_HOST is export                 { 'MASTER_HOST' }
our token MASTER_LOG_FILE is export             { 'MASTER_LOG_FILE' }
our token MASTER_LOG_POS is export              { 'MASTER_LOG_POS' }
our token MASTER_PASSWORD is export             { 'MASTER_PASSWORD' }
our token MASTER_PORT is export                 { 'MASTER_PORT' }
our token MASTER_RETRY_COUNT is export          { 'MASTER_RETRY_COUNT' }
our token MASTER_SERVER_ID is export            { 'MASTER_SERVER_ID' }
our token MASTER_SSL is export                  { 'MASTER_SSL' }
our token MASTER_SSL_CA is export               { 'MASTER_SSL_CA' }
our token MASTER_SSL_CAPATH is export           { 'MASTER_SSL_CAPATH' }
our token MASTER_SSL_CERT is export             { 'MASTER_SSL_CERT' }
our token MASTER_SSL_CIPHER is export           { 'MASTER_SSL_CIPHER' }
our token MASTER_SSL_CRL is export              { 'MASTER_SSL_CRL' }
our token MASTER_SSL_CRLPATH is export          { 'MASTER_SSL_CRLPATH' }
our token MASTER_SSL_KEY is export              { 'MASTER_SSL_KEY' }
our token MASTER_TLS_VERSION is export          { 'MASTER_TLS_VERSION' }
our token MASTER_USER is export                 { 'MASTER_USER' }
our token MAX_CONNECTIONS_PER_HOUR is export    { 'MAX_CONNECTIONS_PER_HOUR' }
our token MAX_QUERIES_PER_HOUR is export        { 'MAX_QUERIES_PER_HOUR' }
our token MAX_ROWS is export                    { 'MAX_ROWS' }
our token MAX_SIZE is export                    { 'MAX_SIZE' }
our token MAX_UPDATES_PER_HOUR is export        { 'MAX_UPDATES_PER_HOUR' }
our token MAX_USER_CONNECTIONS is export        { 'MAX_USER_CONNECTIONS' }
our token MAX_VALUE is export                   { 'MAX_VALUE' }
our token MESSAGE_TEXT is export                { 'MESSAGE_TEXT' }
our token MIN_ROWS is export                    { 'MIN_ROWS' }
our token MYSQL_ERRNO is export                 { 'MYSQL_ERRNO' }
our token NO_WAIT is export                     { 'NO_WAIT' }
our token PACK_KEYS is export                   { 'PACK_KEYS' }
our token PARSE_GCOL_EXPR is export             { 'PARSE_GCOL_EXPR' }
our token PLUGIN_DIR is export                  { 'PLUGIN_DIR' }
our token READ_ONLY is export                   { 'READ_ONLY' }
our token REDO_BUFFER_SIZE is export            { 'REDO_BUFFER_SIZE' }
our token RELAY_LOG_FILE is export              { 'RELAY_LOG_FILE' }
our token RELAY_LOG_POS is export               { 'RELAY_LOG_POS' }
our token RELAY_THREAD is export                { 'RELAY_THREAD' }
our token REPLICATE_DO_DB is export             { 'REPLICATE_DO_DB' }
our token REPLICATE_DO_TABLE is export          { 'REPLICATE_DO_TABLE' }
our token REPLICATE_IGNORE_DB is export         { 'REPLICATE_IGNORE_DB' }
our token REPLICATE_IGNORE_TABLE is export      { 'REPLICATE_IGNORE_TABLE' }
our token REPLICATE_REWRITE_DB is export        { 'REPLICATE_REWRITE_DB' }
our token REPLICATE_WILD_DO_TABLE is export     { 'REPLICATE_WILD_DO_TABLE' }
our token REPLICATE_WILD_IGNORE_TABLE is export { 'REPLICATE_WILD_IGNORE_TABLE' }
our token RETURNED_SQLSTATE is export           { 'RETURNED_SQLSTATE' }
our token ROW_COUNT is export                   { 'ROW_COUNT' }
our token ROW_FORMAT is export                  { 'ROW_FORMAT' }
our token SCHEMA_NAME is export                 { 'SCHEMA_NAME' }
our token SQL_AFTER_GTIDS is export             { 'SQL_AFTER_GTIDS' }
our token SQL_AFTER_MTS_GAPS is export          { 'SQL_AFTER_MTS_GAPS' }
our token SQL_BEFORE_GTIDS is export            { 'SQL_BEFORE_GTIDS' }
our token SQL_BIG_RESULT is export 		          { 'SQL_BIG_RESULT' }
our token SQL_BUFFER_RESULT is export           { 'SQL_BUFFER_RESULT' }
our token SQL_CACHE is export                   { 'SQL_CACHE' }
our token SQL_CALC_FOUND_ROWS is export 		    { 'SQL_CALC_FOUND_ROWS' }
our token SQL_NO_CACHE is export                { 'SQL_NO_CACHE' }
our token SQL_SMALL_RESULT is export 		        { 'SQL_SMALL_RESULT' }
our token SQL_THREAD is export                  { 'SQL_THREAD' }
our token STATS_AUTO_RECALC is export           { 'STATS_AUTO_RECALC' }
our token STATS_PERSISTENT is export            { 'STATS_PERSISTENT' }
our token STATS_SAMPLE_PAGES is export          { 'STATS_SAMPLE_PAGES' }
our token STDDEV_SAMP is export                 { 'STDDEV_SAMP' }
our token STRAIGHT_JOIN is export 		          { 'STRAIGHT_JOIN' }
our token SUBCLASS_ORIGIN is export             { 'SUBCLASS_ORIGIN' }
our token TABLE_CHECKSUM is export              { 'TABLE_CHECKSUM' }
our token TABLE_NAME is export                  { 'TABLE_NAME' }
our token TIMESTAMP_ADD is export               { 'TIMESTAMP_ADD' }
our token TIMESTAMP_DIFF is export              { 'TIMESTAMP_DIFF' }
our token UDF_RETURNS is export                 { 'UDF_RETURNS' }
our token UNDO_BUFFER_SIZE is export            { 'UNDO_BUFFER_SIZE' }
our token USE is export                         { 'USE' }
our token USE_FRM is export                     { 'USE_FRM' }
our token UTC_DATE is export                    { 'UTC_DATE' }
our token UTC_TIME is export                    { 'UTC_TIME' }
our token UTC_TIMESTAMP is export               { 'UTC_TIMESTAMP' }
our token VAR_SAMP is export                    { 'VAR_SAMP' }
our token WEIGHT_STRING is export               { 'WEIGHT_STRING' }
our token WITH_CUBE is export                   { 'WITH_CUBE' }
our token WITH_ROLLUP is export                 { 'WITH_ROLLUP' }
our token YEAR_SYMACTION is export              { 'YEAR_SYMACTION' }

our token all_or_any is export  {  <ALL> | <ANY>     }
our token and is export         {  <AND> | <AND2>    }
our token not2 is export        {  <NOT> | <NOT2>    }
our token or is export          {   <OR> | <OR2>     }
our token plus_minus is export  { <PLUS> | <MINUS>   }

our token bit_ops is export {
  '|' || '&' || '*' || '/' || '%' || '^' ||
   <SHIFT_L> || <SHIFT_R> || <DIV> || <MOD>
}

our token comp_ops is export {
  <EQ> | <GE> | <GT> | <LE> | <LT> | <NE>
}

our token bin_num is export {
  'B'  [ <[01]>+ || "'" <[01]>+ "'" ]
  ||
  '0b' [ <[01]>+ || "'" <[01]>+ "'" ]
}

our token hex_num is export {
  '0'? [ 'x' || 'X' ] [
    <[0123456789ABCDEFabcdef]>+ || "'" <[0123456789ABCDEFabcdef]>+ "'"
  ] »
}

our token number is export        { \d+ }
# cw: <item=.rule> should mean that .rule is non-capturing and the results should
#     go to item, instead. Has there been a syntax change? Try a one-liner for
#     #perl6
our token num is export           {
  $<s>=<[+-]>? <whole=number> [ '.' <dec=number> ]? <!before '.'>
}
our token signed_number is export { $<s>=<[+-]>? <number> }
our token ulong_num is export     { <number> | <hex_num> }

our token order_dir is export     { <ASC> | <DESC> }
our token union_opt is export     { <DISTINCT> | <ALL> }
our token key_or_index is export  { <KEY> | <INDEX> }

our token keyword_sp is export {
  <ACTION>      | <ADDDATE>   | <AFTER>   | <AGAINST>   | <AGGREGATE>  |
  <ALGORITHM>   | <ANALYSE>   | <ANY>     | <AT>        | <AUTO_INC>   |
  <AUTOEXTEND_SIZE>           | <AVG_ROW_LENGTH>        | <AVG>        |
  <BINLOG>      | <BIT>       | <BLOCK>   | <BOOL>      | <BOOLEAN>    |
  <BTREE>       | <CASCADED>  | <CATALOG_NAME>          | <CHAIN>      |
  <CHANGED>     | <CHANNEL>   | <CIPHER>  |
  <CLASS_ORIGIN>              | <CLIENT>  | <COALESCE>  | <CODE>       |
  <COLLATION>   | <COLUMN_FORMAT>         | <COLUMN_NAME>              |
  <COLUMNS>     | <COMMITTED> | <COMPACT> | <COMPLETION>               |
  <COMPRESSED>  | <COMPRESSION>           | <CONCURRENT>               |
  <CONNECTION>  | <CONSISTENT>             | <CONSTRAINT_CATALOG>      |
  <CONSTRAINT_NAME>           | <CONSTRAINT_SCHEMA>     | <CONTEXT>    |
  <CPU>         | <CUBE>      | <CURRENT> | <CURSOR_NAME>              |
  <DATA>        | <DATAFILE>  | <DATE>    | <DATETIME>  | <DAY>        |
  <DEFAULT_AUTH>              | <DEFINER> | <DELAY_KEY_WRITE>          |
  <DISABLE>     | <DISCARD>   | <DISK>    | <DUMPFILE>  | <DUPLICATE>  |
  <DES_KEY_FILE>              | <DIAGNOSTICS>           | <DIRECTORY>  |
  <DYNAMIC>     | <ENABLE>    | <ENCRYPTION>            | <ENDS>       |
  <ENGINE>      | <ENGINES>   | <ENUM>    | <ERROR>     | <ERRORS>     |
  <ESCAPE>      | <EVENT>     | <EVENTS>  | <EVERY>     | <EXCHANGE>   |
  <EXPANSION>   | <EXPIRE>    | <_EXPORT> | <EXTENDED>  |
  <EXTENT_SIZE> | <FAST>      | <FAULTS>  | <FILE_BLOCK_SIZE>          |
  <FILE>        | <FILTER>    | <FIRST>   | <FIXED>     | <FOUND>      |
  <FULL>        | <FUNCTION>  | <GENERAL> | <GEOMETRY>  |
  <GEOMETRYCOLLECTION>        | <GET_FORMAT>            | <GLOBAL>     |
  <GRANTS>      | <HASH>      | <HOSTS>   | <HOUR>      | <IDENTIFIED> |
  <IGNORE_SERVER_IDS>         | <IMPORT>  | <INDEXES>   |
  <INITIAL_SIZE>              | <INSERT_METHOD>         | <INSTANCE>   |
  <INVOKER>     | <IO>        | <IPC>     | <ISOLATION> | <ISSUER>     |
  <JSON>        | <KEY_BLOCK_SIZE>        | <LAST>      | <LEAVES>     |
  <LESS>        | <LEVEL>     | <LINESTRING>            | <LIST>       |
  <LOCAL>       | <LOCKS>     | <LOGFILE> | <LOGS>      |
  <MASTER_AUTO_POSITION>      | <MASTER_CONNECT_RETRY>                 |
  <MASTER_DELAY>              | <MASTER_HEARTBEAT_PERIOD>              |
  <MASTER_HOST>               | <MASTER_LOG_FILE>                      |
  <MASTER_LOG_POS>            | <MASTER_PASSWORD>                      |
  <MASTER_PORT>               | <MASTER_RETRY_COUNT>                   |
  <MASTER_SERVER_ID>          | <MASTER_SSL_CA>                        |
  <MASTER_SSL_CAPATH>         | <MASTER_SSL_CERT>                      |
  <MASTER_SSL_CIPHER>         | <MASTER_SSL_CRL>                       |
  <MASTER_SSL_CRLPATH>        | <MASTER_SSL_KEY>                       |
  <MASTER_SSL>                | <MASTER_TLS_VERSION>                   |
  <MASTER_USER>               |
  <MASTER>                    | <MAX_CONNECTIONS_PER_HOUR>             |
  <MAX_QUERIES_PER_HOUR>      | <MAX_ROWS>               | <MAX_SIZE>  |
  <MAX_UPDATES_PER_HOUR>      | <MAX_USER_CONNECTIONS>   | <MEDIUM>    |
  <MEMORY>      | <MERGE>     | <MESSAGE_TEXT>           |
  <MICROSECOND> | <MIGRATE>   | <MIN_ROWS>               | <MINUTE>     |
  <MODE>        | <MODIFY>    | <MONTH>   | <MULTILINESTRING>           |
  <MULTIPOINT>  | <MULTIPOLYGON>          | <MUTEX>     | <MYSQL_ERRNO> |
  <NAME>        | <NAMES>     | <NATIONAL>              | <NCHAR>       |
  <NDBCLUSTER>  | <NEVER>     | <NEW>     | <NEXT>      | <NO_WAIT>     |
  <NODEGROUP>   | <NONE>      | <NUMBER>  | <NVARCHAR>  | <OFFSET>      |
  <ONE>         | <ONLY>      | <PACK_KEYS>             | <PAGE>        |
  <PARTIAL>     | <PARTITIONING>          | <PARTITIONS>                |
  <PASSWORD>    | <PHASE>     | <PLUGIN_DIR>            | <PLUGIN>      |
  <PLUGINS>     | <POINT>     | <POLYGON> | <PRESERVE>  | <PREV>        |
  <PRIVILEGES>  | <PROCESS>   | <PROCESSLIST>           | <PROFILE>     |
  <PROFILES>    | <PROXY>     | <QUARTER> | <QUERY>     | <QUICK>       |
  <READ_ONLY>   | <REBUILD>   | <RECOVER> | <REDO_BUFFER_SIZE>          |
  <REDOFILE>    | <REDUNDANT> | <RELAY_LOG_FILE>        |
  <RELAY_LOG_POS>             | <RELAY_THREAD>          | <RELAY>       |
  <RELAYLOG>    | <RELOAD>    | <REORGANIZE>            |
  <REPEATABLE>  | <REPLICATE_DO_DB>       | <REPLICATE_DO_TABLE>        |
  <REPLICATE_IGNORE_DB>        |
  <REPLICATE_IGNORE_TABLE>     | <REPLICATE_REWRITE_DB>                 |
  <REPLICATE_WILD_DO_TABLE>    | <REPLICATE_WILD_IGNORE_TABLE>          |
  <REPLICATION> | <RESOURCES>  | <RESUME> | <RETURNED_SQLSTATE>         |
  <RETURNS>     | <REVERSE>    | <ROLLUP> | <ROTATE>    | <ROUTINE>     |
  <ROW_COUNT>   | <ROW_FORMAT>            | <ROW>       | <ROWS>        |
  <RTREE>       | <SCHEDULE>   | <SCHEMA_NAME>          | <SECOND>      |
  <SERIAL>      | <SERIALIZABLE>          | <SESSION>   | <SHARE>       |
  <SIMPLE>      | <SLOW>       | <SNAPSHOT>             | <SOUNDS>      |
  <SOURCE>      | <SQL_AFTER_GTIDS>       | <SQL_AFTER_MTS_GAPS>        |
  <SQL_BEFORE_GTIDS>           | <SQL_BUFFER_RESULT>    | <SQL_CACHE>   |
  <SQL_NO_CACHE>               | <SQL_THREAD>           | <STACKED>     |
  <STARTS>      | <STATS_AUTO_RECALC>     | <STATS_PERSISTENT>          |
  <STATS_SAMPLE_PAGES>         | <STATUS> | <STORAGE>   | <STRING>      |
  <SUBCLASS_ORIGIN>            | <SUBDATE>              | <SUBJECT>     |
  <SUBPARTITION>               | <SUBPARTITIONS>        | <SUPER>       |
  <SUSPEND>     | <SWAPS>      | <SWITCHES>             |
  <TABLE_CHECKSUM>             | <TABLE_NAME>           | <TABLES>      |
  <TABLESPACE>  | <TEMPORARY>  | <TEMPTABLE>            | <TEXT>        |
  <THAN>        | <TIME>       | <TIMESTAMP_ADD>        |
  <TIMESTAMP_DIFF>             | <TIMESTAMP>            | <TRANSACTION> |
  <TRIGGERS>    |  <TYPE>      | <TYPES>                | <UDF_RETURNS> |
  <UNCOMMITTED>                | <UNDEFINED>            |
  <UNDO_BUFFER_SIZE>           | <UNDOFILE>             | <UNKNOWN>     |
  <UNTIL>       | <USE_FRM>    | <USER>   | <VALIDATION>                |
  <VALUE>       | <VARIABLES>  | <VIEW>   | <WAIT>      | <WARNINGS>    |
  <WEEK>        | <WEIGHT_STRING>         | <WITHOUT>   | <WORK>        |
  <X509>        | <XID>        | <XML>    | <YEAR_SYMACTION>            |
  <YEAR>
}

our token keyword is export {
  <keyword_sp> | <ACCOUNT>  | <ASCII>     | <ALWAYS>   | <BACKUP>   |
  <BEGIN>      | <BYTE>     | <CACHE>     | <CHARSET>  | <CHECKSUM> |
  <CLOSE>      | <COMMENT>  | <COMMIT>    | <CONTAINS> |
  <DEALLOCATE> | <DO>       | <END>       | <EXECUTE>  | <FLUSH>    |
  <FOLLOWS>    | <FORMAT>   |
  <GROUP_REPLICATION>       | <HANDLER>   | <HELP>     | <HOST>     |
  <INSTALL>    | <LANGUAGE> | <NO>        | <OPEN>     | <OPTIONS>  |
  <OWNER>      | <PARSER>   |
  <PARSE_GCOL_EXPR>         | <PORT>      | <PRECEDES> | <PREPARE>  |
  <REMOVE>     | <REPAIR>   | <RESET>     | <RESTORE>  | <ROLLBACK> |
  <SAVEPOINT>  | <SECURITY> | <SERVER>    | <SHUTDOWN> | <SIGNED>   |
  <SOCKET>     | <SLAVE>    | <SONAME>    | <START>    | <STOP>     |
  <TRUNCATE>   | <UNICODE>  | <UNINSTALL> | <WRAPPER>  | <XA>       |
  <UPGRADE>
}

# cw: Note the circular ref and how it needed to be avoided.
# Can Identifier consist of a sole _, @ or #? - Going with NO at this point.
# Must have a condition where a variable cannot contain all digits.
our token ident_sys is export {
  <keyword>
  ||
  <:Letter> <:Letter + :Number>+
  ||
  $<i>=[ '@' <:Letter + :Number +[ @ _ ]> <:Letter + :Number +[ _ $ ]>* ]
  ||
  $<i>=[ "@'" <:Letter + :Number +[ @ _ ]> <:Letter + :Number +[ _ $ ]>* \' ]
  ||
  $<i>=[ '@"' <:Letter + :Number +[ @ _ ]> <:Letter + :Number +[ _ $ ]>* \" ]
  ||
  # YYY: Verify that this is IDENT_QUOTED
  '"' <-[\"]>+ '"'
  ||
  "'" <-[\']>+ "'"
}

# Check to see if keyword is supposed to be in both ident_sys AND _ident.
# That doesn't make much sense.
our token _ident is export   { <ident_sys> }

our regex table_ident is export {
  '.'? <_ident> ** 1..2 % '.' <!before '.'>
}

# Needs positive look beind.
our regex field_ident is export   {
  [
    [ <table_ident>? '.' ]? <?after '.'> <_ident>
    ||
    '.'? <_ident>
  ]
  #&& <!after '.'> $
}

our token limit_options is export { <_ident> || <PARAM_MARK> || <num> }

our token query_spec_option is export {
  <STRAIGHT_JOIN>       | <HIGH_PRIORITY>     | <DISTINCT>          |
  <SQL_SMALL_RESULT>    | <SQL_BIG_RESULT>    | <SQL_BUFFER_RESULT> |
  <SQL_CALC_FOUND_ROWS> | <ALL>
}

our token simple_ident is export {
  <simple_ident_q>
}

our token simple_ident_q is export {
  '.'? <_ident> ** 1..3 % '.'
}

our token text is export {
    # Are double quotes allowed as text strings?
    "'" ( <-[']>+ ) "'" || '"' ( <-["]>+ ) '"'
}

our token text_string is export {
  <text> | <hex_num> | <bin_num>
}

our token underscore_charset is export {
  '_' <_ident>
}

our rule select_alias is export {
  <AS>?\s*$<o>=[ <_ident> || <text> ]
}
