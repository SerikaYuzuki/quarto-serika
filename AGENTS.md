# AGENTS.md

## Cursor Cloud specific instructions

This repository is a **Quarto extension** collection (`_extensions/serika/*`: `glass`, `report`,
`research-slides`, `japanese-et-al-citeproc`). There is no compiled application, package manager, or
test framework. The runnable "app" is the `test-site/` Quarto website (the "Serika Glass UI Lab"),
which is used to preview and regression-check the `serika/glass` HTML theme. Most repository docs are
in Japanese; see `README.md` and `test-site/README.md`.

### Toolchain (installed by the environment update script)
- `quarto` (CLI) — the only build tool. Quarto bundles its own `deno`, `pandoc`, and `dart-sass`, so
  no separate Deno/Pandoc install is needed. The `test-site` post-render step
  (`_extensions/serika/glass/build-network.ts`) runs on Quarto's bundled Deno.
- `rsync` — required by `scripts/install.sh`, which vendors `_extensions/serika/` into a target
  Quarto project.

There is **no Python/R/Julia dependency**: the `.qmd` fixtures contain no executable code cells, so
Quarto never invokes Jupyter/knitr. `quarto check` will warn that R/Jupyter are missing — that is
expected and harmless for this repo.

### Render / run the app
- One-shot render (build): `./test-site/render.sh` — this syncs the canonical `_extensions/serika/`
  into `test-site/_extensions/serika/` via `scripts/install.sh`, then runs `quarto render test-site`.
  Output goes to `test-site/_site/` (gitignored).
- Dev server (live reload): `quarto preview test-site --port 4321 --no-browser`. Run `render.sh`
  (or `scripts/install.sh test-site`) at least once first so the extension is present in
  `test-site/_extensions/` (that path is gitignored and not committed).
- Validate the toolchain: `quarto check`.

### Non-obvious caveats
- `render.sh` / `scripts/install.sh test-site` overwrites `test-site/_extensions/serika/` from the
  canonical top-level `_extensions/serika/` using `rsync --delete`. Always edit the canonical
  `_extensions/serika/` files, never the copy under `test-site/`.
- Do **not** run `scripts/install-git-hooks.sh` or `scripts/sync-sibling-sites.sh` in the cloud
  environment. They sync the extension into the maintainer's local sibling checkouts
  (`Developing-Journal`, `PersonalJournal`) and full-render them; those repos do not exist here, so
  the `post-merge` hook / sync will fail. Set `SERIKA_SKIP_SIBLING_SYNC=1` if a merge would trigger
  the hook.
- There is no linter/unit-test setup. The de-facto "test" is a clean full render of `test-site`
  (all pages render and `build-network.ts` reports node/link counts).
