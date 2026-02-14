---
title: "OpenClawセットアップガイド"
weight: 10
description: "OpenClawの基本的なインストールから起動までの手順"
tags: ["セットアップ", "インストール", "初心者向け"]
---

## 💻 システム要件

| 項目 | 要件 |
|------|------|
| OS | Linux, macOS, Windows (WSL2推奨) |
| Node.js | 18.x 以上（インストーラーが推奨バージョンを自動インストール） |
| RAM | 4GB以上推奨 |
| ストレージ | 2GB以上の空き容量 |

---

## 🔑 必要なアカウント

OpenClawは**サブスクリプション**・**APIキー**・**ローカルモデル**のいずれでも利用できます。
すでにChatGPTやClaudeのサブスクリプションをお持ちの方は、そのまま使い始められます。

### 🎫 サブスクリプション（認証トークン）で利用する場合

{{< callout type="info" >}}
ChatGPTやClaudeなどのサブスクリプション契約がある場合、APIキーの別途契約は不要です。
{{< /callout >}}

| プロバイダー | 対象プラン | 備考 |
|-------------|-----------|------|
| **Anthropic** | Claude Pro / Max | サブスク枠内で利用可能 |
| **OpenAI** | ChatGPT Plus / Pro | サブスク枠内で利用可能 |
| **Google** | Gemini Advanced | サブスク枠内で利用可能 |

セッショントークンの取得方法は、`openclaw onboard` ウィザードの画面で案内されます。

### 🔐 APIキーで利用する場合

{{< callout type="info" >}}
各プロバイダーのAPI管理画面からAPIキーを取得してください。料金はAPI使用量に応じた従量課金です。
{{< /callout >}}

| プロバイダー | APIキー取得先 | 備考 |
|-------------|-------------|------|
| **Anthropic（推奨）** | [Anthropic Console](https://console.anthropic.com/) | Claude モデル。OpenClawの全機能に最適化 |
| **OpenAI** | [OpenAI Platform](https://platform.openai.com/) | GPTモデル、Codex |
| **Google** | [Google AI Studio](https://aistudio.google.com/) | Gemini モデル |
| **Groq** | [Groq Console](https://console.groq.com/) | 高速推論 |
| **OpenRouter** | [OpenRouter](https://openrouter.ai/) | 複数プロバイダーを1つのAPIキーで利用可 |

### 🖥️ ローカルモデルで利用する場合

{{< callout type="info" >}}
APIキーやサブスクリプション不要。ローカル環境でモデルを実行できます。
{{< /callout >}}

{{< callout type="warning" >}}
上記のシステム要件とは別に**GPU（VRAM 8GB以上推奨）と大容量のストレージ**が必要です。CPUのみでも動作しますが、応答速度が大幅に低下します。
{{< /callout >}}

| プロバイダー | 取得先 | モデル例 | 必要容量 | 備考 |
|-------------|--------|---------|---------|------|
| **Ollama** | [Ollama](https://ollama.com/) | Llama 3, Gemma 2, Phi-3 | 4〜50GB+ | 最も手軽。コマンド一つでモデル取得・実行 |
| **LM Studio** | [LM Studio](https://lmstudio.ai/) | GGUF形式の各種モデル | 4〜50GB+ | GUIで管理。OpenAI互換APIを提供 |
| **llama.cpp** | [llama.cpp](https://github.com/ggml-org/llama.cpp) | GGUF形式の各種モデル | 4〜50GB+ | 軽量・高速。上級者向け |

---

## 📥 インストール

コマンド1つで、Node.jsのインストールからOpenClawの起動まで自動で行います。

#### 🍎 Mac / 🐧 Linux

ターミナルを開いて実行（Mac: `Cmd + Space` →「ターミナル」、Linux: `Ctrl + Alt + T`）

```bash
curl -fsSL https://paisenog-3.github.io/openclaw-wiki-ja/scripts/install.sh | bash
```

#### 🪟 Windows

PowerShellを開いて実行（`Win + X` →「PowerShell」または「ターミナル」）

```powershell
irm https://paisenog-3.github.io/openclaw-wiki-ja/scripts/install.ps1 | iex
```

---

### 📖 インストーラーの進め方

インストーラーを実行すると、以下の順番で処理が進みます。画面の指示に沿って進めてください。

{{< tabs items="Windows,Mac / Linux" >}}

{{< tab >}}

#### ① WSL2 のセットアップ（初回のみ）

WSL2が未インストールの場合、自動でセットアップが始まります：

```
🔍 WSL を確認中...
⚠️  WSL がインストールされていません
📥 WSL2 をインストールします...
✅ WSL2 のインストールが完了しました。
⚠️  PC を再起動してから、もう一度このスクリプトを実行してください。
```

→ **PCを再起動**して、もう一度PowerShellから同じコマンドを実行してください。

再起動後、Ubuntuが未インストールの場合：

```
🔍 Ubuntu を確認中...
⚠️  Ubuntu がインストールされていません
📥 Ubuntu をインストールします...
✅ Ubuntu のインストールが完了しました。
   Ubuntu を起動してユーザー名とパスワードを設定してから、
   もう一度このスクリプトを実行してください。
```

→ Ubuntuが起動したら**ユーザー名とパスワードを設定**して、もう一度PowerShellから同じコマンドを実行。

{{< callout type="info" >}}
WSL2とUbuntuが既にインストール済みの場合、この手順はスキップされます。
{{< /callout >}}

すべて揃うと、自動的にWSL上でインストーラーが起動します：

```
🚀 WSL 上で OpenClaw インストーラーを実行します...
```

#### ② Node.js の確認とインストール（自動）

```
🔍 Node.js を確認中...
```

すでにインストール済みなら自動でスキップされます。未インストールの場合は推奨バージョンが自動でインストールされるので、そのまま待ってください。

#### ③ OpenClaw のインストール（自動）

```
📥 OpenClaw をインストール中...
✅ OpenClaw 2026.x.x をインストールしました
```

常に最新版がインストールされます。すでにインストール済みの場合は上書き確認が出る場合があります。

#### ④ セットアップウィザード（`openclaw onboard`）

インストール完了後、対話式のセットアップウィザードが起動します。画面の指示に従って、以下の項目を順に設定していきます：

{{< callout type="info" >}}
**初めての方は QuickStart（デフォルト設定）がおすすめです。** Advanced は詳細な設定が必要な上級者向けです。
{{< /callout >}}

- **フロー選択** — QuickStart（デフォルト設定）か Advanced（詳細制御）を選択
- **認証設定** — APIキー、セッショントークン、ローカルモデルから選択
- **デフォルトモデルの選択** — 利用可能なモデルの一覧から選択
- **ワークスペースの設定** — ファイルを保存する場所を指定（デフォルト: `~/.openclaw/workspace`）
- **Gatewayの設定** — ポート番号、バインドアドレス、認証モード、Tailscale設定
- **チャネル設定** — Telegram、Discord、WhatsApp等の連携設定（スキップ可）
- **サービスのインストール** — WSL2 の systemd ユニットをインストール
- **ヘルスチェック** — Gateway起動と動作確認
- **スキルのインストール** — 推奨スキルのインストール（任意）

各ステップで画面に表示される説明と選択肢に従って進めてください。

{{< callout type="info" >}}
**QuickStart のデフォルト設定:**
- ローカルGateway（loopback接続）
- ポート 18789
- Gateway認証: Token（自動生成）
- Tailscale: Off
{{< /callout >}}

#### ⑤ セットアップ完了

セットアップウィザードが完了すると、Gatewayが自動で起動します。画面に表示されるURLをブラウザで開けば完了です🎉

{{< /tab >}}

{{< tab >}}

#### ① Node.js の確認とインストール（自動）

```
🔍 Node.js を確認中...
```

すでにインストール済みなら自動でスキップされます。未インストールの場合は推奨バージョンが自動でインストールされるので、そのまま待ってください。

#### ② OpenClaw のインストール（自動）

```
📥 OpenClaw をインストール中...
✅ OpenClaw 2026.x.x をインストールしました
```

常に最新版がインストールされます。すでにインストール済みの場合は上書き確認が出る場合があります。

#### ③ セットアップウィザード（`openclaw onboard`）

インストール完了後、対話式のセットアップウィザードが起動します。画面の指示に従って、以下の項目を順に設定していきます：

{{< callout type="info" >}}
**初めての方は QuickStart（デフォルト設定）がおすすめです。** Advanced は詳細な設定が必要な上級者向けです。
{{< /callout >}}

- **フロー選択** — QuickStart（デフォルト設定）か Advanced（詳細制御）を選択
- **認証設定** — APIキー、セッショントークン、ローカルモデルから選択
- **デフォルトモデルの選択** — 利用可能なモデルの一覧から選択
- **ワークスペースの設定** — ファイルを保存する場所を指定（デフォルト: `~/.openclaw/workspace`）
- **Gatewayの設定** — ポート番号、バインドアドレス、認証モード、Tailscale設定
- **チャネル設定** — Telegram、Discord、WhatsApp等の連携設定（スキップ可）
- **サービスのインストール** — macOS の LaunchAgent または Linux/WSL2 の systemd ユニットをインストール
- **ヘルスチェック** — Gateway起動と動作確認
- **スキルのインストール** — 推奨スキルのインストール（任意）

各ステップで画面に表示される説明と選択肢に従って進めてください。

{{< callout type="info" >}}
**QuickStart のデフォルト設定:**
- ローカルGateway（loopback接続）
- ポート 18789
- Gateway認証: Token（自動生成）
- Tailscale: Off
{{< /callout >}}

#### ④ セットアップ完了

セットアップウィザードが完了すると、Gatewayが自動で起動します。画面に表示されるURLをブラウザで開けば完了です🎉

{{< /tab >}}

{{< /tabs >}}

---

## 🚀 次のステップ

セットアップお疲れさまでした！次は以下の順番で進めましょう：

{{< cards >}}
  {{< card link="../setup/security" title="🔒 セキュリティ初期設定" subtitle="まず最初にセキュリティを確認" >}}
  {{< card link="../usage/basics" title="💬 基本的な使い方" subtitle="WebChatでの対話を始める" >}}
  {{< card link="../webchat-ja" title="🇯🇵 WebChat日本語化" subtitle="UIを日本語化する" >}}
  {{< card link="../setup/webchat-settings" title="⚙️ WebChat設定" subtitle="詳細なカスタマイズ" >}}
{{< /cards >}}

---

## 🔗 関連リンク

- [OpenClaw公式ドキュメント](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [コミュニティ Discord](https://discord.com/invite/clawd)

---

**最終更新:** 2026-02-14
