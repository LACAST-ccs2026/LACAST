
query: with_clause&_CTE select_stmt_end&_SUBQUERY  ;
with_clause: "" | "WITH" cte_list ;
cte_list: cte_def&_SUBQUERY | cte_def&_SUBQUERY "," cte_list;
cte_def: ALIAS&_DERIVED_TABLE  "AS"  "(" select_stmt_end &_DERIVED_TABLE_COLUMN ")";


select_stmt: select_core_record|select_group_record;

select_stmt_end: select_core_record&_P100 order_by_clause&_ORDER_BY limit_clause
            |select_group_record&_P100 order_by_clause&_ORDER_BY limit_clause;

select_core_record: "SELECT" select_list_record&_COLUMN_RECORD   from_clause&_FROM where_clause ;
select_core_use: "SELECT" select_list_use_record&_COLUMN_RECORD   from_clause&_FROM where_clause ;

select_group_record:"SELECT" select_list_record&_COLUMN_RECORD from_clause&_FROM where_clause group_by_clause&_GROUP_BY having_clause&_HAVING  
                   | "SELECT" select_list_record&_COLUMN_RECORD from_clause&_FROM where_clause ""&_GROUP_BY ""&_HAVING  ;

select_group_use:  "SELECT" select_list_use_record&_COLUMN_RECORD  from_clause&_FROM where_clause group_by_clause&_GROUP_BY having_clause&_HAVING
                  | "SELECT" select_list_use_record&_COLUMN_RECORD  from_clause&_FROM where_clause  ""&_GROUP_BY ""&_HAVING;



select_after: select_core_use
 | select_group_use;

group_by_clause:"GROUP BY"_var_any|"GROUP BY"_var_any(","_var_any)*;
having_clause:"HAVING" bool_evaluator;

select_list_use_record:select_list_use&_DERIVED_TABLE_COLUMN  ALIAS&_DERIVED_TABLE;
select_list_use:_var_row_use;

select_list_record: select_list&_DERIVED_TABLE_COLUMN  ALIAS&_DERIVED_TABLE;
select_list: select_item | select_item ("," select_item)*;
select_item: evaluator "AS" ALIAS;


from_clause: "FROM" table_expr;


table_expr: table_primary | subquery&_SUBQUERY|joinquery1;
table_expr1: table_primary | subquery&_SUBQUERY |joinquery2;
table_expr2: table_primary | subquery&_SUBQUERY ;
table_expr3: table_primary  ;


table_primary: TABLE&_DERIVED_TABLE_COLUMN "AS" ALIAS&_DERIVED_TABLE;
subquery&_3:"(" select_stmt &_DERIVED_TABLE_COLUMN ")" "AS" ALIAS&_DERIVED_TABLE;


joinquery1:"(" join_on_clause &_DERIVED_TABLE_COLUMN ")" "" &_DERIVED_TABLE 
    | join_comma_clause &_DERIVED_TABLE_COLUMN "" &_DERIVED_TABLE;

joinquery2:"(" join_on_clause &_DERIVED_TABLE_COLUMN ")" "" &_DERIVED_TABLE ;


join_on_clause:join_on_clause0|join_on_clause0|join_on_clause1;
join_on_clause0: table_expr1 &_FROM_UP  join_type0 table_expr1 &_FROM_UP "ON" bool_evaluator ;
join_type0
    : "JOIN"
    | "INNER JOIN"
    | "LEFT JOIN"
    | "RIGHT JOIN"
    | "LEFT OUTER JOIN"
    | "RIGHT OUTER JOIN";

join_on_clause1: table_expr1 &_FROM_UP  join_type1 table_expr1 &_FROM_UP "ON" full_join_bool_evaluator ;
join_type1
    : "FULL JOIN"
    | "FULL OUTER JOIN";
full_join_bool_evaluator:"true"|"false";




join_cross_clause:table_expr &_FROM_UP  "CROSS JOIN" table_expr  &_FROM_UP;
join_comma_clause:  table_expr1 &_FROM_UP  "," table_expr1  &_FROM_UP;


where_clause:  "WHERE" bool_evaluator;
order_by_clause: "" | "ORDER" "BY" order_list;
order_list: order_term | order_term "," order_term;
order_term: _var_any   order_dir  | _var_any order_dir;
order_dir: "" | "ASC" | "DESC";

limit_clause: "LIMIT" limit_expr&_INDEPENDENT_SCOPE;
limit_expr:  _var_integer;



AS:"AS";
ALIAS: _alias;
TABLE:_table;


evaluator:integer_evaluator|bit_evaluator|boolean_evaluator|bytea_evaluator|character_evaluator|date_evaluator|double_evaluator|text_evaluator|time_evaluator|timestamp_evaluator|cidr_evaluator|inet_evaluator|macaddr_evaluator|macaddr8_evaluator|uuid_evaluator;
bool_evaluator:boolean_evaluator;

bytea_AGG_evaluator_default:" decode(substr(md5(count(" _var_any ")::text),1,16), 'hex')::bytea";
double_AGG_evaluator_default:"(count("_var_any ") % 1000)::double precision";
boolean_AGG_evaluator_default: "count("  _var_any  ")>1";
bool_AGG_evaluator_default:"count("  _var_any  ")>1";

text_AGG_evaluator_default:"count("  _var_any  ") || ''";
integer_AGG_evaluator_default:"count("  _var_any  ")";
inet_AGG_evaluator_default:"inet '0.0.0.0' + count("  _var_any  ")";
uuid_AGG_evaluator_default:"md5(count("  _var_any  ")::text)::uuid";
macaddr_AGG_evaluator_default: "(lpad(to_hex((count("  _var_any  ") >> 40) & 255), 2, '0') || ':' || "
               "   lpad(to_hex((count("  _var_any  ") >> 32) & 255), 2, '0') || ':' ||"
               "         lpad(to_hex((count("  _var_any  ") >> 24) & 255), 2, '0') || ':' ||"
               "         lpad(to_hex((count("  _var_any  ") >> 16) & 255), 2, '0') || ':' ||"
               "         lpad(to_hex((count("  _var_any  ") >> 8)  & 255), 2, '0') || ':' ||"
               "         lpad(to_hex(count("  _var_any  ") & 255), 2, '0')"
               "  )::macaddr ";
time_AGG_evaluator_default:"time '00:00:00' + (count("_var_any") % 86400) * interval '1 second'";
cidr_AGG_evaluator_default:"set_masklen(inet '0.0.0.0' + count("_var_any"), 32)::cidr";
date_AGG_evaluator_default:"date '1970-01-01' + (count("_var_any") % 36525)* interval '1 day'";
character_AGG_evaluator_default:"substr(md5(count("  _var_any  ")::text), 1, 10)::character(10)";
bit_AGG_evaluator_default: "substr(lpad((count("_var_any"))::bit(64)::text, 64, '0'), 1, 64)::bit(64)";
timestamp_AGG_evaluator_default:"timestamp  '1970-01-01 00:00:00' + count("  _var_any  ") * interval '1 second'";
macaddr8_AGG_evaluator_default:"(lpad(to_hex((count("  _var_any  ") >> 56) & 255), 2, '0') || ':' || "
        "lpad(to_hex((count("  _var_any  ") >> 48) & 255), 2, '0') || ':' || "
        "lpad(to_hex((count("  _var_any  ") >> 40) & 255), 2, '0') || ':' || "
        "lpad(to_hex((count("  _var_any  ") >> 32) & 255), 2, '0') || ':' || "
        "lpad(to_hex((count("  _var_any  ") >> 24) & 255), 2, '0') || ':' || "
        "lpad(to_hex((count("  _var_any  ") >> 16) & 255), 2, '0') || ':' || "
        "lpad(to_hex((count("  _var_any  ") >> 8) & 255), 2, '0') || ':' || "
        "lpad(to_hex(count("  _var_any  ") & 255), 2, '0')"
        ")::macaddr8";