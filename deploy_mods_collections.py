#!/usr/bin/env python3
"""
Mod collection deployer.

Behavior from mod_collection_deployer/specs.md:
- Clean up (delete) existing .zip files in the target Battle Brothers data folder.
- Copy selected mod .zip files from a source folder into the target data folder.
- The selected mod set comes from the .zip files present in the source folder.
"""

from __future__ import annotations

import argparse
import os
import shutil
import sys
from pathlib import Path
from typing import List, Tuple, Union


DEFAULT_SOURCE_DIR = Path(r"E:\battle_brother_mods_collections\reforged")
DEFAULT_DATA_DIR = Path(r"C:\Program Files (x86)\Steam\steamapps\common\Battle Brothers\data")


def _resolve_directory_arg(value: Union[Path, str, None], env_var: str, display_name: str, fallback_dir: Path) -> Path:
	path_text = ""

	if value is not None:
		if isinstance(value, str):
			path_text = value.strip()
		else:
			path_text = str(value).strip()
			if path_text == ".":
				# argparse with optional positional arguments can produce "." when defaulted;
				# treat that as "not provided" so fallback/env can be used.
				path_text = ""
	if path_text == "":
		path_text = os.environ.get(env_var, "").strip()
	if path_text == "":
		path_text = str(fallback_dir)
	if path_text == "":
		raise ValueError(f"{display_name} is required. Provide it as an argument, set {env_var}, or set DEFAULT_{display_name.upper()} in the script.")
	if path_text == "":
		raise ValueError(f"{display_name} is required.")
	return Path(path_text)


def collect_zip_files(source_dir: Path, recursive: bool = False) -> List[Path]:
    """Return a sorted list of .zip files from source_dir."""
    if recursive:
        return sorted(source_dir.rglob("*.zip"))
    return sorted(source_dir.glob("*.zip"))


def cleanup_data_zips(data_dir: Path, dry_run: bool = False) -> Tuple[int, List[Path]]:
    """Delete all .zip files under data_dir recursively."""
    removed = 0
    removed_paths: List[Path] = []

    for path in data_dir.rglob("*.zip"):
        if not path.is_file():
            continue

        removed_paths.append(path)
        if dry_run:
            continue

        try:
            path.unlink()
            removed += 1
        except OSError as err:
            print(f"[WARN] could not delete {path}: {err}", file=sys.stderr)

    return removed if not dry_run else 0, removed_paths


def copy_mod_zips(source_zips: List[Path], data_dir: Path, dry_run: bool = False) -> Tuple[int, List[Path]]:
    """Copy source zip files into data_dir root."""
    copied = 0
    copied_paths: List[Path] = []

    if not data_dir.exists():
        if dry_run:
            print(f"[DRY RUN] would create target directory: {data_dir}")
        else:
            data_dir.mkdir(parents=True, exist_ok=True)

    for src in source_zips:
        dst = data_dir / src.name
        copied_paths.append(dst)
        if dry_run:
            print(f"[DRY RUN] would copy: {src} -> {dst}")
            copied += 1
            continue

        try:
            shutil.copy2(src, dst)
            copied += 1
        except OSError as err:
            print(f"[WARN] could not copy {src} -> {dst}: {err}", file=sys.stderr)

    return copied, copied_paths


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Deploy Battle Brothers mods from .zip files into the game data folder."
    )
    parser.add_argument(
        "source_folder",
        type=Path,
        nargs="?",
        default=None,
        help="Folder containing selected mod .zip files.",
    )
    parser.add_argument(
        "data_folder",
        type=Path,
        nargs="?",
        default=None,
        help="Battle Brothers data folder where mod .zip files are deployed.",
    )
    parser.add_argument(
        "--recursive",
        action="store_true",
        default="true",
        help="Scan source folder recursively for .zip files.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show planned cleanup and copy operations without changing files.",
    )
    parser.add_argument(
        "--no-cleanup",
        action="store_true",
        help="Skip deleting existing .zip files in the data folder.",
    )

    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        source_dir = _resolve_directory_arg(args.source_folder, "BANDAGES_MOD_SOURCE_DIR", "source_folder", DEFAULT_SOURCE_DIR)
        data_dir = _resolve_directory_arg(args.data_folder, "BATTLE_BROTHERS_DATA_DIR", "data_folder", DEFAULT_DATA_DIR)
    except ValueError as err:
        print(f"[ERROR] {err}", file=sys.stderr)
        return 1

    if not source_dir.exists() or not source_dir.is_dir():
        print(f"[ERROR] Source folder not found: {source_dir}", file=sys.stderr)
        return 1

    if not data_dir.exists():
        if args.dry_run:
            print(f"[DRY RUN] would create data folder: {data_dir}")
        else:
            try:
                data_dir.mkdir(parents=True, exist_ok=True)
            except OSError as err:
                print(f"[ERROR] Could not create data folder {data_dir}: {err}", file=sys.stderr)
                return 2

    source_zips = collect_zip_files(source_dir, recursive=args.recursive)
    if not source_zips:
        print(f"[INFO] No .zip files found in source folder: {source_dir}")
        return 0

    print(f"[INFO] Found {len(source_zips)} source zip(s) in {source_dir}:")
    for zip_path in source_zips:
        print(f"  - {zip_path}")

    deleted_count = 0
    if args.no_cleanup:
        print("[INFO] Skipping cleanup because --no-cleanup was set.")
    else:
        print("[INFO] Cleaning up existing .zip files in data folder ...")
        deleted_count, removed_paths = cleanup_data_zips(data_dir, dry_run=args.dry_run)
        print(f"[INFO] {'Would remove' if args.dry_run else 'Removed'} {len(removed_paths)} .zip file(s).")

    copied_count, copied_paths = copy_mod_zips(source_zips, data_dir, dry_run=args.dry_run)
    print(f"[INFO] {'Would copy' if args.dry_run else 'Copied'} {copied_count} mod zip(s).")

    if args.dry_run:
        return 0

    print(f"[INFO] Deployed to: {data_dir}")
    print(f"[INFO] {copied_count} file(s) copied, {deleted_count} old zip file(s) removed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
