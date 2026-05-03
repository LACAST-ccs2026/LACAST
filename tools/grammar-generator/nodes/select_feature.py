import os
import re

from utils.file_utils import write_json, ensure_dir


_INVALID_FS_CHARS = re.compile(r'[<>:"/\\|?*]')

_FS_REPLACE = {
    '*': 'MUL',
    '+': 'PLUS',
    '<': 'LT',
    '>': 'GT',
    '=': 'EQ',
    '|': 'PIPE',
    '?': 'QMARK',
    ':': 'COLON',
    '"': 'QUOTE',
    '/': 'DIV',
    '\\': 'BSLASH',
    '%': 'MOD',
    '&': 'BITAND',
    '-': 'MINUS',
    '!': 'NOT',
    '(': '',
    ')': '',
}


def _safe_name(name: str) -> str:
    name = name.strip()
    for ch, repl in _FS_REPLACE.items():
        name = name.replace(ch, repl)
    if name.startswith('.'):
        name = '_' + name
    name = re.sub(r'_+', '_', name).strip('_')
    return name.upper()


def select_feature_node(state) -> dict:
    from utils.log import log

    fi = state["feature_info"]
    raw = fi["raw_syntax_name"]
    prefix = "agg_" if fi["is_agg"] else ""
    simple = _safe_name(raw.split("(")[0])
    syntax_name = f"{prefix}{simple}"

    log.info(f"  Feature selected: {raw} → {syntax_name}")

    feature_dir = os.path.normpath(os.path.join(
        state.get("work_dir", "."), "data",
        fi["syntax_type"], syntax_name
    ))
    ensure_dir(feature_dir)

    basic_info = {
        "syntax_name": syntax_name,
        "raw_syntax_name": raw,
        "syntax_type": fi["syntax_type"],
        "is_agg": fi["is_agg"],
        "syntax_info": fi["syntax_info"],
    }
    write_json(os.path.join(feature_dir, "basic_info.json"), basic_info)

    return {
        "syntax_name": syntax_name,
        "feature_dir_path": feature_dir,
        "phase": "selecting",
    }

