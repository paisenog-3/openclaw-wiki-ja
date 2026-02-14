---
title: "貢献ガイド・利用規約"
weight: 30
description: "記事の投稿方法、寄与ルール、利用規約"
tags: ["貢献", "コミュニティ", "利用規約"]
toc: true
type: docs
---

## 記事を投稿する

サイト上のフォームから、誰でも記事を投稿できます。GitやHugoの知識は不要です。

<div style="margin: 1.5rem 0;">
  <a href="https://github.com/paisenog-3/openclaw-wiki-ja/issues/new?template=article-submission.yml" target="_blank" style="display: inline-block; padding: 12px 32px; background: #2563eb; color: white; border-radius: 8px; text-decoration: none; font-weight: bold;">📝 記事を投稿する</a>
</div>

### 投稿の流れ

1. 上のボタンからフォームを開く（GitHubアカウントが必要）
2. タイトル、カテゴリ、内容を記入して送信
3. **数分後に自動でWikiに公開されます**

レビュー待ちはありません。投稿したらすぐ公開されます。

### 投稿者情報

| フィールド | 必須 | 説明 |
|-----------|------|------|
| 投稿者名 | 任意 | 空欄なら「匿名」と表示 |
| SNS / Webサイト | 任意 | X、GitHub、ブログ等のURL。記事にリンク付きで表示 |

記事のフッターに「誰が・いつ投稿したか」が表示されます。

---

## 寄与ルール

### 基本

- 投稿者には **寄与割合**（%）が付きます
- 単独投稿の場合は **100%**

### 記事のマージ（統合）

類似テーマの記事が複数投稿された場合、内容を統合することがあります。

- 統合後の記事には **全投稿者の名前と寄与割合** が表示されます
- 寄与割合は **元記事の内容量に基づいて按分** します（合計100%）
- 同一内容の場合は **先に投稿した人を原著者** として優先します

**表示例：**

> 📝 [たろう](https://x.com/taro) さん — 寄与 60%
> 📝 じろう さん — 寄与 40%

### 品質チェック

投稿内容は定期的にチェックされます。スパムや不適切な内容は予告なく削除されることがあります。

---

## 記事の書き方

- **Markdown形式** で記入してください
- 見出し（`##`）、箇条書き（`-`）、コードブロック（` ``` `）が使えます
- IT用語は英語のまま、説明は日本語で
- 実際に動作確認した内容を書いてください

### カテゴリ

| カテゴリ | 内容 |
|---------|------|
| セットアップ | インストール、移行、初期設定 |
| スキル・プラグイン | スキル作成、プラグイン活用 |
| 運用Tips | 日常運用のコツ、便利な使い方 |
| トラブルシューティング | エラー対処、FAQ |
| リリースノート | バージョン別の変更点 |

---

## Git/PRでの貢献

フォーム投稿以外に、従来のGitHub Pull Requestでも貢献できます。

1. [リポジトリ](https://github.com/paisenog-3/openclaw-wiki-ja)をFork
2. ブランチ作成 → 記事追加・編集
3. Pull Requestを送信

詳細は [CONTRIBUTING.md](https://github.com/paisenog-3/openclaw-wiki-ja/blob/main/CONTRIBUTING.md) を参照してください。

---

## 利用規約

### ライセンス

- **記事**: [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.ja) — 自由に利用・改変可。クレジット表示と同一ライセンス継承が条件
- **コード例**: [MIT License](https://opensource.org/licenses/MIT) — 自由に利用可

### 免責事項

{{< callout type="warning" >}}
このWikiの情報は**無保証**です。利用は自己責任でお願いします。本番環境での利用前にテスト環境で確認してください。
{{< /callout >}}

### 行動規範

- 他の貢献者を尊重する
- スパム・宣伝・著作権侵害の投稿禁止
- ハラスメント行為禁止

違反行為はコンテンツ削除・アクセス制限の対象となります。

---

## お問い合わせ

- [GitHub Issues](https://github.com/paisenog-3/openclaw-wiki-ja/issues) — バグ報告・機能提案
- [GitHub Discussions](https://github.com/paisenog-3/openclaw-wiki-ja/discussions) — 質問・議論

---

このWikiは [パイセン｜AIと暮らす](https://x.com/OG3_gata) が運営する非公式コミュニティWikiです。
