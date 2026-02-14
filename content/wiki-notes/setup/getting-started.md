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

#### ④ セットアップウィザード起動（`openclaw onboard`）

インストール完了後、対話式のセットアップウィザードが起動します。画面の指示に従って、以下の項目を順に設定していきます：

{{< callout type="info" >}}
**初めての方は QuickStart（デフォルト設定）がおすすめです。** QuickStartでは多くの設定がデフォルト値で自動設定され、すぐに使い始められます。
{{< /callout >}}

{{< callout type="warning" >}}
**認証設定はウィザード完了後に行います。** ウィザード内では認証の設定画面は表示されません。完了後に別途設定します（次のステップ⑤で説明）。
{{< /callout >}}

**ウィザードで設定する項目（Manual選択時）:**

1. **セキュリティ警告の確認** — セキュリティ注意事項が表示されます。内容を確認してYesで続行

![セキュリティ警告画面](/images/onboard/01-security.png)

2. **Onboarding mode** — QuickStart（デフォルト設定）か Manual（詳細制御）を選択

![QuickStart/Manual選択画面](/images/onboard/02-mode.png)

3. **セットアップ対象** — Local gateway（ローカル環境）か Remote gateway（リモート環境）を選択
4. **Workspace directory** — ファイルを保存する場所を指定（デフォルト: `~/.openclaw/workspace`）
5. **Model check** — モデル設定の状態を表示（認証未設定の場合は警告が表示されますが、ここでは設定しません）

![モデルチェック警告画面](/images/onboard/04-gateway.png)

6. **Gateway port** — ポート番号（デフォルト: 18789）
7. **Gateway bind** — Loopback / LAN / Tailnet / Auto / Custom から選択

![Gatewayバインド設定画面](/images/onboard/05-gateway-bind.png)

8. **Gateway auth** — Token（推奨） / Password から選択
9. **Tailscale exposure** — Off / Serve / Funnel から選択
10. **Gateway token** — トークン入力（空欄にすると自動生成）
11. **Channel status** — 各チャネルの状態一覧が表示されます
12. **Configure chat channels now?** — チャネル設定をするか選択（スキップ可）
13. **Select channel** — 設定するチャネルを選択（Telegram、Discord、WhatsApp等）

![チャネル選択画面](/images/onboard/08-channel-select.png)

14. **サービスのインストール** — WSL2の systemd ユニットをインストール

{{< callout type="info" >}}
**QuickStartを選択した場合:**
セキュリティ警告→QuickStart選択→(既存設定があれば確認)→チャネル選択→完了、のように簡略化されたフローで進みます。以下のデフォルト設定が自動で適用されます:
- ローカルGateway（loopback接続）
- ポート 18789
- Gateway認証: Token（自動生成）
- Tailscale: Off
{{< /callout >}}

#### ⑤ 認証設定（ウィザード完了後に別途実施）

{{< callout type="warning" >}}
**重要:** onboardウィザード内では認証設定（APIキー/セッショントークン）は行いません。ウィザード完了後に以下のいずれかの方法で設定してください。
{{< /callout >}}

**方法1: コマンドラインから設定**

```bash
openclaw configure --section model
```

対話式で以下を設定できます:
- APIキーまたはセッショントークンの入力
- デフォルトモデルの選択
- プロバイダーの選択（Anthropic、OpenAI、Google、Groq等）

**方法2: WebChat画面から設定**

1. ブラウザでGatewayのURL（`http://localhost:18789`）を開く
2. 右上の ⚙️（設定）→ Control UI を開く
3. Model Configuration セクションでAPIキーやモデルを設定

{{< callout type="info" >}}
ローカルモデル（Ollama、LM Studio等）を使用する場合も、この段階で設定します。
{{< /callout >}}

#### ⑥ セットアップ完了

認証設定が完了すると、すべての準備が整いました🎉  
ブラウザで表示されているURLから、すぐにOpenClawを使い始められます。

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

#### ③ セットアップウィザード起動（`openclaw onboard`）

インストール完了後、対話式のセットアップウィザードが起動します。画面の指示に従って、以下の項目を順に設定していきます：

{{< callout type="info" >}}
**初めての方は QuickStart（デフォルト設定）がおすすめです。** QuickStartでは多くの設定がデフォルト値で自動設定され、すぐに使い始められます。
{{< /callout >}}

{{< callout type="warning" >}}
**認証設定はウィザード完了後に行います。** ウィザード内では認証の設定画面は表示されません。完了後に別途設定します（次のステップ④で説明）。
{{< /callout >}}

**ウィザードで設定する項目（Manual選択時）:**

1. **セキュリティ警告の確認** — セキュリティ注意事項が表示されます。内容を確認してYesで続行

![セキュリティ警告画面](/images/onboard/01-security.png)

2. **Onboarding mode** — QuickStart（デフォルト設定）か Manual（詳細制御）を選択

![QuickStart/Manual選択画面](/images/onboard/02-mode.png)

3. **セットアップ対象** — Local gateway（ローカル環境）か Remote gateway（リモート環境）を選択
4. **Workspace directory** — ファイルを保存する場所を指定（デフォルト: `~/.openclaw/workspace`）
5. **Model check** — モデル設定の状態を表示（認証未設定の場合は警告が表示されますが、ここでは設定しません）

![モデルチェック警告画面](/images/onboard/04-gateway.png)

6. **Gateway port** — ポート番号（デフォルト: 18789）
7. **Gateway bind** — Loopback / LAN / Tailnet / Auto / Custom から選択

![Gatewayバインド設定画面](/images/onboard/05-gateway-bind.png)

8. **Gateway auth** — Token（推奨） / Password から選択
9. **Tailscale exposure** — Off / Serve / Funnel から選択
10. **Gateway token** — トークン入力（空欄にすると自動生成）
11. **Channel status** — 各チャネルの状態一覧が表示されます
12. **Configure chat channels now?** — チャネル設定をするか選択（スキップ可）
13. **Select channel** — 設定するチャネルを選択（Telegram、Discord、WhatsApp等）

![チャネル選択画面](/images/onboard/08-channel-select.png)

14. **サービスのインストール** — macOS の LaunchAgent または Linux/WSL2 の systemd ユニットをインストール

{{< callout type="info" >}}
**QuickStartを選択した場合:**
セキュリティ警告→QuickStart選択→(既存設定があれば確認)→チャネル選択→完了、のように簡略化されたフローで進みます。以下のデフォルト設定が自動で適用されます:
- ローカルGateway（loopback接続）
- ポート 18789
- Gateway認証: Token（自動生成）
- Tailscale: Off
{{< /callout >}}

#### ④ 認証設定（ウィザード完了後に別途実施）

{{< callout type="warning" >}}
**重要:** onboardウィザード内では認証設定（APIキー/セッショントークン）は行いません。ウィザード完了後に以下のいずれかの方法で設定してください。
{{< /callout >}}

**方法1: コマンドラインから設定**

```bash
openclaw configure --section model
```

対話式で以下を設定できます:
- APIキーまたはセッショントークンの入力
- デフォルトモデルの選択
- プロバイダーの選択（Anthropic、OpenAI、Google、Groq等）

**方法2: WebChat画面から設定**

1. ブラウザでGatewayのURL（`http://localhost:18789`）を開く
2. 右上の ⚙️（設定）→ Control UI を開く
3. Model Configuration セクションでAPIキーやモデルを設定

{{< callout type="info" >}}
ローカルモデル（Ollama、LM Studio等）を使用する場合も、この段階で設定します。
{{< /callout >}}

#### ⑤ セットアップ完了

認証設定が完了すると、すべての準備が整いました🎉  
ブラウザで表示されているURLから、すぐにOpenClawを使い始められます。

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
