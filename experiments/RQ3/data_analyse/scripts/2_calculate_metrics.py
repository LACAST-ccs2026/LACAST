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
    
    lacast_data = {}
    for db in ['mariadb', 'mysql', 'postgresql', 'sqlite', 'tidb']:
        summary_file = os.path.join(BASE_DIR, "LACAST", db, "summary.txt")
        data_summary_file = os.path.join(BASE_DIR, "LACAST", db, "data_summary.txt")
        
        if os.path.exists(summary_file):
            summary_data = read_summary(summary_file)
            if summary_data:
                correctness = read_data_summary(data_summary_file)
                lacast_data[db] = {
                    'correctness': correctness,
                    'avg_unique': summary_data.get('Avg unique tokens', 0.0)
                }
    
    results = {}
    for db in ['mariadb', 'mysql', 'postgres', 'sqlite', 'tidb']:
        results[db] = {}
        
        for variant in ['LACAST_I', 'LACAST_S']:
            summary_file = os.path.join(BASE_DIR, variant, db, "summary.txt")
            data_summary_file = os.path.join(BASE_DIR, variant, db, "data_summary.txt")
            if os.path.exists(summary_file):
                summary_data = read_summary(summary_file)
                if summary_data:
                    results[db][variant] = {
                        'correctness': read_data_summary(data_summary_file),
                        'avg_unique': summary_data.get('Avg unique tokens', 0.0)
                    }
    
    csv_data = []
    csv_data.append(['DB', 'Tool', 'Correctness_Avg', 'Unique_Tokens'])
    
    db_mapping = {
        'mysql': ('mysql', 'mysql'),
        'mariadb': ('mariadb', 'mariadb'),
        'sqlite': ('sqlite', 'sqlite'),
        'tidb': ('tidb', 'tidb'),
        'postgres': ('postgres', 'postgresql')
    }
    
    for db_display, (db_results, db_lacast) in db_mapping.items():
        for variant in ['LACAST_S', 'LACAST_I']:
            if db_results in results and variant in results[db_results]:
                csv_data.append([
                    db_display, variant,
                    f"{results[db_results][variant]['correctness']:.2f}",
                    f"{results[db_results][variant]['avg_unique']:.2f}"
                ])
        
        if db_lacast in lacast_data:
            csv_data.append([
                db_display, 'LACAST',
                f"{lacast_data[db_lacast]['correctness']:.2f}",
                f"{lacast_data[db_lacast]['avg_unique']:.2f}"
            ])
    
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    with open(OUTPUT_FILE, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerows(csv_data)
    
    print(f"Metrics saved to: {OUTPUT_FILE}")
    
    print("\n" + "="*80)
    print("Table 5: Contribution Evaluation Across DBMSs")
    print("="*80)
    
    db_names = {
        'mysql': 'MySQL',
        'mariadb': 'MariaDB',
        'sqlite': 'SQLite',
        'tidb': 'TiDB',
        'postgres': 'PostgreSQL'
    }
    
    for db_display, (db_results, db_lacast) in db_mapping.items():
        print(f"\n{db_names[db_display]}")
        
        if db_results in results and 'LACAST_S' in results[db_results]:
            c = results[db_results]['LACAST_S']['correctness']
            u = results[db_results]['LACAST_S']['avg_unique']
            print(f"  LACAST!S {c:.0f}% {u:.1f}")
        
        if db_results in results and 'LACAST_I' in results[db_results]:
            c = results[db_results]['LACAST_I']['correctness']
            u = results[db_results]['LACAST_I']['avg_unique']
            print(f"  LACAST!I {c:.2f}% {u:.1f}")
        
        if db_lacast in lacast_data:
            c = lacast_data[db_lacast]['correctness']
            u = lacast_data[db_lacast]['avg_unique']
            print(f"  LACAST {c:.1f}% {u:.1f}")
    
    print("\n" + "="*80)

if __name__ == "__main__":
    main()
