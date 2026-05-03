import os
import shutil

def main():
    print("="*60)
    print("Preparing Plot Data")
    print("="*60)
    
    PROCESSED_DIR = r"processed_results"
    PLOT_DATA_DIR = r"output\plot_data"
    
    all_dbs = ['mariadb', 'mysql', 'postgresql', 'sqlite', 'tidb']
    
    tool_db_map = {
        'LACAST': all_dbs,
        'PINOLO': ['mariadb', 'mysql', 'tidb'],
        'SQLancer': all_dbs
    }
    
    total_files = 0
    
    for db in all_dbs:
        print(f"\nPreparing data for {db}...")
        
        db_dir = os.path.join(PLOT_DATA_DIR, db)
        os.makedirs(db_dir, exist_ok=True)
        
        for tool in ['LACAST', 'PINOLO', 'SQLancer']:
            if tool == 'PINOLO' and db not in ['mariadb', 'mysql', 'tidb']:
                print(f"  {tool}: No data for {db}, skipping")
                continue
            
            source_file = os.path.join(PROCESSED_DIR, tool, db, "data_summary.txt")
            target_file = os.path.join(db_dir, f"{tool.lower()}.txt")
            
            if not os.path.exists(source_file):
                print(f"  {tool}: data_summary.txt not found, skipping")
                continue
            
            shutil.copy2(source_file, target_file)
            total_files += 1
            
            with open(target_file, 'r') as f:
                lines = sum(1 for _ in f)
            
            print(f"  {tool}: Copied {lines} lines to {tool.lower()}.txt")
    
    print("\n" + "="*60)
    print(f"Plot data preparation completed!")
    print(f"Total files created: {total_files}")
    print(f"Output directory: {PLOT_DATA_DIR}")
    print("="*60)
    
    print("\nDirectory structure:")
    for db in all_dbs:
        db_dir = os.path.join(PLOT_DATA_DIR, db)
        if os.path.exists(db_dir):
            files = os.listdir(db_dir)
            print(f"  {db}/")
            for f in files:
                print(f"    - {f}")

if __name__ == "__main__":
    main()
