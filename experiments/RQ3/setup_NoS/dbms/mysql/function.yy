# port from mariadb randgen

{
 function field(num)
     print(string.format("field%d", num))
 end
}

query:
    select_or_explain_select


select_or_explain_select:
   select;

select:
   { num = 0 } SELECT distinct select_list FROM table where group_by_having_order_by_limit;

select_list:
   select_item AS { num=num+1; field(num) } |
   select_item AS { num=num+1; field(num) } , select_list ;

distinct:
   | DISTINCT ;

select_item:
   func | agg_func
;

where:
   | WHERE func ;

group_by_having_order_by_limit:
	group_by having order_by limit
;



group_by:
   | GROUP BY func | GROUP BY func, func ;

having:
   | HAVING func ;

order_by:
   | ORDER BY func | ORDER BY func, func ;

limit:
   | | | LIMIT _tinyint_unsigned ;


table: t0;
arg: field | value | ( func ) ;
field: c0|c1|c2|c3;
value: _int | _bigint | _smallint | _int_usigned | _letter | _english | _datetime | _date | _time | NULL ;

func:
	add_integer_evaluator | add_double_evaluator | agg_add_double_evaluator | agg_add_integer_evaluator | div_integer_evaluator | agg_div_integer_evaluator | div_double_evaluator | agg_div_double_evaluator | div_integer_evaluator | agg_div_integer_evaluator | mod_integer_evaluator | agg_mod_integer_evaluator | mod_double_evaluator | agg_mod_double_evaluator | mul_integer_evaluator | mul_double_evaluator | agg_mul_double_evaluator | agg_mul_integer_evaluator | sub_integer_evaluator | sub_double_evaluator | agg_sub_double_evaluator | unarysub_integer_evaluator | unarysub_double_evaluator | eq_boolean_evaluator | agg_eq_boolean_evaluator | agg_and_blob_evaluator | agg_and_integer_evaluator | and_integer_evaluator | bit_count_integer_evaluator | agg_bit_count_integer_evaluator | agg_complement_blob_evaluator | complement_integer_evaluator | agg_complement_integer_evaluator | gtgt_integer_evaluator | agg_gtgt_text_evaluator | gtgt_blob_evaluator | agg_gtgt_blob_evaluator | agg_gtgt_integer_evaluator | gtgt_bit_evaluator | agg_gtgt_bit_evaluator | gtgt_char_evaluator | agg_gtgt_char_evaluator | gtgt_text_evaluator | ltlt_blob_evaluator | ltlt_integer_evaluator | agg_ltlt_blob_evaluator | agg_ltlt_integer_evaluator | ltlt_char_evaluator | agg_ltlt_char_evaluator | ltlt_text_evaluator | agg_ltlt_text_evaluator | agg_or_char_evaluator | or_integer_evaluator | agg_or_text_evaluator | agg_or_integer_evaluator | pow_blob_evaluator | agg_pow_integer_evaluator | agg_pow_blob_evaluator | pow_integer_evaluator | binary_blob_evaluator | agg_binary_blob_evaluator | cast_char_evaluator | convert_integer_evaluator | coalesce_bit_evaluator | coalesce_double_evaluator | agg_coalesce_double_evaluator | agg_coalesce_bit_evaluator | coalesce_datetime_evaluator | coalesce_integer_evaluator | coalesce_time_evaluator | agg_coalesce_time_evaluator | coalesce_year_evaluator | agg_coalesce_year_evaluator | coalesce_char_evaluator | agg_coalesce_char_evaluator | coalesce_text_evaluator | agg_coalesce_text_evaluator | agg_coalesce_integer_evaluator | coalesce_blob_evaluator | agg_coalesce_blob_evaluator | coalesce_boolean_evaluator | agg_coalesce_boolean_evaluator | greatest_double_evaluator | agg_greatest_double_evaluator | greatest_text_evaluator | agg_greatest_text_evaluator | gt_boolean_evaluator | agg_gt_boolean_evaluator | gteq_boolean_evaluator | agg_gteq_boolean_evaluator | interval_integer_evaluator | agg_interval_integer_evaluator | is_boolean_evaluator | isnot_boolean_evaluator | isnotnull_boolean_evaluator | isnull_integer_evaluator | agg_isnull_integer_evaluator | isnull2_boolean_evaluator | least_integer_evaluator | least_blob_evaluator | agg_least_blob_evaluator | agg_least_integer_evaluator | least_date_evaluator | least_datetime_evaluator | least_timestamp_evaluator | least_time_evaluator | agg_least_time_evaluator | least_year_evaluator | agg_least_year_evaluator | least_double_evaluator | agg_least_double_evaluator | least_char_evaluator | agg_least_char_evaluator | least_text_evaluator | agg_least_text_evaluator | lt_boolean_evaluator | agg_lt_boolean_evaluator | lteq_boolean_evaluator | agg_lteq_boolean_evaluator | lteqgt_boolean_evaluator | agg_lteqgt_boolean_evaluator | ltgt_boolean_evaluator | agg_ltgt_boolean_evaluator | agg_adddate_date_evaluator | addtime_time_evaluator | addtime_datetime_evaluator | agg_addtime_datetime_evaluator | addtime_timestamp_evaluator | agg_addtime_timestamp_evaluator | agg_addtime_time_evaluator | convert_tz_datetime_evaluator | curdate_date_evaluator | curdate_integer_evaluator | current_time_time_evaluator | current_timestamp_datetime_evaluator | current_timestamp_timestamp_evaluator | curtime_time_evaluator | date_date_evaluator | agg_date_date_evaluator | datediff_integer_evaluator | agg_datediff_integer_evaluator | date_add_date_evaluator | date_add_datetime_evaluator | date_format_char_evaluator | agg_date_format_char_evaluator | date_sub_date_evaluator | date_sub_datetime_evaluator | day_integer_evaluator | agg_day_integer_evaluator | dayname_char_evaluator | agg_dayname_char_evaluator | dayofmonth_integer_evaluator | agg_dayofmonth_integer_evaluator | dayofweek_integer_evaluator | agg_dayofweek_integer_evaluator | dayofyear_integer_evaluator | agg_dayofyear_integer_evaluator | extract_integer_evaluator | from_days_date_evaluator | from_unixtime_datetime_evaluator | agg_from_unixtime_char_evaluator | agg_from_unixtime_datetime_evaluator | from_unixtime_char_evaluator | get_format_char_evaluator | hour_integer_evaluator | agg_hour_integer_evaluator | last_day_date_evaluator | agg_last_day_date_evaluator | localtime_datetime_evaluator | localtimestamp_datetime_evaluator | makedate_date_evaluator | agg_makedate_date_evaluator | maketime_time_evaluator | agg_maketime_time_evaluator | microsecond_integer_evaluator | agg_microsecond_integer_evaluator | minute_integer_evaluator | agg_minute_integer_evaluator | month_integer_evaluator | agg_month_integer_evaluator | monthname_char_evaluator | agg_monthname_char_evaluator | now_datetime_evaluator | now_timestamp_evaluator | period_add_integer_evaluator | period_diff_integer_evaluator | quarter_integer_evaluator | agg_quarter_integer_evaluator | second_integer_evaluator | agg_second_integer_evaluator | sec_to_time_time_evaluator | agg_sec_to_time_time_evaluator | str_to_date_date_evaluator | str_to_date_datetime_evaluator | agg_str_to_date_datetime_evaluator | agg_str_to_date_date_evaluator | str_to_date_time_evaluator | agg_str_to_date_time_evaluator | agg_subdate_timestamp_evaluator | subtime_time_evaluator | agg_subtime_text_evaluator | agg_subtime_time_evaluator | subtime_datetime_evaluator | agg_subtime_datetime_evaluator | subtime_timestamp_evaluator | agg_subtime_timestamp_evaluator | subtime_char_evaluator | agg_subtime_char_evaluator | subtime_text_evaluator | sysdate_datetime_evaluator | time_char_evaluator | agg_time_char_evaluator | timediff_time_evaluator | agg_timediff_time_evaluator | timestamp_datetime_evaluator | agg_timestamp_datetime_evaluator | timestampadd_datetime_evaluator | agg_timestampadd_timestamp_evaluator | agg_timestampadd_datetime_evaluator | timestampdiff_integer_evaluator | time_format_char_evaluator | agg_time_format_char_evaluator | time_to_sec_integer_evaluator | agg_time_to_sec_integer_evaluator | to_days_integer_evaluator | agg_to_days_integer_evaluator | to_seconds_integer_evaluator | agg_to_seconds_integer_evaluator | unix_timestamp_integer_evaluator | agg_unix_timestamp_integer_evaluator | unix_timestamp_double_evaluator | agg_unix_timestamp_double_evaluator | utc_date_date_evaluator | utc_time_time_evaluator | utc_time_char_evaluator | utc_time_double_evaluator | utc_timestamp_datetime_evaluator | utc_timestamp_double_evaluator | week_integer_evaluator | agg_week_integer_evaluator | weekday_integer_evaluator | agg_weekday_integer_evaluator | weekofyear_integer_evaluator | agg_weekofyear_integer_evaluator | year_integer_evaluator | agg_year_integer_evaluator | yearweek_integer_evaluator | agg_yearweek_integer_evaluator | case_integer_evaluator | case_char_evaluator | case_double_evaluator | case_date_evaluator | if_integer_evaluator | agg_if_double_evaluator | if_char_evaluator | agg_if_char_evaluator | if_text_evaluator | agg_if_text_evaluator | agg_if_integer_evaluator | if_datetime_evaluator | agg_if_datetime_evaluator | if_blob_evaluator | agg_if_blob_evaluator | if_double_evaluator | ifnull_integer_evaluator | ifnull_blob_evaluator | agg_ifnull_blob_evaluator | ifnull_date_evaluator | ifnull_datetime_evaluator | ifnull_timestamp_evaluator | agg_ifnull_integer_evaluator | ifnull_time_evaluator | agg_ifnull_time_evaluator | ifnull_year_evaluator | agg_ifnull_year_evaluator | ifnull_double_evaluator | agg_ifnull_double_evaluator | ifnull_char_evaluator | agg_ifnull_char_evaluator | nullif_integer_evaluator | nullif_double_evaluator | nullif_datetime_evaluator | nullif_date_evaluator | nullif_char_evaluator | nullif_boolean_evaluator | charset_char_evaluator | agg_charset_char_evaluator | coercibility_integer_evaluator | agg_coercibility_integer_evaluator | collation_char_evaluator | agg_collation_char_evaluator | connection_id_integer_evaluator | current_role_text_evaluator | current_user_text_evaluator | database_char_evaluator | found_rows_integer_evaluator | icu_version_char_evaluator | last_insert_id_integer_evaluator | agg_last_insert_id_integer_evaluator | roles_graphml_text_evaluator | row_count_integer_evaluator | schema_char_evaluator | session_user_char_evaluator | system_user_char_evaluator | user_char_evaluator | version_text_evaluator | and_integer_evaluator | agg_and_integer_evaluator | not_boolean_evaluator | not_boolean_evaluator | agg_not_boolean_evaluator | or_boolean_evaluator | agg_or_boolean_evaluator | xor_integer_evaluator | agg_xor_integer_evaluator | abs_integer_evaluator | agg_abs_boolean_evaluator | agg_abs_integer_evaluator | abs_double_evaluator | agg_abs_double_evaluator | abs_bit_evaluator | agg_abs_bit_evaluator | abs_boolean_evaluator | acos_double_evaluator | agg_acos_double_evaluator | asin_double_evaluator | agg_asin_double_evaluator | atan_double_evaluator | agg_atan_double_evaluator | atan2_double_evaluator | agg_atan2_double_evaluator | ceil_integer_evaluator | ceil_double_evaluator | agg_ceil_double_evaluator | agg_ceil_integer_evaluator | agg_ceiling_integer_evaluator | conv_char_evaluator | agg_conv_char_evaluator | cos_double_evaluator | agg_cos_double_evaluator | cot_double_evaluator | crc32_integer_evaluator | agg_crc32_integer_evaluator | degrees_double_evaluator | agg_degrees_double_evaluator | exp_double_evaluator | floor_integer_evaluator | floor_double_evaluator | agg_floor_double_evaluator | agg_floor_integer_evaluator | format_char_evaluator | agg_format_char_evaluator | hex_char_evaluator | agg_hex_char_evaluator | ln_double_evaluator | agg_ln_double_evaluator | log_double_evaluator | agg_log_double_evaluator | agg_log10_double_evaluator | log2_double_evaluator | agg_log2_double_evaluator | mod_integer_evaluator | agg_mod_double_evaluator | agg_mod_integer_evaluator | mod_double_evaluator | pi_double_evaluator | pow_double_evaluator | agg_pow_double_evaluator | agg_power_double_evaluator | radians_double_evaluator | agg_radians_double_evaluator | rand_double_evaluator | agg_rand_double_evaluator | round_integer_evaluator | agg_round_integer_evaluator | round_double_evaluator | agg_round_double_evaluator | sign_integer_evaluator | agg_sign_integer_evaluator | sin_double_evaluator | agg_sin_double_evaluator | sqrt_double_evaluator | agg_sqrt_double_evaluator | tan_double_evaluator | agg_tan_double_evaluator | truncate_double_evaluator | agg_truncate_integer_evaluator | agg_truncate_double_evaluator | truncate_integer_evaluator | any_value_bit_evaluator | any_value_datetime_evaluator | any_value_time_evaluator | agg_any_value_time_evaluator | any_value_year_evaluator | agg_any_value_year_evaluator | any_value_char_evaluator | agg_any_value_bit_evaluator | agg_any_value_char_evaluator | any_value_text_evaluator | agg_any_value_text_evaluator | any_value_blob_evaluator | agg_any_value_blob_evaluator | any_value_integer_evaluator | agg_any_value_integer_evaluator | any_value_boolean_evaluator | agg_any_value_boolean_evaluator | any_value_double_evaluator | agg_any_value_double_evaluator | bin_to_uuid_char_evaluator | inet6_aton_blob_evaluator | inet6_ntoa_char_evaluator | agg_inet6_ntoa_char_evaluator | inet_aton_integer_evaluator | agg_inet_aton_integer_evaluator | inet_ntoa_char_evaluator | agg_inet_ntoa_char_evaluator | is_ipv4_boolean_evaluator | agg_is_ipv4_boolean_evaluator | is_ipv4_compat_integer_evaluator | agg_is_ipv4_compat_integer_evaluator | is_ipv4_mapped_integer_evaluator | agg_is_ipv4_mapped_integer_evaluator | is_ipv6_integer_evaluator | agg_is_ipv6_integer_evaluator | is_uuid_integer_evaluator | agg_is_uuid_integer_evaluator | name_const_integer_evaluator | name_const_double_evaluator | name_const_char_evaluator | name_const_text_evaluator | name_const_boolean_evaluator | uuid_text_evaluator | uuid_short_integer_evaluator | uuid_to_bin_blob_evaluator | notregexp_boolean_evaluator | agg_notregexp_boolean_evaluator | regexp_integer_evaluator | regexp_instr_integer_evaluator | regexp_like_integer_evaluator | like_boolean_evaluator | not_like_boolean_evaluator | strcmp_integer_evaluator;
agg_func:
	avg_double_evaluator | bit_and_integer_evaluator | bit_or_integer_evaluator | bit_xor_char_evaluator | bit_xor_integer_evaluator | bit_xor_text_evaluator | count_integer_evaluator | group_concat_text_evaluator | group_concat_blob_evaluator | json_arrayagg_text_evaluator | json_objectagg_text_evaluator | max_bit_evaluator | max_integer_evaluator | max_text_evaluator | max_blob_evaluator | max_boolean_evaluator | max_double_evaluator | max_time_evaluator | max_year_evaluator | max_char_evaluator | min_bit_evaluator | min_boolean_evaluator | min_double_evaluator | min_time_evaluator | min_year_evaluator | min_char_evaluator | min_text_evaluator | min_blob_evaluator | min_integer_evaluator | std_double_evaluator | stddev_double_evaluator | stddev_pop_double_evaluator | stddev_samp_double_evaluator | sum_integer_evaluator | sum_double_evaluator | variance_double_evaluator | var_pop_double_evaluator | var_samp_double_evaluator;

avg_double_evaluator:
	AVG( arg  ) | AVG( arg  ) | AVG( arg  ) | AVG( arg  );
bit_and_integer_evaluator:
	BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  ) | BIT_AND( arg  );
bit_or_integer_evaluator:
	BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  ) | BIT_OR( arg  );
bit_xor_char_evaluator:
	BIT_XOR( arg  ) | BIT_XOR( arg  );
bit_xor_integer_evaluator:
	BIT_XOR( arg  ) | BIT_XOR( arg time ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  ) | BIT_XOR( arg  );
bit_xor_text_evaluator:
	BIT_XOR( arg  );
count_integer_evaluator:
	COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg time ) | COUNT( arg  ) | COUNT( arg  ) | COUNT( arg  );
group_concat_text_evaluator:
	GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg  ) | GROUP_CONCAT( arg time );
group_concat_blob_evaluator:
	GROUP_CONCAT( arg  );
bgg_group_concat_separator:
	'', | ',' | ' ' | 'string';
json_arrayagg_text_evaluator:
	JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  ) | JSON_ARRAYAGG( arg  );
json_objectagg_text_evaluator:
	JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg time ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg  ,  arg  ) | JSON_OBJECTAGG( arg time ,  arg time ) | JSON_OBJECTAGG( arg time ,  arg  );
max_bit_evaluator:
	MAX( arg  );
max_integer_evaluator:
	MAX( arg  ) | MAX( arg  );
max_text_evaluator:
	MAX( arg  ) | MAX( arg  );
max_blob_evaluator:
	MAX( arg  );
max_boolean_evaluator:
	MAX( arg  );
max_double_evaluator:
	MAX( arg  ) | MAX( arg  );
max_time_evaluator:
	MAX( arg  );
max_year_evaluator:
	MAX( arg  ) | MAX( arg  );
max_char_evaluator:
	MAX( arg  );
min_bit_evaluator:
	MIN( arg  ) | MIN( arg  );
min_boolean_evaluator:
	MIN( arg  ) | MIN( arg  );
min_double_evaluator:
	MIN( arg  ) | MIN( arg  );
min_time_evaluator:
	MIN( arg  ) | MIN( arg  );
min_year_evaluator:
	MIN( arg  ) | MIN( arg  );
min_char_evaluator:
	MIN( arg  ) | MIN( arg  );
min_text_evaluator:
	MIN( arg  ) | MIN( arg  );
min_blob_evaluator:
	MIN( arg  );
min_integer_evaluator:
	MIN( arg  ) | MIN( arg  );
std_double_evaluator:
	STD( arg  ) | STD( arg  ) | STD( arg  ) | STD( arg  ) | STD( arg  );
stddev_double_evaluator:
	STDDEV( arg  ) | STDDEV( arg  ) | STDDEV( arg  ) | STDDEV( arg  ) | STDDEV( arg  ) | STDDEV( arg  );
stddev_pop_double_evaluator:
	STDDEV_POP( arg  ) | STDDEV_POP( arg  ) | STDDEV_POP( arg  ) | STDDEV_POP( arg  ) | STDDEV_POP( arg  ) | STDDEV_POP( arg  );
stddev_samp_double_evaluator:
	STDDEV_SAMP( arg  ) | STDDEV_SAMP( arg  ) | STDDEV_SAMP( arg  ) | STDDEV_SAMP( arg  ) | STDDEV_SAMP( arg  ) | STDDEV_SAMP( arg  ) | STDDEV_SAMP( arg  );
sum_integer_evaluator:
	SUM( arg  ) | SUM( arg  ) | SUM( arg  ) | SUM( arg  ) | SUM( arg  ) | SUM( arg  );
sum_double_evaluator:
	SUM( arg  );
variance_double_evaluator:
	VARIANCE( arg  ) | VARIANCE( arg  ) | VARIANCE( arg  ) | VARIANCE( arg  );
var_pop_double_evaluator:
	VAR_POP( arg  ) | VAR_POP( arg  ) | VAR_POP( arg  ) | VAR_POP( arg  ) | VAR_POP( arg  );
var_samp_double_evaluator:
	VAR_SAMP( arg  ) | VAR_SAMP( arg  ) | VAR_SAMP( arg  );
add_integer_evaluator:
	 arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg ;
add_double_evaluator:
	 arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg ;
agg_add_double_evaluator:
	 arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg ;
agg_add_integer_evaluator:
	 arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg  |  arg  +  arg ;
div_integer_evaluator:
	 arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg ;
agg_div_integer_evaluator:
	 arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  DIV  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg ;
div_double_evaluator:
	 arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg ;
agg_div_double_evaluator:
	 arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg  |  arg  /  arg ;
mod_integer_evaluator:
	 arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  );
agg_mod_integer_evaluator:
	 arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  );
mod_double_evaluator:
	 arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  );
agg_mod_double_evaluator:
	 arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  |  arg  %  arg  | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  ) | MOD( arg  ,  arg  );
mul_integer_evaluator:
	 arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg ;
mul_double_evaluator:
	 arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg ;
agg_mul_double_evaluator:
	 arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg ;
agg_mul_integer_evaluator:
	 arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg  |  arg  *  arg ;
sub_integer_evaluator:
	 arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg ;
sub_double_evaluator:
	 arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg ;
agg_sub_double_evaluator:
	 arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg  |  arg  -  arg ;
unarysub_integer_evaluator:
	-( arg  ) | -( arg  );
unarysub_double_evaluator:
	-( arg  ) | -( arg  );
eq_boolean_evaluator:
	 arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg time |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg time =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg time =  arg time |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg ;
agg_eq_boolean_evaluator:
	 arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg  |  arg  =  arg ;
agg_and_blob_evaluator:
	 arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg ;
agg_and_integer_evaluator:
	 arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg ;
and_integer_evaluator:
	 arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg time &  arg time |  arg time &  arg  |  arg  &  arg time |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  &  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg time AND  arg  |  arg  AND  arg time |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg ;
bit_count_integer_evaluator:
	BIT_COUNT( arg  ) | BIT_COUNT( arg  ) | BIT_COUNT( arg  ) | BIT_COUNT( arg  );
agg_bit_count_integer_evaluator:
	BIT_COUNT( arg  ) | BIT_COUNT( arg  ) | BIT_COUNT( arg  ) | BIT_COUNT( arg  ) | BIT_COUNT( arg  ) | BIT_COUNT( arg  ) | BIT_COUNT( arg  );
agg_complement_blob_evaluator:
	~( arg  );
complement_integer_evaluator:
	~( arg  ) | ~( arg  ) | ~( arg time ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  );
agg_complement_integer_evaluator:
	~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  ) | ~( arg  );
gtgt_integer_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
agg_gtgt_text_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
gtgt_blob_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
agg_gtgt_blob_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
agg_gtgt_integer_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
gtgt_bit_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
agg_gtgt_bit_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
gtgt_char_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
agg_gtgt_char_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
gtgt_text_evaluator:
	 arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg  |  arg  >>  arg ;
ltlt_blob_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
ltlt_integer_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
agg_ltlt_blob_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
agg_ltlt_integer_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
ltlt_char_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
agg_ltlt_char_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
ltlt_text_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
agg_ltlt_text_evaluator:
	 arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg  |  arg  <<  arg ;
agg_or_char_evaluator:
	 arg  |  arg  |  arg  |  arg  |  arg  |  arg ;
or_integer_evaluator:
	 arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg ;
agg_or_text_evaluator:
	 arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg ;
agg_or_integer_evaluator:
	 arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg  |  arg ;
pow_blob_evaluator:
	 arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg ;
agg_pow_integer_evaluator:
	 arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg ;
agg_pow_blob_evaluator:
	 arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg ;
pow_integer_evaluator:
	 arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg time ^  arg time |  arg time ^  arg  |  arg  ^  arg time |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg ;
binary_blob_evaluator:
	BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg time ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  );
agg_binary_blob_evaluator:
	BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  ) | BINARY( arg  );
cast_char_evaluator:
	CAST( arg   AS  cast_type );
cast_type:
	CHAR | SIGNED INTEGER | DOUBLE;
convert_integer_evaluator:
	CONVERT( arg  , convert_type ) | CONVERT( arg  , convert_type );
convert_type:
	SIGNED | UNSIGNED;
coalesce_bit_evaluator:
	COALESCE( arg  ) | COALESCE( arg  );
coalesce_double_evaluator:
	COALESCE( arg  ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  );
agg_coalesce_double_evaluator:
	COALESCE( arg  ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* );
agg_coalesce_bit_evaluator:
	COALESCE( arg  );
coalesce_datetime_evaluator:
	COALESCE( arg  ) | COALESCE( arg  ,  arg time(,  arg time)* ,  arg (,  arg )* ) | COALESCE( arg  ,  arg time(,  arg time)* ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ,  arg (,  arg )* ) | COALESCE( arg  ,  arg time(,  arg time)* ,  arg (,  arg )* ) | COALESCE( arg  ,  arg time(,  arg time)* ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ,  arg (,  arg )* );
coalesce_integer_evaluator:
	COALESCE( arg  ) | COALESCE( arg  );
coalesce_time_evaluator:
	COALESCE( arg  ) | COALESCE( arg  );
agg_coalesce_time_evaluator:
	COALESCE( arg  );
coalesce_year_evaluator:
	COALESCE( arg  ) | COALESCE( arg  );
agg_coalesce_year_evaluator:
	COALESCE( arg  );
coalesce_char_evaluator:
	COALESCE( arg  ) | COALESCE( arg  );
agg_coalesce_char_evaluator:
	COALESCE( arg  );
coalesce_text_evaluator:
	COALESCE( arg  ) | COALESCE( arg  ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* );
agg_coalesce_text_evaluator:
	COALESCE( arg  ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* ) | COALESCE( arg  ,  arg (,  arg )* );
agg_coalesce_integer_evaluator:
	COALESCE( arg  );
coalesce_blob_evaluator:
	COALESCE( arg  ) | COALESCE( arg  );
agg_coalesce_blob_evaluator:
	COALESCE( arg  );
coalesce_boolean_evaluator:
	COALESCE( arg  ) | COALESCE( arg  );
agg_coalesce_boolean_evaluator:
	COALESCE( arg  );
greatest_double_evaluator:
	GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* );
agg_greatest_double_evaluator:
	GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* );
greatest_text_evaluator:
	GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* );
agg_greatest_text_evaluator:
	GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* ) | GREATEST( arg  ,  arg (,  arg )* );
gt_boolean_evaluator:
	 arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg time >  arg  |  arg  >  arg time |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg ;
agg_gt_boolean_evaluator:
	 arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg  |  arg  >  arg ;
gteq_boolean_evaluator:
	 arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg time >=  arg time |  arg time >=  arg  |  arg  >=  arg time |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg ;
agg_gteq_boolean_evaluator:
	 arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg  |  arg  >=  arg ;
interval_integer_evaluator:
	INTERVAL( arg  ,  arg (,  arg )* ) | INTERVAL( arg  ,  arg (,  arg )* );
agg_interval_integer_evaluator:
	INTERVAL( arg  ,  arg (,  arg )* ) | INTERVAL( arg  ,  arg (,  arg )* ) | INTERVAL( arg  ,  arg (,  arg )* ) | INTERVAL( arg  ,  arg (,  arg )* ) | INTERVAL( arg  ,  arg (,  arg )* );
is_boolean_evaluator:
	 arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg time IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value |  arg  IS is_boolean_value;
is_boolean_value:
	TRUE | FALSE | UNKNOWN;
isnot_boolean_evaluator:
	 arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg time IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value |  arg  IS NOT isnot_boolean_value;
isnot_boolean_value:
	TRUE | FALSE;
isnotnull_boolean_evaluator:
	 arg  IS NOT NULL |  arg  IS NOT NULL |  arg time IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL;
isnull_integer_evaluator:
	ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg time ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  );
agg_isnull_integer_evaluator:
	ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  ) | ISNULL( arg  );
isnull2_boolean_evaluator:
	 arg time IS NULL |  arg  IS NULL |  arg  IS NULL |  arg  IS NULL;
least_integer_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_blob_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
agg_least_blob_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
agg_least_integer_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_date_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_datetime_evaluator:
	LEAST( arg time ,  arg time(,  arg time)* ) | LEAST( arg time ,  arg (,  arg )* ) | LEAST( arg  ,  arg time(,  arg time)* ) | LEAST( arg  ,  arg (,  arg )* );
least_timestamp_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_time_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
agg_least_time_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_year_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
agg_least_year_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_double_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
agg_least_double_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_char_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
agg_least_char_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
least_text_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
agg_least_text_evaluator:
	LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* ) | LEAST( arg  ,  arg (,  arg )* );
lt_boolean_evaluator:
	 arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg time <  arg time |  arg time <  arg  |  arg  <  arg  |  arg  <  arg time |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg ;
agg_lt_boolean_evaluator:
	 arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg  |  arg  <  arg ;
lteq_boolean_evaluator:
	 arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg time <=  arg  |  arg  <=  arg time |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg ;
agg_lteq_boolean_evaluator:
	 arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg  |  arg  <=  arg ;
lteqgt_boolean_evaluator:
	 arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg time <=>  arg time |  arg time <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg ;
agg_lteqgt_boolean_evaluator:
	 arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg  |  arg  <=>  arg ;
ltgt_boolean_evaluator:
	 arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg time <>  arg time |  arg time <>  arg  |  arg  <>  arg time |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg ;
agg_ltgt_boolean_evaluator:
	 arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg  |  arg  <>  arg ;
agg_adddate_date_evaluator:
	ADDDATE( arg  ,  arg  );
addtime_time_evaluator:
	ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  );
addtime_datetime_evaluator:
	ADDTIME( arg  ,  arg  ) | ADDTIME( arg time ,  arg  );
agg_addtime_datetime_evaluator:
	ADDTIME( arg time ,  arg  ) | ADDTIME( arg  ,  arg  );
addtime_timestamp_evaluator:
	ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  );
agg_addtime_timestamp_evaluator:
	ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  );
agg_addtime_time_evaluator:
	ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  ) | ADDTIME( arg  ,  arg  );
convert_tz_datetime_evaluator:
	CONVERT_TZ( arg time , convert_tz_from_tz , convert_tz_to_tz ) | CONVERT_TZ( arg  , convert_tz_from_tz , convert_tz_to_tz ) | CONVERT_TZ( arg  , convert_tz_from_tz , convert_tz_to_tz ) | CONVERT_TZ( arg  , convert_tz_from_tz , convert_tz_to_tz ) | CONVERT_TZ( arg  , convert_tz_from_tz , convert_tz_to_tz ) | CONVERT_TZ( arg  , convert_tz_from_tz , convert_tz_to_tz );
convert_tz_from_tz:
	'UTC' | 'GMT' | 'Europe/Amsterdam' | 'MET' | '+00:00' | '+10:00' | '-04:30';
convert_tz_to_tz:
	'UTC' | 'GMT' | 'Europe/Amsterdam' | 'MET' | '+00:00' | '+10:00' | '-04:30';
curdate_date_evaluator:
	CURDATE( );
curdate_integer_evaluator:
	CURDATE( );
current_time_time_evaluator:
	CURRENT_TIME(current_time_fsp );
current_time_fsp:
	0 | 1 | 2 | 3 | 4 | 5 | 6;
current_timestamp_datetime_evaluator:
	CURRENT_TIMESTAMP( );
current_timestamp_timestamp_evaluator:
	CURRENT_TIMESTAMP( );
curtime_time_evaluator:
	CURTIME();
date_date_evaluator:
	DATE( arg  ) | DATE( arg  ) | DATE( arg  );
agg_date_date_evaluator:
	DATE( arg  );
datediff_integer_evaluator:
	DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg time ,  arg  ) | DATEDIFF( arg  ,  arg time ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  );
agg_datediff_integer_evaluator:
	DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  ) | DATEDIFF( arg  ,  arg  );
date_add_date_evaluator:
	DATE_ADD(  arg  , INTERVAL 1 date_add_unit);
date_add_datetime_evaluator:
	DATE_ADD(  arg time , INTERVAL 1 date_add_unit);
date_add_unit:
	SECOND | MINUTE | HOUR | DAY | MONTH | YEAR;
date_format_char_evaluator:
	DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format );
agg_date_format_char_evaluator:
	DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format ) | DATE_FORMAT( arg  , date_format_format );
date_format_format:
	'%H:%i:%s' | '%W %M %Y';
date_sub_date_evaluator:
	DATE_SUB(  arg  , INTERVAL 1 date_sub_unit);
date_sub_datetime_evaluator:
	DATE_SUB(  arg time , INTERVAL 1 date_sub_unit);
date_sub_unit:
	SECOND | MINUTE | HOUR | DAY | MONTH | YEAR;
day_integer_evaluator:
	DAY( arg  ) | DAY( arg  ) | DAY( arg time ) | DAY( arg  ) | DAY( arg  ) | DAY( arg  ) | DAY( arg  ) | DAY( arg  ) | DAY( arg  ) | DAY( arg  );
agg_day_integer_evaluator:
	DAY( arg  ) | DAY( arg  );
dayname_char_evaluator:
	DAYNAME( arg  ) | DAYNAME( arg  ) | DAYNAME( arg time ) | DAYNAME( arg  ) | DAYNAME( arg  ) | DAYNAME( arg  ) | DAYNAME( arg  ) | DAYNAME( arg  ) | DAYNAME( arg  );
agg_dayname_char_evaluator:
	DAYNAME( arg  ) | DAYNAME( arg  );
dayofmonth_integer_evaluator:
	DAYOFMONTH( arg time ) | DAYOFMONTH( arg  ) | DAYOFMONTH( arg  ) | DAYOFMONTH( arg  ) | DAYOFMONTH( arg  ) | DAYOFMONTH( arg  ) | DAYOFMONTH( arg  ) | DAYOFMONTH( arg  );
agg_dayofmonth_integer_evaluator:
	DAYOFMONTH( arg  ) | DAYOFMONTH( arg  );
dayofweek_integer_evaluator:
	DAYOFWEEK( arg  ) | DAYOFWEEK( arg time ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  );
agg_dayofweek_integer_evaluator:
	DAYOFWEEK( arg  ) | DAYOFWEEK( arg  ) | DAYOFWEEK( arg  );
dayofyear_integer_evaluator:
	DAYOFYEAR( arg  ) | DAYOFYEAR( arg  ) | DAYOFYEAR( arg time ) | DAYOFYEAR( arg  ) | DAYOFYEAR( arg  ) | DAYOFYEAR( arg  ) | DAYOFYEAR( arg  ) | DAYOFYEAR( arg  ) | DAYOFYEAR( arg  );
agg_dayofyear_integer_evaluator:
	DAYOFYEAR( arg  ) | DAYOFYEAR( arg  );
extract_integer_evaluator:
	EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg time) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg ) | EXTRACT(extract_unit FROM  arg );
extract_unit:
	MICROSECOND | SECOND | MINUTE | HOUR | DAY | WEEK | MONTH | QUARTER | YEAR;
from_days_date_evaluator:
	FROM_DAYS( arg  ) | FROM_DAYS( arg  );
from_unixtime_datetime_evaluator:
	FROM_UNIXTIME( arg ) | FROM_UNIXTIME( arg ) | FROM_UNIXTIME( arg ) | FROM_UNIXTIME( arg );
agg_from_unixtime_char_evaluator:
	FROM_UNIXTIME( arg , from_unixtime_format) | FROM_UNIXTIME( arg , from_unixtime_format);
agg_from_unixtime_datetime_evaluator:
	FROM_UNIXTIME( arg ) | FROM_UNIXTIME( arg );
from_unixtime_char_evaluator:
	FROM_UNIXTIME( arg , from_unixtime_format) | FROM_UNIXTIME( arg , from_unixtime_format) | FROM_UNIXTIME( arg , from_unixtime_format) | FROM_UNIXTIME( arg , from_unixtime_format);
from_unixtime_format:
	'%Y-%m-%d %H:%i:%s' | '%Y %D %M %h:%i:%s %x';
get_format_char_evaluator:
	GET_FORMAT(get_format_date_or_time_type, get_format_format);
get_format_date_or_time_type:
	DATE | TIME | DATETIME | TIMESTAMP;
get_format_format:
	'EUR' | 'USA' | 'JIS' | 'ISO' | 'INTERNAL' | NULL;
hour_integer_evaluator:
	HOUR( arg  ) | HOUR( arg  ) | HOUR( arg  ) | HOUR( arg time ) | HOUR( arg  ) | HOUR( arg  ) | HOUR( arg  ) | HOUR( arg  ) | HOUR( arg  ) | HOUR( arg  ) | HOUR( arg  );
agg_hour_integer_evaluator:
	HOUR( arg  ) | HOUR( arg  );
last_day_date_evaluator:
	LAST_DAY( arg  ) | LAST_DAY( arg time ) | LAST_DAY( arg  ) | LAST_DAY( arg  );
agg_last_day_date_evaluator:
	LAST_DAY( arg  );
localtime_datetime_evaluator:
	LOCALTIME() | LOCALTIME(localtime_fsp);
localtime_fsp:
	0 | 1 | 2 | 3 | 4 | 5 | 6;
localtimestamp_datetime_evaluator:
	LOCALTIMESTAMP() | LOCALTIMESTAMP(localtimestamp_fsp);
localtimestamp_fsp:
	0 | 1 | 2 | 3 | 4 | 5 | 6;
makedate_date_evaluator:
	MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  );
agg_makedate_date_evaluator:
	MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  ) | MAKEDATE( arg  ,  arg  );
maketime_time_evaluator:
	MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  );
agg_maketime_time_evaluator:
	MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  ) | MAKETIME( arg  ,  arg  ,  arg  );
microsecond_integer_evaluator:
	MICROSECOND( arg  ) | MICROSECOND( arg  ) | MICROSECOND( arg  ) | MICROSECOND( arg  ) | MICROSECOND( arg  ) | MICROSECOND( arg  );
agg_microsecond_integer_evaluator:
	MICROSECOND( arg  ) | MICROSECOND( arg  ) | MICROSECOND( arg  );
minute_integer_evaluator:
	MINUTE( arg time ) | MINUTE( arg  ) | MINUTE( arg  ) | MINUTE( arg  ) | MINUTE( arg  ) | MINUTE( arg  ) | MINUTE( arg  ) | MINUTE( arg  );
agg_minute_integer_evaluator:
	MINUTE( arg  ) | MINUTE( arg  ) | MINUTE( arg  );
month_integer_evaluator:
	MONTH( arg time ) | MONTH( arg  ) | MONTH( arg  ) | MONTH( arg  ) | MONTH( arg  ) | MONTH( arg  ) | MONTH( arg  );
agg_month_integer_evaluator:
	MONTH( arg  ) | MONTH( arg  ) | MONTH( arg  );
monthname_char_evaluator:
	MONTHNAME( arg  ) | MONTHNAME( arg  ) | MONTHNAME( arg time ) | MONTHNAME( arg  ) | MONTHNAME( arg  ) | MONTHNAME( arg  ) | MONTHNAME( arg  ) | MONTHNAME( arg  ) | MONTHNAME( arg  ) | MONTHNAME( arg  );
agg_monthname_char_evaluator:
	MONTHNAME( arg  ) | MONTHNAME( arg  );
now_datetime_evaluator:
	NOW() | NOW(now_fsp);
now_timestamp_evaluator:
	NOW();
now_fsp:
	6 | 3 | 4 | 1 | 0 | 2 | 5;
period_add_integer_evaluator:
	PERIOD_ADD(period_add_period, arg ) | PERIOD_ADD(period_add_period, arg );
period_add_period:
	202301 | 202302 | 202303 | 202304 | 202305 | 202306 | 202307 | 202308 | 202309 | 202310 | 202311 | 202312;
period_diff_integer_evaluator:
	PERIOD_DIFF(period_diff_period, arg ) | PERIOD_DIFF(period_diff_period, arg );
period_diff_period:
	202301 | 202302 | 202303 | 202304 | 202305 | 202306 | 202307 | 202308 | 202309 | 202310 | 202311 | 202312;
quarter_integer_evaluator:
	QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  );
agg_quarter_integer_evaluator:
	QUARTER( arg  ) | QUARTER( arg  ) | QUARTER( arg  );
second_integer_evaluator:
	SECOND( arg  ) | SECOND( arg time ) | SECOND( arg  ) | SECOND( arg  ) | SECOND( arg  ) | SECOND( arg  );
agg_second_integer_evaluator:
	SECOND( arg  ) | SECOND( arg  ) | SECOND( arg  );
sec_to_time_time_evaluator:
	SEC_TO_TIME( arg  ) | SEC_TO_TIME( arg  ) | SEC_TO_TIME( arg  );
agg_sec_to_time_time_evaluator:
	SEC_TO_TIME( arg  ) | SEC_TO_TIME( arg  );
str_to_date_date_evaluator:
	STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format );
str_to_date_datetime_evaluator:
	STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format );
agg_str_to_date_datetime_evaluator:
	STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format );
agg_str_to_date_date_evaluator:
	STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format );
str_to_date_time_evaluator:
	STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format );
agg_str_to_date_time_evaluator:
	STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format ) | STR_TO_DATE( arg  , str_to_date_format );
str_to_date_format:
	'%h:%i:%s';
agg_subdate_timestamp_evaluator:
	SUBDATE( arg  ,  arg  );
subtime_time_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
agg_subtime_text_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
agg_subtime_time_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
subtime_datetime_evaluator:
	SUBTIME( arg time ,  arg  ) | SUBTIME( arg time ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg time ,  arg  ) | SUBTIME( arg time ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
agg_subtime_datetime_evaluator:
	SUBTIME( arg time ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg time ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg time ,  arg  ) | SUBTIME( arg  ,  arg  );
subtime_timestamp_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
agg_subtime_timestamp_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
subtime_char_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
agg_subtime_char_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
subtime_text_evaluator:
	SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  ) | SUBTIME( arg  ,  arg  );
sysdate_datetime_evaluator:
	SYSDATE() | SYSDATE(sysdate_fsp);
sysdate_fsp:
	0 | 1 | 2 | 3 | 4 | 5 | 6;
time_char_evaluator:
	TIME( arg  ) | TIME( arg  ) | TIME( arg time ) | TIME( arg  ) | TIME( arg  ) | TIME( arg  ) | TIME( arg  );
agg_time_char_evaluator:
	TIME( arg  ) | TIME( arg  ) | TIME( arg  );
timediff_time_evaluator:
	TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg time ,  arg time ) | TIMEDIFF( arg time ,  arg  ) | TIMEDIFF( arg  ,  arg time ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  );
agg_timediff_time_evaluator:
	TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  ) | TIMEDIFF( arg  ,  arg  );
timestamp_datetime_evaluator:
	TIMESTAMP( arg  ) | TIMESTAMP( arg time ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg time ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg time ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ) | TIMESTAMP( arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  );
agg_timestamp_datetime_evaluator:
	TIMESTAMP( arg  ) | TIMESTAMP( arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg time ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg time ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg time ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  ) | TIMESTAMP( arg  ,  arg  );
timestampadd_datetime_evaluator:
	TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg time ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  );
agg_timestampadd_timestamp_evaluator:
	TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  );
agg_timestampadd_datetime_evaluator:
	TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg time ) | TIMESTAMPADD(timestampadd_unit ,  arg  ,  arg  );
timestampadd_unit:
	MINUTE | DAY | WEEK | MONTH | SQL_TSI_MINUTE | SQL_TSI_MONTH;
timestampdiff_integer_evaluator:
	TIMESTAMPDIFF(timestampdiff_unit, arg , arg ) | TIMESTAMPDIFF(timestampdiff_unit, arg , arg time) | TIMESTAMPDIFF(timestampdiff_unit, arg time, arg ) | TIMESTAMPDIFF(timestampdiff_unit, arg time, arg time);
timestampdiff_unit:
	SECOND | MINUTE | HOUR | DAY | MONTH | YEAR;
time_format_char_evaluator:
	TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg time , time_format_format ) | TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format );
agg_time_format_char_evaluator:
	TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format ) | TIME_FORMAT( arg  , time_format_format );
time_format_format:
	'%H' | '%k' | '%h' | '%I' | '%l' | '%i' | '%s' | '%f' | '%H:%i:%s';
time_to_sec_integer_evaluator:
	TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg time ) | TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  );
agg_time_to_sec_integer_evaluator:
	TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  ) | TIME_TO_SEC( arg  );
to_days_integer_evaluator:
	TO_DAYS( arg time ) | TO_DAYS( arg  ) | TO_DAYS( arg  ) | TO_DAYS( arg  ) | TO_DAYS( arg  ) | TO_DAYS( arg  ) | TO_DAYS( arg  ) | TO_DAYS( arg  );
agg_to_days_integer_evaluator:
	TO_DAYS( arg  ) | TO_DAYS( arg  ) | TO_DAYS( arg  ) | TO_DAYS( arg  );
to_seconds_integer_evaluator:
	TO_SECONDS( arg  ) | TO_SECONDS( arg time ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  );
agg_to_seconds_integer_evaluator:
	TO_SECONDS( arg  ) | TO_SECONDS( arg  ) | TO_SECONDS( arg  );
unix_timestamp_integer_evaluator:
	UNIX_TIMESTAMP( ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg time ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  );
agg_unix_timestamp_integer_evaluator:
	UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  );
unix_timestamp_double_evaluator:
	UNIX_TIMESTAMP( arg time ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  );
agg_unix_timestamp_double_evaluator:
	UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  ) | UNIX_TIMESTAMP( arg  );
utc_date_date_evaluator:
	UTC_DATE( );
utc_time_time_evaluator:
	UTC_TIME( ) | UTC_TIME(utc_time_fsp );
utc_time_char_evaluator:
	UTC_TIME( ) | UTC_TIME(utc_time_fsp );
utc_time_double_evaluator:
	UTC_TIME( ) | UTC_TIME(utc_time_fsp );
utc_time_fsp:
	0 | 1 | 2 | 3 | 4 | 5 | 6;
utc_timestamp_datetime_evaluator:
	UTC_TIMESTAMP( ) | UTC_TIMESTAMP(utc_timestamp_fsp );
utc_timestamp_double_evaluator:
	UTC_TIMESTAMP( );
utc_timestamp_fsp:
	0 | 1 | 3 | 4 | 5 | 6;
week_integer_evaluator:
	WEEK( arg  ) | WEEK( arg  ) | WEEK( arg  , week_mode ) | WEEK( arg  , week_mode ) | WEEK( arg  ) | WEEK( arg  ) | WEEK( arg  , week_mode ) | WEEK( arg  ) | WEEK( arg  ) | WEEK( arg  , week_mode ) | WEEK( arg  , week_mode ) | WEEK( arg  ) | WEEK( arg  , week_mode ) | WEEK( arg  ) | WEEK( arg  , week_mode ) | WEEK( arg  , week_mode ) | WEEK( arg  , week_mode ) | WEEK( arg time ) | WEEK( arg  ) | WEEK( arg time , week_mode ) | WEEK( arg  , week_mode ) | WEEK( arg  ) | WEEK( arg  );
agg_week_integer_evaluator:
	WEEK( arg  ) | WEEK( arg  , week_mode ) | WEEK( arg  ) | WEEK( arg  , week_mode ) | WEEK( arg  ) | WEEK( arg  , week_mode );
week_mode:
	1 | 2 | 3 | 4 | 5 | 6 | 7;
weekday_integer_evaluator:
	WEEKDAY( arg  ) | WEEKDAY( arg time ) | WEEKDAY( arg  ) | WEEKDAY( arg  ) | WEEKDAY( arg  ) | WEEKDAY( arg  ) | WEEKDAY( arg  ) | WEEKDAY( arg  );
agg_weekday_integer_evaluator:
	WEEKDAY( arg  ) | WEEKDAY( arg  );
weekofyear_integer_evaluator:
	WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg time ) | WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  );
agg_weekofyear_integer_evaluator:
	WEEKOFYEAR( arg  ) | WEEKOFYEAR( arg  );
year_integer_evaluator:
	YEAR( arg  ) | YEAR( arg  ) | YEAR( arg time ) | YEAR( arg  ) | YEAR( arg  ) | YEAR( arg  ) | YEAR( arg  ) | YEAR( arg  ) | YEAR( arg  ) | YEAR( arg  );
agg_year_integer_evaluator:
	YEAR( arg  ) | YEAR( arg  );
yearweek_integer_evaluator:
	YEARWEEK( arg  ) | YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  ) | YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  ) | YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg time ) | YEARWEEK( arg  ) | YEARWEEK( arg time , yearweek_mode ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  ) | YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode );
agg_yearweek_integer_evaluator:
	YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode ) | YEARWEEK( arg  ) | YEARWEEK( arg  , yearweek_mode );
yearweek_mode:
	0 | 1 | 2 | 3 | 4 | 5 | 6 | 7;
case_integer_evaluator:
	CASE WHEN  arg  THEN  arg  ELSE  arg  END | CASE WHEN  arg  THEN  arg  ELSE  arg  END;
case_char_evaluator:
	CASE WHEN  arg  THEN  arg  ELSE  arg  END;
case_double_evaluator:
	CASE WHEN  arg  THEN  arg  ELSE  arg  END;
case_date_evaluator:
	CASE WHEN  arg  THEN  arg  ELSE  arg  END;
if_integer_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
agg_if_double_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
if_char_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
agg_if_char_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
if_text_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
agg_if_text_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
agg_if_integer_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
if_datetime_evaluator:
	IF( arg  ,  arg time ,  arg time ) | IF( arg  ,  arg time ,  arg  ) | IF( arg  ,  arg  ,  arg time ) | IF( arg  ,  arg time ,  arg  );
agg_if_datetime_evaluator:
	IF( arg  ,  arg time ,  arg time ) | IF( arg  ,  arg time ,  arg  ) | IF( arg  ,  arg  ,  arg time ) | IF( arg  ,  arg  ,  arg  );
if_blob_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
agg_if_blob_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
if_double_evaluator:
	IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  ) | IF( arg  ,  arg  ,  arg  );
ifnull_integer_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
ifnull_blob_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
agg_ifnull_blob_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
ifnull_date_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
ifnull_datetime_evaluator:
	IFNULL( arg time ,  arg time ) | IFNULL( arg time ,  arg  ) | IFNULL( arg  ,  arg time ) | IFNULL( arg  ,  arg  );
ifnull_timestamp_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
agg_ifnull_integer_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
ifnull_time_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
agg_ifnull_time_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
ifnull_year_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
agg_ifnull_year_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
ifnull_double_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
agg_ifnull_double_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
ifnull_char_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
agg_ifnull_char_evaluator:
	IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  ) | IFNULL( arg  ,  arg  );
nullif_integer_evaluator:
	NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  );
nullif_double_evaluator:
	NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  );
nullif_datetime_evaluator:
	NULLIF( arg time ,  arg time ) | NULLIF( arg time ,  arg  ) | NULLIF( arg  ,  arg time );
nullif_date_evaluator:
	NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  );
nullif_char_evaluator:
	NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  );
nullif_boolean_evaluator:
	NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  ) | NULLIF( arg  ,  arg  );
charset_char_evaluator:
	CHARSET( arg  ) | CHARSET( arg  ) | CHARSET( arg  ) | CHARSET( arg  ) | CHARSET( arg  );
agg_charset_char_evaluator:
	CHARSET( arg  ) | CHARSET( arg  ) | CHARSET( arg  );
coercibility_integer_evaluator:
	COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg time ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  );
agg_coercibility_integer_evaluator:
	COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  ) | COERCIBILITY( arg  );
collation_char_evaluator:
	COLLATION( arg  ) | COLLATION( arg  ) | COLLATION( arg  ) | COLLATION( arg  );
agg_collation_char_evaluator:
	COLLATION( arg  ) | COLLATION( arg  );
connection_id_integer_evaluator:
	CONNECTION_ID( );
current_role_text_evaluator:
	CURRENT_ROLE();
current_user_text_evaluator:
	CURRENT_USER( );
database_char_evaluator:
	DATABASE( );
found_rows_integer_evaluator:
	FOUND_ROWS( );
icu_version_char_evaluator:
	ICU_VERSION( );
last_insert_id_integer_evaluator:
	LAST_INSERT_ID( ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  );
agg_last_insert_id_integer_evaluator:
	LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  ) | LAST_INSERT_ID( arg  );
roles_graphml_text_evaluator:
	ROLES_GRAPHML( );
row_count_integer_evaluator:
	ROW_COUNT( );
schema_char_evaluator:
	SCHEMA( );
session_user_char_evaluator:
	SESSION_USER( );
system_user_char_evaluator:
	SYSTEM_USER( );
user_char_evaluator:
	USER( );
version_text_evaluator:
	VERSION( );
not_boolean_evaluator:
	NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | NOT( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg time ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  );
agg_not_boolean_evaluator:
	!( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  ) | !( arg  );
or_boolean_evaluator:
	 arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg time OR  arg time |  arg time OR  arg  |  arg  OR  arg time |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg ;
agg_or_boolean_evaluator:
	 arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg ;
xor_integer_evaluator:
	 arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg time XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg ;
agg_xor_integer_evaluator:
	 arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg  |  arg  XOR  arg ;
abs_integer_evaluator:
	ABS( arg  ) | ABS( arg  );
agg_abs_boolean_evaluator:
	ABS( arg  );
agg_abs_integer_evaluator:
	ABS( arg  );
abs_double_evaluator:
	ABS( arg  ) | ABS( arg  );
agg_abs_double_evaluator:
	ABS( arg  );
abs_bit_evaluator:
	ABS( arg  );
agg_abs_bit_evaluator:
	ABS( arg  );
abs_boolean_evaluator:
	ABS( arg  ) | ABS( arg  );
acos_double_evaluator:
	ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  );
agg_acos_double_evaluator:
	ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  ) | ACOS( arg  );
asin_double_evaluator:
	ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  );
agg_asin_double_evaluator:
	ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  ) | ASIN( arg  );
atan_double_evaluator:
	ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  );
agg_atan_double_evaluator:
	ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  ) | ATAN( arg  ,  arg  );
atan2_double_evaluator:
	ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  );
agg_atan2_double_evaluator:
	ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  ) | ATAN2( arg  ,  arg  );
ceil_integer_evaluator:
	CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  );
ceil_double_evaluator:
	CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  );
agg_ceil_double_evaluator:
	CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  );
agg_ceil_integer_evaluator:
	CEIL( arg  ) | CEIL( arg  ) | CEIL( arg  );
agg_ceiling_integer_evaluator:
	CEILING( arg  );
conv_char_evaluator:
	CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base );
agg_conv_char_evaluator:
	CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base ) | CONV( arg  , conv_from_base , conv_to_base );
conv_from_base:
	-36 | -35 | -34 | -33 | -32 | -31 | -30 | -29 | -28 | -27 | -26 | -25 | -24 | -23 | -22 | -21 | -20 | -19 | -18 | -17 | -16 | -15 | -14 | -13 | -12 | -11 | -10 | -9 | -8 | -7 | -6 | -5 | -4 | -3 | -2 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 | 36;
conv_to_base:
	-36 | -35 | -34 | -33 | -32 | -31 | -30 | -29 | -28 | -27 | -26 | -25 | -24 | -23 | -22 | -21 | -20 | -19 | -18 | -17 | -16 | -15 | -14 | -13 | -12 | -11 | -10 | -9 | -8 | -7 | -6 | -5 | -4 | -3 | -2 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 | 36;
cos_double_evaluator:
	COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  );
agg_cos_double_evaluator:
	COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  ) | COS( arg  );
cot_double_evaluator:
	COT( arg  ) | COT( arg  ) | COT( arg  ) | COT( arg  );
crc32_integer_evaluator:
	CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg time );
agg_crc32_integer_evaluator:
	CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  ) | CRC32( arg  );
degrees_double_evaluator:
	DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  );
agg_degrees_double_evaluator:
	DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  ) | DEGREES( arg  );
exp_double_evaluator:
	EXP( arg  ) | EXP( arg  ) | EXP( arg  ) | EXP( arg  );
floor_integer_evaluator:
	FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  );
floor_double_evaluator:
	FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  );
agg_floor_double_evaluator:
	FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  );
agg_floor_integer_evaluator:
	FLOOR( arg  ) | FLOOR( arg  ) | FLOOR( arg  );
format_char_evaluator:
	FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d );
agg_format_char_evaluator:
	FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d ) | FORMAT( arg  , format_d );
format_d:
	15 | 13 | 8 | 23 | 1 | 21 | 28 | 10 | 0 | 24 | 7 | 17 | 22 | 20 | 19 | 6 | 12 | 3 | 11 | 16 | 27 | 30 | 29 | 14 | 2 | 9 | 18 | 26;
hex_char_evaluator:
	HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  );
agg_hex_char_evaluator:
	HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  ) | HEX( arg  );
ln_double_evaluator:
	LN( arg  ) | LN( arg  ) | LN( arg  ) | LN( arg  ) | LN( arg  ) | LN( arg  );
agg_ln_double_evaluator:
	LN( arg  ) | LN( arg  ) | LN( arg  ) | LN( arg  ) | LN( arg  ) | LN( arg  );
log_double_evaluator:
	LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ) | LOG( arg  );
agg_log_double_evaluator:
	LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ) | LOG( arg  ,  arg  ) | LOG(log_base ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  ) | LOG( arg  ,  arg  );
log_base:
	10;
agg_log10_double_evaluator:
	LOG10( arg  ) | LOG10( arg  ) | LOG10( arg  ) | LOG10( arg  ) | LOG10( arg  );
log2_double_evaluator:
	LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  );
agg_log2_double_evaluator:
	LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  ) | LOG2( arg  );
pi_double_evaluator:
	PI( );
pow_double_evaluator:
	POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  );
agg_pow_double_evaluator:
	POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  ) | POW( arg  ,  arg  );
agg_power_double_evaluator:
	POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  ) | POWER( arg  ,  arg  );
radians_double_evaluator:
	RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  );
agg_radians_double_evaluator:
	RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  ) | RADIANS( arg  );
rand_double_evaluator:
	RAND( ) | RAND( arg  );
agg_rand_double_evaluator:
	RAND( arg  );
round_integer_evaluator:
	ROUND( arg  , round_decimals ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_decimals ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_decimals ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_decimals ) | ROUND( arg  ) | ROUND( arg  , round_decimals );
agg_round_integer_evaluator:
	ROUND( arg  , round_decimals ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_decimals ) | ROUND( arg  , round_decimals ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  , round_d );
round_double_evaluator:
	ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg time , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  , round_decimals ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg time ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  );
agg_round_double_evaluator:
	ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  ) | ROUND( arg  , round_decimals ) | ROUND( arg  ) | ROUND( arg  ) | ROUND( arg  , round_d ) | ROUND( arg  , round_d );
round_d:
	15 | -28 | 13 | 8 | 23 | -25 | -10 | -8 | 1 | 21 | 25 | -21 | -30 | -24 | -20 | -6 | -7 | -2 | 10 | 28 | -14 | -17 | 0 | NULL | 24 | 7 | -22 | -27 | 17 | 20 | 5 | -5 | 22 | 19 | 6 | 12 | -11 | 9 | -19 | -13 | 4 | 3 | -15 | 11 | -4 | 16 | -9 | 27 | -29 | -18 | 30 | -12 | 29 | -1 | 14 | -26 | -23 | 2 | 18 | 26 | -16;
round_decimals:
	-2 | -1 | 0 | 2 | 1;
sign_integer_evaluator:
	SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  );
agg_sign_integer_evaluator:
	SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  ) | SIGN( arg  );
sin_double_evaluator:
	SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  );
agg_sin_double_evaluator:
	SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  ) | SIN( arg  );
sqrt_double_evaluator:
	SQRT( arg  ) | SQRT( arg  ) | SQRT( arg  ) | SQRT( arg  ) | SQRT( arg  ) | SQRT( arg  ) | SQRT( arg  );
agg_sqrt_double_evaluator:
	SQRT( arg  ) | SQRT( arg  ) | SQRT( arg  ) | SQRT( arg  );
tan_double_evaluator:
	TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  );
agg_tan_double_evaluator:
	TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  ) | TAN( arg  );
truncate_double_evaluator:
	TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  );
agg_truncate_integer_evaluator:
	TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  );
agg_truncate_double_evaluator:
	TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  );
truncate_integer_evaluator:
	TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  ) | TRUNCATE( arg  ,  arg  );
any_value_bit_evaluator:
	ANY_VALUE( arg  ) | ANY_VALUE( arg  );
any_value_datetime_evaluator:
	ANY_VALUE( arg time ) | ANY_VALUE( arg  );
any_value_time_evaluator:
	ANY_VALUE( arg  ) | ANY_VALUE( arg  );
agg_any_value_time_evaluator:
	ANY_VALUE( arg  );
any_value_year_evaluator:
	ANY_VALUE( arg  ) | ANY_VALUE( arg  );
agg_any_value_year_evaluator:
	ANY_VALUE( arg  );
any_value_char_evaluator:
	ANY_VALUE( arg  ) | ANY_VALUE( arg  );
agg_any_value_bit_evaluator:
	ANY_VALUE( arg  );
agg_any_value_char_evaluator:
	ANY_VALUE( arg  );
any_value_text_evaluator:
	ANY_VALUE( arg  ) | ANY_VALUE( arg  );
agg_any_value_text_evaluator:
	ANY_VALUE( arg  );
any_value_blob_evaluator:
	ANY_VALUE( arg  ) | ANY_VALUE( arg  );
agg_any_value_blob_evaluator:
	ANY_VALUE( arg  );
any_value_integer_evaluator:
	ANY_VALUE( arg  );
agg_any_value_integer_evaluator:
	ANY_VALUE( arg  );
any_value_boolean_evaluator:
	ANY_VALUE( arg  ) | ANY_VALUE( arg  );
agg_any_value_boolean_evaluator:
	ANY_VALUE( arg  );
any_value_double_evaluator:
	ANY_VALUE( arg  );
agg_any_value_double_evaluator:
	ANY_VALUE( arg  );
bin_to_uuid_char_evaluator:
	BIN_TO_UUID(bin_to_uuid_blob_val );
bin_to_uuid_blob_val:
	UNHEX('123e4567e89b12d3a456426614174000') | UNHEX('abcd1234abcd5678abcd9876abcd1234') | UNHEX('9a0c8b2c56d0436b98f2ab7c18e700d2') | UNHEX('8d4b02400cbb45d5b378e59d5e179b3c') | UNHEX('fdd42358c06f429a90bcbdca19d84076') | UNHEX('dc3a16c7de954736b19d471c3e4d40df') | UNHEX('4a5b221e409b42378c0f8b16820c6d2b') | UNHEX('fe17d84723d64a3b93142bb05b5fdf10');
inet6_aton_blob_evaluator:
	INET6_ATON( arg  ) | INET6_ATON( arg  ) | INET6_ATON( arg  );
inet6_ntoa_char_evaluator:
	INET6_NTOA( arg  ) | INET6_NTOA( arg  );
agg_inet6_ntoa_char_evaluator:
	INET6_NTOA( arg  );
inet_aton_integer_evaluator:
	INET_ATON( arg  ) | INET_ATON( arg  ) | INET_ATON( arg  ) | INET_ATON( arg  ) | INET_ATON( arg  );
agg_inet_aton_integer_evaluator:
	INET_ATON( arg  ) | INET_ATON( arg  ) | INET_ATON( arg  );
inet_ntoa_char_evaluator:
	INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  );
agg_inet_ntoa_char_evaluator:
	INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  ) | INET_NTOA( arg  );
is_ipv4_boolean_evaluator:
	IS_IPV4( arg  ) | IS_IPV4( arg  ) | IS_IPV4( arg  ) | IS_IPV4( arg  ) | IS_IPV4( arg  );
agg_is_ipv4_boolean_evaluator:
	IS_IPV4( arg  ) | IS_IPV4( arg  ) | IS_IPV4( arg  );
is_ipv4_compat_integer_evaluator:
	IS_IPV4_COMPAT( arg  );
agg_is_ipv4_compat_integer_evaluator:
	IS_IPV4_COMPAT( arg  );
is_ipv4_mapped_integer_evaluator:
	IS_IPV4_MAPPED( arg  ) | IS_IPV4_MAPPED( arg  ) | IS_IPV4_MAPPED( arg  ) | IS_IPV4_MAPPED( arg  );
agg_is_ipv4_mapped_integer_evaluator:
	IS_IPV4_MAPPED( arg  ) | IS_IPV4_MAPPED( arg  );
is_ipv6_integer_evaluator:
	IS_IPV6( arg  ) | IS_IPV6( arg  ) | IS_IPV6( arg  ) | IS_IPV6( arg  );
agg_is_ipv6_integer_evaluator:
	IS_IPV6( arg  ) | IS_IPV6( arg  ) | IS_IPV6( arg  );
is_uuid_integer_evaluator:
	IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg time ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  );
agg_is_uuid_integer_evaluator:
	IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  ) | IS_UUID( arg  );
name_const_integer_evaluator:
	NAME_CONST(name_const_name , name_const_value );
name_const_double_evaluator:
	NAME_CONST(name_const_name , name_const_value );
name_const_char_evaluator:
	NAME_CONST(name_const_name , name_const_value );
name_const_text_evaluator:
	NAME_CONST(name_const_name , name_const_value );
name_const_boolean_evaluator:
	NAME_CONST(name_const_name , name_const_value );
name_const_name:
	'myname' | 'col1' | 'x';
name_const_value:
	14 | 3.14 | 'text';
uuid_text_evaluator:
	UUID( );
uuid_short_integer_evaluator:
	UUID_SHORT( );
uuid_to_bin_blob_evaluator:
	UUID_TO_BIN(uuid_to_bin_uuid_val ) | UUID_TO_BIN(uuid_to_bin_uuid_val , uuid_to_bin_swap_flag );
uuid_to_bin_uuid_val:
	'550e8400-e29b-41d4-a716-446655440000' | '123e4567-e89b-12d3-a456-426614174000' | '9a1bfc8d-3d4f-4f77-bb77-9a36db22c8c1' | 'c1a9c8d2-72a7-4a2c-9371-b13c684b7a49' | 'db6b428d-dfdf-4e0a-9c75-b9a3b3815e6a' | '0a45acb9-4730-4773-a2d7-f826b1f25b13' | 'f18b0710-e0e6-4697-93da-d57f6a30a50d' | '885f778f-f561-4828-bff4-74d2b9c15f25' | '23123dbf-b8e0-44a7-b7c7-1a3b7634cb8d';
uuid_to_bin_swap_flag:
	0 | 1;
notregexp_boolean_evaluator:
	 arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg time NOT REGEXP  arg  |  arg time NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg ;
agg_notregexp_boolean_evaluator:
	 arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg time NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg time NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg time NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg  |  arg  NOT REGEXP  arg ;
regexp_integer_evaluator:
	 arg  REGEXP  arg  |  arg  REGEXP  arg  |  arg  REGEXP  arg  |  arg  REGEXP  arg  |  arg  REGEXP  arg  |  arg  REGEXP  arg  |  arg  REGEXP  arg  |  arg  REGEXP  arg ;
regexp_instr_integer_evaluator:
	REGEXP_INSTR( arg  ,  arg  ) | REGEXP_INSTR( arg  ,  arg  ) | REGEXP_INSTR( arg  ,  arg  ) | REGEXP_INSTR( arg  ,  arg  ) | REGEXP_INSTR( arg  ,  arg  , regexp_instr_pos ) | REGEXP_INSTR( arg  ,  arg  , regexp_instr_pos ) | REGEXP_INSTR( arg  ,  arg  , regexp_instr_pos );
regexp_instr_pos:
	1 | 2 | 3;
regexp_instr_occurrence:
	1 | 2 | 3;
regexp_instr_return_option:
	0 | 1;
regexp_instr_match_type:
	'c' | 'i' | 'm' | 'n' | 'u' | 'x';
regexp_like_integer_evaluator:
	REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg , regexp_like_match_type) | REGEXP_LIKE( arg ,  arg , regexp_like_match_type) | REGEXP_LIKE( arg ,  arg , regexp_like_match_type) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg ) | REGEXP_LIKE( arg ,  arg );
regexp_like_match_type:
	'' | 'c' | 'i' | 'm' | 'n' | 'u' | 'ci' | 'im' | 'cimnu';
like_boolean_evaluator:
	 arg  LIKE like_const |  arg  LIKE like_const |  arg  LIKE like_const |  arg  LIKE like_const;
like_const:
	'%' | '_';
not_like_boolean_evaluator:
	 arg  NOT LIKE like_const |  arg  NOT LIKE like_const |  arg  NOT LIKE like_const |  arg  NOT LIKE like_const;
strcmp_integer_evaluator:
	STRCMP( arg  ,  arg  ) | STRCMP( arg  ,  arg  ) | STRCMP( arg  ,  arg  ) | STRCMP( arg  ,  arg  ) | STRCMP( arg  ,  arg  ) | STRCMP( arg  ,  arg  ) | STRCMP( arg  ,  arg  );
