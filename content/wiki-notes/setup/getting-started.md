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

| プロバイダー | 対象プラン | トークン取得先 | 備考 |
|-------------|-----------|---------------|------|
| **Anthropic** | Claude Pro / Max | [claude.ai](https://claude.ai/) からセッショントークンを取得 | サブスク枠内で利用可能 |
| **OpenAI** | ChatGPT Plus / Pro | [chatgpt.com](https://chatgpt.com/) からセッショントークンを取得 | サブスク枠内で利用可能 |
| **Google** | Gemini Advanced | [gemini.google.com](https://gemini.google.com/) からセッショントークンを取得 | サブスク枠内で利用可能 |

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

インストーラーを実行すると、以下の順番で質問されます。画面の指示に沿って進めてください。

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

#### ② Node.js の確認（自動）

```
🔍 Node.js を確認中...
✅ Node.js v22.x.x が見つかりました
```

すでにインストール済みなら自動でスキップされます。未インストールの場合は自動でインストールが始まるので、そのまま待ってください。

#### ③ OpenClaw のインストール（自動）

```
📥 OpenClaw をインストール中...
✅ OpenClaw 2026.x.x をインストールしました
```

常に最新版がインストールされます。すでにインストール済みの場合は上書き確認が出ます：

```
⚠️  OpenClaw がすでにインストールされています
   上書きインストールしますか？ (y/N):
```

→ 最新版にしたい場合は **`y`**、そのままでよければ **Enter**

#### ④ 認証方法の選択

```
🔑 認証設定
  1) サブスクリプション（認証トークン）
  2) APIキー（従量課金）
  3) ローカルモデル（Ollama等）

利用方法を選択してください [1/2/3]:
```

| 選択 | こんな人向け |
|------|------------|
| **1** | ChatGPT Plus/ProやClaude Pro/Maxを契約中 → 追加料金なし |
| **2** | サブスクなし、または大量に使いたい → 従量課金 |
| **3** | GPU搭載PCがある → 完全無料・オフライン |

#### ⑤ プロバイダーの選択（④で 1 or 2 を選んだ場合）

サブスクリプションの場合：
```
どのサービスのサブスクリプションをお持ちですか？
  1) Anthropic（Claude Pro / Max）
  2) OpenAI（ChatGPT Plus / Pro）
  3) Google（Gemini Advanced）
```

→ 自分が契約しているサービスの番号を入力。トークンの取得手順とURLが画面に表示されます。

APIキーの場合：
```
どのプロバイダーを利用しますか？
  1) Anthropic（推奨）
  2) OpenAI
  3) Google
  4) Groq
  5) OpenRouter
```

→ 利用したいプロバイダーの番号を入力。取得手順とURLが画面に表示されます。

#### ⑥ トークン / APIキーの入力

⑤で選択したプロバイダーの取得手順が画面に表示されます。

```
認証トークンを貼り付けてください:
```

→ 画面の手順に従ってトークンまたはAPIキーを取得し、貼り付けてください。入力するまで先に進めません。

{{< callout type="info" >}}
ローカルモデル（④で3を選択）の場合、この手順はスキップされます。
{{< /callout >}}

#### ⑦ デフォルトモデルの選択

選択したプロバイダーに応じた最新の対応モデル一覧がOpenClawから自動取得されます。

```
🤖 デフォルトモデルの選択


  anthropic の対応モデル：
  ─────────────────────────────────
  1) anthropic/claude-sonnet-4-5
  2) anthropic/claude-opus-4-6
  3) anthropic/claude-haiku-4-5
  ...

  番号を入力するか、モデル名を直接入力してください
選択:
```

→ 番号またはモデル名を入力。

#### ⑧ Gateway の起動

```
🚀 OpenClaw Gateway を起動しますか？ (Y/n):
```

→ **Enter** または **`Y`** で起動。画面に表示されるURLをブラウザで開けば完了です🎉

{{< /tab >}}

{{< tab >}}

#### ① Node.js の確認（自動）

```
🔍 Node.js を確認中...
✅ Node.js v22.x.x が見つかりました
```

すでにインストール済みなら自動でスキップされます。未インストールの場合は自動でインストールが始まるので、そのまま待ってください。

#### ② OpenClaw のインストール（自動）

```
📥 OpenClaw をインストール中...
✅ OpenClaw 2026.x.x をインストールしました
```

常に最新版がインストールされます。すでにインストール済みの場合は上書き確認が出ます：

```
⚠️  OpenClaw がすでにインストールされています
   上書きインストールしますか？ (y/N):
```

→ 最新版にしたい場合は **`y`**、そのままでよければ **Enter**

#### ③ 認証方法の選択

```
🔑 認証設定
  1) サブスクリプション（認証トークン）
  2) APIキー（従量課金）
  3) ローカルモデル（Ollama等）

利用方法を選択してください [1/2/3]:
```

| 選択 | こんな人向け |
|------|------------|
| **1** | ChatGPT Plus/ProやClaude Pro/Maxを契約中 → 追加料金なし |
| **2** | サブスクなし、または大量に使いたい → 従量課金 |
| **3** | GPU搭載PCがある → 完全無料・オフライン |

#### ④ プロバイダーの選択（③で 1 or 2 を選んだ場合）

サブスクリプションの場合：
```
どのサービスのサブスクリプションをお持ちですか？
  1) Anthropic（Claude Pro / Max）
  2) OpenAI（ChatGPT Plus / Pro）
  3) Google（Gemini Advanced）
```

→ 自分が契約しているサービスの番号を入力。トークンの取得手順とURLが画面に表示されます。

APIキーの場合：
```
どのプロバイダーを利用しますか？
  1) Anthropic（推奨）
  2) OpenAI
  3) Google
  4) Groq
  5) OpenRouter
```

→ 利用したいプロバイダーの番号を入力。取得手順とURLが画面に表示されます。

#### ⑤ トークン / APIキーの入力

④で選択したプロバイダーの取得手順が画面に表示されます。

```
認証トークンを貼り付けてください:
```

→ 画面の手順に従ってトークンまたはAPIキーを取得し、貼り付けてください。入力するまで先に進めません。

{{< callout type="info" >}}
ローカルモデル（③で3を選択）の場合、この手順はスキップされます。
{{< /callout >}}

#### ⑥ デフォルトモデルの選択

選択したプロバイダーに応じた最新の対応モデル一覧がOpenClawから自動取得されます。

```
🤖 デフォルトモデルの選択


  anthropic の対応モデル：
  ─────────────────────────────────
  1) anthropic/claude-sonnet-4-5
  2) anthropic/claude-opus-4-6
  3) anthropic/claude-haiku-4-5
  ...

  番号を入力するか、モデル名を直接入力してください
選択:
```

→ 番号またはモデル名を入力。

#### ⑦ Gateway の起動

```
🚀 OpenClaw Gateway を起動しますか？ (Y/n):
```

→ **Enter** または **`Y`** で起動。画面に表示されるURLをブラウザで開けば完了です🎉

{{< /tab >}}

{{< /tabs >}}

---

## 🚀 次のステップ

セットアップお疲れさまでした！次は以下の順番で進めましょう：

{{< cards >}}
  {{< card link="/wiki-notes/setup/security" title="🔒 セキュリティ初期設定" subtitle="まず最初にセキュリティを確認" >}}
  {{< card link="/wiki-notes/usage/basics" title="💬 基本的な使い方" subtitle="WebChatでの対話を始める" >}}
  {{< card link="/wiki-notes/customize/webchat-ja" title="🇯🇵 WebChat日本語化" subtitle="UIを日本語化する" >}}
  {{< card link="/wiki-notes/setup/webchat-settings" title="⚙️ WebChat設定" subtitle="詳細なカスタマイズ" >}}
{{< /cards >}}

---

## 🔗 関連リンク

- [OpenClaw公式ドキュメント](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [コミュニティ Discord](https://discord.com/invite/clawd)

---

**最終更新:** 2026-02-14
