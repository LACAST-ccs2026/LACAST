from typing import Annotated, Literal, TypedDict

import operator


class FeatureInfo(TypedDict):
    raw_syntax_name: str
    syntax_type: str
    is_agg: bool
    syntax_info: str


class FailedInfo(TypedDict):
    raw_syntax_name: str
    reason: str


class MainState(TypedDict):
    dbms: str
    work_dir: str
    limit: int
    timeout: int
    start_time: float
    no_fix: bool

    all_features: list[FeatureInfo]
    untrained_features: list[str]
    completed_features: Annotated[list[str], operator.add]
    failed_features: Annotated[list[FailedInfo], operator.add]

    current_feature: FeatureInfo | None
    subgraph_output: dict | None
    is_done: bool
    latest_progress: str


class Rule(TypedDict):
    idx: int
    rule_file_path: str
    type_eval: str
    left: str
    right: str


class RuleResult(TypedDict):
    rule_idx: int
    status: Literal["passed", "failed", "discarded"]
    accuracy: float
    error_info: str | None
    error_summary: str | None
    test_log: list[str]
    fix_episode: dict | None


class FixEpisodeContext(TypedDict):
    dbms: str
    syntax_type: str
    syntax_name: str
    raw_syntax_name: str
    rule_signature: str
    return_type: str
    is_agg: bool


class FixEpisodeError(TypedDict):
    error_type: str
    error_message: str
    error_summary: str
    rule_before: dict


class FixEpisodeFix(TypedDict):
    fix_attempts: int
    rule_after: dict
    fix_actions: list[str]
    fix_summary: str
    success: bool


class FixEpisodeUsage(TypedDict):
    hit_count: int
    last_hit: str | None


class FixEpisode(TypedDict):
    episode_id: str
    timestamp: str
    context: "FixEpisodeContext"
    error: "FixEpisodeError"
    fix: "FixEpisodeFix"
    usage: "FixEpisodeUsage"


class RulePipelineInput(TypedDict):
    rule: Rule
    rule_file_path: str
    const_file_path: str
    max_fix_attempts: int


class FeatureTrainerState(TypedDict):
    dbms: str
    work_dir: str
    feature_info: FeatureInfo
    no_fix: bool

    syntax_name: str
    feature_dir_path: str

    generated_rules: Annotated[list[Rule], operator.add]
    const_productions: dict

    rule_results: Annotated[list[RuleResult], operator.add]
    failed_results: Annotated[list[RuleResult], operator.add]
    fix_episodes: Annotated[list[FixEpisode], operator.add]

    phase: str

    status: Literal["pending", "completed", "failed"]
    saved_count: int
    total_rules: int
    failure_summary: str | None


class SubgraphOutput(TypedDict):
    status: Literal["completed", "failed"]
    raw_syntax_name: str
    syntax_name: str
    saved_count: int
    total_rules: int
    failure_summary: str | None
