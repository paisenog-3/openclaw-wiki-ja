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

セッショントークンの取得方法は、`openclaw configure --section model` コマンドで案内されます。

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

## 📖 インストーラーの進め方

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
✅ Node.js v22.x.x が見つかりました
```

未インストールの場合は推奨バージョンが自動でインストールされます。そのまま待ってください。

#### ③ OpenClaw のインストール（自動）

```
📥 OpenClaw をインストール中...
✅ OpenClaw 2026.x.x をインストールしました
```

常に最新版がインストールされます。

#### ④ セキュリティ警告の確認

セキュリティ注意事項が表示されます。内容を確認して「Yes」を選択してください。

![セキュリティ警告画面](/images/onboard/01-security.png)

#### ⑤ フロー選択

**QuickStart**（デフォルト設定・推奨）または **Manual**（詳細設定）を選択します。

![QuickStart/Manual選択画面](/images/onboard/02-mode.png)

{{< callout type="info" >}}
**初めての方はQuickStartがおすすめです。** 必要な設定がデフォルト値で自動的に適用され、すぐに使い始められます。
{{< /callout >}}

#### ⑥ チャネル選択

メッセージングアプリ（Telegram、Discord、WhatsApp等）との連携を設定できます。  
後から設定することもできるので、**「Skip for now」** を選んでも問題ありません。

![チャネル選択画面](/images/onboard/08-channel-select.png)

#### ⑦ 認証設定（セットアップ完了後に実施）

{{< callout type="info" >}}
**QuickStartではデフォルトモデル（anthropic/claude-sonnet-4-5）が自動設定されます。** 認証が未設定の場合、ブラウザでWebChatを開くとControl UIから設定できます。
{{< /callout >}}

ウィザード完了後、以下のコマンドで認証を設定してください：

```bash
openclaw configure --section model
```

対話式でAPIキーまたはセッショントークンを設定できます。

**または** ブラウザでWebChatを開き、右上の⚙️（設定）→ Control UI から設定することもできます。

#### ⑧ セットアップ完了

Gateway が自動起動し、ブラウザで WebChat にアクセスできるようになります🎉

```
✅ OpenClaw Gateway が起動しました
🌐 http://localhost:18789
```

ブラウザでURLを開いて、すぐに使い始められます。

{{< /tab >}}

{{< tab >}}

#### ① Node.js の確認とインストール（自動）

```
🔍 Node.js を確認中...
✅ Node.js v22.x.x が見つかりました
```

未インストールの場合は推奨バージョンが自動でインストールされます。そのまま待ってください。

#### ② OpenClaw のインストール（自動）

```
📥 OpenClaw をインストール中...
✅ OpenClaw 2026.x.x をインストールしました
```

常に最新版がインストールされます。

#### ③ セキュリティ警告の確認

セキュリティ注意事項が表示されます。内容を確認して「Yes」を選択してください。

![セキュリティ警告画面](/images/onboard/01-security.png)

#### ④ フロー選択

**QuickStart**（デフォルト設定・推奨）または **Manual**（詳細設定）を選択します。

![QuickStart/Manual選択画面](/images/onboard/02-mode.png)

{{< callout type="info" >}}
**初めての方はQuickStartがおすすめです。** 必要な設定がデフォルト値で自動的に適用され、すぐに使い始められます。
{{< /callout >}}

#### ⑤ チャネル選択

メッセージングアプリ（Telegram、Discord、WhatsApp等）との連携を設定できます。  
後から設定することもできるので、**「Skip for now」** を選んでも問題ありません。

![チャネル選択画面](/images/onboard/08-channel-select.png)

#### ⑥ 認証設定（セットアップ完了後に実施）

{{< callout type="info" >}}
**QuickStartではデフォルトモデル（anthropic/claude-sonnet-4-5）が自動設定されます。** 認証が未設定の場合、ブラウザでWebChatを開くとControl UIから設定できます。
{{< /callout >}}

ウィザード完了後、以下のコマンドで認証を設定してください：

```bash
openclaw configure --section model
```

対話式でAPIキーまたはセッショントークンを設定できます。

**または** ブラウザでWebChatを開き、右上の⚙️（設定）→ Control UI から設定することもできます。

#### ⑦ セットアップ完了

Gateway が自動起動し、ブラウザで WebChat にアクセスできるようになります🎉

```
✅ OpenClaw Gateway が起動しました
🌐 http://localhost:18789
```

ブラウザでURLを開いて、すぐに使い始められます。

{{< /tab >}}

{{< /tabs >}}

---

## 🚀 次のステップ

セットアップお疲れさまでした！次は以下の順番で進めましょう：

{{< cards >}}
  {{< card link="./security" title="🔒 セキュリティ初期設定" subtitle="まず最初にセキュリティを確認" >}}
  {{< card link="../usage/basics" title="💬 基本的な使い方" subtitle="WebChatでの対話を始める" >}}
  {{< card link="./webchat-ja" title="🇯🇵 WebChat日本語化" subtitle="UIを日本語化する" >}}
  {{< card link="./webchat-settings" title="⚙️ WebChat設定" subtitle="詳細なカスタマイズ" >}}
{{< /cards >}}

---

## 🔗 関連リンク

- [OpenClaw公式ドキュメント](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [コミュニティ Discord](https://discord.com/invite/clawd)

---

**最終更新:** 2026-02-14
