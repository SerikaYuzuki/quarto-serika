#!/usr/bin/env bash
set -euo pipefail

site_dir="$(cd "$(dirname "$0")" && pwd)"
repo_dir="$(cd "$site_dir/.." && pwd)"

"$repo_dir/scripts/install.sh" "$site_dir"
quarto render "$site_dir"

