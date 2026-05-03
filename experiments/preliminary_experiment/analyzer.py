import argparse
import json


def analyze_results(file_path):
    try:
        data = []
        with open(file_path, 'r', encoding='utf-8') as f:
            for line in f:
                data.append(json.loads(line.strip()))
    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
        return
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in file {file_path}: {e}")
        return

    total_queries = len(data)
    if total_queries == 0:
        print("No queries found in the log file.")
        return

    successful_queries = sum(1 for item in data if item.get("success", False))
    failed_queries = total_queries - successful_queries

    accuracy = (successful_queries / total_queries) * 100 if total_queries > 0 else 0

    generation_times = [item.get("generation_time", 0) for item in data]
    avg_generation_time = sum(generation_times) / len(generation_times) if generation_times else 0
    avg_queries_per_second = 1 / avg_generation_time if avg_generation_time > 0 else 0

    total_prompt_tokens = sum(item.get("prompt_tokens", 0) for item in data)
    total_completion_tokens = sum(item.get("completion_tokens", 0) for item in data)
    total_tokens = total_prompt_tokens + total_completion_tokens

    print("\n--- Fuzzer Results Analysis ---")
    print(f"Log File: {file_path}")
    print(f"Total Queries Generated: {total_queries}")
    print(f"  - Successful: {successful_queries}")
    print(f"  - Failed: {failed_queries}")
    print(f"Execution Accuracy: {accuracy:.2f}%")
    print(f"Average Generation Speed: {avg_queries_per_second:.4f} queries/second")
    print("\n--- Token Consumption ---")
    print(f"Total Prompt Tokens: {total_prompt_tokens}")
    print(f"Total Completion Tokens: {total_completion_tokens}")
    print(f"Total Tokens: {total_tokens}")
    print("---------------------------\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Analyze fuzzer results.")
    parser.add_argument("--file", required=True, help="Path to the result JSONL file.")
    args = parser.parse_args()
    analyze_results(args.file)
