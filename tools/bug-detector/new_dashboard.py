import time

from rich import box
from rich.console import Console
from rich.live import Live
from rich.panel import Panel
from rich.table import Table

from record import Record, ThroughputCount


class RadarDashboard:
    def __init__(self, record: Record, sql_gen_throughput_count: ThroughputCount, sql_exec_throughput_count: ThroughputCount):
        self.is_running = True
        self.record = record
        self.sql_gen_throughput_count = sql_gen_throughput_count
        self.sql_exec_throughput_count = sql_exec_throughput_count

    def get_metrics(self):
        metrics = list()
        # 获取记录信息
        with self.record.lock:
            # 总的统计信息
            metrics.append(("Total SQL Num", self.record.record["total_sql_num"], "", "white"))
            metrics.append(("Error SQL Num", self.record.record["error_sql_num"], "", "white"))
            metrics.append(("Crash SQL Num", self.record.record["crash_num"], "", "bold red"))
            metrics.append(("Error Type Num", self.record.record["error_type_num"], "", "white"))
            metrics.append(("Accuracy", self.record.record["accuracy"], "%", "white"))
            metrics.append(("Generated SQL Num Per Epoch", self.record.record["generated_sql_num_per_epoch"], "sql/epoch", "white"))

        # 运行相关信息
        with self.sql_gen_throughput_count.lock:
            metrics.append(("Throughput of SQL Generation", self.sql_gen_throughput_count.get_throughput(), "sql/s", "white"))

        with self.sql_exec_throughput_count.lock:
            metrics.append(("Throughput of SQL Execution", self.sql_exec_throughput_count.get_throughput(), "sql/s", "white"))

        with self.record.lock:
            metrics.append(("Radar SQL Num", self.record.record["radar_sql_num"], "", "bold red"))
        return metrics

    def build_panel(self, metrics):
        table = Table(
            show_header=True,
            header_style="bold magenta",
            box=box.SIMPLE_HEAVY,
            expand=True,
            padding=(0, 1),
        )

        table.add_column("Metric", justify="left", style="cyan", no_wrap=True)
        table.add_column("Value", justify="right", no_wrap=True)
        table.add_column("Unit", justify="left", style="dim", no_wrap=True)

        def format_value(v):
            if isinstance(v, float):
                return f"{v:.4f}"
            return str(v)

        for name, value, unit, style in metrics:
            table.add_row(
                name,
                f"[{style}]{format_value(value)}[/{style}]",
                unit or "",
            )

        return Panel(
            table,
            title="📊 [bold green]System Metrics[/]",
            border_style="green",
            padding=(1, 2),
        )

    def run(self):
        _console = Console()
        with Live(console=_console, refresh_per_second=1, screen=False) as live:
            while self.is_running:
                metrics = self.get_metrics()
                live.update(self.build_panel(metrics))
                time.sleep(1)
