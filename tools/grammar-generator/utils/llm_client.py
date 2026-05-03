import json
import re
from typing import Any, Literal, Type, TypeVar, Union

from langchain_core.language_models.chat_models import BaseChatModel
from langchain_core.messages import AIMessage, HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI
from pydantic import BaseModel, field_validator

from config import LLMConfig

T = TypeVar("T", bound=BaseModel)

class LLRule(BaseModel):
    type_eval: str
    left: str
    right: str

    @field_validator("right", mode="before")
    @classmethod
    def _right_to_str(cls, v):
        if isinstance(v, list):
            return " ".join(str(x) for x in v)
        return v


class RulesOutput(BaseModel):
    rules: list[LLRule]
    const_productions: dict = {}


class TestVerdict(BaseModel):
    __test__ = False

    status: Literal["pass", "fail"]
    accuracy: float
    summary: str
    error_type: str | None = None


class FixOutput(BaseModel):
    type_eval: str
    left: str
    right: str
    const_productions: dict = {}
    fix_actions: list[str] = []
    fix_summary: str = ""
    status: Literal["fixed", "cannot_fix"] = "fixed"

    @field_validator("right", mode="before")
    @classmethod
    def _right_to_str(cls, v):
        if isinstance(v, list):
            return " ".join(str(x) for x in v)
        return v

    @field_validator("fix_actions", mode="before")
    @classmethod
    def _normalize_actions(cls, v):
        if v and isinstance(v[0], dict):
            return [
                f"{a.get('field', '?')}: {a.get('old', '?')} → {a.get('new', '?')}"
                for a in v
            ]
        return v


def _repair_json(text: str) -> str:
    text = re.sub(r'^```(?:json)?\s*', '', text.strip())
    text = re.sub(r'\s*```$', '', text)
    try:
        json.loads(text)
        return text
    except json.JSONDecodeError:
        pass
    def _fix_right(m):
        raw = m.group(2)
        esc = raw.replace('\\"', '\x00')
        esc = esc.replace('"', '\\"')
        esc = esc.replace('\x00', '\\"')
        return f'{m.group(1)}{esc}"'
    text = re.sub(
        r'("right":\s*")(.+?)(?="\s*[,}])',
        _fix_right, text, flags=re.DOTALL,
    )
    return text


MessageLike = Union[str, list[dict[str, str]]]


def _to_messages(messages: MessageLike) -> list:
    if isinstance(messages, str):
        return [HumanMessage(content=messages)]

    result = []
    for msg in messages:
        role = msg.get("role", "user")
        content = msg.get("content", "")
        if role == "system":
            result.append(SystemMessage(content=content))
        elif role == "assistant":
            result.append(AIMessage(content=content))
        else:
            result.append(HumanMessage(content=content))
    return result

class LLMClient:
    def __init__(self, config: LLMConfig):
        self._config = config
        self._model: BaseChatModel | None = None

    def _build_model(self, temperature: float | None = None) -> BaseChatModel:
        t = temperature if temperature is not None else self._config.temperature
        return ChatOpenAI(
            model=self._config.model,
            api_key=self._config.api_key,
            base_url=self._config.base_url,
            temperature=t,
        )

    def generate_text(
        self, messages: MessageLike, temperature: float | None = None
    ) -> str:
        model = self._build_model(temperature)
        response = model.invoke(_to_messages(messages))
        return response.content

    def generate_structured(
        self,
        messages: MessageLike,
        schema: Type[T],
        method: str = "json_mode",
        temperature: float | None = None,
    ) -> T:
        from langchain_core.exceptions import OutputParserException
        from langchain_core.output_parsers import PydanticOutputParser

        model = self._build_model(temperature).with_structured_output(
            schema, method=method,
        )
        try:
            result: T = model.invoke(_to_messages(messages))
            return result
        except OutputParserException as e:
            raw = str(e.llm_output or "")
            if raw:
                repaired = _repair_json(raw)
                parser = PydanticOutputParser(pydantic_object=schema)
                try:
                    return parser.parse(repaired)
                except Exception:
                    pass
            raise
