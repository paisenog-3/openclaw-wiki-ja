---
title: "このWikiへの貢献方法"
weight: 100
description: "OpenClaw日本語WikiへPull Requestを送る方法と記事執筆ガイドライン"
tags: ["貢献", "コミュニティ", "執筆ガイド"]
bookToc: true
---

# このWikiへの貢献方法

OpenClaw 日本語活用Wikiへのご貢献ありがとうございます！

このページでは、記事の追加・修正方法を解説します。

---

## 貢献の種類

以下のような貢献を歓迎します：

- ✅ **新しい記事の追加** - あなたの知見を共有
- ✅ **既存記事の改善** - より分かりやすく
- ✅ **誤字・リンク切れの修正** - 小さな修正も大歓迎
- ✅ **画像・図解の追加** - 視覚的に分かりやすく
- ✅ **翻訳の改善** - より自然な日本語に
- ✅ **サンプルコードの追加** - 実例で理解を促進

---

## 貢献の流れ

### ステップ1: リポジトリをFork

1. [GitHubリポジトリ](https://github.com/YOUR-USERNAME/openclaw-wiki-ja)にアクセス
2. 右上の **Fork** ボタンをクリック
3. あなたのアカウントにリポジトリがコピーされます

### ステップ2: ローカルにクローン

```bash
# Forkしたリポジトリをクローン
git clone https://github.com/YOUR-USERNAME/openclaw-wiki-ja.git
cd openclaw-wiki-ja

# テーマのsubmoduleを取得
git submodule update --init --recursive
```

### ステップ3: ブランチを作成

```bash
# 作業用ブランチを作成
git checkout -b add/article-name

# ブランチ名の例:
# - add/new-feature-guide (新規記事追加)
# - fix/typo-in-setup (誤字修正)
# - improve/webchat-settings (記事改善)
```

### ステップ4: 記事を作成・編集

#### 新規記事の作成

Hugoコマンドで記事のテンプレートを生成：

```bash
# 例: セットアップカテゴリに新規記事を追加
hugo new content/setup/new-article.md

# 例: カスタマイズカテゴリに新規記事を追加
hugo new content/customize/new-customization.md
```

生成されたファイルを編集して、内容を書いていきます。

#### 既存記事の編集

`content/` ディレクトリ内の対象ファイルを直接編集します。

```bash
# 例
vim content/setup/getting-started.md
```

### ステップ5: ローカルでプレビュー

記事を書いたら、ローカルでプレビューして確認します。

```bash
# Hugoサーバーを起動
hugo server -D

# ブラウザで確認
# http://localhost:1313
```

- `-D` オプション: 下書き（draft: true）の記事も表示

### ステップ6: コミット

変更をコミットします。

```bash
# 変更をステージング
git add content/setup/new-article.md

# コミット
git commit -m "Add: 新しいセットアップガイド記事を追加"
```

#### コミットメッセージの書き方

```
Add: 新規記事の追加
Update: 既存記事の更新
Fix: 誤字・リンク修正
Improve: 内容の改善
```

### ステップ7: Pushとプルリクエスト

```bash
# Forkしたリポジトリにプッシュ
git push origin add/article-name
```

GitHubでプルリクエストを作成：

1. あなたのForkリポジトリページを開く
2. **Compare & pull request** ボタンをクリック
3. タイトルと説明を記入
4. **Create pull request** をクリック

---

## 記事の書き方

### ファイル配置ルール

適切なカテゴリに記事を配置してください：

| ディレクトリ | 用途 |
|-------------|------|
| `content/setup/` | セットアップ・インストール関連 |
| `content/customize/` | カスタマイズ・設定関連 |
| `content/use-cases/` | 活用事例 |
| `content/troubleshooting/` | トラブルシューティング |
| `content/tips/` | Tips & Tricks |
| `content/skills/` | Skillガイド |
| `content/contribute/` | 貢献ガイド |

### ファイル名規則

- **小文字・ハイフン区切り**: `webchat-ja-patch.md`
- **日本語ファイル名は避ける**: 英数字のみ
- **説明的な名前**: 内容が分かる名前をつける

例:
```
✅ good: webchat-japanese-patch.md
❌ bad: 日本語化.md
❌ bad: patch1.md
```

### Front Matter（記事メタデータ）

各記事の冒頭には、以下のYAML形式のメタデータを記述します：

```yaml
---
title: "記事タイトル"
weight: 10
description: "記事の概要（100文字程度、SEO用）"
tags: ["タグ1", "タグ2", "タグ3"]
bookToc: true  # 目次を表示
draft: false   # 公開状態（true=下書き）
---
```

#### weight（表示順序）

数字が小さいほど上に表示されます：

- `10`: カテゴリの最初
- `20`: 2番目
- `30`: 3番目
- ...

### Markdownスタイルガイド

#### 見出し

```markdown
# ページタイトル（Front Matterのtitleと同じ）

## 大見出し

### 中見出し

#### 小見出し
```

- `#` はページタイトル用（1つのみ）
- `##` 以降を本文で使用
- 見出しは階層的に使う（`##` → `###` の順）

#### コードブロック

コードブロックには必ず言語を指定：

````markdown
```bash
# Bashコマンド例
openclaw gateway start
```

```python
# Pythonコード例
def hello():
    print("Hello, OpenClaw!")
```

```javascript
// JavaScriptコード例
console.log("Hello!");
```
````

#### リンク

内部リンク（同じWiki内）:

```markdown
[セットアップガイド]({{< relref "/setup/getting-started" >}})
```

外部リンク:

```markdown
[OpenClaw公式サイト](https://openclaw.io)
```

#### 画像

```markdown
![代替テキスト](/images/screenshot.png)
```

画像ファイルは `static/images/` に配置。

#### テーブル

```markdown
| カラム1 | カラム2 | カラム3 |
|---------|---------|---------|
| データ1 | データ2 | データ3 |
| データ4 | データ5 | データ6 |
```

#### 注意書き・ヒント

Hugo Bookテーマのショートコードを使用：

```markdown
{{< hint info >}}
**情報**: ここに情報を書きます。
{{< /hint >}}

{{< hint warning >}}
**警告**: 注意が必要な内容。
{{< /hint >}}

{{< hint danger >}}
**危険**: 重要な警告。
{{< /hint >}}
```

---

## 記事執筆のベストプラクティス

### トーン＆マナー

- ✅ **「です・ます」調**: 丁寧な文体
- ✅ **初心者にも分かりやすく**: 専門用語は説明を添える
- ✅ **具体的な手順**: 実際に試せる内容
- ✅ **実際に動作確認済み**: テスト済みの内容のみ記載

### 記事の構成

推奨される記事構成：

```markdown
---
# Front Matter
---

# タイトル

## 概要
この記事の要約（3-5行）

## 前提条件
- 必要な環境やツール
- 事前に必要な知識

## 手順

### ステップ1: XXX
具体的な手順

### ステップ2: XXX
具体的な手順

## まとめ
この記事で学んだこと

## 関連記事
- [関連記事へのリンク]()

## 参考リンク
- [外部リンク]()
```

### スクリーンショット

- **日本語環境で撮影**: 英語UIのスクショは避ける
- **適切なサイズ**: 1200px幅以下推奨
- **圧縮**: PNGまたはJPEG（軽量化）
- **説明的なファイル名**: `webchat-settings-dashboard.png`

---

## レビュープロセス

プルリクエストを送信すると、メンテナーがレビューを行います。

### レビューチェックリスト

- [ ] 内容が正確か
- [ ] 手順が実際に動作するか
- [ ] 日本語が自然か（誤字脱字なし）
- [ ] コードブロックに言語指定があるか
- [ ] 画像が適切なサイズか
- [ ] リンク切れがないか
- [ ] Front Matterが適切か
- [ ] カテゴリ配置が適切か

### レビュー期間

- **72時間以内**: 初回レスポンス
- **1週間以内**: マージまたは修正依頼

修正依頼があった場合は、同じブランチで修正をコミット・プッシュしてください。プルリクエストが自動更新されます。

---

## 記事テンプレート

新規記事作成時のテンプレートは `archetypes/default.md` に定義されています。

```markdown
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
weight: 10
description: "記事の概要（100文字程度）"
tags: []
bookToc: true
draft: false
---

# {{ replace .Name "-" " " | title }}

## 概要
この記事では〜について説明します。

## 前提条件
- OpenClaw がインストール済み
- （必要に応じて追加）

## 手順

### ステップ1: XXX
説明文

```bash
# コマンド例
command here
```

### ステップ2: XXX
説明文

## まとめ
この記事では〜を解説しました。

## 関連記事
- （関連記事を追加予定）

## 参考リンク
- [公式ドキュメント](https://example.com)
```

---

## よくある質問

### Q: Hugoの知識がなくても貢献できますか？

**A:** はい！Markdownが書ければ大丈夫です。記事テンプレートを使えば簡単に始められます。

### Q: 英語で書いてもいいですか？

**A:** このWikiは日本語ユーザー向けなので、記事は日本語でお願いします。ただし、IT用語は英語のままで構いません。

### Q: 小さな修正でもPRを送っていいですか？

**A:** はい！誤字修正1文字でも大歓迎です。

### Q: 記事のアイデアはあるけど、書く時間がない

**A:** [GitHub Issues](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/issues)でアイデアを共有してください。他の方が執筆するかもしれません。

### Q: レビューで修正依頼が来たらどうすれば？

**A:** 同じブランチで修正をコミット・プッシュすれば、PRが自動更新されます。

```bash
# 修正後
git add .
git commit -m "Fix: レビュー指摘に対応"
git push origin add/article-name
```

---

## メンテナーになるには

定期的に質の高い貢献をしてくださる方には、メンテナー権限を付与します。

**メンテナーの役割:**
- PRのレビュー
- Issueの管理
- 記事の品質管理
- コミュニティサポート

興味がある方は、[GitHub Discussions](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/discussions)でご連絡ください。

---

## 行動規範

### 尊重と協力

- 他の貢献者を尊重する
- 建設的なフィードバックを心がける
- 初心者に優しく接する
- 多様な視点を歓迎する

### 禁止事項

- 不適切な言葉遣いや攻撃的な表現
- スパムや宣伝目的の投稿
- 他者の著作権を侵害する内容
- 虚偽の情報や未検証の内容

---

## サポートとコミュニケーション

### 質問・議論

- [GitHub Discussions](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/discussions) - 一般的な質問や議論
- [GitHub Issues](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/issues) - バグ報告や機能提案

### リアルタイムチャット

（将来的にDiscordやSlackを設置予定）

---

## 関連リンク

- [OpenClaw公式サイト](https://openclaw.io)
- [Hugo ドキュメント](https://gohugo.io/documentation/)
- [Markdown ガイド](https://www.markdownguide.org/)
- [Hugo Book テーマ](https://github.com/alex-shpak/hugo-book)

---

**ご貢献、心よりお待ちしております！**

---

**最終更新:** 2026-02-14
