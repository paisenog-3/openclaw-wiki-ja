---
title: "利用規約"
weight: 30
description: "OpenClaw日本語Wikiの利用規約、貢献方法、行動規範"
tags: ["貢献", "コミュニティ", "執筆ガイド", "利用規約"]
toc: true
type: docs
---



OpenClaw 日本語活用Wikiへようこそ！

このページでは、Wikiの目的、利用規約、貢献方法について説明します。

---

## このWikiについて

### Wikiの目的

**OpenClaw 日本語活用Wiki**は、OpenClawを日本語環境で活用するための**非公式コミュニティWiki**です。

- 日本語ユーザー向けの実践的な情報を共有
- 公式ドキュメントを補完するTipsやトラブルシューティング
- コミュニティの知見を集約し、検索しやすい形で提供
- 初心者から上級者まで、誰もが貢献できるオープンな場

{{< callout type="info" >}}
**非公式Wikiです**: このWikiはOpenClaw公式プロジェクトではなく、コミュニティによって運営されています。公式情報は[OpenClaw公式サイト](https://openclaw.io)をご覧ください。
{{< /callout >}}

---

## 利用規約

### コンテンツのライセンス

このWikiのすべてのコンテンツは、特に断りのない限り、**[Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/deed.ja)** ライセンスの下で提供されています。

**これは以下を意味します：**

✅ **自由に利用可能**
- コンテンツを自由にコピー、再配布できます
- 営利目的での利用も可能です
- 改変・翻訳・リミックスが可能です

📝 **条件**
- **表示**: 適切なクレジット（著作者名、リンク、変更の有無）を表示してください
- **継承**: 改変した作品も同じライセンス（CC BY-SA 4.0）で公開してください

### コード例のライセンス

記事内のコード例（スクリプト、設定ファイルサンプル等）は、特に断りのない限り、**[MIT License](https://opensource.org/licenses/MIT)** の下で提供されます。

自由にコピー、改変、商用利用が可能です（著作権表示は推奨）。

### 免責事項

{{< callout type="warning" >}}
**重要: 情報は無保証です**

このWikiの情報は、コミュニティメンバーが善意で提供していますが、正確性や安全性を保証するものではありません。

- 情報の利用は**自己責任**でお願いします
- 記載された手順を実行する前に、必ずバックアップを取ってください
- 本番環境での利用前に、テスト環境で動作確認することを推奨します
- Wikiの情報によって生じた損害について、Wikiの運営者・貢献者は責任を負いません

不明な点や不安な点があれば、[GitHub Discussions](https://github.com/paisenog-3/openclaw-wiki-ja/discussions)で質問してください。
{{< /callout >}}

### 外部リンクについて

Wikiには外部サイトへのリンクが含まれますが、リンク先の内容についてWiki運営者は責任を負いません。

---

## 行動規範

### 基本原則

OpenClaw 日本語活用Wikiは、すべての参加者にとって安全で建設的な場であることを目指しています。

以下の行動規範を守ってください：

✅ **推奨される行動**
- **敬意を持って**: 他の貢献者やユーザーを尊重する
- **建設的に**: 批判ではなく、改善提案を
- **初心者に優しく**: 質問には丁寧に答える
- **多様性を歓迎**: 異なる視点や経験を尊重する
- **オープンに**: 議論や意思決定をオープンに行う

❌ **禁止される行動**
- 不適切な言葉遣いや攻撃的な表現
- ハラスメント（人種、性別、宗教、性的指向等に基づく）
- スパムや宣伝目的の投稿
- 他者の著作権を侵害する内容の投稿
- 虚偽の情報や未検証の内容の意図的な投稿
- 個人情報の無断公開

### 違反への対応

行動規範に違反する行為を発見した場合は、GitHubのIssueまたはメンテナーに報告してください。

メンテナーは以下の措置を取る権限を持ちます：
- 警告の発行
- コンテンツの削除
- プルリクエストの却下
- リポジトリへのアクセス制限

---

## 貢献方法

### 貢献の種類

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

1. [GitHubリポジトリ](https://github.com/paisenog-3/openclaw-wiki-ja)にアクセス
2. 右上の **Fork** ボタンをクリック
3. あなたのアカウントにリポジトリがコピーされます

### ステップ2: ローカルにクローン

```bash

git clone https://github.com/paisenog-3/openclaw-wiki-ja.git
cd openclaw-wiki-ja


git submodule update --init --recursive
```

### ステップ3: ブランチを作成

```bash

git checkout -b add/article-name





```

### ステップ4: 記事を作成・編集

#### 新規記事の作成

Hugoコマンドで記事のテンプレートを生成：

```bash

hugo new content/setup/new-article.md


hugo new content/wiki-notes/new-tip.md
```

生成されたファイルを編集して、内容を書いていきます。

#### 既存記事の編集

`content/` ディレクトリ内の対象ファイルを直接編集します。

```bash

vim content/setup/getting-started.md
```

### ステップ5: ローカルでプレビュー

記事を書いたら、ローカルでプレビューして確認します。

```bash

hugo server -D



```

- `-D` オプション: 下書き（draft: true）の記事も表示

### ステップ6: コミット

変更をコミットします。

```bash

git add content/setup/new-article.md


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
| `content/wiki-notes/` | Tips、ガイド、トラブルシューティング |
| `content/releases/` | リリースノート（日本語版） |
| `content/contribute/` | 貢献ガイド・利用規約 |

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

openclaw gateway start
```

```python

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

Hextraのcalloutを使用：

```markdown
{{< callout type="info" >}}
**情報**: ここに情報を書きます。
{{< /callout >}}

{{< callout type="warning" >}}
**警告**: 注意が必要な内容。
{{< /callout >}}
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

---



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

## よくある質問

### Q: Hugoの知識がなくても貢献できますか？

**A:** はい！Markdownが書ければ大丈夫です。記事テンプレートを使えば簡単に始められます。

### Q: 英語で書いてもいいですか？

**A:** このWikiは日本語ユーザー向けなので、記事は日本語でお願いします。ただし、IT用語は英語のままで構いません。

### Q: 小さな修正でもPRを送っていいですか？

**A:** はい！誤字修正1文字でも大歓迎です。

### Q: 記事のアイデアはあるけど、書く時間がない

**A:** [GitHub Issues](https://github.com/paisenog-3/openclaw-wiki-ja/issues)でアイデアを共有してください。他の方が執筆するかもしれません。

### Q: レビューで修正依頼が来たらどうすれば？

**A:** 同じブランチで修正をコミット・プッシュすれば、PRが自動更新されます。

```bash

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

興味がある方は、[GitHub Discussions](https://github.com/paisenog-3/openclaw-wiki-ja/discussions)でご連絡ください。

---

## サポートとコミュニケーション

### 質問・議論

- [GitHub Discussions](https://github.com/paisenog-3/openclaw-wiki-ja/discussions) - 一般的な質問や議論
- [GitHub Issues](https://github.com/paisenog-3/openclaw-wiki-ja/issues) - バグ報告や機能提案

### リアルタイムチャット

（将来的にDiscordやSlackを設置予定）

---

## 関連リンク

- [OpenClaw公式サイト](https://openclaw.io)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [Hugo ドキュメント](https://gohugo.io/documentation/)
- [Markdown ガイド](https://www.markdownguide.org/)
- [Hextra テーマ](https://imfing.github.io/hextra/)

---

**ご貢献、心よりお待ちしております！**

---

**最終更新:** 2026-02-14
