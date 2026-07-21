#!/usr/bin/env bash
# quarto-serika を同階層の利用サイトへ同期し、フルレンダーする。
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
parent_dir="$(dirname "$repo_root")"
targets=(
  "$parent_dir/Developing-Journal"
  "$parent_dir/PersonalJournal"
)

ensure_selection_ai_include() {
  local config="$1/_quarto.yml"
  local temp_file

  if rg -q '_extensions/serika/glass/selection-ai\.html' "$config"; then
    return
  fi
  if ! rg -q '_extensions/serika/glass/plotly-config\.html' "$config"; then
    echo "error: $config の include-in-header に selection-ai.html を追加できません" >&2
    return 1
  fi

  temp_file="$(mktemp "${TMPDIR:-/tmp}/serika-quarto-yml.XXXXXX")"
  awk '
    { print }
    /_extensions\/serika\/glass\/plotly-config\.html/ && !added {
      match($0, /^[[:space:]]*/)
      indent = substr($0, RSTART, RLENGTH)
      print indent "- _extensions/serika/glass/selection-ai.html"
      added = 1
    }
    END { if (!added) exit 1 }
  ' "$config" > "$temp_file"
  mv "$temp_file" "$config"
  echo "configured: $config"
}

for target in "${targets[@]}"; do
  if [ ! -f "$target/_quarto.yml" ]; then
    echo "error: Quartoプロジェクトが見つかりません: $target" >&2
    exit 1
  fi
  if [ -n "$(git -C "$target" status --porcelain -- _extensions/serika _quarto.yml)" ]; then
    echo "error: 同期対象に未コミット変更があります: $target" >&2
    echo "       _extensions/serika と _quarto.yml を確認してください" >&2
    exit 1
  fi
done

for target in "${targets[@]}"; do
  "$repo_root/scripts/install.sh" "$target"
  ensure_selection_ai_include "$target"
  echo "rendering: $target"
  (cd "$target" && quarto render)
done

echo "sibling sync complete"
