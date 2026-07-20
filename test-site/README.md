# Serika Glass UI Lab

`serika/glass` の変更前後を、固定したコンテンツとレイアウトで比較するローカル専用 Quarto サイト。

## レンダー

```bash
./test-site/render.sh
```

`render.sh` は正本の `_extensions/serika/` を `test-site/_extensions/serika/` へ同期してからレンダーする。同期先と `_site/` は生成物なので Git 管理しない。

## ページ

- `index.qmd`: タイポグラフィ、連続 callout、全 callout 種、各種表、コード、数式、タブ、引用の標本。
- `layout-states.qmd`: 左 sidebar・本文・右 TOC の4状態／8遷移、長いタイトル、スクロール連動の標本。

## 基本の確認条件

- Light / Dark
- 1440 / 1280 / 1024 / 768 / 390 px
- 左 sidebar と右 TOC の表示組合せ4種、遷移8方向
- 通常 motion / `prefers-reduced-motion: reduce`
- キーボードのみ、200% zoom、印刷プレビュー

