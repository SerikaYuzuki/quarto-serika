# quarto-serika

複数の Quarto プロジェクト間で共有するテーマ・フィルタ・テンプレートを、Quarto extension としてまとめたリポジトリ。以前は各プロジェクトに `_scss/` `_includes/` `_filters/` `_csl/` `_reference-docs/` などをコピーして共有していたが、修正が他のプロジェクトへ伝播しない問題があったため、この extension に集約した。

## Extension 一覧

- **`serika/glass`**: Website 用の HTML テーマ(ガラス風ライト/ダーク、`styles.css`、サイドバートグル、Plotly 設定)。
- **`serika/report`**: レポート・卒論用の PDF(2段組・和文LaTeX)/DOCX 出力テンプレート。CSL は APA 圧縮スタイル。
- **`serika/research-slides`**: 研究発表用の revealjs テーマとフィルタ(MathJax の TeX フォント設定)。
- **`serika/japanese-et-al-citeproc`**: 日本語文献の "et al." 表記を調整する citeproc 用 Lua フィルタ。

## 導入方法・更新方法

導入も更新も同じで、付属スクリプトで対象プロジェクトへ同期する:

```bash
/Users/recky/GitHub/quarto-serika/scripts/install.sh <Quartoプロジェクトのパス>
```

`_extensions/serika/` 以下に各 extension が vendoring される(対象側の `_extensions/serika/` はこのリポジトリの内容で完全に置き換えられる)。修正はこのリポジトリ側で行い、利用側プロジェクトで再度スクリプトを実行して取り込む。

⚠️ `quarto add` はどの形式でも使わないこと(Quarto 1.8.27 で確認):

- ローカルパス / `.zip` から: `_extensions/<name>/` になり `serika/` の org 階層が飛ぶ。
- GitHub から (`quarto add SerikaYuzuki/quarto-serika`): `_extensions/SerikaYuzuki/<name>/` になる(GitHub のオーナー名が org 階層になる。2026-07-07 確認)。

いずれも利用側の `_extensions/serika/...` パス参照が壊れるため、導入・更新は常に `scripts/install.sh` で行う。別マシンでは `git clone https://github.com/SerikaYuzuki/quarto-serika` してから同スクリプトを実行する。

## 利用側プロジェクトの注意

- `.gitignore` で `*.html` や `*.docx` を広く ignore しているプロジェクトでは、`!_extensions/**` の例外を追加すること。これがないと vendoring された `sidebar-toggle.html` や `report.docx` がコミットされず、他のマシンでレンダーが壊れる。
- vendoring された `_extensions/serika/` は直接編集しない(次回同期で消える)。
- `serika/glass` は TOC のあるページでデスクトップ navbar に目次切替ボタンを表示する。表示状態は同じタブ内のページ遷移でも維持される。
