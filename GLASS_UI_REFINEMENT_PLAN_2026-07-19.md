# Serika Glass UI 洗練計画

作成日: 2026-07-19  
状態: **採用方針確定。テーマ本体の実装変更は未実施**  
対象: `_extensions/serika/glass/`

## 0. 結論

採用した方向は、**Glass Frame / Paper Content** である。

- 現在のグラデーション、floating navbar、色、丸み、左右ナビゲーションは残す。
- Glass は「サイトの枠・操作部・一部のカード」に集中させる。
- 本文、表、展開後の callout は、印刷物に近い平面と組版へ戻す。
- 情報密度は文字を小さくして稼がず、重複した囲いと余白を減らして上げる。
- 遊びは常時動く装飾ではなく、開閉、コピー完了、現在位置など操作への応答として加える。

比較した案は次の三つで、Cを採用した。

| 案 | 内容 | 向いている判断 |
|:--|:--|:--|
| A. 最小 | 左右レール不具合、対称性、表の脱Glass、操作のアクセシビリティ | まず明白な欠点だけ直したい |
| B. 推奨 | A + 本文組版、title、callout、responsive、基本モーション。printは任意 | 見た目を保ちながら全体を一段洗練したい |
| **C. 遊び強化（採用）** | B + TOC marker、callout固有反応、copy成功、footnote反応等 | Bの安定後、触って楽しい質感を足したい |

**採用範囲はC。** AとBを土台にP2をすべて試す。ただしprintは初回実装から外し、各遊びは一つずつ検証して、読む速度を落とさないものだけ残す。

### 0.1 採用決定（2026-07-19）

| 論点 | 決定 | 実装上の解釈 |
|:--|:--|:--|
| 採用範囲 | C | A + B + P2を実施する |
| 基本思想 | Glass Frame / Paper Content | 操作面にGlass、読む面にPaperの文法を使う |
| 992–1279px | 左右railをoverlay | 片側だけが本文を押す構造を作らない |
| mobile TOC | Navigation sheetへ統合 | `サイト / このページ` を同一sheet内で切り替える |
| 通常表のrow hover | ごく薄く残す | hover対応pointerだけで3–5%程度。移動・拡大はしない |
| callout accent notch | 残す | icon色と短いnotchを併用し、全高の太い左罫は外す |
| P2 | 全て試す | 下記の順番で一つずつ導入し、個別に残すか確認する |
| print | 初回対象外 | 設計案とfixtureは残すが、初回acceptance gateにはしない |

## 1. 変えないもの

大まかな見た目を維持するため、次はデザインの核として残す。

- light / dark の色世界と、ゆっくり動く背景グラデーション
- 画面上部の floating pill navbar
- 左 sidebar、中央本文、右 TOC という空間モデル
- Inter / Hiragino Sans / Noto Sans JP / system-ui 系の現在のフォント方向
- callout の「理論=青」「解答=緑」など意味色
- 適度な角丸と、操作部を触ったときの軽い浮遊感
- Quarto の標準HTML、見出し、表、calloutを大きく書き換えず使えること

本計画は「別テーマへの作り直し」ではなく、現在のテーマ内で役割を整理する計画である。

## 2. 確認済みの現状

### 2.1 コード上の構造

- bodyの基本行高は light / dark とも `1.7`。
- title block は `2.5rem 2.75rem` の padding、タイトルは `2.6rem`。
- callout は外周Glass、4px左罫、Glassの円形アイコンを重ねている。
- 表は `table, .table` 全体へGlass、blur、影、18px角丸、行hoverを付けている。
- 左開閉と右開閉は、同じ `.page-columns .content` の単一 `animation` を別々に指定している。
- 左レールの開閉幅は250px固定だが、グリッド側は232px、18px、1.5remなど別の値で構成されている。
- 開閉アニメーションは992px以上、独自の対称グリッドは1400px以上で、適用境界が一致していない。
- reduced motion は背景と右TOC周辺の一部だけで、左sidebar、navbar、drawer、card、buttonには漏れがある。
- 左トグルは `<a href="#">`、右トグルは `<button>` で、ARIAと保存方針も左右非対称。

主な参照箇所:

- `_extensions/serika/glass/styles.css` 98–213行: 左右レールと本文のアニメーション
- `_extensions/serika/glass/styles.css` 250–270行: 1400px以上の独自グリッド
- `_extensions/serika/glass/sidebar-toggle.html` 47–113行: 右TOCの状態
- `_extensions/serika/glass/sidebar-toggle.html` 234–254行: 左sidebarの状態
- `_extensions/serika/glass/theme-glass-*.scss` 334行付近: title block
- `_extensions/serika/glass/theme-glass-*.scss` 394行付近: callout
- `_extensions/serika/glass/theme-glass-*.scss` 442行付近: table

### 2.2 実ページでの視覚ベースライン

専用fixtureを Quarto 1.8.27 でレンダーし、Chromiumで確認した。

| 条件 | 実測・観察 |
|:--|:--|
| 既存記事、1280×720 | 閉じたcalloutは高さ約42.3px、上下marginは各約29.8px。行そのものより行間が密度を下げている |
| 既存記事の表 | 5行で高さ約210.5px、文字約15.3px、行高約21.7px。18px角丸、blur、強いshadowが表よりカードを先に見せる |
| 1440px、左右表示 | 本文外側余白は左305.5px / 右305.5pxで対称 |
| 1440px、左右非表示 | 左30px / 右48px。右に18px残り、本文中心が9px左へずれる |
| 1280px、左右非表示 | 左25.5px / 右75.5px。独自グリッド外では差が約50pxまで広がる |
| 1024px、左右表示 | 左250px + 本文約541px + 右約191px。本文が狭く、長いtitleが早く折り返す |
| 390px | 横overflowは出ないが、長いtitle blockが339×約660pxとなり、一画面の大半を占める。TOC操作は非表示 |
| 390px drawer | drawerは開くが、focusは背後のhamburgerリンクに残る |

このため、情報密度は「calloutをさらに低くする」「本文文字を小さくする」より、**callout間隔、title block、重複面、狭い幅でのレール方式**から改善するのが妥当である。

### 2.3 左右アニメーションの再現結果

`V=表示 / H=非表示`。全4状態・8方向を専用fixtureで操作した。

| No. | 遷移 | 現状 |
|--:|:--|:--|
| 1 | VV → HV: 左を隠す | 動くが、250px固定値と実track差により開始端で段差が出る |
| 2 | HV → VV: 左を出す | 動くが、終了端で段差が出る |
| 3 | VV → VH: 右を隠す | 動くが、右端に小さな段差が出る |
| 4 | VH → VV: 右を出す | 動くが、終了端に小さな段差が出る |
| 5 | HV → HH: 右を隠す | 右側は再生する |
| 6 | HH → HV: 右を出す | 右終了後、無関係な左paddingアニメーションがもう一度走る |
| **7** | **VH → HH: 左を隠す** | **本文側が不発。左sidebarだけfadeし、本文は即時ジャンプ** |
| **8** | **HH → VH: 左を出す** | **本文側が不発。約400ms後に本文がジャンプ** |

原因はCSSカスケードである。

1. 左用 `expandContent / shrinkContent` と右用 `pj-expand-toc-space / pj-shrink-toc-space` が、同じ要素の `animation` を設定する。
2. 右用規則が後にあり、同じ詳細度なので常に勝つ。
3. `forwards` の完了済み右アニメーションが残る。
4. 右を隠したまま左を操作しても `animation-name` が変わらず、左用keyframeが始まらない。
5. `pj-toc-showing` を400ms後に外すと、逆に左の永続アニメーションが再び有効となり、No.6の二段動作が起きる。

## 3. デザイン原則

1. **Glassは枠、Paperは読む面。**
2. **対称性は外枠、余白、操作スロットで作る。** 文章量や左右バー内の項目数は無理に揃えない。
3. **密度は余白の重複を減らして上げる。** 本文16px未満への縮小を主手段にしない。
4. **遊びは状態の説明に使う。** 常時動くものを増やさない。
5. **一つの部品に主役の囲いは一つ、主役の動きも一つ。**
6. **最終配置を状態として定義し、アニメーションを状態そのものにしない。**

## 4. 足し算と引き算

| 対象 | 引く | 足す |
|:--|:--|:--|
| 全体 | Glassの多重使用、場所ごとの任意寸法 | frame / rail / spacing / motion token |
| 本文 | 一律に広い構造余白、長すぎる行 | 日本語向け行長、段落・リスト別リズム |
| title | モバイルでも2.6rem、大きい固定padding | `clamp()`、画面幅に応じるpadding |
| callout | 全高の太い左罫、外周+アイコンの二重Glass、約30pxの上下margin | 左右同幅の操作slot、短いaccent、明確なopen状態 |
| 表 | blur、影、大角丸、常時hover、uppercase | booktabs風横罫、caption、数値揃え、overflow案内 |
| 左右レール | 競合keyframe、固定250px、`showing`一時クラス | 4状態、左右独立変数、共通rail幅 |
| モーション | `transition: all`、固定timer、無差別な登場演出 | duration / easing token、操作に対応したfeedback |
| 色 | opacityだけで薄くしたlabel、色だけの状態 | 十分なcontrast、形・太さ・iconの併用 |
| モバイル | TOCへの入口消失、focusが背後に残るdrawer | ナビ統合、focus管理、同等の左右アクセス |

## 5. 提案仕様

### 5.1 Frame、レール、対称性

navbar、本文、footerで同じframe tokenを使う。

| Token | 初期候補 |
|:--|:--|
| frame最大幅 | 現行を尊重して1380px |
| frame外側余白 | desktop 24px / tablet 20px / mobile 16px |
| 左右レール予約幅 | 共通232pxを基準に検証 |
| 本文とのgutter | 24px |
| prose最大幅 | 42–46remを基準。表・図・コードはwide幅を許可 |

重要なのは、左右を消したときにすべての本文を際限なく横へ伸ばさないことである。

- 通常の文章は可読幅を保ち、frame内で中央に置く。
- 表、図、コード、比較gridだけが解放された幅を使える。
- 片側だけ閉じた場合も、非操作側の辺を固定する。
- 両側同状態では左右余白差を1px以内にする。
- 左右のicon中心、gutter、toggle hit areaは同じtokenから作る。

#### Breakpoint方針

| 幅 | 提案 |
|:--|:--|
| 1280px以上 | 左・中央・右のpush layout。左右は同じ予約幅 |
| 992–1279px | 左右ともoverlay sheet。片側だけが本文を押して中心を崩す構造を避ける |
| 991px以下 | 単一Navigation sheetへ統合し、「サイト / このページ」の2tabでsidebarとTOCを切り替える |

現行の `992pxでanimation開始 / 1400pxで独自grid開始` という不一致は廃止する。

### 5.2 左右レールの状態モデル

安定状態は次の4つだけにする。

| left | right |
|:--|:--|
| open | open |
| closed | open |
| open | closed |
| closed | closed |

実装時の設計条件:

- 一つのlayout rootへ `data-left-rail` と `data-right-rail` を持たせる。
- 永続状態セレクタから `animation` を除き、最終配置だけを定義する。
- `--left-reserve` と `--right-reserve` を別propertyとして遷移させる。
- 同じ要素の単一 `animation` を左右で奪い合わない。
- grid trackを使う場合は、全状態で同じtrack構造を保ち、数値だけ変える。
- 固定400ms timerを状態の本体にしない。必要なcleanupは `transitionend` で行う。
- 連打時は現在の中間値から反転し、古いtimerが新しい状態を壊さない。
- 初期復元は描画前に適用し、最初の1frameではtransitionを無効化する。
- 左右とも `button`、`aria-expanded`、`aria-controls`、`aria-hidden`、`inert`、保存方針を揃える。
- 保存は「同一tab内だけ」など一つの方針に統一する。右だけ残る現状はやめる。

### 5.3 タイポグラフィと密度

目標は、本文の読みやすさを落とさず、主要ページの一画面あたり情報量を約15–25%増やすこと。

| 要素 | 現状の主値 | 提案初期値 |
|:--|:--|:--|
| 本文 | 実ページ約15.3px、line-height 1.7 | 16pxを下限、line-height 1.62–1.68 |
| 段落間 | Bootstrap / Quartoとテーマ規則が混在 | 0.75–0.9em |
| list項目間 | 共通リズムなし | 0.25–0.4em |
| article title | 2.6rem固定 | `clamp(2rem, 3.2vw, 2.4rem)`を起点に比較 |
| h2 | theme固有scaleなし | 約1.5–1.65rem |
| h3 | theme固有scaleなし | 約1.22–1.35rem |
| 小label | 0.65–0.72rem、低opacityあり | 原則0.75rem以上、色tokenでcontrast確保 |
| spacing | 0.4rem、0.875rem、1.75rem等が分散 | 4 / 8 / 12 / 16 / 24 / 32 / 48px scale |

追加方針:

- 日本語見出しには強い負のletter-spacingやuppercaseを使わない。
- 表の数字だけ `tabular-nums` を使う。
- 数式、コード、図の前後は本文より少し広く残す。
- フォントは現行stackを維持し、新しい外部web fontは原則追加しない。
- `Inter` は現在「指定のみ」で同梱されていないため、将来はsystem stackへ意図的に寄せるか、正式同梱するか決める。
- `main, .content, #quarto-content` のように複数階層へ同じ上余白を指定せず、navbar clearanceの責任要素を一つにする。

### 5.4 Title block

大きな見た目は残すが、固定値を減らす。

- desktop padding: 現行40px / 44px相当から、まず32px / 36px程度を比較。
- mobile padding: 20–24px程度。
- 長いtitleはmobileで2rem前後まで下がる `clamp()` を使う。
- categories、description、author、publishedの縦間隔を8 / 12 / 16px scaleへ揃える。
- metadataは視線の流れに合わせ、2列が狭い場合は無理に横並びを維持しない。
- Glassとshadowは残すが、本文直前の下marginを縮める。

### 5.5 Callout / 理論・解答

現在の色、icon、丸い行、chevronは残す。左側だけ重い状態を解消する。

#### 引く

- 外周全高に沿う4pxの色付き左罫
- 外周Glass + icon内Glassの二重blur / 二重border
- 閉じた行の上下に各約30pxあるmargin
- bodyとheaderで揃っていない文字開始位置

#### 足す

- headerを `操作slot / 1fr / 操作slot` の3列にする。
- 左右slotは同じ40–44px、実hit areaは最低44×44px。
- 色はicon、title、高さ16px程度の短いaccent notchで示す。notchは採用し、全高の太い左罫とは区別する。
- 折りたたみ行の高さは44–48pxを起点に比較する。
- 連続calloutの間隔は12–16pxを起点にする。
- open時はheader下へ細い区切りを一つだけ置く。
- body左端をtitle本文の開始位置へ揃える。
- 二行titleは中央列だけが折り返し、左右操作位置を動かさない。

#### 遊び

- chevronを160–220msで回転。
- 理論iconは輪郭が一度だけ明るくなる。
- 解答iconは電球のfillが一度だけ点灯する。
- bodyはBootstrapの高さ変化に合わせ、opacityと4–6px以内の移動を一度だけ行う。
- open中に常時発光させない。

### 5.6 表を「印刷物」にする

「白い紙カード」を新しく置くのではなく、light / dark双方で印刷物の文法を使う。

#### 基本

- table本体のGlass、backdrop-filter、shadow、大角丸、全面背景を削除。
- `border-collapse: collapse` を基本にする。
- 縦罫線は原則使わない。
- table上端、thead下、table下端に強弱を付けた横罫を使う。
- headerのuppercaseと大きなletter-spacingを削除。
- headerは本文より少し小さく、weight 650–700相当。
- cell paddingは縦0.5rem前後、横0.65–0.8remを起点にする。
- 文字列は左、数値は右。Pandocのalign指定を壊さない。
- 数値列へ `font-variant-numeric: tabular-nums`。
- 通常表にもごく薄いrow hoverを残す。`hover: hover` の環境だけで3–5%程度の色差とし、移動、拡大、cursor変更は加えない。
- クリック可能・sortableな表は、別途hover / focusで操作可能性を明示する。
- zebraが必要なら3–5%程度の薄さにする。
- captionは上、出典・注記は下。caption自体にも番号と本文の階層を付ける。
- dark modeも白いカードにはせず、透明面 + 明暗の罫線で表現する。

#### Scope

`table, .table` という全域指定は広すぎる。

- 通常のPandoc本文表を基本対象にする。
- `gt`、DataTables、Plotly、レイアウト用table等が独自styleを維持できる除外規則を用意する。
- row header (`tbody th`)、tfoot、caption、複数段headerをfixtureへ加える。

#### 狭い画面

- 表だけを横scrollできるwrapperへ入れる。
- body全体に横overflowを出さない。
- overflowがあるときだけ端へ薄いfadeを出す。
- wrapperをkeyboard focus可能にし、表のcaptionをaccessible nameへ使う。
- すべての表をmobile cardへ変換しない。見出しとcellの対応が壊れるため。
- sticky header / first columnは長大表で明示した場合だけ。

#### Print（将来対応・初回対象外）

初回実装には含めないが、将来 `@media print` を追加する場合は次を行う。

- 背景、navbar、sidebar、TOC、blur、shadowを削除。
- 黒い本文と実線のtable ruleへ切り替える。
- theadを改ページ後も反復する。
- table rowの不用意な分断を避ける。
- 折りたたみcalloutはすべて展開する。
- link先を必要に応じて印字する。

### 5.7 遊びとモーション

#### P2採用順（全て試す）

1. calloutのchevron回転とiconの一度だけの反応
2. code copy成功時にcopy iconがcheckへ変わる
3. anchor linkの下線と、footnoteから戻った箇所の短いhighlight
4. TOC active markerが次の項目へ滑らかに移る
5. theme切替の短いcolor crossfade

navbar、drawer、左右railのeasing統一はP2ではなく、P0 / P1のlayout修正に含める。

#### 任意

- interactive cardの1–2px lift
- 見出しanchorのhover / focus表示
- figure captionの短いfade
- 検索結果へ移動した際の一度だけのmarker

#### 入れない

- 全段落のscroll reveal
- 常時脈動するbutton
- confetti、音、cursor追従、3D tilt
- 静的table行の移動、拡大、強い発光など、薄い背景hoverを超える演出
- 複数要素が別周期で常時動く状態

#### Motion token

| 種類 | 候補 |
|:--|:--|
| micro | 120–180ms |
| disclosure | 220–280ms |
| rail / drawer | 320–400ms |
| 通常の移動量 | rail以外は8px以内 |
| easing | standard / emphasized の2種類程度 |

`transition: all` は使わず、propertyを明記する。

### 5.8 Reduced motion

`prefers-reduced-motion: reduce` では次を止める。

- 背景drift
- navbar自動退避
- rail / drawerの位置移動
- card lift
- callout icon反応
- theme crossfade

状態変化、表示／非表示、focus移動は残す。透明な不可視要素が操作を塞がないことも確認する。

### 5.9 アクセシビリティ

- 通常文字4.5:1、UI境界と大文字3:1以上。
- muted textをopacityだけで薄くしない。
- 色だけでcallout種別、active、open状態を表さない。
- 見た目がcompactでも主要操作は44×44pxを確保。
- 左右トグルを両方buttonにする。
- drawer open時は先頭操作へfocus、close時は起点へ戻す。
- drawerへfocus trapを付ける。
- hidden railへ `aria-hidden` と `inert` を同期する。
- disclosureの `aria-expanded` / `aria-controls` を同期する。
- tableのcaption、`th`、`scope`を保つ。
- `:focus-visible` をhover以上に明確にする。
- 320px、200% zoom、forced colorsを確認する。

## 6. 実装時の整理案

light / dark SCSSは約660行ずつ重複している。調整を二重実装するとdriftするため、実装時は共通規則をpartialへ寄せる。

想定する責務:

| ファイル / 責務 | 内容 |
|:--|:--|
| theme light / dark | 色token、背景、theme固有contrastのみ |
| common tokens | frame、rail、spacing、type、motion、surface |
| common components | title、callout、table、code、listing、forms |
| `styles.css` | Quarto DOM補正、layout state、drawer、utility |
| `sidebar-toggle.html` | 左右共通state controller、ARIA、保存、focus |
| print rules（将来） | Glass解除、table、callout展開、改ページ。初回実装には含めない |

ただし、構造整理自体を最初の変更にしない。fixtureを固定し、P0の挙動を直してから共通化する。

## 7. 専用テストサイト

この計画の検討用に、リポジトリ内へローカル専用 Quarto siteを追加した。テーマ本体は変更していない。

### 構成

- `test-site/index.qmd`: typography、連続callout、全callout種、複数table、code、数式、tab、引用。
- `test-site/layout-states.qmd`: 左右4状態 / 8遷移、長いtitle、中央目印、scroll連動。
- `test-site/_quarto.yml`: 本番と同じglass extension構成。
- `test-site/render.sh`: 正本extensionをfixtureへ同期してrender。
- `test-site/README.md`: 使い方と基本条件。

### 実行

```bash
./test-site/render.sh
```

生成される `test-site/_extensions/`、`test-site/.quarto/`、`test-site/_site/` はGit管理しない。

### 今回確認した範囲

- Quarto 1.8.27で2ページのrender成功。
- Chromiumでlight / dark切替UIと主要DOMを確認。
- 1280 / 1440 / 1024 / 390pxを確認。
- 左右4状態 / 8方向を実操作し、No.6 / 7 / 8の不具合を再現。
- 390pxでbody横overflowなし、drawer focus不備とTOC入口欠如を確認。

未確認:

- Safari / Firefox
- Windows / Linuxでのfont差
- screen reader実機
- forced colors
- A4 printの目視（将来のprint対応時）
- 200% zoom
- 自動screenshot差分

これらは実装時のacceptanceへ入れる。

## 8. 受け入れ基準

### Layout / motion

- 8方向すべてで対象側の変化が一度だけ再生される。
- 非操作側の本文端はアニメーション中も±1px以内。
- 本文幅が単調に変化し、開始・終了フレームでsnapしない。
- 完了後に不要なpadding、animation、`showing` classが残らない。
- 連打時に現在位置から自然に反転し、最終stateとARIAが一致する。
- 両rail同状態時の左右余白差は1px以内。

### Typography / density

- 本文を16px未満へ縮小せず、主要ページの一画面情報量が約15–25%増える。
- 日本語本文の一行が長くなりすぎない。
- 390pxの長いtitle fixtureで、titleだけが一画面の大半を占めない。
- 200% zoomでも本文と操作が切れない。

### Callout

- 連続した理論 / 解答で左右slot中心と文字baselineが揃う。
- closed / opening / open / closingでborderが二重化しない。
- 二行titleでもiconとchevron位置が崩れない。
- keyboardとscreen readerで開閉状態が伝わる。

### Table

- Glass、blur、shadow、大角丸が通常表から消える。
- 文字列 / 数値 / 単位の対応が一目で追える。
- body全体に横scrollを出さず、wide tableだけscrollできる。
- keyboardでも横scrollできる。
- caption、row header、tfoot、数式、inline codeを含む表が崩れない。
- 初回対象のlight / darkでruleと文字contrastが保たれる。
- printは将来対応へ移し、初回acceptance gateには含めない。

### Accessibility

- axe等の自動検査で重大違反なし。
- その後にkeyboard、focus順、drawer復帰、screen readerを手動確認。
- reduced motionで背景drift、layout移動、liftが残らない。

## 9. 実施順

### P0: 必須

1. fixtureと測定条件を固定。
2. 左右4状態を一元化し、animation競合、固定timer、250px固定値を解消。
3. frame / rail / gutterを共通token化し、左右終端を鏡像にする。
4. 左右toggleのbutton semantics、ARIA、hidden / inertを統一。
5. reduced motionを全motionへ適用。
6. 通常tableのGlass囲いを削除。

### P1: 推奨

1. title blockと本文組版のresponsive scale。
2. calloutの左右重量、間隔、open状態。
3. wide table、caption、薄いrow hover。
4. 992–1279pxのoverlay化、mobile Navigation sheetへのTOC統合。
5. drawerのfocus trap / focus return。
6. light / dark共通component規則のpartial化。

### P2: 遊び

1. callout icon / chevron。
2. code copy成功feedback。
3. anchor / footnote feedback。
4. TOC active marker。
5. theme crossfade。

上記はすべて採用し、この順で一つずつ導入・検証する。

### P3: 初回対象外

- print stylesheet。設計案とfixtureは維持し、初回実装完了後に必要性を再判断する

### 不採用

- 全段落scroll reveal
- 複雑なicon morph
- pointer追従演出
- 装飾的な常時animation
- 薄い背景色変化を超える静的tableの過剰なhover

## 10. 実装時のリスク

- Quarto / Bootstrapのcompiled CSSはspecificityが高く、theme内の単純selectorが上書きされる箇所がある。fixtureのcomputed styleで確認する。
- `table, .table` の変更はDataTables等へ波及し得る。通常Pandoc表へscopeを絞る。
- Bootstrap collapseのHTML classはQuarto version差を受け得る。1.8.27を基準にし、最低対応versionも確認する。
- vendoring先を直接直すと次回同期で消える。正本は常にこのrepo、consumer確認前に `scripts/install.sh` を使う。
- grid track animationはSafari差があり得る。左右独立padding変数案と比較し、実機で決める。
- 新しいfontを安易に配信すると、速度、privacy、offline性が悪化する。今回は追加しない前提。

## 11. 採用判断チェック

- [x] Cを採用する（A + B + P2全て）
- [x] Glass Frame / Paper Contentを基本方針にする
- [x] 992–1279pxで左右railをoverlayにする
- [x] mobile TOCをNavigation sheetへ統合する
- [x] 通常表のrow hoverをごく薄く残す
- [x] calloutの短いaccent notchを残す
- [x] P2を全て試す。順序はcallout → copy → anchor / footnote → TOC → theme
- [x] printを初回実装から外す

確定した初回スコープは、**P0 → P1（printを除く）→ P2全て**である。各段階を別の変更単位にし、P0完了時点で「現在らしさが残る」「表が明確に読みやすい」「左右操作が順番に依存しない」を確認してから次へ進む。
