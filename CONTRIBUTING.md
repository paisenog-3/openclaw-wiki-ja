# コントリビューションガイド

OpenClaw 日本語活用Wikiへのご貢献ありがとうございます！

このドキュメントでは、このWikiへの貢献方法を説明します。

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

## クイックスタート

### 1. リポジトリをFork

[GitHubリポジトリ](https://github.com/YOUR-USERNAME/openclaw-wiki-ja)で **Fork** ボタンをクリック

### 2. クローンとセットアップ

```bash
# Forkしたリポジトリをクローン
git clone https://github.com/YOUR-USERNAME/openclaw-wiki-ja.git
cd openclaw-wiki-ja

# テーマのsubmoduleを取得
git submodule update --init --recursive

# Hugoサーバーを起動（プレビュー用）
hugo server -D
```

### 3. ブランチを作成して作業

```bash
# 作業用ブランチを作成
git checkout -b add/your-article-name

# 新規記事を作成（Hugoコマンド）
hugo new content/setup/your-article.md

# 記事を編集
vim content/setup/your-article.md

# プレビューで確認
# http://localhost:1313
```

### 4. コミットとプッシュ

```bash
# 変更をコミット
git add .
git commit -m "Add: 新しい記事を追加"

# Pushしてプルリクエストを作成
git push origin add/your-article-name
```

GitHubでプルリクエストを作成してください。

---

## 記事の書き方

### ファイル配置

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
- **日本語ファイル名は避ける**
- **説明的な名前**: 内容が分かる名前

### Front Matter（必須項目）

```yaml
---
title: "記事タイトル"
weight: 10
description: "記事の概要（100文字程度）"
tags: ["タグ1", "タグ2"]
bookToc: true
draft: false
---
```

### Markdownスタイル

- 見出しは `##` から開始（`#` はタイトル用）
- コードブロックは言語指定必須: ` ```bash `
- 画像は `/static/images/` に配置
- スクリーンショットは日本語環境で撮影

### トーン＆マナー

- **「です・ます」調** で統一
- **初心者にも分かりやすく** 書く
- **具体的な手順** を記載
- **実際に動作確認済み** の内容のみ

---

## コミットメッセージ

以下の形式でお願いします：

```
Add: 新規記事の追加
Update: 既存記事の更新
Fix: 誤字・リンク修正
Improve: 内容の改善
```

**例:**
```
Add: WebChat日本語化パッチの記事を追加
Fix: セットアップガイドの誤字を修正
Update: モデル設定の情報を最新化
Improve: スクリーンショットを追加してより分かりやすく
```

---

## レビュープロセス

### レビューチェックリスト

プルリクエストは以下の観点でレビューされます：

- [ ] 内容が正確か
- [ ] 手順が実際に動作するか
- [ ] 日本語が自然か（誤字脱字なし）
- [ ] コードブロックに言語指定があるか
- [ ] 画像が適切なサイズか（1200px以下推奨）
- [ ] リンク切れがないか
- [ ] Front Matterが適切か
- [ ] カテゴリ配置が適切か

### レビュー期間

- **72時間以内**: 初回レスポンス
- **1週間以内**: マージまたは修正依頼

### 修正依頼への対応

修正依頼があった場合は、同じブランチで修正をコミット・プッシュしてください：

```bash
# 修正後
git add .
git commit -m "Fix: レビュー指摘に対応"
git push origin add/your-article-name
```

プルリクエストが自動更新されます。

---

## ローカルでのテスト

プルリクエストを送る前に、必ずローカルでビルドテストを行ってください。

```bash
# ビルドテスト
hugo --minify

# エラーがないことを確認
echo $?  # 0 なら成功
```

---

## 詳細なガイド

より詳しい貢献ガイドは、Wikiの[貢献ページ](https://YOUR-USERNAME.github.io/openclaw-wiki-ja/contribute/)をご覧ください。

---

## 質問・サポート

- **一般的な質問**: [GitHub Discussions](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/discussions)
- **バグ報告・機能提案**: [GitHub Issues](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/issues)

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

## ライセンス

このWikiに貢献することで、あなたの貢献がMITライセンスの下で公開されることに同意したものとみなされます。

---

**ご貢献、心よりお待ちしております！**
