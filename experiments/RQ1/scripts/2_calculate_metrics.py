import os
import csv

def read_summary(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        if len(lines) < 2:
            return None
        
        parts = lines[0].strip().split(',')
        data = {}
        for part in parts:
            if ':' in part:
                key, value = part.split(':')
                data[key.strip()] = int(value.strip())
        
        avg_parts = lines[1].strip().split(',')
        for part in avg_parts:
            if ':' in part:
                key, value = part.split(':')
                data[key.strip()] = float(value.strip())
        
        return data

def read_data_summary(file_path):
    total = 0
    success = 0
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split(',')
            if len(parts) == 2:
                total += 1
                if parts[1].strip() == '100':
                    success += 1
    
    if total == 0:
        return 0.0
    return (success / total) * 100

def main():
    print("="*60)
    print("Calculating Metrics")
    print("="*60)
    
    BASE_DIR = r"processed_results"
    OUTPUT_FILE = r"output\metrics_final.csv"
    
    csv_data = []
    csv_data.append(['DB', 'Tool', 'Correctness_Avg', 'Unique_Tokens', 'Total_Unique_Tokens', 'Generated_SQL_per_sec', 'Token_Throughput_per_sec'])
    
    all_dbs = ['mariadb', 'mysql', 'postgresql', 'sqlite', 'tidb']
    all_tools = ['LACAST', 'PINOLO', 'SQLancer']
    
    for db in all_dbs:
        print(f"\nProcessing {db}...")
        
        for tool in all_tools:
            if tool == 'PINOLO' and db in ['postgresql', 'sqlite']:
                continue
            
            summary_file = os.path.join(BASE_DIR, tool, db, "summary.txt")
            data_summary_file = os.path.join(BASE_DIR, tool, db, "data_summary.txt")
            
            if not os.path.exists(summary_file):
                print(f"  Warning: {tool}/{db} summary not found, skipping")
                continue
            
            summary_data = read_summary(summary_file)
            if not summary_data:
                print(f"  Warning: {tool}/{db} summary format error, skipping")
                continue
            
            correctness = read_data_summary(data_summary_file)
            
            queries_per_sec = summary_data.get('Total queries', 0)
            total_tokens = summary_data.get('Total length', 0)
            avg_unique = summary_data.get('Avg unique tokens', 0.0)
            total_unique = summary_data.get('Total unique (global)', 0)
            
            csv_data.append([
                db,
                tool,
                f"{correctness:.2f}",
                f"{avg_unique:.2f}",
                total_unique,
                queries_per_sec,
                total_tokens
            ])
            
            print(f"  {tool}: {queries_per_sec} queries, {correctness:.1f}% correct")
    
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    with open(OUTPUT_FILE, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerows(csv_data)
    
    print("\n" + "="*60)
    print(f"Metrics saved to: {OUTPUT_FILE}")
    print("="*60)
    
    print("\nCSV Preview:")
    print("-" * 80)
    for row in csv_data[:10]:
        print(', '.join(str(x) for x in row))
    print("-" * 80)

if __name__ == "__main__":
    main()
