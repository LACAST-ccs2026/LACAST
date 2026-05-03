query: with_clause&_CTE select_stmt_end&_SUBQUERY  ;
with_clause: "" | "WITH" cte_list ;
cte_list: cte_def&_SUBQUERY | cte_def&_SUBQUERY "," cte_list;
cte_def: ALIAS&_DERIVED_TABLE  "AS"  "(" select_stmt_end &_DERIVED_TABLE_COLUMN ")";

select_stmt: setOp_start |select_core_record|select_group_record;

select_stmt_end: setOp_start&_P100 order_by_clause&_ORDER_BY limit_clause
            |select_core_record&_P100 order_by_clause&_ORDER_BY limit_clause
            |select_group_record&_P100 order_by_clause&_ORDER_BY limit_clause;

select_core_record: "SELECT" select_list_record&_COLUMN_RECORD   from_clause&_FROM where_clause ;
select_core_use: "SELECT" select_list_use_record&_COLUMN_RECORD   from_clause&_FROM where_clause ;

select_group_record:"SELECT" select_list_record&_COLUMN_RECORD from_clause&_FROM where_clause group_by_clause&_GROUP_BY having_clause&_HAVING
                   | "SELECT" select_list_record&_COLUMN_RECORD from_clause&_FROM where_clause ""&_GROUP_BY ""&_HAVING  ;

select_group_use:  "SELECT" select_list_use_record&_COLUMN_RECORD  from_clause&_FROM where_clause group_by_clause&_GROUP_BY having_clause&_HAVING
                  | "SELECT" select_list_use_record&_COLUMN_RECORD  from_clause&_FROM where_clause  ""&_GROUP_BY ""&_HAVING;



select_after: select_core_use
 | select_group_use
 | select_after&_BEFORE_SCOPE setOp select_after&_AFTER_SCOPE;

setOp_start&_3: select_stmt&_BEFORE_SCOPE setOp  select_after&_AFTER_SCOPE  ;

setOp:"UNION" | "INTERSECT" | "EXCEPT";

group_by_clause:"GROUP BY"_var_any|"GROUP BY"_var_any(","_var_any)*;
having_clause:"HAVING" bool_evaluator;

select_list_use_record:select_list_use&_DERIVED_TABLE_COLUMN  ALIAS&_DERIVED_TABLE;
select_list_use:_var_row_use;

select_list_record: select_list&_DERIVED_TABLE_COLUMN  ALIAS&_DERIVED_TABLE;
select_list: select_item | select_item ("," select_item)*;
select_item: evaluator "AS" ALIAS;




from_clause: "FROM" table_expr;
table_expr: table_primary | subquery&_SUBQUERY|joinquery;
table_expr1: table_primary | subquery&_SUBQUERY ;

table_primary: TABLE&_DERIVED_TABLE_COLUMN "AS" ALIAS&_DERIVED_TABLE;
subquery&_3:"(" select_stmt_end &_DERIVED_TABLE_COLUMN ")" "AS" ALIAS&_DERIVED_TABLE;

joinquery:"(" join_on_clause &_DERIVED_TABLE_COLUMN ")" "AS" ALIAS &_DERIVED_TABLE
    |"(" join_natural_clause &_DERIVED_TABLE_COLUMN ")" "AS" ALIAS &_DERIVED_TABLE
      |"(" join_cross_clause &_DERIVED_TABLE_COLUMN ")" "AS" ALIAS &_DERIVED_TABLE
    | "(" join_comma_clause &_DERIVED_TABLE_COLUMN")"  "AS" ALIAS &_DERIVED_TABLE
     |"(" join_using_clause &_DERIVED_TABLE_COLUMN ")" "AS" ALIAS &_DERIVED_TABLE;

join_on_clause: table_expr &_FROM_UP  join_type table_expr &_FROM_UP "ON" bool_evaluator ;
join_type
    : "JOIN"
    | "INNER JOIN"
    | "LEFT JOIN"
    | "RIGHT JOIN"
    |"FULL JOIN"
    | "FULL OUTER JOIN"
    | "LEFT OUTER JOIN"
    | "RIGHT OUTER JOIN";
join_natural_clause:  table_expr1 &_FROM_UP  "NATURAL JOIN" table_expr1   &_FROM_UP;
join_cross_clause:table_expr &_FROM_UP  "CROSS JOIN" table_expr  &_FROM_UP;
join_comma_clause: table_expr &_FROM_UP  "," table_expr  &_FROM_UP;
join_using_clause: table_expr1 &_FROM_UP  "JOIN" table_expr1  &_FROM_UP using_clause;
using_clause:_var_sameUsing ;




where_clause:  "WHERE" bool_evaluator;

order_by_clause:  "ORDER" "BY" order_list;
order_list:  _var_any order_dir |  _var_any order_dir  (","  _var_any order_dir)*;
order_dir: "" | "ASC" | "DESC";

limit_clause: "LIMIT" limit_expr&_INDEPENDENT_SCOPE;
limit_expr:  _var_integer ;

AS:"AS";
ALIAS: _alias;
TABLE:_table;

evaluator:integer_evaluator|real_evaluator|text_evaluator|blob_evaluator|numeric_evaluator;
bool_evaluator
	:integer_evaluator
	|real_evaluator
	|text_evaluator
	|blob_evaluator
	|numeric_evaluator;

integer_AGG_evaluator_default: "COUNT("_var_any")";
numeric_AGG_evaluator_default: "AVG("_var_any")";
real_AGG_evaluator_default: "AVG("_var_any")";
text_AGG_evaluator_default: "GROUP_CONCAT("_var_any")";
blob_AGG_evaluator_default: "CAST(GROUP_CONCAT("_var_any") AS BLOB)";
