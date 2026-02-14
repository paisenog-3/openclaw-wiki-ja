---
title: "WebChat設定ガイド"
weight: 20
description: "OpenClaw WebChatダッシュボードの設定項目を詳しく解説"
tags: ["WebChat", "設定", "カスタマイズ"]
---



OpenClaw WebChatダッシュボードの設定項目を詳しく解説します。

---

## 概要

WebChatダッシュボードでは、セッション管理、モデル設定、UI カスタマイズなど、様々な設定を行えます。このガイドでは、各設定項目の意味と推奨値を説明します。

---

## 設定画面へのアクセス

1. WebChat UIを開く: `http://localhost:8080`
2. 右上の **⚙️ Settings** (設定) アイコンをクリック
3. 各タブから設定を変更

---

## 主要な設定項目

### 1. Overview（概要）

ダッシュボードの全体状況を表示します。

| 項目 | 説明 |
|------|------|
| **Session Status** | セッションの接続状態（Connected/Disconnected） |
| **Active Model** | 現在使用中のClaude モデル |
| **API Usage** | API使用量とトークン数 |
| **Gateway Status** | Gatewayの稼働状態 |

---

### 2. Sessions（セッション）

セッションの管理と設定を行います。

#### セッション一覧

| カラム | 説明 |
|--------|------|
| **Name** | セッション名（編集可能） |
| **Model** | 使用しているモデル |
| **Created** | 作成日時 |
| **Last Active** | 最終アクティブ日時 |
| **Actions** | 削除・エクスポート等のアクション |

#### 新規セッション作成

**New Session** ボタンをクリックすると、新しいセッションが作成されます。

**設定項目:**

| 項目 | 説明 | 推奨値 |
|------|------|--------|
| **Session Name** | セッションの名前 | 用途が分かる名前（例: "コーディング"、"リサーチ"） |
| **Model** | 使用するClaude モデル | `claude-sonnet-4` (バランス型) |
| **System Prompt** | システムプロンプト | 用途に応じてカスタマイズ |
| **Temperature** | 応答のランダム性 | `0.7`（デフォルト） |
| **Max Tokens** | 最大出力トークン数 | `4096`（デフォルト） |

**Temperatureについて:**
- `0.0`: 最も決定的（毎回同じ応答）
- `0.5-0.7`: バランス型（推奨）
- `1.0`: クリエイティブ（多様な応答）

---

### 3. Channels（チャンネル）

外部サービスとの連携設定を行います。

#### 連携可能なチャンネル

| チャンネル | 説明 | 用途 |
|-----------|------|------|
| **WebChat** | ブラウザUI（デフォルト） | 手動操作 |
| **Discord** | Discordボット | コミュニティ支援 |
| **Slack** | Slackボット | チーム連携 |
| **Telegram** | Telegramボット | モバイル通知 |
| **Email** | メール通知 | レポート送信 |

#### チャンネル追加手順

1. **Add Channel** をクリック
2. チャンネルタイプを選択
3. 認証情報（Token/Webhook URL等）を入力
4. **Save** をクリック

---

### 4. Models（モデル）

Claude モデルの選択と設定を行います。

#### 利用可能なモデル

| モデル | 特徴 | 推奨用途 |
|--------|------|----------|
| **claude-opus-4** | 最高性能、高精度 | 複雑な推論、長文生成 |
| **claude-sonnet-4** | バランス型、高速 | 日常的な作業、コーディング |
| **claude-haiku-4** | 高速、低コスト | 簡単なタスク、大量処理 |

#### モデル設定

| 項目 | 説明 | 推奨値 |
|------|------|--------|
| **Default Model** | デフォルトで使用するモデル | `claude-sonnet-4` |
| **Fallback Model** | エラー時のフォールバック | `claude-haiku-4` |
| **API Timeout** | APIタイムアウト（秒） | `120` |
| **Retry Count** | リトライ回数 | `3` |

---

### 5. Settings（詳細設定）

#### UI設定

| 項目 | 説明 | 推奨値 |
|------|------|--------|
| **Theme** | テーマ（Light/Dark/Auto） | `Auto`（システムに合わせる） |
| **Language** | 表示言語 | `ja-JP`（日本語） |
| **Font Size** | フォントサイズ | `14px`（デフォルト） |
| **Code Theme** | コードブロックのテーマ | `monokai`（見やすい） |
| **Sidebar Width** | サイドバーの幅 | `250px`（デフォルト） |

#### 動作設定

| 項目 | 説明 | 推奨値 |
|------|------|--------|
| **Auto-save** | 自動保存間隔（秒） | `30` |
| **Message History** | 保存するメッセージ数 | `1000` |
| **Enable Sounds** | 通知音を有効化 | `true` |
| **Show Typing Indicator** | 入力中表示 | `true` |
| **Stream Responses** | ストリーミング応答 | `true`（推奨） |

#### セキュリティ設定

| 項目 | 説明 | 推奨値 |
|------|------|--------|
| **Require Auth** | 認証を要求 | `false`（ローカル環境） |
| **Session Timeout** | セッションタイムアウト（分） | `60` |
| **Enable CORS** | CORS有効化 | `false`（ローカル） |
| **API Key Storage** | APIキーの保存場所 | `Environment Variable`（安全） |

---

### 6. Logging（ログ）

ログの表示と設定を行います。

#### ログレベル

| レベル | 説明 | 表示内容 |
|--------|------|----------|
| **Error** | エラーのみ | 重大な問題のみ記録 |
| **Warn** | 警告以上 | 警告とエラー |
| **Info** | 情報以上 | 通常の動作ログ（推奨） |
| **Debug** | デバッグ情報 | 詳細な動作ログ |
| **Trace** | すべて | 最も詳細（開発用） |

#### ログ設定

| 項目 | 説明 | 推奨値 |
|------|------|--------|
| **Log Level** | ログレベル | `Info` |
| **Log to File** | ファイルに保存 | `true` |
| **Log File Path** | ログファイルパス | `/root/clawd/logs/openclaw.log` |
| **Max Log Size** | 最大ログサイズ（MB） | `100` |
| **Log Rotation** | ログローテーション | `Daily` |

---

## 推奨設定プロファイル

### プロファイル1: 日常的な使用

```
Model: claude-sonnet-4
Temperature: 0.7
Max Tokens: 4096
Theme: Auto
Language: ja-JP
Stream Responses: true
Log Level: Info
```

### プロファイル2: 開発・コーディング

```
Model: claude-sonnet-4
Temperature: 0.5（より決定的）
Max Tokens: 8192（長いコード生成用）
Code Theme: monokai
Stream Responses: true
Log Level: Debug（問題発生時）
```

### プロファイル3: 複雑な推論タスク

```
Model: claude-opus-4
Temperature: 0.3（高精度）
Max Tokens: 4096
Stream Responses: true
Log Level: Info
```

---

## 設定の保存とエクスポート

### 設定の保存

設定を変更したら、**Save** ボタンをクリックして保存してください。

### 設定のエクスポート

設定をJSONファイルとしてエクスポートできます：

1. **Settings** → **Export Configuration**
2. ファイル名を指定して保存
3. 他の環境でインポート可能

### 設定のインポート

```bash

openclaw config import /path/to/config.json
```

---

## トラブルシューティング

### 設定が反映されない

1. **Save** ボタンをクリックしたか確認
2. Gatewayを再起動: `openclaw gateway restart`
3. ブラウザのキャッシュをクリア

### APIキーエラー

設定画面でAPIキーが正しく入力されているか確認：

1. **Settings** → **API Configuration**
2. Anthropic API Keyを確認
3. テスト接続を実行

### UIが日本語にならない

1. **Settings** → **Language** が `ja-JP` になっているか確認
2. ページをリロード
3. [日本語化パッチ]({{< relref "/wiki-notes/webchat-ja" >}})を適用

---

## 関連記事

- [OpenClawセットアップガイド]({{< relref "/setup/getting-started" >}}) - 初期セットアップ
- [WebChat日本語化パッチ]({{< relref "/wiki-notes/webchat-ja" >}}) - UIの日本語化

---

## 参考リンク

- [OpenClaw公式ドキュメント](https://openclaw.io/docs)
- [Claude API ドキュメント](https://docs.anthropic.com/)

---

**最終更新:** 2026-02-14
