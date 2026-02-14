---
title: "セキュリティ初期設定"
weight: 20
description: "OpenClawインストール後に最初に行うべきセキュリティ設定"
tags: ["セキュリティ", "セットアップ", "初心者向け"]
---

## ⚠️ なぜセキュリティ設定が重要？

{{< callout type="warning" >}}
OpenClawはAIにシェルコマンド実行、ファイル読み書き、ブラウザ操作、メッセージ送信などの強力な権限を与えます。適切な設定をしないと、悪意あるメッセージ（プロンプトインジェクション）によって情報漏洩やファイル操作のリスクが生じます。

**基本方針:** 最小限のアクセスから始めて、必要に応じて段階的に広げていく。
{{< /callout >}}

---

## 🔍 セキュリティ監査を実行する

インストール直後と設定変更後は、必ずセキュリティ監査を実行してください。

```bash
openclaw security audit
```

### オプション

- `--deep` - 詳細なチェックを実行
- `--fix` - 検出された問題を自動修正

### 何をチェックするか

- **DMポリシー:** ダイレクトメッセージの受信ルール
- **グループポリシー:** グループチャットでの応答ルール
- **ネットワーク露出:** Gatewayのバインド設定と認証
- **ファイル権限:** 設定ファイルのパーミッション
- **ツール設定:** サンドボックスやツールポリシー

{{< callout type="info" >}}
**推奨:** インストール直後と設定変更後に必ず実行することを習慣化しましょう。
{{< /callout >}}

---

## 🔒 Gateway認証の設定

OpenClawはデフォルトで認証必須（fail-closed）です。Gateway APIにアクセスするには認証トークンを設定する必要があります。

### トークン生成

```bash
openclaw doctor --generate-gateway-token
```

### 設定例

`~/.openclaw/openclaw.json` に以下を追加：

```json5
{
  gateway: {
    auth: {
      mode: "token",
      token: "your-long-random-token"
    },
  },
}
```

### バインドモード

- **loopback（デフォルト・推奨）:** ローカルホストからのみアクセス可能。最も安全。
- **lan/tailnet（要注意）:** ネットワーク経由でアクセス可能。必ず認証トークンを設定すること。

{{< callout type="warning" >}}
外部ネットワークに公開する場合は、必ず強力な認証トークンを設定してください。トークンなしでの公開は非常に危険です。
{{< /callout >}}

---

## 💬 DM（ダイレクトメッセージ）の制御

OpenClawには4つのDMポリシーがあります。

### ポリシー一覧

| ポリシー | 説明 | 推奨度 |
|---------|------|--------|
| **pairing** | 未知の送信者にはペアリングコードを発行。承認後に応答 | ⭐⭐⭐ 推奨 |
| **allowlist** | 許可リストに登録されたユーザーのみ応答 | ⭐⭐ 安全 |
| **open** | すべてのDMに応答 | ⚠️ 危険 |
| **disabled** | DMを完全に無効化 | - |

### pairingの仕組み（デフォルト）

1. 未知の送信者がメッセージを送ると、OpenClawがペアリングコードを発行
2. 管理者がCLIでコードを確認・承認
3. 承認後、その送信者からのメッセージに応答

### CLI操作

```bash
# ペアリングリスト確認
openclaw pairing list <channel>

# ペアリング承認
openclaw pairing approve <channel> <code>
```

### 設定例

```json5
{
  channels: {
    discord: {
      dmPolicy: "pairing"  // デフォルト
    }
  }
}
```

{{< callout type="warning" >}}
`open` ポリシーは最後の手段です。使用する場合は、設定ファイルに明示的に `"*"` を指定してopt-inする必要があります。
{{< /callout >}}

---

## 👥 グループチャットの制御

グループチャットでは、**メンションされた時だけ応答する**設定を推奨します。

### なぜ重要か

常時応答モードにすると、グループ内のすべてのメッセージをAIが処理します。これにより、プロンプトインジェクションのリスクが大幅に増大します。

### 設定例

```json5
{
  channels: {
    discord: {
      groups: {
        "*": {
          requireMention: true,  // メンションされた時のみ応答
          mentionPatterns: ["@bot", "bot"]  // メンションパターン
        }
      }
    }
  }
}
```

{{< callout type="info" >}}
`requireMention: true` をすべてのグループチャットに設定することで、不要な応答とセキュリティリスクを削減できます。
{{< /callout >}}

---

## 🛡️ サンドボックス（推奨）

サンドボックスは、ツール実行をDockerコンテナ内に隔離する機能です。

### サンドボックスモード

- **off:** サンドボックス無効（デフォルト）
- **non-main:** メインエージェント以外をサンドボックス化（推奨）
- **all:** すべてのエージェントをサンドボックス化

### 最小構成の例

```json5
{
  agents: {
    defaults: {
      sandbox: {
        mode: "non-main",
        scope: "session",
        workspaceAccess: "none",
      },
    },
  },
}
```

{{< callout type="info" >}}
サンドボックスを使用するにはDockerが必要です。事前に `scripts/sandbox-setup.sh` を実行してください。
{{< /callout >}}

---

## 📁 ファイルパーミッション

OpenClawの設定ファイルには、API キーやトークンなどの機密情報が含まれます。適切なパーミッションを設定しましょう。

### 推奨設定

```bash
chmod 700 ~/.openclaw
chmod 600 ~/.openclaw/openclaw.json
```

### 自動修正

セキュリティ監査で自動修正できます：

```bash
openclaw security audit --fix
```

---

## ✅ セキュリティチェックリスト

| 項目 | コマンド/設定 | 優先度 |
|------|--------------|--------|
| セキュリティ監査実行 | `openclaw security audit` | ⭐⭐⭐ 必須 |
| Gateway認証設定 | `openclaw doctor --generate-gateway-token` | ⭐⭐⭐ 必須 |
| DMポリシー設定 | `dmPolicy: "pairing"` | ⭐⭐⭐ 推奨 |
| グループメンション制御 | `requireMention: true` | ⭐⭐⭐ 推奨 |
| サンドボックス有効化 | `sandbox.mode: "non-main"` | ⭐⭐ 推奨 |
| ファイルパーミッション | `chmod 700 ~/.openclaw` | ⭐⭐ 推奨 |

---

## 🔗 関連リンク

- [OpenClaw公式セキュリティドキュメント](https://docs.openclaw.ai/gateway/security)
- [サンドボックス設定](https://docs.openclaw.ai/gateway/sandboxing)
- [ツールポリシー](https://docs.openclaw.ai/gateway/sandbox-vs-tool-policy-vs-elevated)

---

**最終更新:** 2026-02-14
