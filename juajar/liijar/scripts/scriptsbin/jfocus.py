#!/usr/bin/env python3
"""jfocus: scan a directory for out-of-focus images (OpenCV Laplacian variance)."""

import argparse
import subprocess
import sys
from pathlib import Path

import cv2 as cv

EXTS = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tif", ".tiff"}


def notify(msg):
    try:
        subprocess.run(["notify-send", "jfocus", msg], check=False)
    except FileNotFoundError:
        pass


def main():
    ap = argparse.ArgumentParser(description="Find blurry images in a directory.")
    ap.add_argument(
        "directory",
        type=Path,
        nargs="?",
        default=Path.home() / "picjar",
        help="directory to scan (default: ~/picjar)",
    )
    ap.add_argument(
        "-t",
        "--threshold",
        type=float,
        default=15.0,
        help="Laplacian variance below this counts as blurry (default: 15)",
    )
    ap.add_argument(
        "-o",
        "--output",
        type=Path,
        default=Path("blurryimages.txt"),
        help="report file (default: ./blurryimages.txt)",
    )
    args = ap.parse_args()

    root = args.directory
    if not root.is_dir():
        sys.exit(f"jfocus: not a directory: {root}")

    blurry = []
    for path in sorted(root.iterdir()):
        if path.suffix.lower() not in EXTS:
            continue
        image = cv.imread(str(path))
        if image is None:
            continue
        gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
        score = cv.Laplacian(gray, cv.CV_64F).var()
        if score < args.threshold:
            blurry.append((score, path))

    with args.output.open("w") as fh:
        for score, path in blurry:
            fh.write(f"{score:8.2f}  {path.resolve()}\n")

    print(f"{len(blurry)} blurry image(s) written to {args.output}")
    notify(f"{len(blurry)} blurry image(s) -> {args.output}")


if __name__ == "__main__":
    main()
