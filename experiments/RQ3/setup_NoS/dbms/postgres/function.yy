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
	bit_count_bytea_integer_evaluator | bit_length_bytea_integer_evaluator | btrim_bytea_evaluator | bytea_concat_bytea_evaluator | convert_from_func_evaluator | convert_func_evaluator | convert_to_bytea_evaluator | convert_to_func_evaluator | decode_bytea_evaluator | encode_bytea_text_evaluator | get_bit_bytea_integer_evaluator | get_byte_integer_evaluator | length_bytea_integer_evaluator | length_bytea_encoding_evaluator | ltrim_bytea_bytea_evaluator | md5_bytea_text_evaluator | octet_length_bytea_integer_evaluator | position_bytea_evaluator | reverse_bytea_evaluator | rtrim_bytea_bytea_evaluator | set_bit_bytea_evaluator | set_byte_evaluator | sha224_bytea_evaluator | sha256_bytea_evaluator | sha384_bytea_evaluator | sha512_bytea_evaluator | substring_bytea_evaluator | substring_bytea_evaluator_2 | substring_bytea_evaluator_3 | substr_bytea_evaluator | substr_bytea_evaluator_2 | substr_bytea_evaluator | bit_and_bit_bit_evaluator | bit_concat_bit_evaluator | bit_count_integer_evaluator | bit_length_bit_integer_evaluator | bit_lshift_bit_evaluator | bit_not_bit_evaluator | bit_or_bit_bit_evaluator | bit_rshift_bit_evaluator | bit_xor_bit_bit_evaluator | get_bit_integer_evaluator | length_bit_integer_evaluator | octet_length_bit_integer_evaluator | overlay_bit_bit_evaluator | set_bit_bit_bit_evaluator | substring_bit_bit_evaluator | between_boolean_evaluator | between_symmetric_boolean_evaluator | isdistinctfrom_boolean_evaluator | isnotdistinctfrom_boolean_evaluator | isnotnull_boolean_evaluator | isnull_boolean_evaluator | is_false_boolean_evaluator | is_not_false_boolean_evaluator | is_not_true_boolean_evaluator | is_not_unknown_boolean_evaluator | is_null_boolean_evaluator | is_true_boolean_evaluator | is_unknown_boolean_evaluator | notnull_boolean_evaluator | not_between_boolean_evaluator | not_between_symmetric_evaluator | num_nonnulls_integer_evaluator | num_nulls_integer_evaluator | greatest_integer_evaluator | greatest_bit_evaluator | greatest_boolean_evaluator | greatest_bytea_evaluator | greatest_character_evaluator | greatest_date_evaluator | greatest_double_evaluator | greatest_time_evaluator | greatest_timestamp_evaluator | greatest_cidr_evaluator | greatest_inet_evaluator | greatest_macaddr_evaluator | greatest_macaddr8_evaluator | greatest_uuid_evaluator | least_integer_evaluator | least_bit_evaluator | least_boolean_evaluator | least_bytea_evaluator | least_character_evaluator | least_date_evaluator | least_double_evaluator | least_time_evaluator | least_timestamp_evaluator | least_cidr_evaluator | least_inet_evaluator | least_macaddr_evaluator | least_macaddr8_evaluator | least_uuid_evaluator | nullif_integer_evaluator | nullif_bit_evaluator | nullif_macaddr8_evaluator | nullif_uuid_evaluator | nullif_boolean_evaluator | nullif_bytea_evaluator | nullif_character_evaluator | nullif_date_evaluator | nullif_double_evaluator | nullif_time_evaluator | nullif_timestamp_evaluator | nullif_cidr_evaluator | nullif_inet_evaluator | nullif_macaddr_evaluator | to_char_text_evaluator | to_char_interval_text_evaluator | to_char_timestamp_text_evaluator | to_date_date_evaluator | to_number_double_evaluator | to_number_func_evaluator | to_timestamp_text_timestamp_evaluator | clock_timestamp_timestamp_evaluator | current_time_time_evaluator | current_timestamp_func_timestamp_evaluator | current_timestamp_with_precision_timestamp_evaluator | date_add_timestamp_evaluator | date_add_integer_date_evaluator | date_add_interval_timestamp_evaluator | date_add_time_timestamp_evaluator | date_bin_timestamp_evaluator | date_part_interval_double_evaluator | date_part_timestamp_double_evaluator | date_subtract_timestamp_evaluator | date_sub_date_integer_evaluator | date_sub_integer_date_evaluator | date_sub_interval_timestamp_evaluator | date_trunc_timestamp_evaluator | date_trunc_timestamp_timestamp_evaluator | date_trunc_timestamptz_timestamp_evaluator | extract_interval_double_evaluator | extract_timestamp_double_evaluator | isfinite_date_boolean_evaluator | isfinite_interval_boolean_evaluator | isfinite_timestamp_boolean_evaluator | localtimestamp_timestamp_evaluator | localtimestamp_func_timestamp_evaluator | localtime_func_time_evaluator | localtime_with_precision_time_evaluator | make_date_date_evaluator | make_time_time_evaluator | make_timestamp_timestamp_evaluator | make_timestamptz_timestamp_evaluator | now_timestamp_evaluator | timestamp_add_interval_timestamp_evaluator | timestamp_sub_interval_timestamp_evaluator | time_add_interval_time_evaluator | time_sub_interval_time_evaluator | to_timestamp_timestamp_evaluator | transaction_timestamp_timestamp_evaluator | broadcast_inet_evaluator | family_inet_evaluator | statement_timestamp_evaluator | timeofday_evaluator | and_boolean_evaluator | not_boolean_evaluator | not_boolean_evaluator | or_boolean_evaluator | abs_integer_evaluator | abs_double_evaluator | acos_double_evaluator | acosd_double_evaluator | acosh_double_evaluator | asin_double_evaluator | asind_double_evaluator | asinh_double_evaluator | at_integer_evaluator | at_double_evaluator | atan_double_evaluator | atan2_double_evaluator | atan2d_double_evaluator | atand_double_evaluator | atanh_double_evaluator | atan_double_evaluator | bitwise_and_integral_integer_evaluator | bitwise_lshift_integral_evaluator | bitwise_not_integral_integer_evaluator | bitwise_or_integral_integer_evaluator | cbrt_double_evaluator | cbrt_double_evaluator | ceil_double_evaluator | ceiling_double_evaluator | ceil_numeric_double_evaluator | cosd_double_evaluator | cosh_double_evaluator | cos_double_evaluator | cot_double_evaluator | cotd_double_evaluator | cube_root_double_evaluator | degrees_double_evaluator | degrees_double_evaluator | div_numeric_double_evaluator | div_numeric_integer_evaluator | erf_double_evaluator | erfc_double_evaluator | exp_double_evaluator | factorial_double_evaluator | floor_double_evaluator | gamma_double_evaluator | gcd_integer_evaluator | hash_integer_evaluator | integral_lshift_integer_evaluator | lcm_integer_evaluator | lgamma_double_evaluator | ln_double_evaluator | log10_double_evaluator | log_numeric_evaluator | log_two_args_double_evaluator | min_scale_integer_evaluator | mod_integer_integer_evaluator | mod_numeric_op_integer_evaluator | mul_integer_evaluator | mul_double_evaluator | ordiv_double_evaluator | pi_double_evaluator | pow_double_evaluator | power_double_evaluator | radians_double_evaluator | random_double_evaluator | random_normal_double_evaluator | random_range_integer_evaluator | round_double_integer_evaluator | round_with_scale_double_evaluator | scale_integer_evaluator | sign_double_integer_evaluator | agg_sign_double_integer_evaluator | sin_double_evaluator | sind_double_evaluator | sinh_double_evaluator | sqrt_double_evaluator | sub_numeric_integer_evaluator | tan_double_evaluator | tand_double_evaluator | tanh_double_evaluator | trim_scale_evaluator | trunc_double_integer_evaluator | trunc_with_scale_double_evaluator | unary_plus_double_evaluator | unary_plus_integer_evaluator | width_bucket_array_integer_evaluator | width_bucket_func_evaluator | width_bucket_numeric_integer_evaluator | abbrev_cidr_text_evaluator | abbrev_inet_text_evaluator | bigint_add_inet_evaluator | host_text_evaluator | hostmask_inet_evaluator | inet_add_bigint_inet_evaluator | inet_bit_and_evaluator | inet_bit_not_evaluator | inet_bit_or_evaluator | inet_contained_by_boolean_evaluator | inet_contained_by_eq_boolean_evaluator | inet_contains_boolean_evaluator | inet_contains_eq_boolean_evaluator | inet_merge_cidr_evaluator | inet_plus_bigint_inet_evaluator | inet_same_family_boolean_evaluator | inet_strictly_contains_boolean_evaluator | inet_sub_bigint_evaluator | inet_sub_inet_integer_evaluator | macaddr8_set7bit_evaluator | masklen_integer_evaluator | netmask_inet_evaluator | network_cidr_evaluator | set_masklen_cidr_inet_evaluator | set_masklen_inet_inet_evaluator | text_text_evaluator | trunc_macaddr_evaluator | trunc_macaddr8_evaluator | regex_match_evaluator | regex_match_i_evaluator | regex_not_match_evaluator | regex_not_match_i_evaluator | ascii_integer_evaluator | ascii_text_integer_evaluator | bit_length_text_integer_evaluator | btrim_text_evaluator | casefold_text_evaluator | character_length_integer_evaluator | char_length_integer_evaluator | chr_text_evaluator | concat_text_evaluator | concat_ws_text_evaluator | convert_from_text_evaluator | format_text_evaluator | initcap_text_evaluator | left_text_evaluator | length_text_integer_evaluator | agg_length_text_integer_evaluator | lower_text_evaluator | agg_lower_text_evaluator | lpad_text_evaluator | ltrim_text_evaluator | md5_text_evaluator | normalize_text_evaluator | octet_length_integer_evaluator | octet_length_text_integer_evaluator | oror_text_evaluator | overlay_text_evaluator | pg_client_encoding_text_evaluator | position_integer_evaluator | position_text_integer_evaluator | quote_ident_text_evaluator | quote_literal_text_evaluator | quote_literal_text_evaluator | quote_nullable_text_evaluator | quote_nullable_text_evaluator | regexp_count_evaluator | regexp_instr_evaluator | regexp_like_evaluator | regexp_replace_advanced_evaluator | regexp_replace_text_evaluator | regexp_substr_evaluator | repeat_text_evaluator | replace_text_evaluator | reverse_text_evaluator | reverse_text_func_evaluator | right_text_evaluator | rpad_text_evaluator | rtrim_text_evaluator | left_text_evaluator | starts_with_boolean_evaluator | starts_with_op_boolean_evaluator | strpos_text_evaluator | substr_text_evaluator | substring_regex_evaluator | substring_similar_evaluator | substring_text_from_evaluator | text_concat_evaluator | text_normalized_evaluator | to_bin_text_evaluator | to_hex_text_evaluator | to_oct_text_evaluator | translate_text_evaluator | translate_text_evaluator | trim_from_evaluator | trim_text_evaluator | unicode_assigned_evaluator | unistr_text_evaluator | upper_text_evaluator | agg_upper_text_evaluator | gen_random_uuid_uuid_evaluator | uuidv7_uuid_evaluator | uuid_extract_timestamp_timestamp_evaluator | uuid_extract_version_integer_evaluator;
agg_func:
	any_value_integer_evaluator | any_value_bytea_evaluator | any_value_boolean_evaluator | any_value_date_evaluator | any_value_double_evaluator | any_value_text_evaluator | any_value_time_evaluator | any_value_timestamp_evaluator | any_value_bit_evaluator | avg_double_evaluator | bit_and_integer_evaluator | bit_and_bit_evaluator | bit_or_integer_evaluator | bit_or_bit_evaluator | bit_xor_integer_evaluator | bit_xor_bit_evaluator | bool_and_boolean_evaluator | bool_or_boolean_evaluator | corr_double_evaluator | count_integer_evaluator | covar_pop_double_evaluator | covar_samp_double_evaluator | every_boolean_evaluator | max_integer_evaluator | max_date_evaluator | max_time_evaluator | max_timestamp_evaluator | max_inet_evaluator | max_double_evaluator | max_character_evaluator | min_integer_evaluator | min_date_evaluator | min_time_evaluator | min_timestamp_evaluator | min_inet_evaluator | min_double_evaluator | min_character_evaluator | regr_avgx_double_evaluator | regr_avgy_double_evaluator | regr_count_integer_evaluator | regr_intercept_double_evaluator | regr_r2_double_evaluator | regr_slope_double_evaluator | regr_sxx_double_evaluator | regr_sxy_double_evaluator | regr_syy_double_evaluator | stddev_double_evaluator | stddev_pop_double_evaluator | stddev_samp_double_evaluator | sum_integer_evaluator | sum_double_evaluator | variance_double_evaluator | var_pop_double_evaluator | var_samp_double_evaluator;

any_value_integer_evaluator:
	any_value(( arg ) ) | any_value(( arg ) );
any_value_bytea_evaluator:
	any_value(( arg ) ) | any_value(( arg ) );
any_value_boolean_evaluator:
	any_value(( arg ) ) | any_value(( arg ) );
any_value_date_evaluator:
	any_value(( arg ) ) | any_value(( arg ) );
any_value_double_evaluator:
	any_value(( arg )  precision) | any_value(( arg )  precision);
any_value_text_evaluator:
	any_value(( arg ) ) | any_value(( arg ) );
any_value_time_evaluator:
	any_value(( arg ) ) | any_value(( arg ) );
any_value_timestamp_evaluator:
	any_value(( arg stamp) stamp) | any_value(( arg ) stamp);
any_value_bit_evaluator:
	any_value(( arg ) ) | any_value(( arg ) );
avg_double_evaluator:
	avg( arg ) | avg( arg ) | avg( arg ) | avg( arg );
bit_and_integer_evaluator:
	bit_and( arg ) | bit_and( arg );
bit_and_bit_evaluator:
	bit_and( arg ) | bit_and( arg );
bit_or_integer_evaluator:
	bit_or( arg ) | bit_or( arg );
bit_or_bit_evaluator:
	bit_or( arg ) | bit_or( arg );
bit_xor_integer_evaluator:
	bit_xor( arg ) | bit_xor( arg );
bit_xor_bit_evaluator:
	bit_xor( arg ) | bit_xor( arg );
bool_and_boolean_evaluator:
	bool_and( arg ) | bool_and( arg );
bool_or_boolean_evaluator:
	bool_or( arg ) | bool_or( arg );
corr_double_evaluator:
	corr( arg  ,  arg ) | corr( arg  ,  arg ) | corr( arg  ,  arg ) | corr( arg  ,  arg );
count_integer_evaluator:
	count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg 8) | count( arg ) | count( arg ) | count( arg stamp) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg ) | count( arg );
covar_pop_double_evaluator:
	covar_pop( arg  ,  arg ) | covar_pop( arg  ,  arg ) | covar_pop( arg  ,  arg ) | covar_pop( arg  ,  arg );
covar_samp_double_evaluator:
	covar_samp( arg  ,  arg ) | covar_samp( arg  ,  arg ) | covar_samp( arg  ,  arg ) | covar_samp( arg  ,  arg );
every_boolean_evaluator:
	every( arg ) | every( arg );
max_integer_evaluator:
	max( arg ) | max( arg );
max_date_evaluator:
	max( arg ) | max( arg );
max_time_evaluator:
	max( arg ) | max( arg );
max_timestamp_evaluator:
	max( arg ) | max( arg stamp);
max_inet_evaluator:
	max( arg ) | max( arg );
max_double_evaluator:
	max( arg ) | max( arg );
max_character_evaluator:
	max( arg ) | max( arg );
min_integer_evaluator:
	min( arg ) | min( arg );
min_date_evaluator:
	min( arg ) | min( arg );
min_time_evaluator:
	min( arg ) | min( arg );
min_timestamp_evaluator:
	min( arg stamp) | min( arg );
min_inet_evaluator:
	min( arg ) | min( arg );
min_double_evaluator:
	min( arg ) | min( arg );
min_character_evaluator:
	min( arg ) | min( arg );
regr_avgx_double_evaluator:
	regr_avgx( arg  ,  arg ) | regr_avgx( arg  ,  arg ) | regr_avgx( arg  ,  arg ) | regr_avgx( arg  ,  arg );
regr_avgy_double_evaluator:
	regr_avgy( arg  ,  arg ) | regr_avgy( arg  ,  arg ) | regr_avgy( arg  ,  arg ) | regr_avgy( arg  ,  arg );
regr_count_integer_evaluator:
	regr_count( arg  ,  arg ) | regr_count( arg  ,  arg ) | regr_count( arg  ,  arg ) | regr_count( arg  ,  arg );
regr_intercept_double_evaluator:
	regr_intercept( arg  ,  arg ) | regr_intercept( arg  ,  arg ) | regr_intercept( arg  ,  arg ) | regr_intercept( arg  ,  arg );
regr_r2_double_evaluator:
	regr_r2( arg  ,  arg ) | regr_r2( arg  ,  arg ) | regr_r2( arg  ,  arg ) | regr_r2( arg  ,  arg );
regr_slope_double_evaluator:
	regr_slope( arg  ,  arg ) | regr_slope( arg  ,  arg ) | regr_slope( arg  ,  arg ) | regr_slope( arg  ,  arg );
regr_sxx_double_evaluator:
	regr_sxx( arg  ,  arg ) | regr_sxx( arg  ,  arg ) | regr_sxx( arg  ,  arg ) | regr_sxx( arg  ,  arg );
regr_sxy_double_evaluator:
	regr_sxy( arg  ,  arg ) | regr_sxy( arg  ,  arg ) | regr_sxy( arg  ,  arg ) | regr_sxy( arg  ,  arg );
regr_syy_double_evaluator:
	regr_syy( arg  ,  arg ) | regr_syy( arg  ,  arg ) | regr_syy( arg  ,  arg ) | regr_syy( arg  ,  arg );
stddev_double_evaluator:
	stddev( arg ) | stddev( arg );
stddev_pop_double_evaluator:
	stddev_pop( arg ) | stddev_pop( arg );
stddev_samp_double_evaluator:
	stddev_samp( arg ) | stddev_samp( arg );
sum_integer_evaluator:
	sum( arg ) | sum( arg );
sum_double_evaluator:
	sum( arg ) | sum( arg );
variance_double_evaluator:
	variance( arg ) | variance( arg );
var_pop_double_evaluator:
	var_pop( arg ) | var_pop( arg ) | var_pop( arg ) | var_pop( arg );
var_samp_double_evaluator:
	var_samp( arg ) | var_samp( arg );
bit_count_bytea_integer_evaluator:
	bit_count(  arg  ) | bit_count(  arg  );
bit_length_bytea_integer_evaluator:
	bit_length(  arg  ) | bit_length(  arg  );
btrim_bytea_evaluator:
	btrim(  arg  ,  arg  ) | btrim(  arg  ,  arg  ) | btrim(  arg  ,  arg  );
bytea_concat_bytea_evaluator:
	 arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg ;
convert_from_func_evaluator:
	convert_from( 'Hello'  , 'UTF8' ) | convert_from( 'Test'  , 'SQL_ASCII' );
convert_func_evaluator:
	convert( 'Hello'  , 'UTF8' , 'LATIN1' ) | convert( 'Test'  , 'SQL_ASCII' , 'UTF8' );
convert_to_bytea_evaluator:
	convert_to('hello' , 'UTF8');
convert_to_func_evaluator:
	convert_to( 'Hello World' , 'UTF8' ) | convert_to( 'Test' , 'LATIN1' );
decode_bytea_evaluator:
	decode('SGVsbG8=', 'base64');
encode_bytea_text_evaluator:
	encode(  arg  ,'base64' ) | encode(  arg  ,'hex' ) | encode(  arg  ,'escape' );
encode_format:
	base64 | hex | escape;
get_bit_bytea_integer_evaluator:
	get_bit( '\x01'  , 0 );
get_byte_integer_evaluator:
	get_byte(E'\\xDEADBEEF' , 1);
length_bytea_integer_evaluator:
	length(  arg  ) | length(  arg  );
length_bytea_encoding_evaluator:
	length( E'\\x48656C6C6F'  , 'UTF8' ) | length( E'\\x54657374'  , 'SQL_ASCII' );
ltrim_bytea_bytea_evaluator:
	ltrim(  arg  ,  arg  ) | ltrim(  arg  ,  arg  ) | ltrim(  arg  ,  arg  );
md5_bytea_text_evaluator:
	md5(  arg  ) | md5(  arg  );
octet_length_bytea_integer_evaluator:
	octet_length(  arg  ) | octet_length(  arg  );
position_bytea_evaluator:
	position(  arg   IN   arg  );
reverse_bytea_evaluator:
	reverse(  arg  );
rtrim_bytea_bytea_evaluator:
	rtrim(  arg  ,  arg  ) | rtrim(  arg  ,  arg  );
set_bit_bytea_evaluator:
	set_bit( E'\\xDEADBEEF'  , 3 , 0 ) | set_bit( E'\\x12345678'  , 0 , 1 );
set_byte_evaluator:
	set_byte( E'\\x12345678' , 2 , 65 ) | set_byte( E'\\xDEADBEEF' , 1 , 255 );
sha224_bytea_evaluator:
	sha224( 'hello'  );
sha256_bytea_evaluator:
	sha256(  arg  );
sha384_bytea_evaluator:
	sha384(  arg  );
sha512_bytea_evaluator:
	sha512( 'hello'  );
substring_bytea_evaluator:
	substring(  arg   FROM 1 );
substring_bytea_evaluator_2:
	substring(  arg   FOR 5 );
substring_bytea_evaluator_3:
	substring(  arg   FROM 1 FOR 5 );
substr_bytea_evaluator:
	substr(  arg  , 1 ) | substr( E'\\xDEADBEEF'  , 2 , 2 ) | substr( E'\\x12345678'  , 1 , 3 ) | substr( E'\\xABCDEF'  , 2 );
substr_bytea_evaluator_2:
	substr(  arg  , 1 , 5 );
bit_and_bit_bit_evaluator:
	B'1010' & B'1010';
bit_concat_bit_evaluator:
	 arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg ;
bit_count_integer_evaluator:
	bit_count( arg );
bit_length_bit_integer_evaluator:
	bit_length(  arg  );
bit_lshift_bit_evaluator:
	B'1011' << 2;
bit_not_bit_evaluator:
	~  arg  | ~  arg ;
bit_or_bit_bit_evaluator:
	 arg  |  arg  |  arg  |  arg ;
bit_rshift_bit_evaluator:
	 arg  >> 1;
bit_xor_bit_bit_evaluator:
	 arg  #  arg  |  arg  #  arg  |  arg  #  arg  |  arg  #  arg ;
get_bit_integer_evaluator:
	get_bit(B'10101010', 3);
length_bit_integer_evaluator:
	length(  arg  ) | length(  arg  );
octet_length_bit_integer_evaluator:
	octet_length(  arg  );
overlay_bit_bit_evaluator:
	overlay( B'101010'  placing  B'11'  from  3 );
set_bit_bit_bit_evaluator:
	set_bit(  arg  , 1 , 1);
substring_bit_bit_evaluator:
	substring(  arg   from  2  for  3 );
between_boolean_evaluator:
	 arg  BETWEEN  arg  AND  arg ;
between_symmetric_boolean_evaluator:
	 arg  BETWEEN SYMMETRIC  arg  AND  arg ;
isdistinctfrom_boolean_evaluator:
	 arg  IS DISTINCT FROM  arg stamp |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg stamp |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg stamp IS DISTINCT FROM  arg stamp |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg stamp IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg 8 IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg 8 |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg stamp IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg 8 IS DISTINCT FROM  arg 8 |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg  |  arg  IS DISTINCT FROM  arg ;
isnotdistinctfrom_boolean_evaluator:
	 arg stamp IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg stamp IS NOT DISTINCT FROM  arg stamp |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg 8 |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg stamp IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg stamp |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg 8 IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg stamp |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg  |  arg  IS NOT DISTINCT FROM  arg ;
isnotnull_boolean_evaluator:
	 arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL |  arg  IS NOT NULL;
isnull_boolean_evaluator:
	 arg  ISNULL |  arg  ISNULL |  arg  ISNULL |  arg  ISNULL;
is_false_boolean_evaluator:
	 arg  IS FALSE;
is_not_false_boolean_evaluator:
	 arg  IS NOT FALSE;
is_not_true_boolean_evaluator:
	 arg  IS NOT TRUE;
is_not_unknown_boolean_evaluator:
	 arg  IS NOT UNKNOWN;
is_null_boolean_evaluator:
	 arg  IS NULL;
is_true_boolean_evaluator:
	 arg  IS TRUE;
is_unknown_boolean_evaluator:
	 arg  IS UNKNOWN;
notnull_boolean_evaluator:
	 arg  NOTNULL;
not_between_boolean_evaluator:
	 arg  NOT BETWEEN  arg  AND  arg ;
not_between_symmetric_evaluator:
	5 not between symmetric 8 and 2 | 10 not between symmetric 5 and 15 | 'b' not between symmetric 'a' and 'c';
num_nonnulls_integer_evaluator:
	num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg 8(,  arg 8)*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg stamp(,  arg stamp)*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*) | num_nonnulls( arg (,  arg )*);
num_nulls_integer_evaluator:
	num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg 8(,  arg 8)*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*) | num_nulls( arg (,  arg )*);
greatest_integer_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_bit_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_boolean_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_bytea_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_character_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_date_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_double_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_time_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_timestamp_evaluator:
	GREATEST( arg stamp ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg stamp ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg stamp(,  arg stamp)*) | GREATEST( arg  ,  arg stamp(,  arg stamp)*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg stamp ,  arg stamp(,  arg stamp)*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_cidr_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_inet_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_macaddr_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_macaddr8_evaluator:
	GREATEST( arg 8 ,  arg (,  arg )*) | GREATEST( arg  ,  arg 8(,  arg 8)*) | GREATEST( arg 8 ,  arg 8(,  arg 8)*) | GREATEST( arg  ,  arg (,  arg )*);
greatest_uuid_evaluator:
	GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*) | GREATEST( arg  ,  arg (,  arg )*);
least_integer_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_bit_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_boolean_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_bytea_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_character_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_date_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_double_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_time_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_timestamp_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg stamp(,  arg stamp)*) | LEAST( arg stamp ,  arg (,  arg )*) | LEAST( arg stamp ,  arg stamp(,  arg stamp)*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg stamp ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_cidr_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_inet_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_macaddr_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
least_macaddr8_evaluator:
	LEAST( arg 8 ,  arg (,  arg )*) | LEAST( arg  ,  arg 8(,  arg 8)*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg 8 ,  arg 8(,  arg 8)*);
least_uuid_evaluator:
	LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*) | LEAST( arg  ,  arg (,  arg )*);
nullif_integer_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_bit_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_macaddr8_evaluator:
	NULLIF( arg  ,  arg 8) | NULLIF( arg 8 ,  arg 8) | NULLIF( arg 8 ,  arg );
nullif_uuid_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_boolean_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_bytea_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_character_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_date_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_double_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_time_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_timestamp_evaluator:
	NULLIF( arg stamp ,  arg stamp) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg stamp) | NULLIF( arg  ,  arg ) | NULLIF( arg stamp ,  arg ) | NULLIF( arg stamp ,  arg );
nullif_cidr_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_inet_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
nullif_macaddr_evaluator:
	NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg ) | NULLIF( arg  ,  arg );
to_char_text_evaluator:
	to_char( arg  , '999D99S') | to_char( arg  , '999D99S') | to_char( arg  , '999D99S') | to_char( arg  , '999D9') | to_char( arg  , '999') | to_char( arg  , '999') | to_char( arg  , '999D99S') | to_char( arg  , '999D99S') | to_char( arg  , '999') | to_char( arg  , '999D99S') | to_char( arg  , '999') | to_char( arg  , '999') | to_char( arg  , '999D9') | to_char( arg  , '999D9') | to_char( arg  , '999D9') | to_char( arg  , '999D9');
to_char_interval_text_evaluator:
	to_char( '1 day'  , 'HH24:MI' );
to_char_timestamp_text_evaluator:
	to_char(  arg stamp , 'YYYY-MM-DD' );
to_date_date_evaluator:
	to_date( '2024-01-01' , 'YYYY-MM-DD' );
to_number_double_evaluator:
	to_number( '12345' , '99999' );
to_number_func_evaluator:
	to_number( '12,454.8-' , '99G999D9S' ) | to_number( '12345' , '99999' ) | to_number( '$100.50' , 'L999D99' );
to_timestamp_text_timestamp_evaluator:
	to_timestamp( '2024-01-01 12:00:00' , 'YYYY-MM-DD HH24:MI:SS' );
clock_timestamp_timestamp_evaluator:
	clock_timestamp();
current_time_time_evaluator:
	current_time(4) | current_time(3) | current_time(1) | current_time(2) | current_time(0) | current_time(6) | current_time(5);
current_timestamp_func_timestamp_evaluator:
	current_timestamp(0);
current_timestamp_with_precision_timestamp_evaluator:
	current_timestamp(3);
date_add_timestamp_evaluator:
	date_add( arg stamp , '1 day'  , 'America/New_York') | date_add( arg  , '1 day'  , 'UTC') | date_add( arg stamp , '2 hours'  , 'UTC') | date_add( arg  , '1 day'  , 'Europe/Warsaw') | date_add( arg  , '1 day'  , 'Europe/Warsaw') | date_add( arg  , '2 hours' ) | date_add( arg stamp , '2 hours'  , 'America/New_York') | date_add( arg stamp , '1 day'  , 'UTC') | date_add( arg  , '1 month'  , 'Europe/Warsaw') | date_add( arg  , '1 day' ) | date_add( arg  , '2 hours' ) | date_add( arg  , '2 hours'  , 'UTC') | date_add( arg stamp , '1 month'  , 'Europe/Warsaw') | date_add( arg stamp , '1 month'  , 'UTC') | date_add( arg  , '1 day' ) | date_add( arg stamp , '1 day' ) | date_add( arg  , '1 day'  , 'America/New_York') | date_add( arg  , '2 hours'  , 'Europe/Warsaw') | date_add( arg stamp , '2 hours' ) | date_add( arg stamp , '1 month' ) | date_add( arg  , '1 day'  , 'America/New_York') | date_add( arg  , '1 month' ) | date_add( arg  , '2 hours'  , 'America/New_York') | date_add( arg  , '1 month' ) | date_add( arg  , '2 hours'  , 'America/New_York') | date_add( arg  , '2 hours'  , 'Europe/Warsaw') | date_add( arg stamp , '1 day'  , 'Europe/Warsaw');
date_add_integer_date_evaluator:
	DATE '2024-01-01' + 7;
date_add_interval_timestamp_evaluator:
	 arg  + '1 day' ;
date_add_time_timestamp_evaluator:
	 arg  +  arg ;
date_bin_timestamp_evaluator:
	date_bin('1 day' ,  arg  ,  arg ) | date_bin('1 hour' ,  arg  ,  arg stamp) | date_bin('00:15:00' ,  arg  ,  arg stamp) | date_bin('00:15:00' ,  arg  ,  arg ) | date_bin('00:15:00' ,  arg stamp ,  arg ) | date_bin('15 minutes' ,  arg  ,  arg ) | date_bin('00:15:00' ,  arg  ,  arg ) | date_bin('1 day' ,  arg  ,  arg ) | date_bin('1 day' ,  arg  ,  arg ) | date_bin('1 day' ,  arg  ,  arg ) | date_bin('1 hour' ,  arg  ,  arg ) | date_bin('00:15:00' ,  arg stamp ,  arg ) | date_bin('1 day' ,  arg  ,  arg stamp) | date_bin('1 day' ,  arg stamp ,  arg ) | date_bin('1 hour' ,  arg stamp ,  arg stamp) | date_bin('00:15:00' ,  arg stamp ,  arg stamp) | date_bin('15 minutes' ,  arg stamp ,  arg stamp) | date_bin('1 hour' ,  arg  ,  arg stamp) | date_bin('00:15:00' ,  arg  ,  arg ) | date_bin('15 minutes' ,  arg  ,  arg stamp) | date_bin('1 hour' ,  arg stamp ,  arg ) | date_bin('15 minutes' ,  arg  ,  arg ) | date_bin('1 hour' ,  arg  ,  arg ) | date_bin('15 minutes' ,  arg  ,  arg stamp) | date_bin('15 minutes' ,  arg stamp ,  arg ) | date_bin('1 hour' ,  arg  ,  arg ) | date_bin('1 day' ,  arg  ,  arg stamp);
date_part_interval_double_evaluator:
	date_part('day' , '1 day' );
date_part_timestamp_double_evaluator:
	date_part('day' ,  arg stamp);
date_subtract_timestamp_evaluator:
	date_subtract( '2024-01-01 12:00:00' stamp with time zone , '1 day' );
date_sub_date_integer_evaluator:
	DATE '2024-01-15' - DATE '2024-01-01';
date_sub_integer_date_evaluator:
	DATE '2024-01-15' - 7;
date_sub_interval_timestamp_evaluator:
	 arg  - '1 day' ;
date_trunc_timestamp_evaluator:
	date_trunc('microsecond' ,  arg stamp) | date_trunc('hour' ,  arg ) | date_trunc('year' ,  arg stamp) | date_trunc('minute' ,  arg ) | date_trunc('millisecond' ,  arg stamp) | date_trunc('day' ,  arg stamp) | date_trunc('quarter' ,  arg ) | date_trunc('week' ,  arg ) | date_trunc('year' ,  arg ) | date_trunc('century' ,  arg stamp) | date_trunc('second' ,  arg stamp) | date_trunc('minute' ,  arg ) | date_trunc('year' ,  arg ) | date_trunc('millisecond' ,  arg ) | date_trunc('millennium' ,  arg ) | date_trunc('second' ,  arg ) | date_trunc('microsecond' ,  arg ) | date_trunc('quarter' ,  arg stamp) | date_trunc('day' ,  arg ) | date_trunc('minute' ,  arg stamp) | date_trunc('month' ,  arg ) | date_trunc('week' ,  arg ) | date_trunc('second' ,  arg ) | date_trunc('millisecond' ,  arg ) | date_trunc('millennium' ,  arg ) | date_trunc('millennium' ,  arg stamp) | date_trunc('decade' ,  arg stamp) | date_trunc('century' ,  arg ) | date_trunc('decade' ,  arg ) | date_trunc('hour' ,  arg stamp) | date_trunc('microsecond' ,  arg );
date_trunc_timestamp_timestamp_evaluator:
	date_trunc('day' ,  arg stamp);
date_trunc_timestamptz_timestamp_evaluator:
	date_trunc('day' , '2024-01-01 12:00:00 UTC' stamp with time zone);
extract_interval_double_evaluator:
	EXTRACT(DAY FROM '1 day' );
extract_timestamp_double_evaluator:
	EXTRACT(DAY FROM  arg stamp);
isfinite_date_boolean_evaluator:
	isfinite(  arg  ) | isfinite(  arg  );
isfinite_interval_boolean_evaluator:
	isfinite(interval '4 hours');
isfinite_timestamp_boolean_evaluator:
	isfinite(  arg  );
localtimestamp_timestamp_evaluator:
	localtimestamp(2) | localtimestamp(4) | localtimestamp(5) | localtimestamp(0) | localtimestamp(1);
localtimestamp_func_timestamp_evaluator:
	localtimestamp;
localtime_func_time_evaluator:
	localtime;
localtime_with_precision_time_evaluator:
	localtime(3);
make_date_date_evaluator:
	make_date(2024 , 1 , 1);
make_time_time_evaluator:
	make_time(12 , 30 , 0.0);
make_timestamp_timestamp_evaluator:
	make_timestamp(2024 , 1 , 1 , 12 , 30 , 0.0);
make_timestamptz_timestamp_evaluator:
	make_timestamptz(2024 , 1 , 1 , 12 , 30 , 0.0);
now_timestamp_evaluator:
	now();
timestamp_add_interval_timestamp_evaluator:
	 arg  + '1 day' ;
timestamp_sub_interval_timestamp_evaluator:
	 arg  - '1 day' ;
time_add_interval_time_evaluator:
	 arg  + '1 hour' ;
time_sub_interval_time_evaluator:
	 arg  - '1 hour' ;
to_timestamp_timestamp_evaluator:
	to_timestamp( arg ) | to_timestamp( arg ) | to_timestamp( arg );
transaction_timestamp_timestamp_evaluator:
	transaction_timestamp();
broadcast_inet_evaluator:
	broadcast (  arg  );
family_inet_evaluator:
	family (  arg  );
statement_timestamp_evaluator:
	statement_timestamp ( );
timeofday_evaluator:
	timeofday ( );
and_boolean_evaluator:
	 arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg  |  arg  AND  arg ;
not_boolean_evaluator:
	NOT( arg ) | NOT( arg ) | NOT( arg ) | not( arg ) | not( arg ) | not( arg );
or_boolean_evaluator:
	 arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg  |  arg  OR  arg ;
abs_integer_evaluator:
	abs( arg ) | abs( arg ) | abs( arg );
abs_double_evaluator:
	abs( arg ) | abs( arg );
acos_double_evaluator:
	acos(  arg  );
acosd_double_evaluator:
	acosd(  arg  );
acosh_double_evaluator:
	acosh(2.0);
asin_double_evaluator:
	asin(  arg  );
asind_double_evaluator:
	asind(  arg  );
asinh_double_evaluator:
	asinh( arg ) | asinh( arg );
at_integer_evaluator:
	@( arg ) | @( arg ) | @( arg );
at_double_evaluator:
	@( arg );
atan_double_evaluator:
	atan( arg ) | atan( arg ) | atan( arg ) | atan(  arg  ) | atan(  arg  );
atan2_double_evaluator:
	atan2( arg  ,  arg ) | atan2( arg  ,  arg ) | atan2( arg  ,  arg ) | atan2( arg  ,  arg ) | atan2( arg  ,  arg ) | atan2( arg  ,  arg );
atan2d_double_evaluator:
	atan2d( arg  ,  arg ) | atan2d( arg  ,  arg ) | atan2d( arg  ,  arg ) | atan2d( arg  ,  arg ) | atan2d( arg  ,  arg ) | atan2d( arg  ,  arg ) | atan2d( arg  ,  arg );
atand_double_evaluator:
	atand(  arg  );
atanh_double_evaluator:
	atanh(  arg  );
bitwise_and_integral_integer_evaluator:
	 arg  &  arg ;
bitwise_lshift_integral_evaluator:
	5 << 2 | 10 << 3;
bitwise_not_integral_integer_evaluator:
	~  arg ;
bitwise_or_integral_integer_evaluator:
	 arg  |  arg ;
cbrt_double_evaluator:
	cbrt( arg ) | cbrt( arg ) | cbrt(  arg  ) | cbrt(  arg  );
ceil_double_evaluator:
	ceil( arg ) | ceil( arg ) | ceil( arg );
ceiling_double_evaluator:
	ceiling( arg ) | ceiling( arg );
ceil_numeric_double_evaluator:
	ceil( arg );
cosd_double_evaluator:
	cosd( arg );
cosh_double_evaluator:
	cosh( arg ) | cosh( arg );
cos_double_evaluator:
	cos(  arg  ) | cos(  arg  );
cot_double_evaluator:
	cot(  arg  );
cotd_double_evaluator:
	cotd( arg ) | cotd( arg ) | cotd( arg );
cube_root_double_evaluator:
	||/( arg );
degrees_double_evaluator:
	degrees( arg ) | degrees( arg ) | degrees(  arg  ) | degrees(  arg  );
div_numeric_double_evaluator:
	div(10 , 3);
div_numeric_integer_evaluator:
	 arg  /  arg ;
erf_double_evaluator:
	erf( arg ) | erf( arg ) | erf( arg );
erfc_double_evaluator:
	erfc( arg ) | erfc( arg );
exp_double_evaluator:
	exp( arg ) | exp( arg );
factorial_double_evaluator:
	factorial(5);
floor_double_evaluator:
	floor( arg ) | floor( arg ) | floor( arg );
gamma_double_evaluator:
	gamma( arg );
gcd_integer_evaluator:
	gcd( arg  ,  arg ) | gcd( arg  ,  arg ) | gcd( arg  ,  arg );
hash_integer_evaluator:
	 arg  #  arg  |  arg  #  arg  |  arg  #  arg  |  arg  #  arg ;
integral_lshift_integer_evaluator:
	1 << 2;
lcm_integer_evaluator:
	lcm( arg  ,  arg ) | lcm( arg  ,  arg ) | lcm( arg  ,  arg ) | lcm( arg  ,  arg ) | lcm( arg  ,  arg ) | lcm( arg  ,  arg );
lgamma_double_evaluator:
	lgamma( arg );
ln_double_evaluator:
	ln( arg );
log10_double_evaluator:
	log10(  arg  );
log_numeric_evaluator:
	log(  arg  );
log_two_args_double_evaluator:
	log(2 , 8);
min_scale_integer_evaluator:
	min_scale( arg );
mod_integer_integer_evaluator:
	mod(  arg  ,  arg  ) | mod(  arg  ,  arg  );
mod_numeric_op_integer_evaluator:
	 arg  %  arg ;
mul_integer_evaluator:
	( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg );
mul_double_evaluator:
	( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg ) | ( arg  ) * (  arg );
ordiv_double_evaluator:
	|/( arg );
pi_double_evaluator:
	pi();
pow_double_evaluator:
	 arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg  |  arg  ^  arg ;
power_double_evaluator:
	power( arg  ,  arg );
radians_double_evaluator:
	radians( arg );
random_double_evaluator:
	random();
random_normal_double_evaluator:
	random_normal();
random_range_integer_evaluator:
	random(1 , 100);
round_double_integer_evaluator:
	round(  arg  ) | round(  arg  );
round_with_scale_double_evaluator:
	round(0.569527954956146 , 2);
scale_integer_evaluator:
	scale( arg ) | scale( arg );
sign_double_integer_evaluator:
	sign(  arg  );
agg_sign_double_integer_evaluator:
	sign(  arg  );
sin_double_evaluator:
	sin(  arg  ) | sin(  arg  );
sind_double_evaluator:
	sind( arg ) | sind( arg ) | sind( arg );
sinh_double_evaluator:
	sinh(  arg  );
sqrt_double_evaluator:
	sqrt( arg ) | sqrt( arg );
sub_numeric_integer_evaluator:
	 arg  -  arg ;
tan_double_evaluator:
	tan(  arg  ) | tan(  arg  );
tand_double_evaluator:
	tand( arg ) | tand( arg ) | tand( arg );
tanh_double_evaluator:
	tanh( arg ) | tanh( arg );
trim_scale_evaluator:
	(trim_scale(  arg  )) ;
trunc_double_integer_evaluator:
	trunc(  arg  );
trunc_with_scale_double_evaluator:
	trunc(0.569527954956146 , 2);
unary_plus_double_evaluator:
	+  arg  | +  arg ;
unary_plus_integer_evaluator:
	+  arg  | +  arg ;
width_bucket_array_integer_evaluator:
	width_bucket(5 , ARRAY[1, 3, 5, 10]);
width_bucket_func_evaluator:
	width_bucket( 5 , ARRAY[1, 3, 5, 10] ) | width_bucket( 7.5 , ARRAY[0, 5, 10, 15] );
width_bucket_numeric_integer_evaluator:
	width_bucket(  arg  , 0 , 100 , 10 );
abbrev_cidr_text_evaluator:
	abbrev(  arg  );
abbrev_inet_text_evaluator:
	abbrev(  arg  );
bigint_add_inet_evaluator:
	5 + inet '192.168.1.1' | 10 + inet '10.0.0.1';
host_text_evaluator:
	host(  arg  );
hostmask_inet_evaluator:
	hostmask(  arg  );
inet_add_bigint_inet_evaluator:
	1 + inet '192.168.1.1';
inet_bit_and_evaluator:
	 arg  &  arg ;
inet_bit_not_evaluator:
	~  arg ;
inet_bit_or_evaluator:
	 arg  |  arg ;
inet_contained_by_boolean_evaluator:
	 arg  <<  arg ;
inet_contained_by_eq_boolean_evaluator:
	 arg  <<=  arg ;
inet_contains_boolean_evaluator:
	 arg  &&  arg ;
inet_contains_eq_boolean_evaluator:
	 arg  >>=  arg ;
inet_merge_cidr_evaluator:
	inet_merge('192.168.1.1' , '192.168.2.1' );
inet_plus_bigint_inet_evaluator:
	inet '192.168.1.1' + 1;
inet_same_family_boolean_evaluator:
	inet_same_family(  arg  ,  arg  );
inet_strictly_contains_boolean_evaluator:
	 arg  >>  arg ;
inet_sub_bigint_evaluator:
	inet '192.168.1.10' - 5 | inet '10.0.0.100' - 10;
inet_sub_inet_integer_evaluator:
	 arg  -  arg ;
macaddr8_set7bit_evaluator:
	macaddr8_set7bit(  arg 8 );
masklen_integer_evaluator:
	masklen(  arg  );
netmask_inet_evaluator:
	netmask(  arg  );
network_cidr_evaluator:
	network(  arg  );
set_masklen_cidr_inet_evaluator:
	set_masklen(  arg  , 24 );
set_masklen_inet_inet_evaluator:
	set_masklen('192.168.1.0' , 16);
text_text_evaluator:
	text( arg ) | text( arg );
trunc_macaddr_evaluator:
	trunc(  arg  );
trunc_macaddr8_evaluator:
	trunc(  arg 8 );
regex_match_evaluator:
	 arg  ~  arg  |  arg  ~  arg  |  arg  ~  arg  |  arg  ~  arg ;
regex_match_i_evaluator:
	 arg  ~*  arg  |  arg  ~*  arg  |  arg  ~*  arg  |  arg  ~*  arg ;
regex_not_match_evaluator:
	 arg  !~  arg  |  arg  !~  arg  |  arg  !~  arg  |  arg  !~  arg ;
regex_not_match_i_evaluator:
	 arg  !~*  arg  |  arg  !~*  arg  |  arg  !~*  arg  |  arg  !~*  arg ;
ascii_integer_evaluator:
	ascii( arg ) | ascii( arg );
ascii_text_integer_evaluator:
	ascii(  arg  ) | ascii(  arg  );
bit_length_text_integer_evaluator:
	bit_length(  arg  ) | bit_length(  arg  );
btrim_text_evaluator:
	btrim( arg  , '') | btrim( arg  , ' ') | btrim( arg  , '') | btrim( arg  , ' ') | btrim( arg  , '') | btrim( arg ) | btrim( arg  , 'xyz') | btrim( arg  , ' ') | btrim( arg  , 'xyz') | btrim( arg  , 'xyz') | btrim( arg ) | btrim( arg );
casefold_text_evaluator:
	casefold(  arg  ) | casefold(  arg  );
character_length_integer_evaluator:
	character_length( arg ) | character_length( arg ) | character_length( arg );
char_length_integer_evaluator:
	char_length( arg ) | char_length( arg ) | char_length( arg );
chr_text_evaluator:
	chr( 65 );
concat_text_evaluator:
	concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg stamp(,  arg stamp)*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*) | concat( arg (,  arg )*);
concat_ws_text_evaluator:
	concat_ws( arg  ,  arg  (,  arg )*);
convert_from_text_evaluator:
	convert_from( 'Hello'  , 'UTF8' );
format_text_evaluator:
	format( arg  (,  arg )*);
initcap_text_evaluator:
	initcap( arg ) | initcap( arg ) | initcap( arg );
left_text_evaluator:
	left( 'ABCDEF' , 3 ) | left( 'Hello World' , 5 ) | left( 'PostgreSQL' , 4 ) | left( 'Database' , 4 ) | left( 'Testing' , 2 ) | left( 'SQL' , 2 ) | split_part( 'hello-world-test' , '-' , 2 ) | split_part( '2024,03,11' , ',' , 1 ) | split_part( 'abc def ghi' , ' ' , 3 ) | split_part( 'one;two;three;four' , ';' , 4 ) | split_part( 'a|b|c|d|e' , '|' , 1 ) | split_part( 'first:last' , ':' , 2 );
length_text_integer_evaluator:
	length(  arg  ) | length(  arg  );
agg_length_text_integer_evaluator:
	length(  arg  );
lower_text_evaluator:
	lower(  arg  ) | lower(  arg  );
agg_lower_text_evaluator:
	lower(  arg  );
lpad_text_evaluator:
	lpad( 'A' , 42 ) | lpad( 'test' , 10 ) | lpad( 'hello' , 15 ) | lpad( 'A' , 5 , 'x' ) | lpad( 'A' , 10 , ' ' ) | lpad( 'A' , 10 , 'xy' );
ltrim_text_evaluator:
	ltrim( arg ) | ltrim( arg  ,  arg ) | ltrim( arg  ,  arg ) | ltrim( arg  ,  arg ) | ltrim( arg ) | ltrim( arg  ,  arg ) | ltrim( arg  ,  arg ) | ltrim( arg  ,  arg ) | ltrim( arg  ,  arg ) | ltrim( arg  ,  arg ) | ltrim( arg  ,  arg ) | ltrim( arg );
md5_text_evaluator:
	md5(  arg  ) | md5(  arg  );
normalize_text_evaluator:
	normalize('Café', NFC);
octet_length_integer_evaluator:
	octet_length( arg ) | octet_length( arg );
octet_length_text_integer_evaluator:
	octet_length('Hello');
oror_text_evaluator:
	 arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg ;
overlay_text_evaluator:
	overlay( 'Txxxxas' placing 'hom' from 2 for 4 ) | overlay( 'Hello' placing 'XX' from 3 for 2 ) | overlay( 'Txxxxas' placing 'hom' from 2 );
pg_client_encoding_text_evaluator:
	pg_client_encoding();
position_integer_evaluator:
	position(  arg   IN   arg  );
position_text_integer_evaluator:
	position('lo' IN 'Hello');
quote_ident_text_evaluator:
	quote_ident(  arg  ) | quote_ident(  arg  );
quote_literal_text_evaluator:
	quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg 8) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal( arg ) | quote_literal(  arg  ) | quote_literal(  arg  );
quote_nullable_text_evaluator:
	quote_nullable( arg 8) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable( arg ) | quote_nullable(  arg  ) | quote_nullable(  arg  );
regexp_count_evaluator:
	regexp_count( 'ABCABC' , 'A.' ) | regexp_count( 'Hello World Hello' , 'Hello' ) | regexp_count( 'Test123Test' , '[0-9]' );
regexp_instr_evaluator:
	regexp_instr( 'foobarbequebaz' , 'ba' ) | regexp_instr( 'Hello World' , 'World' ) | regexp_instr( 'Test123Test' , '[0-9]+' );
regexp_like_evaluator:
	regexp_like(  arg  ,  arg  ) | regexp_like(  arg  ,  arg  ) | regexp_like(  arg  ,  arg  ) | regexp_like(  arg  ,  arg  );
regexp_replace_advanced_evaluator:
	regexp_replace( 'Thomas' , '.' , 'X' , 3 ) | regexp_replace( 'Test123Test' , '[0-9]' , 'X' , 1 , 2 ) | regexp_replace( 'Hello World' , 'o' , '0' , 1 , 1 );
regexp_replace_text_evaluator:
	regexp_replace(  arg  ,  arg  ,  arg  ) | regexp_replace(  arg  ,  arg  ,  arg  ) | regexp_replace(  arg  ,  arg  ,  arg  ) | regexp_replace(  arg  ,  arg  ,  arg  ) | regexp_replace(  arg  ,  arg  ,  arg  ) | regexp_replace(  arg  ,  arg  ,  arg  ) | regexp_replace(  arg  ,  arg  ,  arg  ) | regexp_replace(  arg  ,  arg  ,  arg  );
regexp_substr_evaluator:
	regexp_substr( 'foobarbequebaz' , 'ba.' ) | regexp_substr( 'Hello World' , '[A-Z]+' ) | regexp_substr( 'Test123Data' , '[0-9]+' );
repeat_text_evaluator:
	repeat( 'A' , 5 ) | repeat( 'ab' , 3 ) | repeat( 'x' , 10 ) | repeat( 'hello' , 2 ) | repeat( '*' , 20 ) | repeat( '-' , 8 );
replace_text_evaluator:
	replace(  arg  ,  arg  ,  arg  ) | replace(  arg  ,  arg  ,  arg  ) | replace(  arg  ,  arg  ,  arg  ) | replace(  arg  ,  arg  ,  arg  ) | replace(  arg  ,  arg  ,  arg  ) | replace(  arg  ,  arg  ,  arg  ) | replace(  arg  ,  arg  ,  arg  ) | replace(  arg  ,  arg  ,  arg  );
reverse_text_evaluator:
	reverse( arg ) | reverse( arg );
reverse_text_func_evaluator:
	reverse(  arg  ) | reverse(  arg  );
right_text_evaluator:
	right( 'ABC' , 2 ) | right( 'Hello World' , 5 ) | right( 'Test String' , 3 ) | right( 'PostgreSQL' , 7 ) | right( 'Database' , 4 ) | right( 'SQL' , 2 );
rpad_text_evaluator:
	rpad( 'A' , 42 ) | rpad( 'test' , 10 ) | rpad( 'hello' , 15 ) | rpad( 'A' , 5 , 'x' ) | rpad( 'A' , 10 , ' ' ) | rpad( 'A' , 10 , 'xy' );
rtrim_text_evaluator:
	rtrim( arg ) | rtrim( arg  , ' ') | rtrim( arg  , ' ') | rtrim( arg  , 'xyz') | rtrim( arg  , 'xyz') | rtrim( arg ) | rtrim( arg  , ' ');
starts_with_boolean_evaluator:
	starts_with( arg  ,  arg ) | starts_with( arg  ,  arg ) | starts_with( arg  ,  arg ) | starts_with( arg  ,  arg ) | starts_with( arg  ,  arg );
starts_with_op_boolean_evaluator:
	'Hello' ^@ 'He';
strpos_text_evaluator:
	strpos(  arg  ,  arg  ) | strpos(  arg  ,  arg  ) | strpos(  arg  ,  arg  ) | strpos(  arg  ,  arg  );
substr_text_evaluator:
	substr( 'Hello World' , 1 ) | substr( 'Hello World' , 7 ) | substr( 'Hello World' , 1 , 5 ) | substr( 'abcdefg' , 3 , 4 ) | substr( 'PostgreSQL' , 1 , 4 ) | substr( 'Testing' , 4 , 3 );
substring_regex_evaluator:
	substring( 'Thomas' from '...$' ) | substring( 'Hello World' from '[A-Z]+' ) | substring( 'Test123Data' from '[0-9]+' );
substring_similar_evaluator:
	substring( 'Thomas' similar 'Th%' escape '#' ) | substring( 'Hello World' similar 'He%ld' escape '#' );
substring_text_from_evaluator:
	substring( 'Thomas' from 2 for 3 ) | substring( 'Hello World' from 7 ) | substring( 'Testing' for 4 ) | substring( 'Database' from 3 for 4 );
text_concat_evaluator:
	 arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg  |  arg  ||  arg ;
text_normalized_evaluator:
	'a' IS NFC NORMALIZED | 'Hello' IS NFD NORMALIZED | 'test' IS NOT NFC NORMALIZED;
to_bin_text_evaluator:
	to_bin( 10 ) | to_bin( 255 ) | to_bin( 100 ) | to_bin( 42 ) | to_bin( 16 ) | to_bin( 128 );
to_hex_text_evaluator:
	to_hex( 255 ) | to_hex( 16 ) | to_hex( 100 ) | to_hex( 42 ) | to_hex( 1024 ) | to_hex( 128 );
to_oct_text_evaluator:
	to_oct( 64 ) | to_oct( 255 ) | to_oct( 8 ) | to_oct( 100 ) | to_oct( 512 ) | to_oct( 128 );
translate_text_evaluator:
	translate( 'Hello' , 'el' , 'ip' ) | translate( '12345' , '143' , 'axz' ) | translate( 'abcdef' , 'abc' , 'xyz' ) | translate( 'PostgreSQL' , 'Post' , 'SQL ' ) | translate( 'Test String' , 'Te' , 'XY' ) | translate( 'Database' , 'Datab' , '12345' ) | translate(  arg  ,  arg  ,  arg  ) | translate(  arg  ,  arg  ,  arg  ) | translate(  arg  ,  arg  ,  arg  ) | translate(  arg  ,  arg  ,  arg  ) | translate(  arg  ,  arg  ,  arg  ) | translate(  arg  ,  arg  ,  arg  ) | translate(  arg  ,  arg  ,  arg  ) | translate(  arg  ,  arg  ,  arg  );
trim_from_evaluator:
	trim( both from 'yxTomxx' , 'xyz' ) | trim( leading from 'xxxHello' , 'x' ) | trim( from '  Hello  ' );
trim_text_evaluator:
	trim( both 'xyz' from 'yxTomxx' ) | trim( leading 'x' from 'xxxHello' ) | trim( trailing 'x' from 'Helloxxx' ) | trim( both from '  Hello  ' );
unicode_assigned_evaluator:
	unicode_assigned(  arg  ) | unicode_assigned(  arg  );
unistr_text_evaluator:
	unistr( '\\0061' ) | unistr( '\\0041' ) | unistr( 'Hello\\0020World' ) | unistr( '\\0030\\0031\\0032' ) | unistr( '\\+00003B1' ) | unistr( 'A\\0042C' );
upper_text_evaluator:
	upper(  arg  ) | upper(  arg  );
agg_upper_text_evaluator:
	upper(  arg  );
gen_random_uuid_uuid_evaluator:
	gen_random_uuid();
uuidv7_uuid_evaluator:
	uuidv7();
uuid_extract_timestamp_timestamp_evaluator:
	uuid_extract_timestamp(  arg  );
uuid_extract_version_integer_evaluator:
	uuid_extract_version(  arg  );
