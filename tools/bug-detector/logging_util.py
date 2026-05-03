import logging
from logging.handlers import RotatingFileHandler


def setup_logging(logging_path):
    max_log_size = 30 * 1024 * 1024
    backup_count = 5

    handler = RotatingFileHandler(
        logging_path,
        maxBytes=max_log_size,
        backupCount=backup_count,
        encoding="utf-8"
    )

    formatter = logging.Formatter("%(asctime)s [%(levelname)s] %(message)s")
    handler.setFormatter(formatter)

    logging.basicConfig(
        level=logging.INFO,
        handlers=[handler]
    )

def setup_logging2(logging_path):
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
        handlers=[
            logging.FileHandler(logging_path, mode="a", encoding="utf-8"),
        ]
    )