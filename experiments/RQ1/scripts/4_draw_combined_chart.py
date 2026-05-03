import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import interp1d
import os

step_size = 8
avg_window = 3
max_lines = 800000

def interpolate_data(data, token_range):
    if not data:
        return None
    x, y = zip(*data)
    f = interp1d(x, y, bounds_error=False, fill_value=(min(y), max(y)))
    return f(token_range)

def get_token_range(data, step_size=1):
    if not data:
        return np.array([])
    tokens = [token for token, _ in data]
    return np.arange(min(tokens), max(tokens) + step_size, step_size)

def process_file(file_path, step_size, avg_window, max_lines=max_lines):
    data = []
    if not os.path.exists(file_path):
        return []
    
    with open(file_path, 'r') as f:
        for i, line in enumerate(f):
            if i >= max_lines:
                break
            parts = line.strip().split(',')
            if len(parts) == 2:
                token, accuracy = float(parts[0]), float(parts[1])
                data.append((token, accuracy))
    
    if not data:
        return []
    
    tokens = [token for token, accuracy in data]
    min_token = min(tokens)
    max_token = max(tokens)
    
    processed_data = []
    current_token = min_token
    
    while current_token <= max_token:
        in_range = [(token, accuracy) for token, accuracy in data 
                    if current_token <= token < current_token + step_size]
        
        if in_range:
            avg_accuracy = np.mean([accuracy for token, accuracy in in_range])
            processed_data.append((current_token, avg_accuracy))
        
        current_token += step_size
    
    smoothed_data = []
    for i in range(len(processed_data)):
        start = max(0, i - avg_window)
        end = min(len(processed_data), i + avg_window + 1)
        avg_accuracy = np.mean([accuracy for _, accuracy in processed_data[start:end]])
        smoothed_data.append((processed_data[i][0], avg_accuracy))
    
    return smoothed_data

def draw_subplot(ax, db_name, plot_data_dir):
    lacast_file = os.path.join(plot_data_dir, db_name, "lacast.txt")
    pinolo_file = os.path.join(plot_data_dir, db_name, "pinolo.txt")
    sqlancer_file = os.path.join(plot_data_dir, db_name, "sqlancer.txt")
    
    lacast_data = process_file(lacast_file, step_size, avg_window)
    pinolo_data = process_file(pinolo_file, step_size, avg_window) if db_name in ['mariadb', 'mysql', 'tidb'] else []
    sqlancer_data = process_file(sqlancer_file, step_size, avg_window)
    
    lacast_token_range = get_token_range(lacast_data, step_size)
    pinolo_token_range = get_token_range(pinolo_data, step_size) if pinolo_data else None
    sqlancer_token_range = get_token_range(sqlancer_data, step_size)
    
    lacast_interp = interpolate_data(lacast_data, lacast_token_range) if lacast_data else None
    pinolo_interp = interpolate_data(pinolo_data, pinolo_token_range) if pinolo_data else None
    sqlancer_interp = interpolate_data(sqlancer_data, sqlancer_token_range) if sqlancer_data else None
    
    if lacast_interp is not None:
        ax.plot(lacast_token_range, lacast_interp, 'x-', color='#6A4C93', linewidth=2, markersize=10)
    if pinolo_interp is not None:
        ax.plot(pinolo_token_range, pinolo_interp, 's-', color='#E63946', linewidth=2, markersize=10)
    if sqlancer_interp is not None:
        ax.plot(sqlancer_token_range, sqlancer_interp, '^-', color='#1D3557', linewidth=2, markersize=10)
    
    ax.set_title(db_name, fontsize=24, fontweight='bold')
    ax.set_ylim(bottom=0, top=105)
    ax.set_xlim(left=1)
    ax.grid(True, alpha=0.3)
    ax.tick_params(axis='both', labelsize=16)
    ax.set_xlabel('Unique Tokens', fontsize=18)
    ax.set_ylabel('Correctness (%)', fontsize=18)

def main():
    PLOT_DATA_DIR = r"output\plot_data"
    OUTPUT_DIR = r"output\charts"
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    fig, axes = plt.subplots(2, 3, figsize=(20, 12))
    
    draw_subplot(axes[0, 0], 'mysql', PLOT_DATA_DIR)
    draw_subplot(axes[0, 1], 'mariadb', PLOT_DATA_DIR)
    draw_subplot(axes[0, 2], 'sqlite', PLOT_DATA_DIR)
    
    axes[1, 0].axis('off')
    axes[1, 0].legend(
        handles=[
            plt.Line2D([0], [0], marker='x', color='#6A4C93', label='LACAST', markersize=15, linewidth=2),
            plt.Line2D([0], [0], marker='s', color='#E63946', label='PINOLO', markersize=15, linewidth=2),
            plt.Line2D([0], [0], marker='^', color='#1D3557', label='SQLancer', markersize=15, linewidth=2)
        ],
        loc='center',
        fontsize=20,
        frameon=True,
        fancybox=True,
        shadow=True
    )
    
    draw_subplot(axes[1, 1], 'postgresql', PLOT_DATA_DIR)
    draw_subplot(axes[1, 2], 'tidb', PLOT_DATA_DIR)
    
    plt.tight_layout()
    
    output_file = os.path.join(OUTPUT_DIR, "rq1_results.pdf")
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    plt.close()
    
    print(f"Chart saved to: {output_file}")

if __name__ == "__main__":
    main()
