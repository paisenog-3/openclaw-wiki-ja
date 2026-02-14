# OpenClaw 日本語活用Wiki

[![Hugo](https://img.shields.io/badge/Hugo-0.155.3-blue.svg)](https://gohugo.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**コミュニティで育てる実践ガイド**

OpenClawを日本語環境で快適に使うための実践的な情報を共有するコミュニティ主導のWikiです。

🌐 **サイト**: https://YOUR-USERNAME.github.io/openclaw-wiki-ja/

---

## 📚 このWikiについて

このWikiは、**OpenClawの日本語ユーザー向けに、実践的な活用知識**を共有することを目的としています。

公式ドキュメントの翻訳ではなく、以下のような内容を中心に扱います：

- ✅ 日本語環境でのセットアップ手順
- ✅ WebChat UIの日本語化パッチ
- ✅ カスタマイズ・設定のベストプラクティス
- ✅ 日本語環境特有の問題と解決策
- ✅ 実践的な活用事例
- ✅ Tips & Tricks

---

## 🚀 クイックスタート

### Wikiを閲覧

[https://YOUR-USERNAME.github.io/openclaw-wiki-ja/](https://YOUR-USERNAME.github.io/openclaw-wiki-ja/)

### ローカルでWikiを起動

```bash
# リポジトリをクローン
git clone --recurse-submodules https://github.com/YOUR-USERNAME/openclaw-wiki-ja.git
cd openclaw-wiki-ja

# Hugoサーバーを起動
hugo server -D

# ブラウザで確認
# http://localhost:1313
```

---

## 📖 主なコンテンツ

### 🚀 セットアップ

- [OpenClawセットアップガイド](content/setup/getting-started.md) - 基本的なインストール〜起動まで
- [WebChat設定ガイド](content/setup/webchat-settings.md) - WebChatダッシュボードの設定項目解説

### 🎨 カスタマイズ

- [WebChat日本語化パッチ](content/customize/webchat-ja.md) - UIを日本語化する方法

### 🤝 貢献する

- [このWikiへの貢献方法](content/contribute/_index.md) - PR出し方、記事テンプレート

---

## 🤝 貢献

このWikiは**コミュニティの皆さんの知識で成り立っています**。

記事の追加・改善・誤字修正など、どんな貢献も歓迎します！

### 貢献の流れ

1. **リポジトリをFork**
2. **ブランチを作成** (`git checkout -b add/article-name`)
3. **記事を作成・編集**
4. **コミット** (`git commit -m 'Add: 新しい記事を追加'`)
5. **Push** (`git push origin add/article-name`)
6. **Pull Requestを作成**

詳しくは [CONTRIBUTING.md](CONTRIBUTING.md) をご覧ください。

---

## 🛠️ 技術スタック

| 技術 | 用途 |
|------|------|
| **Hugo** | 静的サイトジェネレータ |
| **Hugo Book テーマ** | Wikiテーマ |
| **GitHub Pages** | ホスティング |
| **GitHub Actions** | 自動ビルド・デプロイ |
| **Flexsearch** | 全文検索（クライアントサイド） |

---

## 📁 リポジトリ構成

```
openclaw-wiki-ja/
├── .github/
│   └── workflows/
│       └── hugo.yml            # GitHub Actionsワークフロー
├── content/                    # 記事コンテンツ
│   ├── _index.md               # トップページ
│   ├── setup/                  # セットアップ記事
│   ├── customize/              # カスタマイズ記事
│   ├── use-cases/              # 活用事例
│   ├── troubleshooting/        # トラブルシューティング
│   ├── tips/                   # Tips & Tricks
│   ├── skills/                 # Skillガイド
│   └── contribute/             # 貢献ガイド
├── static/                     # 静的ファイル
│   ├── images/                 # 画像
│   └── css/                    # カスタムCSS
├── archetypes/
│   └── default.md              # 記事テンプレート
├── themes/
│   └── hugo-book/              # Hugo Bookテーマ（submodule）
├── hugo.toml                   # Hugo設定ファイル
├── CONTRIBUTING.md             # 貢献ガイド
├── README.md                   # このファイル
└── LICENSE                     # ライセンス
```

---

## 🔧 開発

### 必要なツール

- **Hugo** 0.155.3以上（Extended版推奨）
- **Git** 2.x以上
- **Node.js** 18.x以上（オプション）

### Hugoのインストール

```bash
# Snap（Linux）
snap install hugo --channel=extended

# Homebrew（macOS）
brew install hugo

# または公式サイトからダウンロード
# https://gohugo.io/installation/
```

### ローカル開発

```bash
# リポジトリをクローン（submodule含む）
git clone --recurse-submodules https://github.com/YOUR-USERNAME/openclaw-wiki-ja.git
cd openclaw-wiki-ja

# Hugoサーバーを起動（ライブリロード有効）
hugo server -D

# ブラウザで確認
# http://localhost:1313
```

### 新規記事の作成

```bash
# Hugoコマンドで記事を作成
hugo new content/setup/new-article.md

# 生成されたファイルを編集
vim content/setup/new-article.md
```

### ビルド

```bash
# 本番用ビルド
hugo --minify

# 出力先: public/
```

---

## 🚀 デプロイ

GitHub Pagesに自動デプロイされます。

### デプロイフロー

```
mainブランチへプッシュ
  ↓
GitHub Actions自動実行
  ↓
Hugoビルド
  ↓
GitHub Pagesにデプロイ
  ↓
https://YOUR-USERNAME.github.io/openclaw-wiki-ja/ 更新
```

### 手動デプロイ（必要な場合）

```bash
# ビルド
hugo --minify

# public/ ディレクトリをgh-pagesブランチにデプロイ
# （通常は不要、GitHub Actionsが自動実行）
```

---

## 📜 ライセンス

このWikiのコンテンツは、特記なき限り[MITライセンス](LICENSE)の下で公開されています。

---

## 🔗 リンク

- **OpenClaw公式サイト**: [https://openclaw.io](https://openclaw.io)
- **Hugo**: [https://gohugo.io](https://gohugo.io)
- **Hugo Book テーマ**: [https://github.com/alex-shpak/hugo-book](https://github.com/alex-shpak/hugo-book)
- **GitHub Issues**: [Issues](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/issues)
- **GitHub Discussions**: [Discussions](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/discussions)

---

## 📞 お問い合わせ

- **記事の誤り・改善提案**: [GitHub Issues](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/issues)
- **一般的な質問・議論**: [GitHub Discussions](https://github.com/YOUR-USERNAME/openclaw-wiki-ja/discussions)

---

**コミュニティで育てるWiki、ご参加お待ちしております！**
