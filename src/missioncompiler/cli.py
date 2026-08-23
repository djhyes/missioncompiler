"""Command-line interface for MissionCompiler's deterministic POC policy."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

from .decision_engine import decide


EXPECTED_KEYS = {
    "mode",
    "risk_level",
    "model_tier",
    "reasoning_effort",
    "workspace_strategy",
    "reviewer",
    "approval_timing",
    "execution_disposition",
}


def _load_json(path: str) -> Any:
    return json.loads(Path(path).read_text(encoding="utf-8"))


def _print_json(value: Any) -> None:
    print(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True))


def run_decide(path: str) -> int:
    payload = _load_json(path)
    facts = payload.get("facts", payload) if isinstance(payload, dict) else payload
    _print_json(decide(facts))
    return 0


def run_eval(path: str) -> int:
    cases = _load_json(path)
    if not isinstance(cases, list):
        raise ValueError("eval file must contain a JSON array")

    failures: list[dict[str, Any]] = []
    for case in cases:
        actual = decide(case["facts"])
        expected = case["expected"]
        mismatch = {
            key: {"expected": expected.get(key), "actual": actual.get(key)}
            for key in EXPECTED_KEYS
            if actual.get(key) != expected.get(key)
        }
        if mismatch:
            failures.append({"id": case.get("id"), "mismatch": mismatch})

    summary = {
        "total": len(cases),
        "passed": len(cases) - len(failures),
        "failed": len(failures),
        "failures": failures,
    }
    _print_json(summary)
    return 1 if failures else 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="missioncompiler")
    subparsers = parser.add_subparsers(dest="command", required=True)

    decide_parser = subparsers.add_parser("decide", help="evaluate one normalized facts object")
    decide_parser.add_argument("path")

    eval_parser = subparsers.add_parser("eval", help="evaluate a JSON array of test cases")
    eval_parser.add_argument("path")
    return parser


def main() -> None:
    args = build_parser().parse_args()
    try:
        status = run_decide(args.path) if args.command == "decide" else run_eval(args.path)
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"missioncompiler: {exc}", file=sys.stderr)
        raise SystemExit(2) from exc
    raise SystemExit(status)


if __name__ == "__main__":
    main()
