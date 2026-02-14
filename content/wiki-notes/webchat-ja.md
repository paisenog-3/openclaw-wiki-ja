---
title: "WebChat日本語化パッチ"
weight: 10
description: "OpenClaw WebChatダッシュボードUIを日本語化する方法"
tags: ["カスタマイズ", "日本語化", "WebChat"]
---



OpenClaw WebChatダッシュボードUIを日本語化するパッチの導入手順を解説します。

---

## 概要

`openclaw-webchat-ja`は、OpenClaw WebChatダッシュボードのUIを日本語化するためのパッチです。約70個の主要なUI要素が日本語に翻訳されます。

### 翻訳の特徴

- ✅ **自然な日英混在UI** - 日本語 + IT用語は英語のまま
- ✅ **自動検出** - OpenClawインストール先を自動で発見
- ✅ **安全なパッチ適用** - 適用前に自動バックアップ
- ✅ **簡単な復元** - ワンコマンドで英語版に戻せる
- ✅ **冪等性** - 何度実行しても安全

### 翻訳例

| 英語 | 日本語 | 備考 |
|------|--------|------|
| Overview | 概要 | |
| Sessions | セッション | |
| Settings | 設定 | |
| Save | 保存 | |
| Apply | 適用 | |
| Connected | 接続済 | |
| Expand sidebar | サイドバー展開 | |
| Chat | Chat | IT用語として英語のまま |
| Agents | Agents | IT用語として英語のまま |

---

## 前提条件

- OpenClaw がインストール済み
- Bashシェルが使用可能

---

## インストール手順

### 方法1: 直接インストール（推奨）

パッチスクリプトをダウンロードして実行します。

```bash

wget https://raw.githubusercontent.com/yozora4416/openclaw-webchat-ja/main/scripts/apply.sh


chmod +x apply.sh


./apply.sh
```

### 方法2: リポジトリをクローン

```bash

git clone https://github.com/yozora4416/openclaw-webchat-ja.git
cd openclaw-webchat-ja


./scripts/apply.sh
```

### 方法3: OpenClaw Skillとして

OpenClawのskillsディレクトリに配置する方法です。

```bash

git clone https://github.com/yozora4416/openclaw-webchat-ja.git \
  /root/clawd/skills/webchat-ja

cd /root/clawd/skills/webchat-ja


./scripts/apply.sh
```

---

## 適用後の確認

パッチ適用後、OpenClawを再起動します。

```bash
openclaw gateway restart
```

ブラウザでWebChatダッシュボードを開き、UIが日本語化されていることを確認してください。

```
http://localhost:8080
```

---

## 使い方

### 日本語化を適用

```bash
./scripts/apply.sh
```

実行すると、以下の処理が自動的に行われます：

1. OpenClaw control-ui JavaScriptファイルを検出
2. オリジナルファイルのバックアップを作成
3. 日本語翻訳を適用
4. 完了メッセージを表示

### 変更をプレビュー（ドライラン）

実際には適用せず、どのような変更が行われるかを確認できます。

```bash
./scripts/apply.sh --dry-run
```

### 英語版に戻す

元の英語UIに戻したい場合は、復元スクリプトを実行します。

```bash
./scripts/restore.sh
```

その後、OpenClawを再起動してください。

```bash
openclaw gateway restart
```

---

## 翻訳方針

日本の開発者にとって馴染みのある英語IT用語はそのまま残し、自然言語のUI要素を日本語に翻訳することで、快適なバイリンガルUIを実現しています。

### 英語のまま残す用語

- Chat, Agents, Skills, Models, Tools
- Browser, Canvas, Nodes, Plugins
- Gateway, Online, Offline, Tokens
- API, Webhook, Filter, Search

これらは日本の技術者にとって英語で使うことが一般的なため、翻訳せずそのまま使用しています。

### 日本語に翻訳する要素

- ナビゲーションラベル（概要、セッション、設定）
- アクションボタン（保存、適用、削除）
- ステータスメッセージ（接続済、有効、保留中）
- ユーザー向け説明文

---

## OpenClawアップデート後の対応

OpenClawを更新すると、パッチが上書きされるため、再適用が必要です。

```bash

npm update -g openclaw


cd /path/to/openclaw-webchat-ja
./scripts/apply.sh


openclaw gateway restart
```

---

## トラブルシューティング

### "No OpenClaw control-ui JavaScript file found"

OpenClawがインストールされていない可能性があります。以下で確認してください：

```bash
which openclaw
npm list -g openclaw
```

手動でcontrol-uiファイルを探す場合：

```bash
find /root/.nvm -name "index-*.js" -path "*/control-ui/assets/*"
```

### 一部の文字列が翻訳されていない

UIが更新されて新しい文字列が追加された可能性があります。[GitHubリポジトリ](https://github.com/yozora4416/openclaw-webchat-ja)にIssueを報告してください。

### パッチ適用後にUIが壊れた

復元スクリプトで元に戻してください：

```bash
./scripts/restore.sh
openclaw gateway restart
```

その後、GitHubでIssueを報告していただけると助かります。

---

## 貢献方法

より良い翻訳の提案を歓迎します！

1. [翻訳マップ](https://github.com/yozora4416/openclaw-webchat-ja/blob/main/translation-map.md)で既存の翻訳を確認
2. 実際のUIで翻訳をテスト
3. GitHubでIssueを作成、またはPull Requestを送信

詳しくは[リポジトリのCONTRIBUTING.md](https://github.com/yozora4416/openclaw-webchat-ja/blob/main/CONTRIBUTING.md)をご覧ください。

---

## 関連リンク

- [openclaw-webchat-ja GitHubリポジトリ](https://github.com/yozora4416/openclaw-webchat-ja)
- [WebChat設定ガイド]({{< relref "/setup/webchat-settings" >}})
- [OpenClaw公式サイト](https://openclaw.io)

---

**最終更新:** 2026-02-14
