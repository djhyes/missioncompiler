from __future__ import annotations

import json
import unittest
from pathlib import Path

from missioncompiler.decision_engine import decide


ROOT = Path(__file__).resolve().parents[1]
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


class DecisionEngineTests(unittest.TestCase):
    def test_all_eval_cases_match_expected_policy(self) -> None:
        cases = json.loads((ROOT / "evals" / "tasks.json").read_text(encoding="utf-8"))
        self.assertEqual(30, len(cases))
        for case in cases:
            with self.subTest(case=case["id"]):
                actual = decide(case["facts"])
                for key in EXPECTED_KEYS:
                    self.assertEqual(case["expected"][key], actual[key])

    def test_red_action_always_requires_per_action_approval(self) -> None:
        result = decide(
            {
                "task_type": "analysis",
                "clarity": "clear",
                "estimated_files": 0,
                "estimated_modules": 0,
                "modifies_files": False,
                "git_repo": False,
                "external_actions": ["send_message"],
                "risk_tags": [],
            }
        )
        self.assertEqual("red", result["risk_level"])
        self.assertEqual("per_action", result["approval_timing"])

    def test_untrusted_capability_fails_closed(self) -> None:
        result = decide(
            {
                "task_type": "project_setup",
                "clarity": "partial",
                "estimated_files": 1,
                "estimated_modules": 1,
                "modifies_files": True,
                "git_repo": True,
                "requires_capability_install": True,
                "untrusted_capability": True,
                "external_actions": [],
                "risk_tags": ["supply_chain"],
            }
        )
        self.assertEqual("blocked", result["execution_disposition"])

    def test_invalid_facts_are_rejected(self) -> None:
        with self.assertRaises(ValueError):
            decide({"task_type": "magic", "clarity": "clear"})


if __name__ == "__main__":
    unittest.main()
