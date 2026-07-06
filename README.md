# quarto-serika

複数の Quarto プロジェクト間で共有するテーマ・フィルタ・テンプレートを、Quarto extension としてまとめたリポジトリ。以前は各プロジェクトに `_scss/` `_includes/` `_filters/` `_csl/` `_reference-docs/` などをコピーして共有していたが、修正が他のプロジェクトへ伝播しない問題があったため、この extension に集約した。

## Extension 一覧

- **`serika/glass`**: Website 用の HTML テーマ(ガラス風ライト/ダーク、`styles.css`、サイドバートグル、Plotly 設定)。
- **`serika/report`**: レポート・卒論用の PDF(2段組・和文LaTeX)/DOCX 出力テンプレート。CSL は APA 圧縮スタイル。
- **`serika/research-slides`**: 研究発表用の revealjs テーマとフィルタ(MathJax の TeX フォント設定)。
- **`serika/japanese-et-al-citeproc`**: 日本語文献の "et al." 表記を調整する citeproc 用 Lua フィルタ。

## 導入方法

利用したいプロジェクトのルートで:

```bash
quarto add /Users/recky/GitHub/quarto-serika --no-prompt
```

リモートリポジトリ化した後は GitHub 経由でも追加できる:

```bash
quarto add <owner>/quarto-serika --no-prompt
```

`_extensions/serika/` 以下に各 extension が vendoring される。

## 更新方法

このリポジトリ側でファイルを修正した後、利用側プロジェクトで再度取り込む:

```bash
quarto add /Users/recky/GitHub/quarto-serika --no-prompt
# または
quarto update
```
