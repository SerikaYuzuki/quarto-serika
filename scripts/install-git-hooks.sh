#!/usr/bin/env bash
# リポジトリ管理下のGitフックを、このcheckoutで有効化する。
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
current_hooks_path="$(git -C "$repo_root" config --local --get core.hooksPath || true)"

if [ -n "$current_hooks_path" ] && [ "$current_hooks_path" != ".githooks" ]; then
  echo "error: core.hooksPath は既に '$current_hooks_path' に設定されています" >&2
  exit 1
fi

chmod +x "$repo_root/.githooks/post-merge" "$repo_root/scripts/sync-sibling-sites.sh"
git -C "$repo_root" config --local core.hooksPath .githooks
echo "installed: core.hooksPath=.githooks"
