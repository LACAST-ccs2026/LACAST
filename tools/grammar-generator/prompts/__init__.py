import os

_PROMPTS_DIR = os.path.normpath(os.path.join(os.path.dirname(__file__)))


def load(name: str) -> str:
    path = os.path.join(_PROMPTS_DIR, f"{name}.txt")
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def loadf(name: str, **kwargs) -> str:
    template = load(name)
    return template.format(**kwargs)
