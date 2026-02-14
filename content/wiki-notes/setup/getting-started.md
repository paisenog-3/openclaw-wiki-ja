---
title: "OpenClawセットアップガイド"
weight: 10
description: "OpenClawの基本的なインストールから起動までの手順"
tags: ["セットアップ", "インストール", "初心者向け"]
---



OpenClawの基本的なインストールから起動までの手順を解説します。

---

## 概要

OpenClawは、Claude AIをローカル環境で活用するためのオープンソースプラットフォームです。WebChat UIを通じて、Claudeとの対話、ファイル操作、ブラウザ制御、タスク自動化などを統合的に行えます。

### 主な機能

- **WebChat UI**: ブラウザベースの直感的な対話インターフェース
- **ファイル操作**: ローカルファイルの読み書き・編集
- **ブラウザ制御**: Webページの自動操作
- **タスク自動化**: Skillsによるワークフロー自動化
- **マルチモーダル**: テキスト、画像、音声の統合処理

---

## 前提条件

### システム要件

| 項目 | 要件 |
|------|------|
| OS | Linux, macOS, Windows (WSL2推奨) |
| Node.js | 18.x 以上 |
| RAM | 4GB以上推奨 |
| ストレージ | 2GB以上の空き容量 |

### 必要なアカウント

- **Anthropic APIキー**: [Anthropic Console](https://console.anthropic.com/)で取得

---

## インストール手順

### ステップ1: Node.jsのインストール

OpenClawはNode.js環境で動作します。まずNode.jsをインストールしてください。

#### Linux/macOS

nvmを使用する方法（推奨）：

```bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash


source ~/.bashrc  # または ~/.zshrc


nvm install 22
nvm use 22


node --version  # v22.x.x と表示されればOK
```

#### Windows (WSL2)

WSL2上でLinuxの手順と同じようにインストールできます。

```bash

```

---

### ステップ2: OpenClawのインストール

npmを使ってOpenClawをグローバルインストールします。

```bash
npm install -g openclaw
```

インストールが完了したら、バージョンを確認：

```bash
openclaw --version
```

---

### ステップ3: 初期設定

#### Anthropic APIキーの設定

OpenClawを初めて起動する前に、APIキーを設定します。

```bash

export ANTHROPIC_API_KEY="your-api-key-here"


echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

または、OpenClaw起動時に対話的に設定することもできます。

---

### ステップ4: Gatewayの起動

OpenClaw Gatewayを起動します。これはバックグラウンドで動作し、WebChat UIとClaude APIの橋渡しを行います。

```bash
openclaw gateway start
```

起動確認：

```bash
openclaw gateway status
```

以下のように表示されればOKです：

```
✓ Gateway is running (PID: 12345)
✓ WebChat UI: http://localhost:8080
```

---

### ステップ5: WebChat UIにアクセス

ブラウザで以下のURLを開きます：

```
http://localhost:8080
```

初回アクセス時には、以下の設定が求められる場合があります：

1. **APIキー**: Anthropic APIキーを入力
2. **デフォルトモデル**: `claude-sonnet-4` 等を選択
3. **言語設定**: `ja-JP` を選択（日本語）

---

## 基本的な使い方

### チャットを開始

1. WebChat UIの左サイドバーから **"New Session"**（新規セッション）をクリック
2. チャット入力欄にメッセージを入力
3. Enterキーで送信

### ファイル操作の例

```
このディレクトリにあるファイル一覧を教えて
```

Claudeがローカルファイルシステムにアクセスして、ファイル一覧を表示します。

### コード生成の例

```
Pythonで簡単なWebスクレイパーを書いて
```

Claudeがコードを生成し、ファイルとして保存することもできます。

---

## 日本語環境の最適化

### 日本語UIパッチの適用

WebChatダッシュボードを日本語化するパッチを適用できます。

詳しくは [WebChat日本語化パッチ]({{< relref "/wiki-notes/webchat-ja" >}}) をご覧ください。

### 日本語フォントの設定

デフォルトでは日本語フォントが適切に表示されますが、カスタムフォントを使いたい場合は、WebChatの設定から変更できます。

詳しくは [WebChat設定ガイド]({{< relref "/setup/webchat-settings" >}}) をご覧ください。

---

## よくある質問

### Q: Gatewayが起動しない

**A:** ポート8080が既に使用されている可能性があります。以下で確認：

```bash
lsof -i :8080
```

別のポートで起動する場合：

```bash
PORT=8081 openclaw gateway start
```

### Q: APIキーエラーが出る

**A:** APIキーが正しく設定されているか確認：

```bash
echo $ANTHROPIC_API_KEY
```

何も表示されない場合は、環境変数が設定されていません。ステップ3を再確認してください。

### Q: WebChat UIにアクセスできない

**A:** 以下を確認してください：

1. Gatewayが起動しているか: `openclaw gateway status`
2. ファイアウォールでポートがブロックされていないか
3. ブラウザのキャッシュをクリアして再アクセス

### Q: 日本語が文字化けする

**A:** ブラウザの文字エンコーディングがUTF-8になっているか確認してください。ほとんどの場合、自動検出で問題ありません。

---

## 停止と再起動

### Gatewayの停止

```bash
openclaw gateway stop
```

### Gatewayの再起動

```bash
openclaw gateway restart
```

### ログの確認

```bash
openclaw gateway logs
```

---

## 次のステップ

OpenClawのセットアップが完了しました！次は以下をお試しください：

- [WebChat設定ガイド]({{< relref "/setup/webchat-settings" >}}) - WebChatの詳細設定
- [WebChat日本語化パッチ]({{< relref "/wiki-notes/webchat-ja" >}}) - UIを日本語化
- [OpenClaw公式ドキュメント](https://openclaw.io/docs) - 詳細な機能ガイド

---

## 関連リンク

- [OpenClaw公式サイト](https://openclaw.io)
- [Anthropic Console](https://console.anthropic.com/)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)

---

**最終更新:** 2026-02-14
