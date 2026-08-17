"""Deploy the owned Battle Brothers mods through modbb."""

from __future__ import annotations

import argparse
import subprocess
from pathlib import Path

DEFAULT_MODS = [
    "mod_developer_test",
    "mod_aura_routing",
    "mod_op_archers",
    "mod_bandages_enhanced",
    "mod_potion_helper",
    "mod_potion_resurrection",
    "mod_dismissal_enhanced",
    "mod_mentor_rookie",
    "mod_level_max",
    "mod_alternate_difficulties"
]

WORKSPACE_ROOT = Path(__file__).resolve().parent.parent


def build_command(mod_dir: Path, has_config: bool) -> list[str] | None:
    if not has_config:
        return None
    return ["modbb"]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--mods",
        nargs="+",
        choices=DEFAULT_MODS,
        default=DEFAULT_MODS,
        help="Mod directories to deploy (default: all owned mods).",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    for mod_name in args.mods:
        mod_dir = WORKSPACE_ROOT / mod_name
        if not mod_dir.is_dir():
            print(f"Missing mod directory: {mod_dir}")
            return 1

        command = build_command(mod_dir, (mod_dir / "mod_config.json").is_file())
        if command is None:
            print(f"Skipping {mod_name}: mod_config.json not found.")
            continue

        print(f"Deploying {mod_name}")
        result = subprocess.run(command, cwd=mod_dir, check=False)
        if result.returncode != 0:
            print(f"Deployment failed for {mod_name} (exit {result.returncode}).")
            return result.returncode

    print("Deployment completed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
