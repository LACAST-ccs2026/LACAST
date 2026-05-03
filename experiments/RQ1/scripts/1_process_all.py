import re
import os
from collections import defaultdict
import json
import copy
from token_categories import SQL_KEYWORDS, TYPE_KEYWORDS

TOKEN_PATTERN = re.compile(
    r"""
    '[^']*' | "[^"]*" | `[^`]*` |
    \b\d+\.?\d*[Ee][+-]?\d+\b |
    \b\d+\.\d+\b | \b\d+\b |
    \b[A-Za-z_][A-Za-z0-9_]*\b |
    >=|<=|<>|!=|&&|\|\||[!&|^=><+\-*/%~] |
    [(),.;]
    """, re.VERBOSE
)

def get_token_category(token):
    token = str(token) 
    token = token.upper()
    upper_t = token
    
    if token.startswith("'") or token.startswith('"') or token.startswith('`'): 
        return "STRINGS", token
    
    if upper_t in SQL_KEYWORDS:
        return upper_t, upper_t
    if upper_t in ('!', '&&', '||', 'XOR', 'NOT', 'AND', 'OR'):
        return upper_t, upper_t
    if upper_t in [">=", "<=", "<>", "!=", "=", ">", "<", "+", "-", "*", "/", "^", "&", "%", "~"]:
        return upper_t, token
    if token in "(),.;":
        return token, token
    
    if upper_t in TYPE_KEYWORDS:
        return "TYPE_KEYWORDS", upper_t
    
    if re.match(r'^-?\d', token) or 'E' in upper_t:
        if not any(c.isalpha() for c in token.replace('E','').replace('e','')):
            return "NUMBERS", token
    
    if re.fullmatch(r"t[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "TABLE_REFS", token
    if re.fullmatch(r"TABLE[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "TABLE_REFS", token
    
    if re.fullmatch(r"c[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "COLUMN_REFS", token
    if re.fullmatch(r"F[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "COLUMN_REFS", token
    if re.fullmatch(r"COL[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "COLUMN_REFS", token
    
    if re.fullmatch(r"ref[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "REFERENCE_IDS", token
    if re.fullmatch(r"database[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "REFERENCE_IDS", token
    if re.fullmatch(r"i[A-Za-z0-9_]+", token, re.IGNORECASE):
        return "REFERENCE_IDS", token
    if re.fullmatch(r"RT[A-Za-z0-9]+", token, re.IGNORECASE):
        return "REFERENCE_IDS", token
    if re.fullmatch(r"V[A-Za-z0-9]+", token, re.IGNORECASE):
        return "REFERENCE_IDS", token
    if len(token) <= 2:
        return "REFERENCE_IDS", token
    
    if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", token):
        return "OTHER_FUNCTIONS", "token"
    
    return "OTHER_IDS", token

def parse_sql_line(raw_sql, stats=None):
    if not re.match(r'^\s*(SELECT|WITH|\()', raw_sql, re.IGNORECASE):
        return 0, 0
    
    cnt = 0
    categories_dict = defaultdict(set)
    
    for t in TOKEN_PATTERN.findall(raw_sql):
        cat, val = get_token_category(t)
        
        if stats is not None and cat not in stats:
            stats[cat] = 1
        if cat not in categories_dict:
            categories_dict[cat] = set()
        
        cnt+=1
    
    total_unique_categories = len(categories_dict)
    return cnt, total_unique_categories

def process_file(input_path, output_path):
    query_count = 0
    all_length = 0
    all_unique_count = 0
    result_file = os.path.join(output_path, "data_summary.txt")
    error_file = os.path.join(output_path, "error_summary.txt")
    stats = defaultdict(int)
    
    with open(input_path, 'r', encoding='utf-8', errors='ignore') as f, \
         open(result_file, 'w', encoding='utf-8') as rf, \
         open(error_file, 'w', encoding='utf-8') as ef:
        
        for line in f:
            clean_line = line.strip()
            if not clean_line:
                continue
            try:
                data = json.loads(clean_line)
            except:
                continue
            
            raw_sql = data.get("sql", "").strip()
            result = data.get("result", "")
            error_info = data.get("error_info", "")
            
            if "connect" in error_info.lower():
                continue
            if not raw_sql:
                continue
            
            if result.lower() == "success":
                length, unique_count = parse_sql_line(raw_sql, stats)
                if length == 0 and unique_count == 0:
                    continue
                result_flag = 100
                query_count += 1
                all_length += length
                all_unique_count += unique_count
            else:
                length, unique_count = parse_sql_line(raw_sql, copy.deepcopy(stats))
                if length == 0 and unique_count == 0:
                    continue
                result_flag = 0
            
            rf.write(f"{unique_count},{result_flag}\n")
            if error_info:
                ef.write(error_info + "\n")
    
    summary_file = os.path.join(output_path, "summary.txt")
    with open(summary_file, 'w', encoding='utf-8') as sf:
        sf.write(f"Total queries: {query_count}, Total length: {all_length}, Total unique (per query): {all_unique_count}, Total unique (global): {len(stats)}\n")
        if query_count > 0:
            avg_length_per_query = all_length / query_count
            avg_unique_per_query = all_unique_count / query_count
            sf.write(f"Avg query length: {avg_length_per_query:.2f}, Avg unique tokens: {avg_unique_per_query:.2f}\n")
    
    return query_count, all_length, all_unique_count

def main():
    print("="*60)
    print("Processing SQL Generation Data")
    print("="*60)
    
    INPUT_BASE = r"input_dataset"
    OUTPUT_BASE = r"processed_results"
    
    TOOL_DBS = {
        "LACAST": ["mariadb", "mysql", "postgresql", "sqlite", "tidb"],
        "PINOLO": ["mariadb", "mysql", "tidb"],
        "SQLancer": ["mariadb", "mysql", "postgresql", "sqlite", "tidb"]
    }
    
    for tool, dbs in TOOL_DBS.items():
        print(f"\nProcessing {tool}...")
        
        for db in dbs:
            input_file = os.path.join(INPUT_BASE, tool, db, "epoch-1.jsonl")
            output_dir = os.path.join(OUTPUT_BASE, tool, db)
            
            if not os.path.exists(input_file):
                print(f"  Warning: {tool}/{db} not found, skipping")
                continue
            
            os.makedirs(output_dir, exist_ok=True)
            query_count, total_length, unique_count = process_file(input_file, output_dir)
            print(f"  {db}: {query_count} queries, {total_length} tokens, {unique_count} unique")
    
    print("\n" + "="*60)
    print("All processing completed!")
    print("="*60)

if __name__ == "__main__":
    main()
