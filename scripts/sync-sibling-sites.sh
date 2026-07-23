#!/usr/bin/env bash
# quarto-serika を同階層の利用サイトへ同期し、フルレンダーする。
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
parent_dir="$(dirname "$repo_root")"
targets=(
  "$parent_dir/Developing-Journal"
  "$parent_dir/PersonalJournal"
)

ensure_header_include() {
  local config="$1/_quarto.yml"
  local include_file="$2"
  local temp_file

  if rg -Fq "$include_file" "$config"; then
    return
  fi
  if ! rg -q '_extensions/serika/glass/plotly-config\.html' "$config"; then
    echo "error: $config の include-in-header に $include_file を追加できません" >&2
    return 1
  fi

  temp_file="$(mktemp "${TMPDIR:-/tmp}/serika-quarto-yml.XXXXXX")"
  awk -v include_file="$include_file" '
    { print }
    /_extensions\/serika\/glass\/plotly-config\.html/ && !added {
      match($0, /^[[:space:]]*/)
      indent = substr($0, RSTART, RLENGTH)
      print indent "- " include_file
      added = 1
    }
    END { if (!added) exit 1 }
  ' "$config" > "$temp_file"
  mv "$temp_file" "$config"
  echo "configured: $config"
}

ensure_network_post_render() {
  local config="$1/_quarto.yml"
  local hook="_extensions/serika/glass/build-network.ts"
  local temp_file

  if rg -Fq "$hook" "$config"; then
    return
  fi

  temp_file="$(mktemp "${TMPDIR:-/tmp}/serika-quarto-yml.XXXXXX")"
  if rg -q '^[[:space:]]+post-render:[[:space:]]*$' "$config"; then
    awk -v hook="$hook" '
      { print }
      /^[[:space:]]+post-render:[[:space:]]*$/ && !added {
        match($0, /^[[:space:]]*/)
        indent = substr($0, RSTART, RLENGTH)
        print indent "  - " hook
        added = 1
      }
      END { if (!added) exit 1 }
    ' "$config" > "$temp_file"
  else
    awk -v hook="$hook" '
      { print }
      /^[[:space:]]+output-dir:/ && !added {
        match($0, /^[[:space:]]*/)
        indent = substr($0, RSTART, RLENGTH)
        print indent "post-render:"
        print indent "  - " hook
        added = 1
      }
      END { if (!added) exit 1 }
    ' "$config" > "$temp_file"
  fi
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
  ensure_header_include "$target" "_extensions/serika/glass/network.html"
  ensure_header_include "$target" "_extensions/serika/glass/selection-ai.html"
  ensure_network_post_render "$target"
  echo "rendering: $target"
  (cd "$target" && quarto render)
done

echo "sibling sync complete"
