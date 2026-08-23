"""Deterministic routing and approval policy for MissionCompiler V0.1.

The language model is responsible for converting a raw request and observed
environment into normalized facts. This module deliberately does not infer
facts from prompt keywords. It applies inspectable policy to those facts.
"""

from __future__ import annotations

from typing import Any


HARD_PLAN_TAGS = {
    "authentication",
    "database_migration",
    "payment",
    "production",
    "regulatory",
    "secrets",
    "security_sensitive",
    "trading",
}

RED_RISK_TAGS = HARD_PLAN_TAGS | {"destructive", "personal_data"}

RED_EXTERNAL_ACTIONS = {
    "create_calendar_event",
    "create_task",
    "delete_remote_data",
    "deploy_production",
    "modify_external_data",
    "modify_production_data",
    "payment",
    "publish",
    "real_order",
    "regulatory_submit",
    "send_message",
}


def _as_bool(facts: dict[str, Any], key: str) -> bool:
    return bool(facts.get(key, False))


def _as_int(facts: dict[str, Any], key: str, default: int = 0) -> int:
    value = facts.get(key, default)
    if isinstance(value, bool) or not isinstance(value, int) or value < 0:
        raise ValueError(f"{key} must be a non-negative integer")
    return value


def _as_set(facts: dict[str, Any], key: str) -> set[str]:
    value = facts.get(key, [])
    if not isinstance(value, list) or not all(isinstance(item, str) for item in value):
        raise ValueError(f"{key} must be an array of strings")
    return set(value)


def validate_facts(facts: dict[str, Any]) -> None:
    if not isinstance(facts, dict):
        raise ValueError("facts must be an object")

    task_type = facts.get("task_type")
    if task_type not in {
        "bug_fix",
        "small_feature",
        "code_review",
        "test_repair",
        "project_setup",
        "analysis",
    }:
        raise ValueError("facts.task_type is missing or unsupported")

    clarity = facts.get("clarity")
    if clarity not in {"clear", "partial", "unclear"}:
        raise ValueError("facts.clarity must be clear, partial, or unclear")

    _as_int(facts, "estimated_files")
    _as_int(facts, "estimated_modules")
    _as_set(facts, "risk_tags")
    _as_set(facts, "external_actions")


def _plan_score(facts: dict[str, Any], risk_tags: set[str], external_actions: set[str]) -> int:
    score = 0
    files = _as_int(facts, "estimated_files")
    modules = _as_int(facts, "estimated_modules")
    clarity = facts["clarity"]

    if files >= 4:
        score += 2
    if modules >= 2:
        score += 2
    if clarity == "partial":
        score += 2
    elif clarity == "unclear":
        score += 4
    if _as_bool(facts, "requires_network"):
        score += 1
    if _as_bool(facts, "requires_capability_install"):
        score += 2
    if _as_bool(facts, "needs_visual_check"):
        score += 1
    if _as_bool(facts, "difficult_to_rollback"):
        score += 3
    if _as_bool(facts, "dirty_worktree") and _as_bool(facts, "modifies_files"):
        score += 1
    if facts["task_type"] == "small_feature":
        score += 1
    elif facts["task_type"] == "project_setup":
        score += 2
    if external_actions:
        score += 3
    if risk_tags & HARD_PLAN_TAGS:
        score += 4

    return score


def _risk_level(facts: dict[str, Any], risk_tags: set[str], external_actions: set[str]) -> str:
    if risk_tags & RED_RISK_TAGS or external_actions & RED_EXTERNAL_ACTIONS:
        return "red"
    if (
        _as_bool(facts, "modifies_files")
        or _as_bool(facts, "requires_network")
        or _as_bool(facts, "requires_capability_install")
        or external_actions
    ):
        return "yellow"
    return "green"


def _workspace_strategy(facts: dict[str, Any], mode: str, external_actions: set[str]) -> str:
    modifies_files = _as_bool(facts, "modifies_files")
    if not modifies_files:
        return (
            "external_only"
            if external_actions or _as_bool(facts, "requires_capability_install")
            else "read_only"
        )
    if not _as_bool(facts, "git_repo"):
        return "snapshot_workspace"
    if mode == "plan" or _as_bool(facts, "dirty_worktree") or _as_int(facts, "estimated_files") > 1:
        return "isolated_worktree"
    return "current_workspace"


def decide(facts: dict[str, Any]) -> dict[str, Any]:
    """Return an auditable execution recommendation for normalized facts."""

    validate_facts(facts)
    risk_tags = _as_set(facts, "risk_tags")
    external_actions = _as_set(facts, "external_actions")
    score = _plan_score(facts, risk_tags, external_actions)
    hard_plan = bool(risk_tags & HARD_PLAN_TAGS)
    mode = "plan" if hard_plan or score >= 4 else "direct"
    risk_level = _risk_level(facts, risk_tags, external_actions)

    if hard_plan or score >= 7 or facts["clarity"] == "unclear":
        model_tier = "strong"
        reasoning_effort = "high"
    elif _as_bool(facts, "modifies_files") or score >= 3 or _as_bool(facts, "requires_network"):
        model_tier = "balanced"
        reasoning_effort = "medium"
    else:
        model_tier = "fast"
        reasoning_effort = "low"

    blocked = _as_bool(facts, "conflicts_with_constraint") or _as_bool(
        facts, "untrusted_capability"
    )
    if blocked:
        execution_disposition = "blocked"
        approval_timing = "blocked"
    elif risk_level == "red":
        execution_disposition = "approval_required"
        approval_timing = "per_action"
    elif risk_level == "yellow":
        execution_disposition = "approval_required"
        approval_timing = "upfront"
    else:
        execution_disposition = "proceed"
        approval_timing = "none"

    permissions = ["read_workspace"]
    if _as_bool(facts, "modifies_files"):
        permissions.append("write_workspace")
    if _as_bool(facts, "requires_network"):
        permissions.append("network")
    if _as_bool(facts, "requires_capability_install"):
        permissions.append("install_capability")
    permissions.extend(f"external:{action}" for action in sorted(external_actions))

    reviewer = (
        _as_bool(facts, "modifies_files")
        or _as_bool(facts, "requires_capability_install")
        or risk_level == "red"
    )
    stop_conditions = [
        "A required fact cannot be verified from the workspace or an approved source.",
        "The planned change exceeds the approved files, permissions, or external actions.",
        "A required verification fails after the bounded repair loop.",
    ]
    if risk_level == "red":
        stop_conditions.append("A red external action lacks immediate user approval.")
    if blocked:
        stop_conditions.insert(0, "Resolve the blocking constraint or capability trust failure.")

    return {
        "mode": mode,
        "risk_level": risk_level,
        "model_tier": model_tier,
        "reasoning_effort": reasoning_effort,
        "workspace_strategy": _workspace_strategy(facts, mode, external_actions),
        "reviewer": reviewer,
        "approval_timing": approval_timing,
        "execution_disposition": execution_disposition,
        "plan_score": score,
        "permissions": permissions,
        "stop_conditions": stop_conditions,
    }
