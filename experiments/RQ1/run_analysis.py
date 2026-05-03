import os
import sys
import subprocess

def main():
    print("="*60)
    print("RQ1 Experiment - Automated Analysis Pipeline")
    print("="*60)
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = script_dir
    
    os.chdir(base_dir)
    
    scripts = [
        ("Processing all SQL generation data", "scripts/1_process_all.py"),
        ("Calculating metrics", "scripts/2_calculate_metrics.py"),
        ("Preparing plot data", "scripts/3_prepare_plot_data.py"),
        ("Drawing combined chart", "scripts/4_draw_combined_chart.py")
    ]
    
    for i, (desc, script) in enumerate(scripts, 1):
        print(f"\n[{i}/{len(scripts)}] {desc}...")
        script_path = os.path.join(base_dir, script)
        
        if not os.path.exists(script_path):
            print(f"ERROR: Script not found: {script_path}")
            return 1
        
        result = subprocess.run([sys.executable, script_path], capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"ERROR: {script} failed")
            print(result.stderr)
            return 1
        
        if result.stdout:
            print(result.stdout)
    
    print("\n" + "="*60)
    print("Analysis completed successfully!")
    print("="*60)
    print(f"\nResults:")
    print(f"  - Metrics: output/metrics_final.csv")
    print(f"  - Charts:  output/charts/rq1_results.pdf")
    print("="*60)
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
