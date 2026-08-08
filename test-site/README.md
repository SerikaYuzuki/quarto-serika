# Serika Glass UI Lab

`serika/glass` の変更前後を、固定したコンテンツとレイアウトで比較するローカル専用 Quarto サイト。ショーケース（listing・星図・HUD）と回帰標本を同居させる。

## レンダー

```bash
./test-site/render.sh
```

`render.sh` は正本の `_extensions/serika/` を `test-site/_extensions/serika/` へ同期してからレンダーする。同期先と `_site/` は生成物なので Git 管理しない。

## ページ

| ページ | 役割 |
|:--|:--|
| `index.qmd` | Lab hub + 星座 listing カード |
| `playground.qmd` | callout / copy / TOC / selection AI / theme の操作カタログ |
| `long-read.qmd` | 読書 HUD・チャプター・完読の長文標本 |
| `components.qmd` | タイポ・表・コード・数式・タブの視覚標本 |
| `layout-states.qmd` | 左右レール 4 状態 / 8 遷移 |
| `posts/*.qmd` | 相互リンク付き fixture（星図デモ） |

## 基本の確認条件

- Light / Dark
- 1440 / 1280 / 1024 / 768 / 390 px
- Listing カード hover（星の瞬き・軌道回転）、navbar 星図
- 読書 HUD 完読、callout / copy、TOC sliding marker
- 左 sidebar と右 TOC の表示組合せ 4 種、遷移 8 方向
- ≥992px ではレール表示時に本文を押し広げ、TOC/sidebar が本文に重ならないこと
- 390px ではページ左右の余白がほぼ無く、safe-area 以外は端まで使うこと
- 通常 motion / `prefers-reduced-motion: reduce`
- キーボードのみ、200% zoom
- 本文ページで常時装飾が増えていないこと
