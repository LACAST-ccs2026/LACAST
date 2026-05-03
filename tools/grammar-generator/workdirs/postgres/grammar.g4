
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

integer_evaluator:integer_evaluator_without_agg|integer_AGG_evaluator;
integer_evaluator_without_agg:_var_integer|bit_count_bytea_integer_evaluator|bit_length_bytea_integer_evaluator|get_bit_bytea_integer_evaluator|get_byte_integer_evaluator|length_bytea_integer_evaluator|length_bytea_encoding_evaluator|octet_length_bytea_integer_evaluator|position_bytea_evaluator|bit_count_integer_evaluator|bit_length_bit_integer_evaluator|get_bit_integer_evaluator|length_bit_integer_evaluator|octet_length_bit_integer_evaluator|num_nonnulls_integer_evaluator|num_nulls_integer_evaluator|GREATEST_integer_evaluator|LEAST_integer_evaluator|NULLIF_integer_evaluator|date_sub_date_integer_evaluator|abs_integer_evaluator|at_integer_evaluator|bitwise_and_integral_integer_evaluator|bitwise_lshift_integral_evaluator|bitwise_not_integral_integer_evaluator|bitwise_or_integral_integer_evaluator|div_numeric_integer_evaluator|gcd_integer_evaluator|hash_integer_evaluator|integral_lshift_integer_evaluator|lcm_integer_evaluator|min_scale_integer_evaluator|mod_integer_integer_evaluator|mod_numeric_op_integer_evaluator|mul_integer_evaluator|random_range_integer_evaluator|scale_integer_evaluator|sub_numeric_integer_evaluator|trim_scale_evaluator|unary_plus_integer_evaluator|width_bucket_array_integer_evaluator|width_bucket_func_evaluator|width_bucket_numeric_integer_evaluator|family_inet_evaluator|inet_sub_inet_integer_evaluator|masklen_integer_evaluator|ascii_integer_evaluator|ascii_text_integer_evaluator|bit_length_text_integer_evaluator|character_length_integer_evaluator|char_length_integer_evaluator|length_text_integer_evaluator|agg_length_text_integer_evaluator|octet_length_integer_evaluator|octet_length_text_integer_evaluator|position_integer_evaluator|position_text_integer_evaluator|regexp_count_evaluator|regexp_instr_evaluator|strpos_text_evaluator|uuid_extract_version_integer_evaluator;
bit_evaluator:bit_evaluator_without_agg|bit_AGG_evaluator;
bit_evaluator_without_agg:_var_bit|bit_and_bit_bit_evaluator|bit_concat_bit_evaluator|bit_lshift_bit_evaluator|bit_not_bit_evaluator|bit_or_bit_bit_evaluator|bit_rshift_bit_evaluator|bit_xor_bit_bit_evaluator|overlay_bit_bit_evaluator|set_bit_bit_bit_evaluator|substring_bit_bit_evaluator|GREATEST_bit_evaluator|LEAST_bit_evaluator|NULLIF_bit_evaluator;
boolean_evaluator:boolean_evaluator_without_agg|boolean_AGG_evaluator;
boolean_evaluator_without_agg:_var_boolean|between_boolean_evaluator|between_symmetric_boolean_evaluator|ISDISTINCTFROM_boolean_evaluator|ISNOTDISTINCTFROM_boolean_evaluator|ISNOTNULL_boolean_evaluator|ISNULL_boolean_evaluator|is_false_boolean_evaluator|is_not_false_boolean_evaluator|is_not_true_boolean_evaluator|is_not_unknown_boolean_evaluator|is_null_boolean_evaluator|is_true_boolean_evaluator|is_unknown_boolean_evaluator|notnull_boolean_evaluator|not_between_boolean_evaluator|not_between_symmetric_evaluator|GREATEST_boolean_evaluator|LEAST_boolean_evaluator|NULLIF_boolean_evaluator|isfinite_date_boolean_evaluator|isfinite_interval_boolean_evaluator|isfinite_timestamp_boolean_evaluator|AND_boolean_evaluator|NOT_boolean_evaluator|not_boolean_evaluator|OR_boolean_evaluator|inet_contained_by_boolean_evaluator|inet_contained_by_eq_boolean_evaluator|inet_contains_boolean_evaluator|inet_contains_eq_boolean_evaluator|inet_same_family_boolean_evaluator|inet_strictly_contains_boolean_evaluator|regex_match_evaluator|regex_match_i_evaluator|regex_not_match_evaluator|regex_not_match_i_evaluator|regexp_like_evaluator|starts_with_boolean_evaluator|starts_with_op_boolean_evaluator|text_normalized_evaluator|unicode_assigned_evaluator;
bytea_evaluator:bytea_evaluator_without_agg|bytea_AGG_evaluator;
bytea_evaluator_without_agg:_var_bytea|btrim_bytea_evaluator|bytea_concat_bytea_evaluator|convert_func_evaluator|convert_to_bytea_evaluator|convert_to_func_evaluator|decode_bytea_evaluator|ltrim_bytea_bytea_evaluator|reverse_bytea_evaluator|rtrim_bytea_bytea_evaluator|set_bit_bytea_evaluator|set_byte_evaluator|sha224_bytea_evaluator|sha256_bytea_evaluator|sha384_bytea_evaluator|sha512_bytea_evaluator|substring_bytea_evaluator|substring_bytea_evaluator_2|substring_bytea_evaluator_3|substr_bytea_evaluator|substr_bytea_evaluator_2|substr_bytea_evaluator|GREATEST_bytea_evaluator|LEAST_bytea_evaluator|NULLIF_bytea_evaluator;
character_evaluator:character_evaluator_without_agg|character_AGG_evaluator;
character_evaluator_without_agg:_var_character|GREATEST_character_evaluator|LEAST_character_evaluator|NULLIF_character_evaluator;
date_evaluator:date_evaluator_without_agg|date_AGG_evaluator;
date_evaluator_without_agg:_var_date|GREATEST_date_evaluator|LEAST_date_evaluator|NULLIF_date_evaluator|to_date_date_evaluator|date_add_integer_date_evaluator|date_sub_integer_date_evaluator|make_date_date_evaluator;
double_evaluator:double_evaluator_without_agg|double_AGG_evaluator;
double_evaluator_without_agg:_var_double|GREATEST_double_evaluator|LEAST_double_evaluator|NULLIF_double_evaluator|to_number_double_evaluator|to_number_func_evaluator|date_part_interval_double_evaluator|date_part_timestamp_double_evaluator|extract_interval_double_evaluator|extract_timestamp_double_evaluator|abs_double_evaluator|acos_double_evaluator|acosd_double_evaluator|acosh_double_evaluator|asin_double_evaluator|asind_double_evaluator|asinh_double_evaluator|at_double_evaluator|atan_double_evaluator|atan2_double_evaluator|atan2d_double_evaluator|atand_double_evaluator|atanh_double_evaluator|atan_double_evaluator|cbrt_double_evaluator|cbrt_double_evaluator|ceil_double_evaluator|ceiling_double_evaluator|ceil_numeric_double_evaluator|cosd_double_evaluator|cosh_double_evaluator|cos_double_evaluator|cot_double_evaluator|cotd_double_evaluator|cube_root_double_evaluator|degrees_double_evaluator|degrees_double_evaluator|div_numeric_double_evaluator|erf_double_evaluator|erfc_double_evaluator|exp_double_evaluator|factorial_double_evaluator|floor_double_evaluator|gamma_double_evaluator|lgamma_double_evaluator|ln_double_evaluator|log10_double_evaluator|log_numeric_evaluator|log_two_args_double_evaluator|mul_double_evaluator|ordiv_double_evaluator|pi_double_evaluator|pow_double_evaluator|power_double_evaluator|radians_double_evaluator|random_double_evaluator|random_normal_double_evaluator|round_double_integer_evaluator|round_with_scale_double_evaluator|sign_double_integer_evaluator|agg_sign_double_integer_evaluator|sin_double_evaluator|sind_double_evaluator|sinh_double_evaluator|sqrt_double_evaluator|tan_double_evaluator|tand_double_evaluator|tanh_double_evaluator|trunc_double_integer_evaluator|trunc_with_scale_double_evaluator|unary_plus_double_evaluator;
text_evaluator:text_evaluator_without_agg|text_AGG_evaluator;
text_evaluator_without_agg:_var_text|convert_from_func_evaluator|encode_bytea_text_evaluator|md5_bytea_text_evaluator|to_char_text_evaluator|to_char_interval_text_evaluator|to_char_timestamp_text_evaluator|timeofday_evaluator|abbrev_cidr_text_evaluator|abbrev_inet_text_evaluator|host_text_evaluator|text_text_evaluator|btrim_text_evaluator|casefold_text_evaluator|chr_text_evaluator|concat_text_evaluator|concat_ws_text_evaluator|convert_from_text_evaluator|format_text_evaluator|initcap_text_evaluator|left_text_evaluator|lower_text_evaluator|agg_lower_text_evaluator|lpad_text_evaluator|ltrim_text_evaluator|md5_text_evaluator|normalize_text_evaluator|oror_text_evaluator|overlay_text_evaluator|pg_client_encoding_text_evaluator|quote_ident_text_evaluator|quote_literal_text_evaluator|quote_literal_text_evaluator|quote_nullable_text_evaluator|quote_nullable_text_evaluator|regexp_replace_advanced_evaluator|regexp_replace_text_evaluator|regexp_substr_evaluator|repeat_text_evaluator|replace_text_evaluator|reverse_text_evaluator|reverse_text_func_evaluator|right_text_evaluator|rpad_text_evaluator|rtrim_text_evaluator|left_text_evaluator|substr_text_evaluator|substring_regex_evaluator|substring_similar_evaluator|substring_text_from_evaluator|text_concat_evaluator|to_bin_text_evaluator|to_hex_text_evaluator|to_oct_text_evaluator|translate_text_evaluator|translate_text_evaluator|trim_from_evaluator|trim_text_evaluator|unistr_text_evaluator|upper_text_evaluator|agg_upper_text_evaluator|convert_from_text_evaluator;
time_evaluator:time_evaluator_without_agg|time_AGG_evaluator;
time_evaluator_without_agg:_var_time|GREATEST_time_evaluator|LEAST_time_evaluator|NULLIF_time_evaluator|current_time_time_evaluator|localtime_func_time_evaluator|localtime_with_precision_time_evaluator|make_time_time_evaluator|time_add_interval_time_evaluator|time_sub_interval_time_evaluator;
timestamp_evaluator:timestamp_evaluator_without_agg|timestamp_AGG_evaluator;
timestamp_evaluator_without_agg:_var_timestamp|GREATEST_timestamp_evaluator|LEAST_timestamp_evaluator|NULLIF_timestamp_evaluator|to_timestamp_text_timestamp_evaluator|clock_timestamp_timestamp_evaluator|current_timestamp_func_timestamp_evaluator|current_timestamp_with_precision_timestamp_evaluator|date_add_timestamp_evaluator|date_add_interval_timestamp_evaluator|date_add_time_timestamp_evaluator|date_bin_timestamp_evaluator|date_subtract_timestamp_evaluator|date_sub_interval_timestamp_evaluator|date_trunc_timestamp_evaluator|date_trunc_timestamp_timestamp_evaluator|date_trunc_timestamptz_timestamp_evaluator|localtimestamp_timestamp_evaluator|localtimestamp_func_timestamp_evaluator|make_timestamp_timestamp_evaluator|make_timestamptz_timestamp_evaluator|now_timestamp_evaluator|statement_timestamp_evaluator|timestamp_add_interval_timestamp_evaluator|timestamp_sub_interval_timestamp_evaluator|to_timestamp_timestamp_evaluator|transaction_timestamp_timestamp_evaluator|uuid_extract_timestamp_timestamp_evaluator;
cidr_evaluator:cidr_evaluator_without_agg;
cidr_evaluator_without_agg:_var_cidr|GREATEST_cidr_evaluator|LEAST_cidr_evaluator|NULLIF_cidr_evaluator|inet_merge_cidr_evaluator|network_cidr_evaluator;
inet_evaluator:inet_evaluator_without_agg|inet_AGG_evaluator;
inet_evaluator_without_agg:_var_inet|GREATEST_inet_evaluator|LEAST_inet_evaluator|NULLIF_inet_evaluator|bigint_add_inet_evaluator|broadcast_inet_evaluator|hostmask_inet_evaluator|inet_add_bigint_inet_evaluator|inet_bit_and_evaluator|inet_bit_not_evaluator|inet_bit_or_evaluator|inet_plus_bigint_inet_evaluator|inet_sub_bigint_evaluator|netmask_inet_evaluator|set_masklen_cidr_inet_evaluator|set_masklen_inet_inet_evaluator;
macaddr_evaluator:macaddr_evaluator_without_agg;
macaddr_evaluator_without_agg:_var_macaddr|GREATEST_macaddr_evaluator|LEAST_macaddr_evaluator|NULLIF_macaddr_evaluator|trunc_macaddr_evaluator;
macaddr8_evaluator:macaddr8_evaluator_without_agg;
macaddr8_evaluator_without_agg:_var_macaddr8|GREATEST_macaddr8_evaluator|LEAST_macaddr8_evaluator|NULLIF_macaddr8_evaluator|macaddr8_set7bit_evaluator|trunc_macaddr8_evaluator;
uuid_evaluator:uuid_evaluator_without_agg;
uuid_evaluator_without_agg:_var_uuid|GREATEST_uuid_evaluator|LEAST_uuid_evaluator|NULLIF_uuid_evaluator|gen_random_uuid_uuid_evaluator|uuidv7_uuid_evaluator;
integer_AGG_evaluator:any_value_integer_evaluator|bit_and_integer_evaluator|bit_or_integer_evaluator|bit_xor_integer_evaluator|count_integer_evaluator|max_integer_evaluator|min_integer_evaluator|regr_count_integer_evaluator|sum_integer_evaluator;
agg_evaluator:integer_AGG_evaluator|text_AGG_evaluator|time_AGG_evaluator|timestamp_AGG_evaluator|bit_AGG_evaluator|bytea_AGG_evaluator|boolean_AGG_evaluator|date_AGG_evaluator|double_AGG_evaluator|inet_AGG_evaluator|character_AGG_evaluator;
any_value_integer_evaluator:"any_value(("_var_integer")::integer)"|"any_value(("integer_evaluator_without_agg")::integer)";
any_value_text_evaluator:"any_value(("text_evaluator_without_agg")::text)"|"any_value(("_var_text")::text)";
any_value_time_evaluator:"any_value(("time_evaluator_without_agg")::time)"|"any_value(("_var_time")::time)";
any_value_timestamp_evaluator:"any_value(("_var_timestamp")::timestamp)"|"any_value(("timestamp_evaluator_without_agg")::timestamp)";
any_value_bit_evaluator:"any_value(("_var_bit")::bit)"|"any_value(("bit_evaluator_without_agg")::bit)";
any_value_bytea_evaluator:"any_value(("_var_bytea")::bytea)"|"any_value(("bytea_evaluator_without_agg")::bytea)";
any_value_boolean_evaluator:"any_value(("boolean_evaluator_without_agg")::boolean)"|"any_value(("_var_boolean")::boolean)";
any_value_date_evaluator:"any_value(("date_evaluator_without_agg")::date)"|"any_value(("_var_date")::date)";
any_value_double_evaluator:"any_value(("_var_double")::double precision)"|"any_value(("double_evaluator_without_agg")::double precision)";
text_AGG_evaluator:any_value_text_evaluator;
time_AGG_evaluator:any_value_time_evaluator|max_time_evaluator|min_time_evaluator;
timestamp_AGG_evaluator:any_value_timestamp_evaluator|max_timestamp_evaluator|min_timestamp_evaluator;
bit_AGG_evaluator:any_value_bit_evaluator|bit_and_bit_evaluator|bit_or_bit_evaluator|bit_xor_bit_evaluator;
bytea_AGG_evaluator:any_value_bytea_evaluator;
boolean_AGG_evaluator:any_value_boolean_evaluator|bool_and_boolean_evaluator|bool_or_boolean_evaluator|every_boolean_evaluator;
date_AGG_evaluator:any_value_date_evaluator|max_date_evaluator|min_date_evaluator;
double_AGG_evaluator:any_value_double_evaluator|avg_double_evaluator|corr_double_evaluator|covar_pop_double_evaluator|covar_samp_double_evaluator|max_double_evaluator|min_double_evaluator|regr_avgx_double_evaluator|regr_avgy_double_evaluator|regr_intercept_double_evaluator|regr_r2_double_evaluator|regr_slope_double_evaluator|regr_sxx_double_evaluator|regr_sxy_double_evaluator|regr_syy_double_evaluator|stddev_double_evaluator|stddev_pop_double_evaluator|stddev_samp_double_evaluator|sum_double_evaluator|variance_double_evaluator|var_pop_double_evaluator|var_samp_double_evaluator;
avg_double_evaluator:"avg("_var_integer")"|"avg("_var_double")"|"avg("double_evaluator_without_agg")"|"avg("integer_evaluator_without_agg")";
bit_and_integer_evaluator:"bit_and("_var_integer")"|"bit_and("integer_evaluator_without_agg")";
bit_and_bit_evaluator:"bit_and("_var_bit")"|"bit_and("bit_evaluator_without_agg")";
bit_or_integer_evaluator:"bit_or("integer_evaluator_without_agg")"|"bit_or("_var_integer")";
bit_or_bit_evaluator:"bit_or("bit_evaluator_without_agg")"|"bit_or("_var_bit")";
bit_xor_integer_evaluator:"bit_xor("_var_integer")"|"bit_xor("integer_evaluator_without_agg")";
bit_xor_bit_evaluator:"bit_xor("_var_bit")"|"bit_xor("bit_evaluator_without_agg")";
bool_and_boolean_evaluator:"bool_and("boolean_evaluator_without_agg")"|"bool_and("_var_boolean")";
bool_or_boolean_evaluator:"bool_or("_var_boolean")"|"bool_or("boolean_evaluator_without_agg")";
corr_double_evaluator:"corr("_var_double "," _var_double")"|"corr("double_evaluator_without_agg "," _var_double")"|"corr("double_evaluator_without_agg "," double_evaluator_without_agg")"|"corr("_var_double "," double_evaluator_without_agg")";
count_integer_evaluator:"count("_var_bytea")"|"count("_var_time")"|"count("integer_evaluator_without_agg")"|"count("timestamp_evaluator_without_agg")"|"count("inet_evaluator_without_agg")"|"count("date_evaluator_without_agg")"|"count("_var_integer")"|"count("time_evaluator_without_agg")"|"count("double_evaluator_without_agg")"|"count("_var_uuid")"|"count("boolean_evaluator_without_agg")"|"count("bit_evaluator_without_agg")"|"count("cidr_evaluator_without_agg")"|"count("bytea_evaluator_without_agg")"|"count("uuid_evaluator_without_agg")"|"count("_var_character")"|"count("_var_cidr")"|"count("macaddr_evaluator_without_agg")"|"count("_var_boolean")"|"count("_var_inet")"|"count("macaddr8_evaluator_without_agg")"|"count("_var_macaddr")"|"count("text_evaluator_without_agg")"|"count("_var_macaddr8")"|"count("_var_double")"|"count("_var_date")"|"count("_var_timestamp")"|"count("_var_text")"|"count("_var_bit")"|"count("character_evaluator_without_agg")";
covar_pop_double_evaluator:"covar_pop("_var_double "," _var_double")"|"covar_pop("_var_double "," double_evaluator_without_agg")"|"covar_pop("double_evaluator_without_agg "," double_evaluator_without_agg")"|"covar_pop("double_evaluator_without_agg "," _var_double")";
covar_samp_double_evaluator:"covar_samp("_var_double "," double_evaluator_without_agg")"|"covar_samp("double_evaluator_without_agg "," _var_double")"|"covar_samp("_var_double "," _var_double")"|"covar_samp("double_evaluator_without_agg "," double_evaluator_without_agg")";
every_boolean_evaluator:"every("_var_boolean")"|"every("boolean_evaluator_without_agg")";
max_integer_evaluator:"max("_var_integer")"|"max("integer_evaluator_without_agg")";
max_timestamp_evaluator:"max("timestamp_evaluator_without_agg")"|"max("_var_timestamp")";
max_inet_evaluator:"max("_var_inet")"|"max("inet_evaluator_without_agg")";
max_double_evaluator:"max("double_evaluator_without_agg")"|"max("_var_double")";
max_character_evaluator:"max("character_evaluator_without_agg")"|"max("_var_character")";
max_date_evaluator:"max("date_evaluator_without_agg")"|"max("_var_date")";
max_time_evaluator:"max("_var_time")"|"max("time_evaluator_without_agg")";
inet_AGG_evaluator:max_inet_evaluator|min_inet_evaluator;
character_AGG_evaluator:max_character_evaluator|min_character_evaluator;
min_integer_evaluator:"min("_var_integer")"|"min("integer_evaluator_without_agg")";
min_timestamp_evaluator:"min("_var_timestamp")"|"min("timestamp_evaluator_without_agg")";
min_inet_evaluator:"min("_var_inet")"|"min("inet_evaluator_without_agg")";
min_double_evaluator:"min("_var_double")"|"min("double_evaluator_without_agg")";
min_character_evaluator:"min("_var_character")"|"min("character_evaluator_without_agg")";
min_date_evaluator:"min("date_evaluator_without_agg")"|"min("_var_date")";
min_time_evaluator:"min("time_evaluator_without_agg")"|"min("_var_time")";
regr_avgx_double_evaluator:"regr_avgx("double_evaluator_without_agg "," _var_double")"|"regr_avgx("_var_double "," _var_double")"|"regr_avgx("_var_double "," double_evaluator_without_agg")"|"regr_avgx("double_evaluator_without_agg "," double_evaluator_without_agg")";
regr_avgy_double_evaluator:"regr_avgy("_var_double "," _var_double")"|"regr_avgy("_var_double "," double_evaluator_without_agg")"|"regr_avgy("double_evaluator_without_agg "," _var_double")"|"regr_avgy("double_evaluator_without_agg "," double_evaluator_without_agg")";
regr_count_integer_evaluator:"regr_count("double_evaluator_without_agg "," _var_double")"|"regr_count("_var_double "," _var_double")"|"regr_count("_var_double "," double_evaluator_without_agg")"|"regr_count("double_evaluator_without_agg "," double_evaluator_without_agg")";
regr_intercept_double_evaluator:"regr_intercept("double_evaluator_without_agg "," _var_double")"|"regr_intercept("_var_double "," double_evaluator_without_agg")"|"regr_intercept("double_evaluator_without_agg "," double_evaluator_without_agg")"|"regr_intercept("_var_double "," _var_double")";
regr_r2_double_evaluator:"regr_r2("_var_double "," double_evaluator_without_agg")"|"regr_r2("double_evaluator_without_agg "," _var_double")"|"regr_r2("_var_double "," _var_double")"|"regr_r2("double_evaluator_without_agg "," double_evaluator_without_agg")";
regr_slope_double_evaluator:"regr_slope("_var_double "," _var_double")"|"regr_slope("_var_double "," double_evaluator_without_agg")"|"regr_slope("double_evaluator_without_agg "," double_evaluator_without_agg")"|"regr_slope("double_evaluator_without_agg "," _var_double")";
regr_sxx_double_evaluator:"regr_sxx("double_evaluator_without_agg "," double_evaluator_without_agg")"|"regr_sxx("_var_double "," _var_double")"|"regr_sxx("_var_double "," double_evaluator_without_agg")"|"regr_sxx("double_evaluator_without_agg "," _var_double")";
regr_sxy_double_evaluator:"regr_sxy("_var_double "," double_evaluator_without_agg")"|"regr_sxy("double_evaluator_without_agg "," _var_double")"|"regr_sxy("_var_double "," _var_double")"|"regr_sxy("double_evaluator_without_agg "," double_evaluator_without_agg")";
regr_syy_double_evaluator:"regr_syy("_var_double "," double_evaluator_without_agg")"|"regr_syy("_var_double "," _var_double")"|"regr_syy("double_evaluator_without_agg "," double_evaluator_without_agg")"|"regr_syy("double_evaluator_without_agg "," _var_double")";
stddev_double_evaluator:"stddev("double_evaluator_without_agg")"|"stddev("_var_double")";
stddev_pop_double_evaluator:"stddev_pop("double_evaluator_without_agg")"|"stddev_pop("_var_double")";
stddev_samp_double_evaluator:"stddev_samp("_var_double")"|"stddev_samp("double_evaluator_without_agg")";
sum_integer_evaluator:"sum("integer_evaluator_without_agg")"|"sum("_var_integer")";
sum_double_evaluator:"sum("_var_double")"|"sum("double_evaluator_without_agg")";
variance_double_evaluator:"variance("double_evaluator_without_agg")"|"variance("_var_double")";
var_pop_double_evaluator:"var_pop("_var_integer")"|"var_pop("double_evaluator_without_agg")"|"var_pop("integer_evaluator_without_agg")"|"var_pop("_var_double")";
var_samp_double_evaluator:"var_samp("_var_double")"|"var_samp("double_evaluator_without_agg")";
bit_count_bytea_integer_evaluator:"bit_count(" _var_bytea ")"|"bit_count(" bytea_evaluator_without_agg ")";
bit_length_bytea_integer_evaluator:"bit_length(" _var_bytea ")"|"bit_length(" bytea_evaluator_without_agg ")";
btrim_bytea_evaluator:"btrim(" bytea_evaluator_without_agg "," bytea_evaluator_without_agg ")"|"btrim(" bytea_evaluator_without_agg "," _var_bytea ")"|"btrim(" _var_bytea "," bytea_evaluator_without_agg ")";
bytea_concat_bytea_evaluator:_var_bytea "||" _var_bytea|bytea_evaluator_without_agg "||" _var_bytea|_var_bytea "||" bytea_evaluator_without_agg;
convert_from_func_evaluator:"convert_from( 'Hello'::bytea , 'UTF8' )"|"convert_from( 'Test'::bytea , 'SQL_ASCII' )";
convert_func_evaluator:"convert( 'Hello'::bytea , 'UTF8' , 'LATIN1' )"|"convert( 'Test'::bytea , 'SQL_ASCII' , 'UTF8' )";
convert_to_bytea_evaluator:"convert_to(""'hello'" "," "'UTF8'"")";
convert_to_func_evaluator:"convert_to( 'Hello World' , 'UTF8' )"|"convert_to( 'Test' , 'LATIN1' )";
decode_bytea_evaluator:"decode('SGVsbG8=', 'base64')";
encode_bytea_text_evaluator:"encode(" _var_bytea ",""'base64'" ")"|"encode(" _var_bytea ",""'hex'" ")"|"encode(" _var_bytea ",""'escape'" ")";
encode_format:"base64"|"hex"|"escape";
get_bit_bytea_integer_evaluator:"get_bit(" "'\x01'::bytea" "," "0" ")";
get_byte_integer_evaluator:"get_byte(E'\\xDEADBEEF'::bytea, 1)";
length_bytea_integer_evaluator:"length(" _var_bytea ")"|"length(" bytea_evaluator_without_agg ")";
length_bytea_encoding_evaluator:"length( E'\\x48656C6C6F'::bytea , 'UTF8' )"|"length( E'\\x54657374'::bytea , 'SQL_ASCII' )";
ltrim_bytea_bytea_evaluator:"ltrim(" bytea_evaluator_without_agg "," bytea_evaluator_without_agg ")"|"ltrim(" bytea_evaluator_without_agg "," _var_bytea ")"|"ltrim(" _var_bytea "," bytea_evaluator_without_agg ")";
productions:;
md5_bytea_text_evaluator:"md5(" _var_bytea ")"|"md5(" bytea_evaluator_without_agg ")";
octet_length_bytea_integer_evaluator:"octet_length(" _var_bytea ")"|"octet_length(" bytea_evaluator_without_agg ")";
position_bytea_evaluator:"position(" _var_bytea " IN " _var_bytea ")";
reverse_bytea_evaluator:"reverse(" _var_bytea ")";
rtrim_bytea_bytea_evaluator:"rtrim(" bytea_evaluator_without_agg "," bytea_evaluator_without_agg ")"|"rtrim(" bytea_evaluator_without_agg "," _var_bytea ")";
set_bit_bytea_evaluator:"set_bit( E'\\xDEADBEEF'::bytea , 3 , 0 )"|"set_bit( E'\\x12345678'::bytea , 0 , 1 )";
set_byte_evaluator:"set_byte( E'\\x12345678' , 2 , 65 )"|"set_byte( E'\\xDEADBEEF' , 1 , 255 )";
sha224_bytea_evaluator:"sha224(" "'hello'::bytea" ")";
sha256_bytea_evaluator:"sha256(" _var_bytea ")";
sha384_bytea_evaluator:"sha384(" _var_bytea ")";
sha512_bytea_evaluator:"sha512(" "'hello'::bytea" ")";
substring_bytea_evaluator:"substring(" _var_bytea " FROM 1 )";
substring_bytea_evaluator_2:"substring(" _var_bytea " FOR 5 )";
substring_bytea_evaluator_3:"substring(" _var_bytea " FROM 1 FOR 5 )";
substr_bytea_evaluator:"substr( E'\\xDEADBEEF'::bytea , 2 , 2 )"|"substr( E'\\x12345678'::bytea , 1 , 3 )"|"substr( E'\\xABCDEF'::bytea , 2 )";
substr_bytea_evaluator_2:"substr(" _var_bytea ", 1 , 5 )";
bit_and_bit_bit_evaluator:"B'1010'" "&" "B'1010'";
bit_concat_bit_evaluator:_var_bit "||" _var_bit|bit_evaluator_without_agg "||" _var_bit|_var_bit "||" bit_evaluator_without_agg|bit_evaluator_without_agg "||" bit_evaluator_without_agg;
bit_count_integer_evaluator:"bit_count("_var_bit")";
bit_length_bit_integer_evaluator:"bit_length(" _var_bit ")";
bit_lshift_bit_evaluator:"B'1011'" "<<" "2";
bit_not_bit_evaluator:"~" bit_evaluator_without_agg|"~" _var_bit;
bit_or_bit_bit_evaluator:_var_bit "|" bit_evaluator_without_agg|_var_bit "|" _var_bit;
bit_rshift_bit_evaluator:_var_bit ">>" "1";
bit_xor_bit_bit_evaluator:bit_evaluator_without_agg "#" bit_evaluator_without_agg|bit_evaluator_without_agg "#" _var_bit|_var_bit "#" bit_evaluator_without_agg|_var_bit "#" _var_bit;
get_bit_integer_evaluator:"get_bit(B'10101010', 3)";
length_bit_integer_evaluator:"length(" bit_evaluator_without_agg ")"|"length(" _var_bit ")";
octet_length_bit_integer_evaluator:"octet_length(" _var_bit ")";
overlay_bit_bit_evaluator:"overlay(" "B'101010'" " placing " "B'11'" " from " "3" ")";
set_bit_bit_bit_evaluator:"set_bit(" bit_evaluator_without_agg "," "1" "," "1"")";
substring_bit_bit_evaluator:"substring(" bit_evaluator_without_agg " from " "2" " for " "3" ")";
between_boolean_evaluator:_var_bit "BETWEEN" _var_bit "AND" _var_bit;
between_symmetric_boolean_evaluator:_var_bit "BETWEEN SYMMETRIC" _var_bit "AND" _var_bit;
ISDISTINCTFROM_boolean_evaluator:timestamp_evaluator_without_agg "IS DISTINCT FROM" _var_timestamp|inet_evaluator_without_agg "IS DISTINCT FROM" inet_evaluator_without_agg|date_evaluator_without_agg "IS DISTINCT FROM" _var_date|character_evaluator_without_agg "IS DISTINCT FROM" character_evaluator_without_agg|timestamp_AGG_evaluator "IS DISTINCT FROM" timestamp_evaluator_without_agg|date_AGG_evaluator "IS DISTINCT FROM" date_evaluator_without_agg|date_AGG_evaluator "IS DISTINCT FROM" date_AGG_evaluator|bit_evaluator_without_agg "IS DISTINCT FROM" _var_bit|character_AGG_evaluator "IS DISTINCT FROM" _var_character|date_AGG_evaluator "IS DISTINCT FROM" _var_date|date_evaluator_without_agg "IS DISTINCT FROM" date_evaluator_without_agg|_var_date "IS DISTINCT FROM" date_AGG_evaluator|_var_double "IS DISTINCT FROM" double_AGG_evaluator|_var_integer "IS DISTINCT FROM" _var_integer|bit_evaluator_without_agg "IS DISTINCT FROM" bit_AGG_evaluator|_var_macaddr "IS DISTINCT FROM" _var_macaddr|inet_AGG_evaluator "IS DISTINCT FROM" inet_AGG_evaluator|_var_cidr "IS DISTINCT FROM" _var_cidr|timestamp_AGG_evaluator "IS DISTINCT FROM" _var_timestamp|time_evaluator_without_agg "IS DISTINCT FROM" time_evaluator_without_agg|inet_evaluator_without_agg "IS DISTINCT FROM" _var_inet|double_AGG_evaluator "IS DISTINCT FROM" _var_double|integer_evaluator_without_agg "IS DISTINCT FROM" integer_evaluator_without_agg|_var_bytea "IS DISTINCT FROM" bytea_evaluator_without_agg|_var_bit "IS DISTINCT FROM" bit_AGG_evaluator|integer_AGG_evaluator "IS DISTINCT FROM" integer_evaluator_without_agg|time_evaluator_without_agg "IS DISTINCT FROM" time_AGG_evaluator|timestamp_evaluator_without_agg "IS DISTINCT FROM" timestamp_AGG_evaluator|bit_evaluator_without_agg "IS DISTINCT FROM" bit_evaluator_without_agg|_var_timestamp "IS DISTINCT FROM" _var_timestamp|_var_character "IS DISTINCT FROM" _var_character|timestamp_AGG_evaluator "IS DISTINCT FROM" timestamp_AGG_evaluator|double_evaluator_without_agg "IS DISTINCT FROM" double_AGG_evaluator|_var_timestamp "IS DISTINCT FROM" timestamp_AGG_evaluator|_var_time "IS DISTINCT FROM" time_AGG_evaluator|character_evaluator_without_agg "IS DISTINCT FROM" character_AGG_evaluator|bit_AGG_evaluator "IS DISTINCT FROM" _var_bit|_var_integer "IS DISTINCT FROM" integer_evaluator_without_agg|double_evaluator_without_agg "IS DISTINCT FROM" _var_double|cidr_evaluator_without_agg "IS DISTINCT FROM" _var_cidr|_var_inet "IS DISTINCT FROM" _var_inet|_var_bit "IS DISTINCT FROM" _var_bit|macaddr_evaluator_without_agg "IS DISTINCT FROM" macaddr_evaluator_without_agg|_var_boolean "IS DISTINCT FROM" _var_boolean|_var_macaddr8 "IS DISTINCT FROM" macaddr8_evaluator_without_agg|double_AGG_evaluator "IS DISTINCT FROM" double_AGG_evaluator|integer_evaluator_without_agg "IS DISTINCT FROM" _var_integer|double_AGG_evaluator "IS DISTINCT FROM" double_evaluator_without_agg|time_AGG_evaluator "IS DISTINCT FROM" time_evaluator_without_agg|_var_boolean "IS DISTINCT FROM" boolean_AGG_evaluator|boolean_AGG_evaluator "IS DISTINCT FROM" boolean_AGG_evaluator|_var_character "IS DISTINCT FROM" character_evaluator_without_agg|macaddr8_evaluator_without_agg "IS DISTINCT FROM" macaddr8_evaluator_without_agg|_var_macaddr "IS DISTINCT FROM" macaddr_evaluator_without_agg|cidr_evaluator_without_agg "IS DISTINCT FROM" cidr_evaluator_without_agg|bit_AGG_evaluator "IS DISTINCT FROM" bit_evaluator_without_agg|time_evaluator_without_agg "IS DISTINCT FROM" _var_time|_var_time "IS DISTINCT FROM" time_evaluator_without_agg|time_AGG_evaluator "IS DISTINCT FROM" time_AGG_evaluator|double_evaluator_without_agg "IS DISTINCT FROM" double_evaluator_without_agg|macaddr8_evaluator_without_agg "IS DISTINCT FROM" _var_macaddr8|character_AGG_evaluator "IS DISTINCT FROM" character_evaluator_without_agg|boolean_evaluator_without_agg "IS DISTINCT FROM" boolean_AGG_evaluator|_var_uuid "IS DISTINCT FROM" uuid_evaluator_without_agg|_var_character "IS DISTINCT FROM" character_AGG_evaluator|integer_AGG_evaluator "IS DISTINCT FROM" integer_AGG_evaluator|_var_timestamp "IS DISTINCT FROM" timestamp_evaluator_without_agg|date_evaluator_without_agg "IS DISTINCT FROM" date_AGG_evaluator|boolean_AGG_evaluator "IS DISTINCT FROM" _var_boolean|macaddr_evaluator_without_agg "IS DISTINCT FROM" _var_macaddr|_var_macaddr8 "IS DISTINCT FROM" _var_macaddr8|time_AGG_evaluator "IS DISTINCT FROM" _var_time|_var_date "IS DISTINCT FROM" date_evaluator_without_agg|_var_date "IS DISTINCT FROM" _var_date|character_AGG_evaluator "IS DISTINCT FROM" character_AGG_evaluator|_var_inet "IS DISTINCT FROM" inet_evaluator_without_agg|character_evaluator_without_agg "IS DISTINCT FROM" _var_character|_var_double "IS DISTINCT FROM" double_evaluator_without_agg|_var_integer "IS DISTINCT FROM" integer_AGG_evaluator|_var_time "IS DISTINCT FROM" _var_time|timestamp_evaluator_without_agg "IS DISTINCT FROM" timestamp_evaluator_without_agg|inet_AGG_evaluator "IS DISTINCT FROM" _var_inet|_var_double "IS DISTINCT FROM" _var_double|integer_AGG_evaluator "IS DISTINCT FROM" _var_integer|_var_bit "IS DISTINCT FROM" bit_evaluator_without_agg|bit_AGG_evaluator "IS DISTINCT FROM" bit_AGG_evaluator|_var_uuid "IS DISTINCT FROM" _var_uuid;
ISNOTDISTINCTFROM_boolean_evaluator:_var_timestamp "IS NOT DISTINCT FROM" timestamp_evaluator_without_agg|_var_time "IS NOT DISTINCT FROM" _var_time|timestamp_evaluator_without_agg "IS NOT DISTINCT FROM" timestamp_evaluator_without_agg|time_AGG_evaluator "IS NOT DISTINCT FROM" time_AGG_evaluator|timestamp_AGG_evaluator "IS NOT DISTINCT FROM" _var_timestamp|_var_inet "IS NOT DISTINCT FROM" _var_inet|double_evaluator_without_agg "IS NOT DISTINCT FROM" double_evaluator_without_agg|time_evaluator_without_agg "IS NOT DISTINCT FROM" time_evaluator_without_agg|_var_integer "IS NOT DISTINCT FROM" _var_integer|_var_character "IS NOT DISTINCT FROM" character_evaluator_without_agg|bit_AGG_evaluator "IS NOT DISTINCT FROM" _var_bit|bytea_evaluator_without_agg "IS NOT DISTINCT FROM" bytea_evaluator_without_agg|_var_time "IS NOT DISTINCT FROM" time_AGG_evaluator|bit_AGG_evaluator "IS NOT DISTINCT FROM" bit_AGG_evaluator|integer_evaluator_without_agg "IS NOT DISTINCT FROM" _var_integer|integer_AGG_evaluator "IS NOT DISTINCT FROM" _var_integer|time_evaluator_without_agg "IS NOT DISTINCT FROM" _var_time|_var_timestamp "IS NOT DISTINCT FROM" _var_timestamp|date_AGG_evaluator "IS NOT DISTINCT FROM" date_evaluator_without_agg|date_AGG_evaluator "IS NOT DISTINCT FROM" _var_date|_var_cidr "IS NOT DISTINCT FROM" _var_cidr|_var_integer "IS NOT DISTINCT FROM" integer_AGG_evaluator|_var_bit "IS NOT DISTINCT FROM" _var_bit|bit_evaluator_without_agg "IS NOT DISTINCT FROM" _var_bit|character_AGG_evaluator "IS NOT DISTINCT FROM" _var_character|bit_evaluator_without_agg "IS NOT DISTINCT FROM" bit_AGG_evaluator|date_evaluator_without_agg "IS NOT DISTINCT FROM" date_evaluator_without_agg|macaddr8_evaluator_without_agg "IS NOT DISTINCT FROM" _var_macaddr8|inet_evaluator_without_agg "IS NOT DISTINCT FROM" inet_AGG_evaluator|time_AGG_evaluator "IS NOT DISTINCT FROM" time_evaluator_without_agg|_var_timestamp "IS NOT DISTINCT FROM" timestamp_AGG_evaluator|_var_boolean "IS NOT DISTINCT FROM" boolean_AGG_evaluator|_var_macaddr "IS NOT DISTINCT FROM" _var_macaddr|_var_bit "IS NOT DISTINCT FROM" bit_AGG_evaluator|date_AGG_evaluator "IS NOT DISTINCT FROM" date_AGG_evaluator|timestamp_AGG_evaluator "IS NOT DISTINCT FROM" timestamp_AGG_evaluator|integer_evaluator_without_agg "IS NOT DISTINCT FROM" integer_AGG_evaluator|double_evaluator_without_agg "IS NOT DISTINCT FROM" _var_double|character_evaluator_without_agg "IS NOT DISTINCT FROM" character_AGG_evaluator|bit_evaluator_without_agg "IS NOT DISTINCT FROM" bit_evaluator_without_agg|integer_AGG_evaluator "IS NOT DISTINCT FROM" integer_AGG_evaluator|_var_inet "IS NOT DISTINCT FROM" inet_evaluator_without_agg|macaddr8_evaluator_without_agg "IS NOT DISTINCT FROM" macaddr8_evaluator_without_agg|character_AGG_evaluator "IS NOT DISTINCT FROM" character_evaluator_without_agg|double_evaluator_without_agg "IS NOT DISTINCT FROM" double_AGG_evaluator|_var_time "IS NOT DISTINCT FROM" time_evaluator_without_agg|bit_AGG_evaluator "IS NOT DISTINCT FROM" bit_evaluator_without_agg|inet_AGG_evaluator "IS NOT DISTINCT FROM" inet_AGG_evaluator|_var_double "IS NOT DISTINCT FROM" double_AGG_evaluator|inet_evaluator_without_agg "IS NOT DISTINCT FROM" _var_inet|double_AGG_evaluator "IS NOT DISTINCT FROM" double_AGG_evaluator|date_evaluator_without_agg "IS NOT DISTINCT FROM" _var_date|boolean_AGG_evaluator "IS NOT DISTINCT FROM" boolean_AGG_evaluator|_var_macaddr8 "IS NOT DISTINCT FROM" macaddr8_evaluator_without_agg|time_evaluator_without_agg "IS NOT DISTINCT FROM" time_AGG_evaluator|macaddr_evaluator_without_agg "IS NOT DISTINCT FROM" _var_macaddr|timestamp_AGG_evaluator "IS NOT DISTINCT FROM" timestamp_evaluator_without_agg|integer_evaluator_without_agg "IS NOT DISTINCT FROM" integer_evaluator_without_agg|timestamp_evaluator_without_agg "IS NOT DISTINCT FROM" _var_timestamp|character_evaluator_without_agg "IS NOT DISTINCT FROM" character_evaluator_without_agg|double_AGG_evaluator "IS NOT DISTINCT FROM" _var_double|_var_uuid "IS NOT DISTINCT FROM" uuid_evaluator_without_agg|_var_double "IS NOT DISTINCT FROM" _var_double|_var_double "IS NOT DISTINCT FROM" double_evaluator_without_agg|boolean_AGG_evaluator "IS NOT DISTINCT FROM" _var_boolean|_var_bit "IS NOT DISTINCT FROM" bit_evaluator_without_agg|_var_date "IS NOT DISTINCT FROM" date_AGG_evaluator|_var_integer "IS NOT DISTINCT FROM" integer_evaluator_without_agg|_var_date "IS NOT DISTINCT FROM" date_evaluator_without_agg|_var_date "IS NOT DISTINCT FROM" _var_date|_var_boolean "IS NOT DISTINCT FROM" _var_boolean|timestamp_evaluator_without_agg "IS NOT DISTINCT FROM" timestamp_AGG_evaluator|double_AGG_evaluator "IS NOT DISTINCT FROM" double_evaluator_without_agg|character_evaluator_without_agg "IS NOT DISTINCT FROM" _var_character|time_AGG_evaluator "IS NOT DISTINCT FROM" _var_time|_var_character "IS NOT DISTINCT FROM" _var_character|_var_macaddr "IS NOT DISTINCT FROM" macaddr_evaluator_without_agg;
ISNOTNULL_boolean_evaluator:integer_evaluator_without_agg "IS NOT NULL"|text_evaluator_without_agg "IS NOT NULL"|_var_integer "IS NOT NULL"|_var_text "IS NOT NULL";
ISNULL_boolean_evaluator:integer_evaluator_without_agg "ISNULL"|text_evaluator_without_agg "ISNULL"|_var_integer "ISNULL"|_var_text "ISNULL";
is_false_boolean_evaluator:_var_boolean "IS FALSE";
is_not_false_boolean_evaluator:_var_boolean "IS NOT FALSE";
is_not_true_boolean_evaluator:_var_boolean "IS NOT TRUE";
is_not_unknown_boolean_evaluator:_var_boolean "IS NOT UNKNOWN";
is_null_boolean_evaluator:integer_evaluator_without_agg "IS NULL";
is_true_boolean_evaluator:_var_boolean "IS TRUE";
is_unknown_boolean_evaluator:_var_boolean "IS UNKNOWN";
notnull_boolean_evaluator:integer_evaluator_without_agg "NOTNULL";
not_between_boolean_evaluator:_var_bit "NOT BETWEEN" _var_bit "AND" _var_bit;
not_between_symmetric_evaluator:"5 not between symmetric 8 and 2"|"10 not between symmetric 5 and 15"|"'b' not between symmetric 'a' and 'c'";
num_nonnulls_integer_evaluator:"num_nonnulls("_var_cidr("," _var_cidr)*")"|"num_nonnulls("double_evaluator_without_agg("," double_evaluator_without_agg)*")"|"num_nonnulls("time_AGG_evaluator("," time_AGG_evaluator)*")"|"num_nonnulls("_var_timestamp("," _var_timestamp)*")"|"num_nonnulls("date_AGG_evaluator("," date_AGG_evaluator)*")"|"num_nonnulls("character_AGG_evaluator("," character_AGG_evaluator)*")"|"num_nonnulls("uuid_evaluator_without_agg("," uuid_evaluator_without_agg)*")"|"num_nonnulls("_var_date("," _var_date)*")"|"num_nonnulls("_var_text("," _var_text)*")"|"num_nonnulls("_var_double("," _var_double)*")"|"num_nonnulls("integer_AGG_evaluator("," integer_AGG_evaluator)*")"|"num_nonnulls("integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"num_nonnulls("_var_bytea("," _var_bytea)*")"|"num_nonnulls("_var_macaddr("," _var_macaddr)*")"|"num_nonnulls("time_evaluator_without_agg("," time_evaluator_without_agg)*")"|"num_nonnulls("_var_inet("," _var_inet)*")"|"num_nonnulls("inet_AGG_evaluator("," inet_AGG_evaluator)*")"|"num_nonnulls("_var_boolean("," _var_boolean)*")"|"num_nonnulls("double_AGG_evaluator("," double_AGG_evaluator)*")"|"num_nonnulls("bit_evaluator_without_agg("," bit_evaluator_without_agg)*")"|"num_nonnulls("text_AGG_evaluator("," text_AGG_evaluator)*")"|"num_nonnulls("boolean_evaluator_without_agg("," boolean_evaluator_without_agg)*")"|"num_nonnulls("_var_macaddr8("," _var_macaddr8)*")"|"num_nonnulls("_var_time("," _var_time)*")"|"num_nonnulls("timestamp_evaluator_without_agg("," timestamp_evaluator_without_agg)*")"|"num_nonnulls("_var_bit("," _var_bit)*")"|"num_nonnulls("macaddr_evaluator_without_agg("," macaddr_evaluator_without_agg)*")"|"num_nonnulls("date_evaluator_without_agg("," date_evaluator_without_agg)*")"|"num_nonnulls("bit_AGG_evaluator("," bit_AGG_evaluator)*")"|"num_nonnulls("timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")";
num_nulls_integer_evaluator:"num_nulls("double_evaluator_without_agg("," double_evaluator_without_agg)*")"|"num_nulls("boolean_AGG_evaluator("," boolean_AGG_evaluator)*")"|"num_nulls("_var_macaddr8("," _var_macaddr8)*")"|"num_nulls("integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"num_nulls("_var_uuid("," _var_uuid)*")"|"num_nulls("_var_text("," _var_text)*")"|"num_nulls("double_AGG_evaluator("," double_AGG_evaluator)*")"|"num_nulls("cidr_evaluator_without_agg("," cidr_evaluator_without_agg)*")"|"num_nulls("boolean_evaluator_without_agg("," boolean_evaluator_without_agg)*")"|"num_nulls("_var_bit("," _var_bit)*")"|"num_nulls("bit_AGG_evaluator("," bit_AGG_evaluator)*")"|"num_nulls("macaddr8_evaluator_without_agg("," macaddr8_evaluator_without_agg)*")"|"num_nulls("inet_AGG_evaluator("," inet_AGG_evaluator)*")"|"num_nulls("_var_character("," _var_character)*")"|"num_nulls("_var_macaddr("," _var_macaddr)*")"|"num_nulls("_var_double("," _var_double)*")"|"num_nulls("_var_boolean("," _var_boolean)*")"|"num_nulls("time_evaluator_without_agg("," time_evaluator_without_agg)*")"|"num_nulls("_var_date("," _var_date)*")"|"num_nulls("_var_time("," _var_time)*")"|"num_nulls("time_AGG_evaluator("," time_AGG_evaluator)*")"|"num_nulls("timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")"|"num_nulls("integer_AGG_evaluator("," integer_AGG_evaluator)*")";
GREATEST_integer_evaluator:"GREATEST("integer_evaluator_without_agg "," _var_integer("," _var_integer)*")"|"GREATEST("_var_integer "," integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"GREATEST("integer_evaluator_without_agg "," integer_AGG_evaluator("," integer_AGG_evaluator)*")"|"GREATEST("_var_integer "," integer_AGG_evaluator("," integer_AGG_evaluator)*")"|"GREATEST("integer_AGG_evaluator "," integer_AGG_evaluator("," integer_AGG_evaluator)*")"|"GREATEST("integer_AGG_evaluator "," integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"GREATEST("_var_integer "," _var_integer("," _var_integer)*")";
GREATEST_bit_evaluator:"GREATEST("bit_AGG_evaluator "," bit_evaluator_without_agg("," bit_evaluator_without_agg)*")"|"GREATEST("_var_bit "," bit_evaluator_without_agg("," bit_evaluator_without_agg)*")"|"GREATEST("bit_evaluator_without_agg "," _var_bit("," _var_bit)*")"|"GREATEST("bit_evaluator_without_agg "," bit_AGG_evaluator("," bit_AGG_evaluator)*")"|"GREATEST("_var_bit "," _var_bit("," _var_bit)*")";
GREATEST_boolean_evaluator:"GREATEST("boolean_evaluator_without_agg "," _var_boolean("," _var_boolean)*")"|"GREATEST("_var_boolean "," _var_boolean("," _var_boolean)*")"|"GREATEST("_var_boolean "," boolean_AGG_evaluator("," boolean_AGG_evaluator)*")"|"GREATEST("boolean_AGG_evaluator "," boolean_AGG_evaluator("," boolean_AGG_evaluator)*")"|"GREATEST("_var_boolean "," boolean_evaluator_without_agg("," boolean_evaluator_without_agg)*")";
GREATEST_bytea_evaluator:"GREATEST("_var_bytea "," _var_bytea("," _var_bytea)*")"|"GREATEST("bytea_evaluator_without_agg "," _var_bytea("," _var_bytea)*")"|"GREATEST("_var_bytea "," bytea_evaluator_without_agg("," bytea_evaluator_without_agg)*")";
GREATEST_character_evaluator:"GREATEST("character_evaluator_without_agg "," _var_character("," _var_character)*")"|"GREATEST("character_evaluator_without_agg "," character_AGG_evaluator("," character_AGG_evaluator)*")"|"GREATEST("character_AGG_evaluator "," character_AGG_evaluator("," character_AGG_evaluator)*")"|"GREATEST("character_AGG_evaluator "," _var_character("," _var_character)*")"|"GREATEST("_var_character "," character_AGG_evaluator("," character_AGG_evaluator)*")"|"GREATEST("character_AGG_evaluator "," character_evaluator_without_agg("," character_evaluator_without_agg)*")"|"GREATEST("_var_character "," _var_character("," _var_character)*")"|"GREATEST("_var_character "," character_evaluator_without_agg("," character_evaluator_without_agg)*")";
GREATEST_date_evaluator:"GREATEST("date_evaluator_without_agg "," _var_date("," _var_date)*")"|"GREATEST("date_AGG_evaluator "," _var_date("," _var_date)*")"|"GREATEST("_var_date "," date_evaluator_without_agg("," date_evaluator_without_agg)*")"|"GREATEST("_var_date "," _var_date("," _var_date)*")"|"GREATEST("date_AGG_evaluator "," date_AGG_evaluator("," date_AGG_evaluator)*")"|"GREATEST("_var_date "," date_AGG_evaluator("," date_AGG_evaluator)*")"|"GREATEST("date_evaluator_without_agg "," date_AGG_evaluator("," date_AGG_evaluator)*")"|"GREATEST("date_evaluator_without_agg "," date_evaluator_without_agg("," date_evaluator_without_agg)*")"|"GREATEST("date_AGG_evaluator "," date_evaluator_without_agg("," date_evaluator_without_agg)*")";
GREATEST_double_evaluator:"GREATEST("double_evaluator_without_agg "," _var_double("," _var_double)*")"|"GREATEST("_var_double "," double_evaluator_without_agg("," double_evaluator_without_agg)*")"|"GREATEST("double_AGG_evaluator "," double_evaluator_without_agg("," double_evaluator_without_agg)*")"|"GREATEST("_var_double "," double_AGG_evaluator("," double_AGG_evaluator)*")"|"GREATEST("double_evaluator_without_agg "," double_AGG_evaluator("," double_AGG_evaluator)*")"|"GREATEST("double_AGG_evaluator "," double_AGG_evaluator("," double_AGG_evaluator)*")"|"GREATEST("_var_double "," _var_double("," _var_double)*")"|"GREATEST("double_AGG_evaluator "," _var_double("," _var_double)*")";
GREATEST_time_evaluator:"GREATEST("time_evaluator_without_agg "," _var_time("," _var_time)*")"|"GREATEST("time_AGG_evaluator "," time_AGG_evaluator("," time_AGG_evaluator)*")"|"GREATEST("_var_time "," _var_time("," _var_time)*")"|"GREATEST("time_AGG_evaluator "," time_evaluator_without_agg("," time_evaluator_without_agg)*")"|"GREATEST("_var_time "," time_evaluator_without_agg("," time_evaluator_without_agg)*")";
GREATEST_timestamp_evaluator:"GREATEST("_var_timestamp "," timestamp_evaluator_without_agg("," timestamp_evaluator_without_agg)*")"|"GREATEST("timestamp_evaluator_without_agg "," timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")"|"GREATEST("_var_timestamp "," timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")"|"GREATEST("timestamp_AGG_evaluator "," timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")"|"GREATEST("timestamp_evaluator_without_agg "," _var_timestamp("," _var_timestamp)*")"|"GREATEST("timestamp_AGG_evaluator "," _var_timestamp("," _var_timestamp)*")"|"GREATEST("timestamp_AGG_evaluator "," timestamp_evaluator_without_agg("," timestamp_evaluator_without_agg)*")"|"GREATEST("_var_timestamp "," _var_timestamp("," _var_timestamp)*")"|"GREATEST("timestamp_evaluator_without_agg "," timestamp_evaluator_without_agg("," timestamp_evaluator_without_agg)*")";
GREATEST_cidr_evaluator:"GREATEST("cidr_evaluator_without_agg "," _var_cidr("," _var_cidr)*")"|"GREATEST("_var_cidr "," cidr_evaluator_without_agg("," cidr_evaluator_without_agg)*")"|"GREATEST("_var_cidr "," _var_cidr("," _var_cidr)*")";
GREATEST_inet_evaluator:"GREATEST("_var_inet "," _var_inet("," _var_inet)*")"|"GREATEST("inet_evaluator_without_agg "," _var_inet("," _var_inet)*")"|"GREATEST("inet_AGG_evaluator "," inet_evaluator_without_agg("," inet_evaluator_without_agg)*")"|"GREATEST("inet_AGG_evaluator "," _var_inet("," _var_inet)*")";
GREATEST_macaddr_evaluator:"GREATEST("_var_macaddr "," macaddr_evaluator_without_agg("," macaddr_evaluator_without_agg)*")"|"GREATEST("_var_macaddr "," _var_macaddr("," _var_macaddr)*")"|"GREATEST("macaddr_evaluator_without_agg "," _var_macaddr("," _var_macaddr)*")";
GREATEST_macaddr8_evaluator:"GREATEST("_var_macaddr8 "," macaddr8_evaluator_without_agg("," macaddr8_evaluator_without_agg)*")"|"GREATEST("macaddr8_evaluator_without_agg "," _var_macaddr8("," _var_macaddr8)*")"|"GREATEST("_var_macaddr8 "," _var_macaddr8("," _var_macaddr8)*")"|"GREATEST("macaddr8_evaluator_without_agg "," macaddr8_evaluator_without_agg("," macaddr8_evaluator_without_agg)*")";
GREATEST_uuid_evaluator:"GREATEST("_var_uuid "," _var_uuid("," _var_uuid)*")"|"GREATEST("uuid_evaluator_without_agg "," _var_uuid("," _var_uuid)*")"|"GREATEST("uuid_evaluator_without_agg "," uuid_evaluator_without_agg("," uuid_evaluator_without_agg)*")"|"GREATEST("_var_uuid "," uuid_evaluator_without_agg("," uuid_evaluator_without_agg)*")";
LEAST_integer_evaluator:"LEAST("_var_integer "," integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"LEAST("_var_integer "," integer_AGG_evaluator("," integer_AGG_evaluator)*")"|"LEAST("integer_AGG_evaluator "," integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"LEAST("integer_evaluator_without_agg "," integer_AGG_evaluator("," integer_AGG_evaluator)*")"|"LEAST("integer_evaluator_without_agg "," integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"LEAST("integer_AGG_evaluator "," _var_integer("," _var_integer)*")"|"LEAST("integer_evaluator_without_agg "," _var_integer("," _var_integer)*")"|"LEAST("_var_integer "," _var_integer("," _var_integer)*")"|"LEAST("integer_AGG_evaluator "," integer_AGG_evaluator("," integer_AGG_evaluator)*")";
LEAST_bit_evaluator:"LEAST("bit_evaluator_without_agg "," bit_evaluator_without_agg("," bit_evaluator_without_agg)*")"|"LEAST("bit_evaluator_without_agg "," bit_AGG_evaluator("," bit_AGG_evaluator)*")"|"LEAST("bit_AGG_evaluator "," bit_AGG_evaluator("," bit_AGG_evaluator)*")"|"LEAST("_var_bit "," bit_evaluator_without_agg("," bit_evaluator_without_agg)*")"|"LEAST("_var_bit "," _var_bit("," _var_bit)*")"|"LEAST("bit_evaluator_without_agg "," _var_bit("," _var_bit)*")";
LEAST_boolean_evaluator:"LEAST("_var_boolean "," boolean_evaluator_without_agg("," boolean_evaluator_without_agg)*")"|"LEAST("boolean_evaluator_without_agg "," boolean_AGG_evaluator("," boolean_AGG_evaluator)*")"|"LEAST("boolean_AGG_evaluator "," boolean_AGG_evaluator("," boolean_AGG_evaluator)*")"|"LEAST("boolean_evaluator_without_agg "," _var_boolean("," _var_boolean)*")"|"LEAST("boolean_AGG_evaluator "," _var_boolean("," _var_boolean)*")"|"LEAST("boolean_evaluator_without_agg "," boolean_evaluator_without_agg("," boolean_evaluator_without_agg)*")"|"LEAST("_var_boolean "," _var_boolean("," _var_boolean)*")"|"LEAST("_var_boolean "," boolean_AGG_evaluator("," boolean_AGG_evaluator)*")";
LEAST_bytea_evaluator:"LEAST("bytea_evaluator_without_agg "," bytea_evaluator_without_agg("," bytea_evaluator_without_agg)*")"|"LEAST("_var_bytea "," bytea_evaluator_without_agg("," bytea_evaluator_without_agg)*")"|"LEAST("bytea_evaluator_without_agg "," _var_bytea("," _var_bytea)*")"|"LEAST("_var_bytea "," _var_bytea("," _var_bytea)*")";
LEAST_character_evaluator:"LEAST("_var_character "," character_evaluator_without_agg("," character_evaluator_without_agg)*")"|"LEAST("character_AGG_evaluator "," character_AGG_evaluator("," character_AGG_evaluator)*")"|"LEAST("character_evaluator_without_agg "," character_AGG_evaluator("," character_AGG_evaluator)*")"|"LEAST("character_evaluator_without_agg "," _var_character("," _var_character)*")"|"LEAST("character_evaluator_without_agg "," character_evaluator_without_agg("," character_evaluator_without_agg)*")"|"LEAST("_var_character "," _var_character("," _var_character)*")"|"LEAST("character_AGG_evaluator "," _var_character("," _var_character)*")"|"LEAST("_var_character "," character_AGG_evaluator("," character_AGG_evaluator)*")";
LEAST_date_evaluator:"LEAST("_var_date "," _var_date("," _var_date)*")"|"LEAST("date_evaluator_without_agg "," _var_date("," _var_date)*")"|"LEAST("date_evaluator_without_agg "," date_AGG_evaluator("," date_AGG_evaluator)*")"|"LEAST("date_AGG_evaluator "," date_evaluator_without_agg("," date_evaluator_without_agg)*")"|"LEAST("_var_date "," date_evaluator_without_agg("," date_evaluator_without_agg)*")"|"LEAST("date_AGG_evaluator "," _var_date("," _var_date)*")"|"LEAST("date_AGG_evaluator "," date_AGG_evaluator("," date_AGG_evaluator)*")"|"LEAST("date_evaluator_without_agg "," date_evaluator_without_agg("," date_evaluator_without_agg)*")";
LEAST_double_evaluator:"LEAST("_var_double "," _var_double("," _var_double)*")"|"LEAST("double_AGG_evaluator "," double_evaluator_without_agg("," double_evaluator_without_agg)*")"|"LEAST("double_evaluator_without_agg "," _var_double("," _var_double)*")"|"LEAST("_var_double "," double_AGG_evaluator("," double_AGG_evaluator)*")"|"LEAST("double_evaluator_without_agg "," double_evaluator_without_agg("," double_evaluator_without_agg)*")"|"LEAST("double_evaluator_without_agg "," double_AGG_evaluator("," double_AGG_evaluator)*")"|"LEAST("_var_double "," double_evaluator_without_agg("," double_evaluator_without_agg)*")"|"LEAST("double_AGG_evaluator "," double_AGG_evaluator("," double_AGG_evaluator)*")"|"LEAST("double_AGG_evaluator "," _var_double("," _var_double)*")";
LEAST_time_evaluator:"LEAST("time_evaluator_without_agg "," _var_time("," _var_time)*")"|"LEAST("time_AGG_evaluator "," time_evaluator_without_agg("," time_evaluator_without_agg)*")"|"LEAST("_var_time "," time_AGG_evaluator("," time_AGG_evaluator)*")"|"LEAST("time_AGG_evaluator "," time_AGG_evaluator("," time_AGG_evaluator)*")"|"LEAST("_var_time "," time_evaluator_without_agg("," time_evaluator_without_agg)*")"|"LEAST("time_evaluator_without_agg "," time_AGG_evaluator("," time_AGG_evaluator)*")"|"LEAST("time_evaluator_without_agg "," time_evaluator_without_agg("," time_evaluator_without_agg)*")"|"LEAST("time_AGG_evaluator "," _var_time("," _var_time)*")"|"LEAST("_var_time "," _var_time("," _var_time)*")";
LEAST_timestamp_evaluator:"LEAST("timestamp_evaluator_without_agg "," timestamp_evaluator_without_agg("," timestamp_evaluator_without_agg)*")"|"LEAST("timestamp_evaluator_without_agg "," _var_timestamp("," _var_timestamp)*")"|"LEAST("_var_timestamp "," timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")"|"LEAST("_var_timestamp "," _var_timestamp("," _var_timestamp)*")"|"LEAST("timestamp_AGG_evaluator "," timestamp_evaluator_without_agg("," timestamp_evaluator_without_agg)*")"|"LEAST("timestamp_evaluator_without_agg "," timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")"|"LEAST("_var_timestamp "," timestamp_evaluator_without_agg("," timestamp_evaluator_without_agg)*")"|"LEAST("timestamp_AGG_evaluator "," timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")";
LEAST_cidr_evaluator:"LEAST("cidr_evaluator_without_agg "," cidr_evaluator_without_agg("," cidr_evaluator_without_agg)*")"|"LEAST("_var_cidr "," cidr_evaluator_without_agg("," cidr_evaluator_without_agg)*")"|"LEAST("cidr_evaluator_without_agg "," _var_cidr("," _var_cidr)*")"|"LEAST("_var_cidr "," _var_cidr("," _var_cidr)*")";
LEAST_inet_evaluator:"LEAST("inet_evaluator_without_agg "," _var_inet("," _var_inet)*")"|"LEAST("inet_evaluator_without_agg "," inet_evaluator_without_agg("," inet_evaluator_without_agg)*")"|"LEAST("_var_inet "," inet_evaluator_without_agg("," inet_evaluator_without_agg)*")"|"LEAST("_var_inet "," _var_inet("," _var_inet)*")";
LEAST_macaddr_evaluator:"LEAST("_var_macaddr "," _var_macaddr("," _var_macaddr)*")"|"LEAST("macaddr_evaluator_without_agg "," macaddr_evaluator_without_agg("," macaddr_evaluator_without_agg)*")"|"LEAST("macaddr_evaluator_without_agg "," _var_macaddr("," _var_macaddr)*")"|"LEAST("_var_macaddr "," macaddr_evaluator_without_agg("," macaddr_evaluator_without_agg)*")";
LEAST_macaddr8_evaluator:"LEAST("_var_macaddr8 "," macaddr8_evaluator_without_agg("," macaddr8_evaluator_without_agg)*")"|"LEAST("macaddr8_evaluator_without_agg "," _var_macaddr8("," _var_macaddr8)*")"|"LEAST("macaddr8_evaluator_without_agg "," macaddr8_evaluator_without_agg("," macaddr8_evaluator_without_agg)*")"|"LEAST("_var_macaddr8 "," _var_macaddr8("," _var_macaddr8)*")";
LEAST_uuid_evaluator:"LEAST("uuid_evaluator_without_agg "," uuid_evaluator_without_agg("," uuid_evaluator_without_agg)*")"|"LEAST("_var_uuid "," uuid_evaluator_without_agg("," uuid_evaluator_without_agg)*")"|"LEAST("_var_uuid "," _var_uuid("," _var_uuid)*")";
NULLIF_integer_evaluator:"NULLIF("_var_integer "," _var_integer")"|"NULLIF("integer_evaluator_without_agg "," _var_integer")"|"NULLIF("integer_AGG_evaluator "," _var_integer")"|"NULLIF("integer_evaluator_without_agg "," integer_evaluator_without_agg")"|"NULLIF("_var_integer "," integer_evaluator_without_agg")";
NULLIF_bit_evaluator:"NULLIF("bit_AGG_evaluator "," bit_evaluator_without_agg")"|"NULLIF("_var_bit "," bit_AGG_evaluator")"|"NULLIF("bit_AGG_evaluator "," _var_bit")"|"NULLIF("_var_bit "," bit_evaluator_without_agg")"|"NULLIF("bit_AGG_evaluator "," bit_AGG_evaluator")"|"NULLIF("_var_bit "," _var_bit")"|"NULLIF("bit_evaluator_without_agg "," bit_AGG_evaluator")"|"NULLIF("bit_evaluator_without_agg "," _var_bit")";
NULLIF_uuid_evaluator:"NULLIF("_var_uuid "," _var_uuid")"|"NULLIF("uuid_evaluator_without_agg "," _var_uuid")"|"NULLIF("_var_uuid "," uuid_evaluator_without_agg")";
NULLIF_boolean_evaluator:"NULLIF("_var_boolean "," boolean_evaluator_without_agg")"|"NULLIF("boolean_evaluator_without_agg "," _var_boolean")"|"NULLIF("_var_boolean "," _var_boolean")"|"NULLIF("_var_boolean "," boolean_AGG_evaluator")"|"NULLIF("boolean_AGG_evaluator "," boolean_AGG_evaluator")"|"NULLIF("boolean_AGG_evaluator "," boolean_evaluator_without_agg")"|"NULLIF("boolean_AGG_evaluator "," _var_boolean")";
NULLIF_bytea_evaluator:"NULLIF("_var_bytea "," _var_bytea")"|"NULLIF("_var_bytea "," bytea_evaluator_without_agg")"|"NULLIF("bytea_evaluator_without_agg "," _var_bytea")"|"NULLIF("bytea_evaluator_without_agg "," bytea_evaluator_without_agg")";
NULLIF_character_evaluator:"NULLIF("_var_character "," _var_character")"|"NULLIF("_var_character "," character_evaluator_without_agg")"|"NULLIF("character_AGG_evaluator "," character_evaluator_without_agg")"|"NULLIF("_var_character "," character_AGG_evaluator")"|"NULLIF("character_AGG_evaluator "," character_AGG_evaluator")"|"NULLIF("character_evaluator_without_agg "," character_evaluator_without_agg")"|"NULLIF("character_evaluator_without_agg "," character_AGG_evaluator")"|"NULLIF("character_AGG_evaluator "," _var_character")"|"NULLIF("character_evaluator_without_agg "," _var_character")";
NULLIF_date_evaluator:"NULLIF("date_evaluator_without_agg "," _var_date")"|"NULLIF("_var_date "," _var_date")"|"NULLIF("date_AGG_evaluator "," date_evaluator_without_agg")"|"NULLIF("date_AGG_evaluator "," _var_date")"|"NULLIF("_var_date "," date_evaluator_without_agg")"|"NULLIF("date_AGG_evaluator "," date_AGG_evaluator")"|"NULLIF("date_evaluator_without_agg "," date_AGG_evaluator")"|"NULLIF("_var_date "," date_AGG_evaluator")";
NULLIF_double_evaluator:"NULLIF("_var_integer "," _var_double")"|"NULLIF("_var_double "," double_evaluator_without_agg")"|"NULLIF("integer_evaluator_without_agg "," double_AGG_evaluator")"|"NULLIF("_var_double "," integer_AGG_evaluator")"|"NULLIF("double_evaluator_without_agg "," _var_integer")"|"NULLIF("integer_AGG_evaluator "," double_AGG_evaluator")"|"NULLIF("_var_integer "," double_AGG_evaluator")"|"NULLIF("double_evaluator_without_agg "," double_AGG_evaluator")"|"NULLIF("double_evaluator_without_agg "," integer_AGG_evaluator")"|"NULLIF("_var_double "," _var_double")"|"NULLIF("double_AGG_evaluator "," _var_double")"|"NULLIF("double_evaluator_without_agg "," integer_evaluator_without_agg")"|"NULLIF("double_AGG_evaluator "," integer_evaluator_without_agg")"|"NULLIF("integer_evaluator_without_agg "," double_evaluator_without_agg")"|"NULLIF("_var_double "," double_AGG_evaluator")"|"NULLIF("double_AGG_evaluator "," double_AGG_evaluator")"|"NULLIF("_var_integer "," double_evaluator_without_agg")"|"NULLIF("double_AGG_evaluator "," double_evaluator_without_agg")"|"NULLIF("_var_double "," integer_evaluator_without_agg")"|"NULLIF("integer_AGG_evaluator "," double_evaluator_without_agg")"|"NULLIF("_var_double "," _var_integer")"|"NULLIF("double_evaluator_without_agg "," _var_double")"|"NULLIF("integer_evaluator_without_agg "," _var_double")"|"NULLIF("double_evaluator_without_agg "," double_evaluator_without_agg")"|"NULLIF("double_AGG_evaluator "," _var_integer")"|"NULLIF("double_AGG_evaluator "," integer_AGG_evaluator")"|"NULLIF("integer_AGG_evaluator "," _var_double")";
NULLIF_time_evaluator:"NULLIF("_var_time "," _var_time")"|"NULLIF("_var_time "," time_evaluator_without_agg")"|"NULLIF("time_AGG_evaluator "," time_AGG_evaluator")"|"NULLIF("time_AGG_evaluator "," time_evaluator_without_agg")"|"NULLIF("time_evaluator_without_agg "," _var_time")"|"NULLIF("_var_time "," time_AGG_evaluator")"|"NULLIF("time_evaluator_without_agg "," time_evaluator_without_agg")";
NULLIF_timestamp_evaluator:"NULLIF("_var_timestamp "," _var_timestamp")"|"NULLIF("timestamp_evaluator_without_agg "," timestamp_AGG_evaluator")"|"NULLIF("timestamp_AGG_evaluator "," timestamp_AGG_evaluator")"|"NULLIF("timestamp_evaluator_without_agg "," _var_timestamp")"|"NULLIF("timestamp_AGG_evaluator "," timestamp_evaluator_without_agg")"|"NULLIF("_var_timestamp "," timestamp_AGG_evaluator")"|"NULLIF("_var_timestamp "," timestamp_evaluator_without_agg")";
NULLIF_cidr_evaluator:"NULLIF("cidr_evaluator_without_agg "," _var_cidr")"|"NULLIF("_var_cidr "," _var_cidr")"|"NULLIF("_var_cidr "," cidr_evaluator_without_agg")";
NULLIF_inet_evaluator:"NULLIF("_var_inet "," inet_evaluator_without_agg")"|"NULLIF("inet_evaluator_without_agg "," _var_inet")"|"NULLIF("inet_AGG_evaluator "," _var_inet")"|"NULLIF("_var_inet "," inet_AGG_evaluator")"|"NULLIF("_var_inet "," _var_inet")"|"NULLIF("inet_AGG_evaluator "," inet_evaluator_without_agg")"|"NULLIF("inet_AGG_evaluator "," inet_AGG_evaluator")";
NULLIF_macaddr_evaluator:"NULLIF("_var_macaddr "," _var_macaddr")"|"NULLIF("macaddr_evaluator_without_agg "," _var_macaddr")"|"NULLIF("_var_macaddr "," macaddr_evaluator_without_agg")";
NULLIF_macaddr8_evaluator:"NULLIF("_var_macaddr8 "," _var_macaddr8")"|"NULLIF("_var_macaddr8 "," macaddr8_evaluator_without_agg")"|"NULLIF("macaddr8_evaluator_without_agg "," _var_macaddr8")";
to_char_text_evaluator:"to_char("_var_integer "," "'999D99S'"")"|"to_char("double_evaluator_without_agg "," "'999D99S'"")"|"to_char("double_AGG_evaluator "," "'999'"")"|"to_char("double_AGG_evaluator "," "'999D99S'"")"|"to_char("integer_evaluator_without_agg "," "'999'"")"|"to_char("_var_double "," "'999'"")"|"to_char("_var_integer "," "'999D9'"")"|"to_char("_var_double "," "'999D9'"")"|"to_char("double_evaluator_without_agg "," "'999D9'"")"|"to_char("integer_AGG_evaluator "," "'999D9'"")"|"to_char("integer_evaluator_without_agg "," "'999D99S'"")"|"to_char("integer_evaluator_without_agg "," "'999D9'"")"|"to_char("_var_integer "," "'999'"")"|"to_char("double_evaluator_without_agg "," "'999'"")"|"to_char("integer_AGG_evaluator "," "'999D99S'"")"|"to_char("_var_double "," "'999D99S'"")";
to_char_interval_text_evaluator:"to_char(" "'1 day'::interval" "," "'HH24:MI'" ")";
to_char_timestamp_text_evaluator:"to_char(" _var_timestamp "," "'YYYY-MM-DD'" ")";
to_date_date_evaluator:"to_date(" "'2024-01-01'" "," "'YYYY-MM-DD'" ")";
to_number_double_evaluator:"to_number(" "'12345'" "," "'99999'" ")";
to_number_func_evaluator:"to_number( '12,454.8-' , '99G999D9S' )"|"to_number( '12345' , '99999' )"|"to_number( '$100.50' , 'L999D99' )";
to_timestamp_text_timestamp_evaluator:"to_timestamp(" "'2024-01-01 12:00:00'" "," "'YYYY-MM-DD HH24:MI:SS'" ")";
clock_timestamp_timestamp_evaluator:"clock_timestamp("")";
current_time_time_evaluator:"current_time(""4"")"|"current_time(""3"")"|"current_time(""1"")"|"current_time(""2"")"|"current_time(""0"")"|"current_time(""6"")"|"current_time(""5"")";
current_timestamp_func_timestamp_evaluator:"current_timestamp(""0"")";
current_timestamp_with_precision_timestamp_evaluator:"current_timestamp(3)";
date_add_timestamp_evaluator:"date_add("_var_timestamp "," "'1 day'::interval" "," "'America/New_York'"")"|"date_add("timestamp_evaluator_without_agg "," "'1 day'::interval" "," "'UTC'"")"|"date_add("_var_timestamp "," "'1 month'::interval" "," "'Europe/Warsaw'"")"|"date_add("timestamp_evaluator_without_agg "," "'1 day'::interval" "," "'America/New_York'"")"|"date_add("timestamp_evaluator_without_agg "," "'1 month'::interval"")"|"date_add("timestamp_AGG_evaluator "," "'2 hours'::interval" "," "'America/New_York'"")"|"date_add("timestamp_AGG_evaluator "," "'1 month'::interval"")"|"date_add("timestamp_evaluator_without_agg "," "'2 hours'::interval" "," "'America/New_York'"")"|"date_add("timestamp_evaluator_without_agg "," "'2 hours'::interval" "," "'Europe/Warsaw'"")"|"date_add("_var_timestamp "," "'1 day'::interval" "," "'Europe/Warsaw'"")"|"date_add("_var_timestamp "," "'2 hours'::interval" "," "'UTC'"")"|"date_add("timestamp_AGG_evaluator "," "'1 day'::interval" "," "'Europe/Warsaw'"")"|"date_add("timestamp_evaluator_without_agg "," "'1 day'::interval" "," "'Europe/Warsaw'"")"|"date_add("timestamp_AGG_evaluator "," "'2 hours'::interval"")"|"date_add("_var_timestamp "," "'2 hours'::interval" "," "'America/New_York'"")"|"date_add("_var_timestamp "," "'1 day'::interval" "," "'UTC'"")"|"date_add("timestamp_AGG_evaluator "," "'1 month'::interval" "," "'Europe/Warsaw'"")"|"date_add("timestamp_evaluator_without_agg "," "'1 day'::interval"")"|"date_add("timestamp_evaluator_without_agg "," "'2 hours'::interval"")"|"date_add("timestamp_AGG_evaluator "," "'2 hours'::interval" "," "'UTC'"")"|"date_add("_var_timestamp "," "'1 month'::interval" "," "'UTC'"")"|"date_add("timestamp_AGG_evaluator "," "'1 day'::interval"")"|"date_add("_var_timestamp "," "'1 day'::interval"")"|"date_add("timestamp_AGG_evaluator "," "'1 day'::interval" "," "'America/New_York'"")"|"date_add("timestamp_AGG_evaluator "," "'2 hours'::interval" "," "'Europe/Warsaw'"")"|"date_add("_var_timestamp "," "'2 hours'::interval"")"|"date_add("_var_timestamp "," "'1 month'::interval"")";
date_add_integer_date_evaluator:"DATE '2024-01-01' + 7";
date_add_interval_timestamp_evaluator:date_evaluator_without_agg "+" "'1 day'::interval";
date_add_time_timestamp_evaluator:date_evaluator_without_agg "+" time_evaluator_without_agg;
date_bin_timestamp_evaluator:"date_bin(""'1 day'" "," timestamp_evaluator_without_agg "," timestamp_evaluator_without_agg")"|"date_bin(""'1 hour'" "," timestamp_evaluator_without_agg "," _var_timestamp")"|"date_bin(""'1 day'" "," timestamp_AGG_evaluator "," _var_timestamp")"|"date_bin(""'1 hour'" "," _var_timestamp "," timestamp_AGG_evaluator")"|"date_bin(""'15 minutes'" "," timestamp_AGG_evaluator "," timestamp_evaluator_without_agg")"|"date_bin(""'1 hour'" "," timestamp_evaluator_without_agg "," timestamp_AGG_evaluator")"|"date_bin(""'15 minutes'" "," timestamp_evaluator_without_agg "," _var_timestamp")"|"date_bin(""'15 minutes'" "," _var_timestamp "," timestamp_AGG_evaluator")"|"date_bin(""'1 hour'" "," timestamp_AGG_evaluator "," timestamp_evaluator_without_agg")"|"date_bin(""'1 day'" "," timestamp_evaluator_without_agg "," _var_timestamp")"|"date_bin(""'00:15:00'" "," timestamp_evaluator_without_agg "," _var_timestamp")"|"date_bin(""'00:15:00'" "," timestamp_evaluator_without_agg "," timestamp_AGG_evaluator")"|"date_bin(""'00:15:00'" "," _var_timestamp "," timestamp_evaluator_without_agg")"|"date_bin(""'15 minutes'" "," timestamp_AGG_evaluator "," timestamp_AGG_evaluator")"|"date_bin(""'00:15:00'" "," timestamp_AGG_evaluator "," timestamp_evaluator_without_agg")"|"date_bin(""'1 day'" "," timestamp_evaluator_without_agg "," timestamp_AGG_evaluator")"|"date_bin(""'1 day'" "," timestamp_AGG_evaluator "," timestamp_AGG_evaluator")"|"date_bin(""'1 day'" "," timestamp_AGG_evaluator "," timestamp_evaluator_without_agg")"|"date_bin(""'1 hour'" "," timestamp_AGG_evaluator "," timestamp_AGG_evaluator")"|"date_bin(""'00:15:00'" "," _var_timestamp "," timestamp_AGG_evaluator")"|"date_bin(""'1 day'" "," _var_timestamp "," timestamp_AGG_evaluator")"|"date_bin(""'1 hour'" "," _var_timestamp "," _var_timestamp")"|"date_bin(""'00:15:00'" "," _var_timestamp "," _var_timestamp")"|"date_bin(""'15 minutes'" "," _var_timestamp "," _var_timestamp")"|"date_bin(""'1 hour'" "," timestamp_AGG_evaluator "," _var_timestamp")"|"date_bin(""'00:15:00'" "," timestamp_AGG_evaluator "," timestamp_AGG_evaluator")"|"date_bin(""'15 minutes'" "," timestamp_AGG_evaluator "," _var_timestamp")";
date_part_interval_double_evaluator:"date_part(""'day'" "," "'1 day'::interval"")";
date_part_timestamp_double_evaluator:"date_part(""'day'" "," _var_timestamp")";
date_subtract_timestamp_evaluator:"date_subtract(" "'2024-01-01 12:00:00'::timestamp with time zone" "," "'1 day'::interval"")";
date_sub_date_integer_evaluator:"DATE '2024-01-15' - DATE '2024-01-01'";
date_sub_integer_date_evaluator:"DATE '2024-01-15' - 7";
date_sub_interval_timestamp_evaluator:date_evaluator_without_agg "-" "'1 day'::interval";
date_trunc_timestamp_evaluator:"date_trunc(""'microsecond'" "," _var_timestamp")"|"date_trunc(""'hour'" "," timestamp_AGG_evaluator")"|"date_trunc(""'year'" "," timestamp_AGG_evaluator")"|"date_trunc(""'millisecond'" "," timestamp_evaluator_without_agg")"|"date_trunc(""'millennium'" "," _var_timestamp")"|"date_trunc(""'decade'" "," _var_timestamp")"|"date_trunc(""'century'" "," timestamp_AGG_evaluator")"|"date_trunc(""'decade'" "," timestamp_AGG_evaluator")"|"date_trunc(""'hour'" "," _var_timestamp")"|"date_trunc(""'microsecond'" "," timestamp_AGG_evaluator")"|"date_trunc(""'year'" "," _var_timestamp")"|"date_trunc(""'minute'" "," timestamp_evaluator_without_agg")"|"date_trunc(""'millisecond'" "," _var_timestamp")"|"date_trunc(""'day'" "," _var_timestamp")"|"date_trunc(""'quarter'" "," timestamp_AGG_evaluator")"|"date_trunc(""'week'" "," timestamp_AGG_evaluator")"|"date_trunc(""'year'" "," timestamp_evaluator_without_agg")"|"date_trunc(""'century'" "," _var_timestamp")"|"date_trunc(""'second'" "," _var_timestamp")"|"date_trunc(""'minute'" "," timestamp_AGG_evaluator")"|"date_trunc(""'millisecond'" "," timestamp_AGG_evaluator")"|"date_trunc(""'millennium'" "," timestamp_evaluator_without_agg")"|"date_trunc(""'second'" "," timestamp_evaluator_without_agg")"|"date_trunc(""'microsecond'" "," timestamp_evaluator_without_agg")"|"date_trunc(""'quarter'" "," _var_timestamp")"|"date_trunc(""'day'" "," timestamp_AGG_evaluator")"|"date_trunc(""'minute'" "," _var_timestamp")"|"date_trunc(""'month'" "," timestamp_AGG_evaluator")"|"date_trunc(""'week'" "," timestamp_evaluator_without_agg")"|"date_trunc(""'second'" "," timestamp_AGG_evaluator")"|"date_trunc(""'millennium'" "," timestamp_AGG_evaluator")";
date_trunc_timestamp_timestamp_evaluator:"date_trunc(""'day'" "," _var_timestamp")";
date_trunc_timestamptz_timestamp_evaluator:"date_trunc(""'day'" "," "'2024-01-01 12:00:00 UTC'::timestamp with time zone"")";
extract_interval_double_evaluator:"EXTRACT(""DAY FROM" "'1 day'::interval"")";
extract_timestamp_double_evaluator:"EXTRACT(""DAY FROM" _var_timestamp")";
isfinite_date_boolean_evaluator:"isfinite(" date_evaluator_without_agg ")"|"isfinite(" _var_date ")";
isfinite_interval_boolean_evaluator:"isfinite(interval '4 hours')";
isfinite_timestamp_boolean_evaluator:"isfinite(" timestamp_evaluator_without_agg ")";
localtimestamp_timestamp_evaluator:"localtimestamp(""2"")"|"localtimestamp(""4"")"|"localtimestamp(""5"")"|"localtimestamp(""0"")"|"localtimestamp(""1"")";
localtimestamp_func_timestamp_evaluator:"localtimestamp";
localtime_func_time_evaluator:"localtime";
localtime_with_precision_time_evaluator:"localtime(3)";
make_date_date_evaluator:"make_date(""2024" "," "1" "," "1"")";
make_time_time_evaluator:"make_time(""12" "," "30" "," "0.0"")";
make_timestamp_timestamp_evaluator:"make_timestamp(""2024" "," "1" "," "1" "," "12" "," "30" "," "0.0"")";
make_timestamptz_timestamp_evaluator:"make_timestamptz(""2024" "," "1" "," "1" "," "12" "," "30" "," "0.0"")";
now_timestamp_evaluator:"now("")";
statement_timestamp_evaluator:"statement_timestamp" "(" ")";
timeofday_evaluator:"timeofday" "(" ")";
timestamp_add_interval_timestamp_evaluator:timestamp_evaluator_without_agg "+" "'1 day'::interval";
timestamp_sub_interval_timestamp_evaluator:timestamp_evaluator_without_agg "-" "'1 day'::interval";
time_add_interval_time_evaluator:time_evaluator_without_agg "+" "'1 hour'::interval";
time_sub_interval_time_evaluator:time_evaluator_without_agg "-" "'1 hour'::interval";
to_timestamp_timestamp_evaluator:"to_timestamp("double_evaluator_without_agg")"|"to_timestamp("_var_double")"|"to_timestamp("double_AGG_evaluator")";
transaction_timestamp_timestamp_evaluator:"transaction_timestamp("")";
AND_boolean_evaluator:_var_boolean "AND" boolean_evaluator_without_agg|boolean_evaluator_without_agg "AND" boolean_evaluator_without_agg|_var_boolean "AND" _var_boolean|boolean_AGG_evaluator "AND" boolean_evaluator_without_agg|boolean_AGG_evaluator "AND" _var_boolean|_var_boolean "AND" boolean_AGG_evaluator|boolean_AGG_evaluator "AND" boolean_AGG_evaluator|boolean_evaluator_without_agg "AND" _var_boolean|boolean_evaluator_without_agg "AND" boolean_AGG_evaluator;
NOT_boolean_evaluator:"NOT("_var_boolean")"|"NOT("boolean_evaluator_without_agg")"|"NOT("boolean_AGG_evaluator")";
not_boolean_evaluator:"not("boolean_evaluator_without_agg")"|"not("boolean_AGG_evaluator")"|"not("_var_boolean")";
OR_boolean_evaluator:_var_boolean "OR" boolean_evaluator_without_agg|_var_boolean "OR" boolean_AGG_evaluator|boolean_AGG_evaluator "OR" _var_boolean|boolean_AGG_evaluator "OR" boolean_AGG_evaluator|boolean_evaluator_without_agg "OR" boolean_evaluator_without_agg|_var_boolean "OR" _var_boolean|boolean_evaluator_without_agg "OR" _var_boolean|boolean_AGG_evaluator "OR" boolean_evaluator_without_agg;
abs_integer_evaluator:"abs("_var_integer")"|"abs("integer_evaluator_without_agg")"|"abs("integer_AGG_evaluator")";
abs_double_evaluator:"abs("double_evaluator_without_agg")"|"abs("_var_double")";
acos_double_evaluator:"acos(" _var_double ")";
acosd_double_evaluator:"acosd(" _var_double ")";
acosh_double_evaluator:"acosh(2.0)";
asin_double_evaluator:"asin(" _var_double ")";
asind_double_evaluator:"asind(" _var_double ")";
asinh_double_evaluator:"asinh("_var_double")"|"asinh("double_evaluator_without_agg")";
at_integer_evaluator:"@("_var_integer")"|"@("integer_evaluator_without_agg")"|"@("integer_AGG_evaluator")";
at_double_evaluator:"@("_var_double")";
atan_double_evaluator:"atan(" _var_double ")"|"atan(" double_evaluator_without_agg ")";
atan2_double_evaluator:"atan2("_var_double "," double_evaluator_without_agg")"|"atan2("_var_double "," double_AGG_evaluator")"|"atan2("double_AGG_evaluator "," double_AGG_evaluator")"|"atan2("double_AGG_evaluator "," _var_double")"|"atan2("double_evaluator_without_agg "," double_AGG_evaluator")"|"atan2("double_evaluator_without_agg "," _var_double")";
atan2d_double_evaluator:"atan2d("_var_double "," double_evaluator_without_agg")"|"atan2d("_var_double "," _var_double")"|"atan2d("double_evaluator_without_agg "," _var_double")"|"atan2d("double_AGG_evaluator "," double_AGG_evaluator")"|"atan2d("_var_double "," double_AGG_evaluator")"|"atan2d("double_AGG_evaluator "," _var_double")"|"atan2d("double_evaluator_without_agg "," double_evaluator_without_agg")";
atand_double_evaluator:"atand(" _var_double ")";
atanh_double_evaluator:"atanh(" _var_double ")";
bitwise_and_integral_integer_evaluator:_var_integer "&" _var_integer;
bitwise_lshift_integral_evaluator:"5 << 2"|"10 << 3";
bitwise_not_integral_integer_evaluator:"~" _var_integer;
bitwise_or_integral_integer_evaluator:_var_integer "|" _var_integer;
cbrt_double_evaluator:"cbrt(" _var_double ")"|"cbrt(" double_evaluator_without_agg ")";
ceil_double_evaluator:"ceil("_var_double")"|"ceil("double_AGG_evaluator")"|"ceil("double_evaluator_without_agg")";
ceiling_double_evaluator:"ceiling("double_evaluator_without_agg")"|"ceiling("double_AGG_evaluator")";
ceil_numeric_double_evaluator:"ceil("_var_double")";
cosd_double_evaluator:"cosd("_var_double")";
cosh_double_evaluator:"cosh("_var_double")"|"cosh("double_AGG_evaluator")";
cos_double_evaluator:"cos(" _var_double ")"|"cos(" double_evaluator_without_agg ")";
cot_double_evaluator:"cot(" _var_double ")";
cotd_double_evaluator:"cotd("_var_double")"|"cotd("double_AGG_evaluator")"|"cotd("double_evaluator_without_agg")";
cube_root_double_evaluator:"||/("_var_double")";
degrees_double_evaluator:"degrees(" _var_double ")"|"degrees(" double_evaluator_without_agg ")";
div_numeric_double_evaluator:"div(""10" "," "3"")";
div_numeric_integer_evaluator:_var_integer "/" _var_integer;
erf_double_evaluator:"erf("_var_double")"|"erf("double_AGG_evaluator")"|"erf("double_evaluator_without_agg")";
erfc_double_evaluator:"erfc("_var_double")"|"erfc("double_evaluator_without_agg")";
exp_double_evaluator:"exp("_var_double")"|"exp("double_AGG_evaluator")";
factorial_double_evaluator:"factorial(""5"")";
floor_double_evaluator:"floor("_var_double")"|"floor("double_evaluator_without_agg")"|"floor("double_AGG_evaluator")";
gamma_double_evaluator:"gamma("_var_double")";
gcd_integer_evaluator:"gcd("_var_integer "," _var_integer")"|"gcd("integer_evaluator_without_agg "," integer_evaluator_without_agg")"|"gcd("integer_evaluator_without_agg "," _var_integer")";
hash_integer_evaluator:_var_integer "#" integer_evaluator_without_agg|integer_evaluator_without_agg "#" integer_evaluator_without_agg|_var_integer "#" _var_integer|integer_evaluator_without_agg "#" _var_integer;
integral_lshift_integer_evaluator:"1" "<<" "2";
lcm_integer_evaluator:"lcm("_var_integer "," _var_integer")"|"lcm("integer_AGG_evaluator "," _var_integer")"|"lcm("integer_evaluator_without_agg "," integer_AGG_evaluator")"|"lcm("integer_AGG_evaluator "," integer_evaluator_without_agg")"|"lcm("_var_integer "," integer_AGG_evaluator")"|"lcm("integer_evaluator_without_agg "," _var_integer")";
lgamma_double_evaluator:"lgamma("_var_double")";
ln_double_evaluator:"ln("_var_double")";
log10_double_evaluator:"log10(" _var_double ")";
log_numeric_evaluator:"log(" _var_double ")";
log_two_args_double_evaluator:"log(""2" "," "8"")";
min_scale_integer_evaluator:"min_scale("_var_integer")";
mod_integer_integer_evaluator:"mod(" _var_integer "," _var_integer ")"|"mod(" integer_evaluator_without_agg "," _var_integer ")";
mod_numeric_op_integer_evaluator:_var_integer "%" _var_integer;
mul_integer_evaluator:"("integer_evaluator_without_agg ") * (" _var_integer")"|"("_var_integer ") * (" integer_AGG_evaluator")"|"("integer_AGG_evaluator ") * (" integer_evaluator_without_agg")"|"("_var_integer ") * (" integer_evaluator_without_agg")";
mul_double_evaluator:"("integer_AGG_evaluator ") * (" double_AGG_evaluator")"|"("double_AGG_evaluator ") * (" _var_integer")"|"("double_evaluator_without_agg ") * (" integer_AGG_evaluator")"|"("double_AGG_evaluator ") * (" integer_AGG_evaluator")"|"("double_AGG_evaluator ") * (" double_AGG_evaluator")"|"("double_evaluator_without_agg ") * (" _var_double")"|"("_var_double ") * (" _var_double")"|"("_var_double ") * (" integer_AGG_evaluator")"|"("_var_double ") * (" _var_integer")"|"("_var_integer ") * (" double_evaluator_without_agg")"|"("double_AGG_evaluator ") * (" _var_double")"|"("integer_AGG_evaluator ") * (" _var_double")"|"("_var_double ") * (" double_AGG_evaluator")"|"("double_evaluator_without_agg ") * (" double_evaluator_without_agg")"|"("double_AGG_evaluator ") * (" double_evaluator_without_agg")"|"("integer_AGG_evaluator ") * (" double_evaluator_without_agg")"|"("_var_integer ") * (" double_AGG_evaluator")"|"("double_evaluator_without_agg ") * (" _var_integer")"|"("double_evaluator_without_agg ") * (" double_AGG_evaluator")";
ordiv_double_evaluator:"|/("_var_double")";
pi_double_evaluator:"pi()";
pow_double_evaluator:_var_double "^" _var_double|double_evaluator_without_agg "^" _var_double|double_evaluator_without_agg "^" double_AGG_evaluator|_var_double "^" double_evaluator_without_agg|double_AGG_evaluator "^" double_evaluator_without_agg|double_evaluator_without_agg "^" double_evaluator_without_agg|_var_double "^" double_AGG_evaluator|double_AGG_evaluator "^" _var_double;
power_double_evaluator:"power("double_evaluator_without_agg "," _var_double")";
radians_double_evaluator:"radians("_var_double")";
random_double_evaluator:"random()";
random_normal_double_evaluator:"random_normal()";
random_range_integer_evaluator:"random(""1" "," "100"")";
round_double_integer_evaluator:"round(" _var_double ")"|"round(" double_evaluator_without_agg ")";
round_with_scale_double_evaluator:"round(""0.569527954956146" "," "2"")";
scale_integer_evaluator:"scale("integer_evaluator_without_agg")"|"scale("_var_integer")";
sign_double_integer_evaluator:"sign(" _var_double ")";
agg_sign_double_integer_evaluator:"sign(" double_AGG_evaluator ")";
sin_double_evaluator:"sin(" _var_double ")"|"sin(" double_evaluator_without_agg ")";
sind_double_evaluator:"sind("double_evaluator_without_agg")"|"sind("double_AGG_evaluator")"|"sind("_var_double")";
sinh_double_evaluator:"sinh(" _var_double ")";
sqrt_double_evaluator:"sqrt("double_evaluator_without_agg")"|"sqrt("_var_double")";
sub_numeric_integer_evaluator:integer_evaluator_without_agg "-" _var_integer;
tan_double_evaluator:"tan(" _var_double ")"|"tan(" double_evaluator_without_agg ")";
tand_double_evaluator:"tand("double_evaluator_without_agg")"|"tand("_var_double")"|"tand("double_AGG_evaluator")";
tanh_double_evaluator:"tanh("_var_double")"|"tanh("double_evaluator_without_agg")";
trim_scale_evaluator:"(trim_scale(" _var_integer "))::integer";
trunc_double_integer_evaluator:"trunc(" double_evaluator_without_agg ")";
trunc_with_scale_double_evaluator:"trunc(""0.569527954956146" "," "2"")";
unary_plus_double_evaluator:"+" double_evaluator_without_agg|"+" _var_double;
unary_plus_integer_evaluator:"+" integer_evaluator_without_agg|"+" _var_integer;
width_bucket_array_integer_evaluator:"width_bucket(""5" "," "ARRAY[1, 3, 5, 10]"")";
width_bucket_func_evaluator:"width_bucket( 5 , ARRAY[1, 3, 5, 10] )"|"width_bucket( 7.5 , ARRAY[0, 5, 10, 15] )";
width_bucket_numeric_integer_evaluator:"width_bucket(" _var_double "," "0" "," "100" "," "10" ")";
abbrev_cidr_text_evaluator:"abbrev(" _var_cidr ")";
abbrev_inet_text_evaluator:"abbrev(" _var_inet ")";
bigint_add_inet_evaluator:"5 + inet '192.168.1.1'"|"10 + inet '10.0.0.1'";
broadcast_inet_evaluator:"broadcast" "(" _var_inet ")";
family_inet_evaluator:"family" "(" _var_inet ")";
host_text_evaluator:"host(" _var_inet ")";
hostmask_inet_evaluator:"hostmask(" _var_inet ")";
inet_add_bigint_inet_evaluator:"1 + inet '192.168.1.1'";
inet_bit_and_evaluator:_var_inet "&" _var_inet;
inet_bit_not_evaluator:"~" _var_inet;
inet_bit_or_evaluator:_var_inet "|" _var_inet;
inet_contained_by_boolean_evaluator:_var_inet "<<" _var_inet;
inet_contained_by_eq_boolean_evaluator:_var_inet "<<=" _var_inet;
inet_contains_boolean_evaluator:_var_inet "&&" _var_inet;
inet_contains_eq_boolean_evaluator:_var_inet ">>=" _var_inet;
inet_merge_cidr_evaluator:"inet_merge('192.168.1.1'::inet, '192.168.2.1'::inet)";
inet_plus_bigint_inet_evaluator:"inet '192.168.1.1' + 1";
inet_same_family_boolean_evaluator:"inet_same_family(" _var_inet "," _var_inet ")";
inet_strictly_contains_boolean_evaluator:_var_inet ">>" _var_inet;
inet_sub_bigint_evaluator:"inet '192.168.1.10' - 5"|"inet '10.0.0.100' - 10";
inet_sub_inet_integer_evaluator:_var_inet "-" _var_inet;
macaddr8_set7bit_evaluator:"macaddr8_set7bit(" _var_macaddr8 ")";
masklen_integer_evaluator:"masklen(" _var_inet ")";
netmask_inet_evaluator:"netmask(" _var_inet ")";
network_cidr_evaluator:"network(" _var_inet ")";
set_masklen_cidr_inet_evaluator:"set_masklen(" _var_cidr "," "24" ")";
set_masklen_inet_inet_evaluator:"set_masklen('192.168.1.0'::inet, 16)";
text_text_evaluator:"text("_var_inet")"|"text("inet_evaluator_without_agg")";
trunc_macaddr_evaluator:"trunc(" _var_macaddr ")";
trunc_macaddr8_evaluator:"trunc(" _var_macaddr8 ")";
regex_match_evaluator:_var_character "~" _var_character|character_evaluator_without_agg "~" _var_character|_var_character "~" character_evaluator_without_agg|character_evaluator_without_agg "~" character_evaluator_without_agg;
regex_match_i_evaluator:_var_character "~*" _var_character|character_evaluator_without_agg "~*" _var_character|_var_character "~*" character_evaluator_without_agg|character_evaluator_without_agg "~*" character_evaluator_without_agg;
regex_not_match_evaluator:_var_character "!~" _var_character|character_evaluator_without_agg "!~" _var_character|_var_character "!~" character_evaluator_without_agg|character_evaluator_without_agg "!~" character_evaluator_without_agg;
regex_not_match_i_evaluator:_var_character "!~*" _var_character|character_evaluator_without_agg "!~*" _var_character|_var_character "!~*" character_evaluator_without_agg|character_evaluator_without_agg "!~*" character_evaluator_without_agg;
ascii_integer_evaluator:"ascii("_var_character")"|"ascii("character_evaluator_without_agg")";
ascii_text_integer_evaluator:"ascii(" character_evaluator_without_agg ")"|"ascii(" text_evaluator_without_agg ")";
bit_length_text_integer_evaluator:"bit_length(" _var_character ")"|"bit_length(" character_evaluator_without_agg ")";
btrim_text_evaluator:"btrim("character_evaluator_without_agg "," "''"")"|"btrim("_var_character "," "' '"")"|"btrim("character_AGG_evaluator "," "''"")"|"btrim("character_AGG_evaluator")"|"btrim("character_evaluator_without_agg "," "'xyz'"")"|"btrim("character_evaluator_without_agg "," "' '"")"|"btrim("_var_character "," "'xyz'"")"|"btrim("character_AGG_evaluator "," "'xyz'"")"|"btrim("character_evaluator_without_agg")"|"btrim("_var_character")"|"btrim("_var_character "," "''"")"|"btrim("character_AGG_evaluator "," "' '"")";
casefold_text_evaluator:"casefold(" _var_character ")"|"casefold(" character_evaluator_without_agg ")";
character_length_integer_evaluator:"character_length("_var_character")"|"character_length("character_AGG_evaluator")"|"character_length("character_evaluator_without_agg")";
char_length_integer_evaluator:"char_length("character_evaluator_without_agg")"|"char_length("character_AGG_evaluator")"|"char_length("_var_character")";
chr_text_evaluator:"chr( 65 )";
concat_text_evaluator:"concat("_var_bit("," _var_bit)*")"|"concat("_var_text("," _var_text)*")"|"concat("text_evaluator_without_agg("," text_evaluator_without_agg)*")"|"concat("bit_AGG_evaluator("," bit_AGG_evaluator)*")"|"concat("text_AGG_evaluator("," text_AGG_evaluator)*")"|"concat("cidr_evaluator_without_agg("," cidr_evaluator_without_agg)*")"|"concat("_var_bytea("," _var_bytea)*")"|"concat("_var_date("," _var_date)*")"|"concat("_var_boolean("," _var_boolean)*")"|"concat("_var_time("," _var_time)*")"|"concat("double_AGG_evaluator("," double_AGG_evaluator)*")"|"concat("integer_evaluator_without_agg("," integer_evaluator_without_agg)*")"|"concat("inet_AGG_evaluator("," inet_AGG_evaluator)*")"|"concat("_var_timestamp("," _var_timestamp)*")"|"concat("character_evaluator_without_agg("," character_evaluator_without_agg)*")"|"concat("date_evaluator_without_agg("," date_evaluator_without_agg)*")"|"concat("integer_AGG_evaluator("," integer_AGG_evaluator)*")"|"concat("_var_double("," _var_double)*")"|"concat("macaddr8_evaluator_without_agg("," macaddr8_evaluator_without_agg)*")"|"concat("_var_character("," _var_character)*")"|"concat("_var_inet("," _var_inet)*")"|"concat("time_AGG_evaluator("," time_AGG_evaluator)*")"|"concat("timestamp_AGG_evaluator("," timestamp_AGG_evaluator)*")"|"concat("_var_cidr("," _var_cidr)*")"|"concat("uuid_evaluator_without_agg("," uuid_evaluator_without_agg)*")";
concat_ws_text_evaluator:"concat_ws("_var_character "," _var_bit ("," _var_bit)*")";
convert_from_text_evaluator:"convert_from(" "'Hello'::bytea" "," "'UTF8'" ")"|"convert_from(" "'Hello'::bytea" "," "'UTF8'" ")";
format_text_evaluator:"format("_var_character ("," _var_bit)*")";
initcap_text_evaluator:"initcap("character_evaluator_without_agg")"|"initcap("character_AGG_evaluator")"|"initcap("_var_character")";
left_text_evaluator:"split_part( 'hello-world-test' , '-' , 2 )"|"split_part( '2024,03,11' , ',' , 1 )"|"split_part( 'abc def ghi' , ' ' , 3 )"|"split_part( 'one;two;three;four' , ';' , 4 )"|"split_part( 'a|b|c|d|e' , '|' , 1 )"|"split_part( 'first:last' , ':' , 2 )";
length_text_integer_evaluator:"length(" character_evaluator_without_agg ")"|"length(" text_evaluator_without_agg ")";
agg_length_text_integer_evaluator:"length(" character_AGG_evaluator ")";
lower_text_evaluator:"lower(" character_evaluator_without_agg ")"|"lower(" text_evaluator_without_agg ")";
agg_lower_text_evaluator:"lower(" character_AGG_evaluator ")";
lpad_text_evaluator:"lpad( 'A' , 42 )"|"lpad( 'test' , 10 )"|"lpad( 'hello' , 15 )"|"lpad( 'A' , 5 , 'x' )"|"lpad( 'A' , 10 , ' ' )"|"lpad( 'A' , 10 , 'xy' )";
ltrim_text_evaluator:"ltrim("_var_character")"|"ltrim("character_AGG_evaluator "," character_evaluator_without_agg")"|"ltrim("character_evaluator_without_agg")"|"ltrim("character_AGG_evaluator "," character_AGG_evaluator")"|"ltrim("_var_character "," character_evaluator_without_agg")"|"ltrim("character_AGG_evaluator "," _var_character")"|"ltrim("character_evaluator_without_agg "," character_evaluator_without_agg")"|"ltrim("_var_character "," _var_character")"|"ltrim("character_evaluator_without_agg "," _var_character")"|"ltrim("character_AGG_evaluator")"|"ltrim("_var_character "," character_AGG_evaluator")"|"ltrim("character_evaluator_without_agg "," character_AGG_evaluator")";
md5_text_evaluator:"md5(" _var_character ")"|"md5(" character_evaluator_without_agg ")";
normalize_text_evaluator:"normalize('Café', NFC)";
octet_length_integer_evaluator:"octet_length("character_evaluator_without_agg")"|"octet_length("_var_character")";
octet_length_text_integer_evaluator:"octet_length('Hello')";
oror_text_evaluator:_var_text "||" character_evaluator_without_agg|text_evaluator_without_agg "||" boolean_AGG_evaluator|_var_text "||" boolean_AGG_evaluator|character_AGG_evaluator "||" text_evaluator_without_agg|_var_text "||" integer_AGG_evaluator|text_evaluator_without_agg "||" time_AGG_evaluator|_var_text "||" timestamp_AGG_evaluator|_var_text "||" character_AGG_evaluator|text_evaluator_without_agg "||" double_AGG_evaluator|text_evaluator_without_agg "||" integer_AGG_evaluator|text_evaluator_without_agg "||" timestamp_AGG_evaluator|_var_text "||" time_AGG_evaluator|character_evaluator_without_agg "||" text_evaluator_without_agg|character_evaluator_without_agg "||" text_AGG_evaluator|character_AGG_evaluator "||" _var_text|character_AGG_evaluator "||" text_AGG_evaluator|text_evaluator_without_agg "||" text_AGG_evaluator|_var_text "||" bit_AGG_evaluator|_var_text "||" date_AGG_evaluator|text_evaluator_without_agg "||" character_AGG_evaluator|_var_text "||" double_AGG_evaluator|text_evaluator_without_agg "||" date_AGG_evaluator|text_AGG_evaluator "||" character_AGG_evaluator|text_evaluator_without_agg "||" bit_AGG_evaluator|text_evaluator_without_agg "||" character_evaluator_without_agg|_var_text "||" inet_AGG_evaluator|_var_text "||" text_AGG_evaluator|text_AGG_evaluator "||" character_evaluator_without_agg|character_evaluator_without_agg "||" _var_text;
overlay_text_evaluator:"overlay( 'Txxxxas' placing 'hom' from 2 for 4 )"|"overlay( 'Hello' placing 'XX' from 3 for 2 )"|"overlay( 'Txxxxas' placing 'hom' from 2 )";
pg_client_encoding_text_evaluator:"pg_client_encoding("")";
position_integer_evaluator:"position(" _var_text " IN " _var_text ")";
position_text_integer_evaluator:"position('lo' IN 'Hello')";
quote_ident_text_evaluator:"quote_ident(" _var_character ")"|"quote_ident(" character_evaluator_without_agg ")";
quote_literal_text_evaluator:"quote_literal(" _var_character ")"|"quote_literal(" character_evaluator_without_agg ")";
quote_nullable_text_evaluator:"quote_nullable(" _var_character ")"|"quote_nullable(" character_evaluator_without_agg ")";
regexp_count_evaluator:"regexp_count( 'ABCABC' , 'A.' )"|"regexp_count( 'Hello World Hello' , 'Hello' )"|"regexp_count( 'Test123Test' , '[0-9]' )";
regexp_instr_evaluator:"regexp_instr( 'foobarbequebaz' , 'ba' )"|"regexp_instr( 'Hello World' , 'World' )"|"regexp_instr( 'Test123Test' , '[0-9]+' )";
regexp_like_evaluator:"regexp_like(" _var_character "," _var_character ")"|"regexp_like(" character_evaluator_without_agg "," _var_character ")"|"regexp_like(" _var_character "," character_evaluator_without_agg ")"|"regexp_like(" character_evaluator_without_agg "," character_evaluator_without_agg ")";
regexp_replace_advanced_evaluator:"regexp_replace( 'Thomas' , '.' , 'X' , 3 )"|"regexp_replace( 'Test123Test' , '[0-9]' , 'X' , 1 , 2 )"|"regexp_replace( 'Hello World' , 'o' , '0' , 1 , 1 )";
regexp_replace_text_evaluator:"regexp_replace(" _var_character "," _var_character "," _var_character ")"|"regexp_replace(" character_evaluator_without_agg "," _var_character "," _var_character ")"|"regexp_replace(" _var_character "," character_evaluator_without_agg "," _var_character ")"|"regexp_replace(" _var_character "," _var_character "," character_evaluator_without_agg ")"|"regexp_replace(" character_evaluator_without_agg "," character_evaluator_without_agg "," _var_character ")"|"regexp_replace(" character_evaluator_without_agg "," _var_character "," character_evaluator_without_agg ")"|"regexp_replace(" _var_character "," character_evaluator_without_agg "," character_evaluator_without_agg ")"|"regexp_replace(" character_evaluator_without_agg "," character_evaluator_without_agg "," character_evaluator_without_agg ")";
regexp_substr_evaluator:"regexp_substr( 'foobarbequebaz' , 'ba.' )"|"regexp_substr( 'Hello World' , '[A-Z]+' )"|"regexp_substr( 'Test123Data' , '[0-9]+' )";
repeat_text_evaluator:"repeat( 'A' , 5 )"|"repeat( 'ab' , 3 )"|"repeat( 'x' , 10 )"|"repeat( 'hello' , 2 )"|"repeat( '*' , 20 )"|"repeat( '-' , 8 )";
replace_text_evaluator:"replace(" _var_character "," _var_character "," _var_character ")"|"replace(" character_evaluator_without_agg "," _var_character "," _var_character ")"|"replace(" _var_character "," character_evaluator_without_agg "," _var_character ")"|"replace(" _var_character "," _var_character "," character_evaluator_without_agg ")"|"replace(" character_evaluator_without_agg "," character_evaluator_without_agg "," _var_character ")"|"replace(" character_evaluator_without_agg "," _var_character "," character_evaluator_without_agg ")"|"replace(" _var_character "," character_evaluator_without_agg "," character_evaluator_without_agg ")"|"replace(" character_evaluator_without_agg "," character_evaluator_without_agg "," character_evaluator_without_agg ")";
reverse_text_evaluator:"reverse("character_evaluator_without_agg")"|"reverse("_var_character")";
reverse_text_func_evaluator:"reverse(" _var_character ")"|"reverse(" character_evaluator_without_agg ")";
right_text_evaluator:"right( 'ABC' , 2 )"|"right( 'Hello World' , 5 )"|"right( 'Test String' , 3 )"|"right( 'PostgreSQL' , 7 )"|"right( 'Database' , 4 )"|"right( 'SQL' , 2 )";
rpad_text_evaluator:"rpad( 'A' , 42 )"|"rpad( 'test' , 10 )"|"rpad( 'hello' , 15 )"|"rpad( 'A' , 5 , 'x' )"|"rpad( 'A' , 10 , ' ' )"|"rpad( 'A' , 10 , 'xy' )";
rtrim_text_evaluator:"rtrim("_var_character")"|"rtrim("_var_character "," "' '"")"|"rtrim("character_AGG_evaluator "," "' '"")"|"rtrim("_var_character "," "'xyz'"")"|"rtrim("character_evaluator_without_agg "," "'xyz'"")"|"rtrim("character_evaluator_without_agg")"|"rtrim("character_evaluator_without_agg "," "' '"")";
starts_with_boolean_evaluator:"starts_with("_var_character "," _var_character")"|"starts_with("character_evaluator_without_agg "," _var_character")"|"starts_with("character_evaluator_without_agg "," character_evaluator_without_agg")"|"starts_with("_var_character "," character_AGG_evaluator")"|"starts_with("_var_character "," character_evaluator_without_agg")";
starts_with_op_boolean_evaluator:"'Hello' ^@ 'He'";
strpos_text_evaluator:"strpos(" _var_character "," _var_character ")"|"strpos(" character_evaluator_without_agg "," _var_character ")"|"strpos(" _var_character "," character_evaluator_without_agg ")"|"strpos(" character_evaluator_without_agg "," character_evaluator_without_agg ")";
substr_text_evaluator:"substr( 'Hello World' , 1 )"|"substr( 'Hello World' , 7 )"|"substr( 'Hello World' , 1 , 5 )"|"substr( 'abcdefg' , 3 , 4 )"|"substr( 'PostgreSQL' , 1 , 4 )"|"substr( 'Testing' , 4 , 3 )";
substring_regex_evaluator:"substring( 'Thomas' from '...$' )"|"substring( 'Hello World' from '[A-Z]+' )"|"substring( 'Test123Data' from '[0-9]+' )";
substring_similar_evaluator:"substring( 'Thomas' similar 'Th%' escape '#' )"|"substring( 'Hello World' similar 'He%ld' escape '#' )";
substring_text_from_evaluator:"substring( 'Thomas' from 2 for 3 )"|"substring( 'Hello World' from 7 )"|"substring( 'Testing' for 4 )"|"substring( 'Database' from 3 for 4 )";
text_concat_evaluator:_var_character "||" _var_character|character_evaluator_without_agg "||" _var_character|_var_character "||" character_evaluator_without_agg|character_evaluator_without_agg "||" character_evaluator_without_agg;
text_normalized_evaluator:"'a' IS NFC NORMALIZED"|"'Hello' IS NFD NORMALIZED"|"'test' IS NOT NFC NORMALIZED";
to_bin_text_evaluator:"to_bin( 10 )"|"to_bin( 255 )"|"to_bin( 100 )"|"to_bin( 42 )"|"to_bin( 16 )"|"to_bin( 128 )";
to_hex_text_evaluator:"to_hex( 255 )"|"to_hex( 16 )"|"to_hex( 100 )"|"to_hex( 42 )"|"to_hex( 1024 )"|"to_hex( 128 )";
to_oct_text_evaluator:"to_oct( 64 )"|"to_oct( 255 )"|"to_oct( 8 )"|"to_oct( 100 )"|"to_oct( 512 )"|"to_oct( 128 )";
translate_text_evaluator:"translate(" _var_character "," _var_character "," _var_character ")"|"translate(" character_evaluator_without_agg "," _var_character "," _var_character ")"|"translate(" _var_character "," character_evaluator_without_agg "," _var_character ")"|"translate(" _var_character "," _var_character "," character_evaluator_without_agg ")"|"translate(" character_evaluator_without_agg "," character_evaluator_without_agg "," _var_character ")"|"translate(" character_evaluator_without_agg "," _var_character "," character_evaluator_without_agg ")"|"translate(" _var_character "," character_evaluator_without_agg "," character_evaluator_without_agg ")"|"translate(" character_evaluator_without_agg "," character_evaluator_without_agg "," character_evaluator_without_agg ")";
trim_from_evaluator:"trim( both from 'yxTomxx' , 'xyz' )"|"trim( leading from 'xxxHello' , 'x' )"|"trim( from '  Hello  ' )";
trim_text_evaluator:"trim( both 'xyz' from 'yxTomxx' )"|"trim( leading 'x' from 'xxxHello' )"|"trim( trailing 'x' from 'Helloxxx' )"|"trim( both from '  Hello  ' )";
unicode_assigned_evaluator:"unicode_assigned(" _var_character ")"|"unicode_assigned(" character_evaluator_without_agg ")";
unistr_text_evaluator:"unistr( '\\0061' )"|"unistr( '\\0041' )"|"unistr( 'Hello\\0020World' )"|"unistr( '\\0030\\0031\\0032' )"|"unistr( '\\+00003B1' )"|"unistr( 'A\\0042C' )";
upper_text_evaluator:"upper(" text_evaluator_without_agg ")"|"upper(" character_evaluator_without_agg ")";
agg_upper_text_evaluator:"upper(" character_AGG_evaluator ")";
gen_random_uuid_uuid_evaluator:"gen_random_uuid()";
uuidv7_uuid_evaluator:"uuidv7()";
uuid_extract_timestamp_timestamp_evaluator:"uuid_extract_timestamp(" _var_uuid ")";
uuid_extract_version_integer_evaluator:"uuid_extract_version(" _var_uuid ")";
