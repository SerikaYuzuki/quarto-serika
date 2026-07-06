#!/usr/bin/env bash
# quarto-serika の extension を対象 Quarto プロジェクトへ vendoring する。
# quarto add はローカルパス/zip からだと _extensions/serika/ の org 階層を
# 落としてしまう (2026-07-06 確認) ため、このスクリプトで直接同期する。
#
# 使い方: scripts/install.sh <Quartoプロジェクトのパス>
set -euo pipefail

target="${1:?usage: scripts/install.sh <path-to-quarto-project>}"
src="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -f "$target/_quarto.yml" ]; then
  echo "error: $target に _quarto.yml が見つからない (Quarto プロジェクトではない)" >&2
  exit 1
fi

mkdir -p "$target/_extensions"
rsync -a --delete "$src/_extensions/serika/" "$target/_extensions/serika/"
echo "installed: $src/_extensions/serika/ -> $target/_extensions/serika/"
