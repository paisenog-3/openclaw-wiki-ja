---
title: "セキュリティ初期設定"
weight: 20
description: "OpenClawインストール後に行うべきセキュリティ設定の包括的ガイド"
tags: ["セキュリティ", "セットアップ"]
---

OpenClawインストール後に設定すべき全セキュリティ項目の包括的リファレンス。本ページはAIエージェントが読み取り、実行可能な形式で記述されています。

---

## 🔍 セキュリティ監査

### コマンド

```bash
# 標準監査
openclaw security audit

# 詳細監査
openclaw security audit --deep

# 自動修正付き監査
openclaw security audit --fix
```

### チェック項目

- Gateway認証設定の有無
- ネットワークバインド設定と認証の組み合わせ
- DMポリシー（pairing/allowlist推奨）
- グループポリシー（requireMention推奨）
- ファイルパーミッション（~/.openclaw: 700、openclaw.json: 600）
- サンドボックス設定
- ツールポリシー設定

{{< callout type="info" >}}
インストール直後および設定変更後に必ず実行すること。
{{< /callout >}}

---

## 🔒 Gateway認証

### デフォルト動作

- 認証必須（fail-closed）
- オンボーディングウィザードが初回起動時にトークンを生成

### 認証モード

| モード | 説明 |
|--------|------|
| `token` | トークンベース認証（推奨） |
| `password` | パスワード認証 |

### トークン生成

```bash
openclaw doctor --generate-gateway-token
```

### 設定例（トークンモード）

```json5
{
  gateway: {
    auth: {
      mode: "token",
      token: "your-cryptographically-random-token-here"
    },
    // リモートCLIアクセス用（ローカルWebSocket認証とは別）
    remote: {
      token: "separate-remote-cli-token",
      // TLS証明書フィンガープリント固定（MITM対策）
      tlsFingerprint: "sha256:..."
    }
  }
}
```

### 環境変数による認証

```bash
export OPENCLAW_GATEWAY_PASSWORD="your-password"
openclaw gateway start
```

{{< callout type="warning" >}}
トークンは暗号学的に安全なランダム文字列を使用すること。`--generate-gateway-token`の使用を推奨。
{{< /callout >}}

---

## 🌐 ネットワーク露出

### gateway.bind設定

| 値 | 説明 | 安全性 |
|----|------|--------|
| `loopback` | 127.0.0.1のみ（デフォルト） | ⭐⭐⭐ 最も安全 |
| `lan` | LAN内からアクセス可能 | ⚠️ 認証必須 |
| `tailnet` | Tailscaleネットワークからアクセス可能 | ⚠️ 認証必須 |
| `0.0.0.0` or custom | カスタムバインド | 🚨 認証必須 |

### gateway.port

デフォルト: `18789`

### 推奨構成

```json5
{
  gateway: {
    bind: "loopback",  // ローカルのみ
    port: 18789,
    auth: {
      mode: "token",
      token: "..."
    }
  }
}
```

### Tailscale Serve経由での公開（推奨）

```bash
# Tailscale Serveを使用（バインドはloopbackのまま）
tailscale serve https / http://127.0.0.1:18789
```

LANバインド（0.0.0.0）よりもTailscale Serveの使用を推奨。

### リバースプロキシ経由の場合

```json5
{
  gateway: {
    trustedProxies: ["192.168.1.0/24"],
    auth: {
      // Tailscaleアイデンティティヘッダーによる認証
      allowTailscale: true
    }
  }
}
```

{{< callout type="warning" >}}
**絶対禁止:** 認証なしで0.0.0.0にバインドすることは、システムへの無制限アクセスを許可することに等しい。
{{< /callout >}}

---

## 📡 mDNS/ディスカバリー

### デフォルト動作

mDNS経由でローカルネットワークに存在を通知。

### モード

| モード | 説明 |
|--------|------|
| `minimal` | サービス名のみ通知（推奨） |
| `off` | mDNS完全無効 |
| `full` | 詳細情報を通知（cliPath、sshPort等） |

### 設定例

```json5
{
  discovery: {
    mdns: {
      mode: "minimal"  // 推奨
    }
  }
}
```

### fullモードで公開される情報

- CLIパス (`cliPath`)
- SSHポート (`sshPort`)
- ホスト名
- バージョン情報

{{< callout type="info" >}}
プライバシーとセキュリティのため、`minimal`または`off`を推奨。
{{< /callout >}}

---

## 💬 DMポリシー

### 4つのポリシー

| ポリシー | 動作 | 推奨度 |
|----------|------|--------|
| `pairing` | ペアリングコード発行→承認後に応答 | ⭐⭐⭐ デフォルト推奨 |
| `allowlist` | 許可リストのユーザーのみ | ⭐⭐ 厳格 |
| `open` | すべてのDMに応答 | 🚨 危険 |
| `disabled` | DM完全無効 | - |

### ペアリングフロー（pairingポリシー）

1. 未知の送信者がDMを送信
2. OpenClawがペアリングコード（例: `ABC123`）を発行
3. オペレーターがCLIで承認: `openclaw pairing approve <channel> ABC123`
4. 承認後、その送信者からのメッセージに応答

### CLI操作

```bash
# ペアリングリスト表示
openclaw pairing list discord

# ペアリング承認
openclaw pairing approve discord ABC123

# ペアリング拒否
openclaw pairing reject discord ABC123
```

### チャンネルごとの設定例

```json5
{
  channels: {
    discord: {
      dmPolicy: "pairing"
    },
    telegram: {
      dmPolicy: "allowlist",
      dmAllowFrom: ["user123", "user456"]
    },
    whatsapp: {
      dmPolicy: "disabled"
    }
  }
}
```

### DMセッション分離

複数ユーザーからのDMを処理する場合、セッション分離が重要。

```json5
{
  session: {
    // DMセッションのスコープ
    dmScope: "per-channel-peer"  // 推奨（各ユーザーごとに別セッション）
    // dmScope: "main"  // デフォルト（全DMが同じセッションを共有）
    // dmScope: "per-account-channel-peer"  // マルチアカウント環境
  }
}
```

| dmScope | 説明 |
|---------|------|
| `main` | 全DMが同じセッションを共有（デフォルト） |
| `per-channel-peer` | チャンネル×ユーザーごとに別セッション（推奨） |
| `per-account-channel-peer` | アカウント×チャンネル×ユーザーごとに別セッション |

### クロスチャンネルアイデンティティ

同一ユーザーの異なるチャンネルアカウントをリンク。

```json5
{
  session: {
    identityLinks: [
      {
        discord: "user123",
        telegram: "@user123",
        whatsapp: "+1234567890"
      }
    ]
  }
}
```

---

## 👥 グループポリシー

### ポリシー

| ポリシー | 説明 |
|----------|------|
| `open` | すべてのグループメッセージを処理 |
| `allowlist` | 許可リストのグループのみ |

### メンション要求（推奨）

すべてのグループで`requireMention: true`を設定。

```json5
{
  channels: {
    discord: {
      groupPolicy: "open",
      groups: {
        "*": {  // すべてのグループ
          requireMention: true,  // メンション時のみ応答
          mentionPatterns: ["@OpenClaw", "oc>", "!oc"]
        }
      }
    },
    telegram: {
      groups: {
        "*": {
          requireMention: true,
          mentionPatterns: ["@OpenClawBot", "/oc"]
        }
      }
    },
    whatsapp: {
      groups: {
        "*": {
          requireMention: true,
          mentionPatterns: ["@OpenClaw"]
        }
      }
    }
  }
}
```

### グループごとの個別設定

```json5
{
  channels: {
    discord: {
      groupPolicy: "allowlist",
      groups: {
        "123456789": {  // グループID
          requireMention: false,  // このグループでは常時応答
          groupAllowFrom: ["admin_user_id"]  // このユーザーのみボット起動可能
        },
        "987654321": {
          requireMention: true
        }
      }
    }
  }
}
```

{{< callout type="warning" >}}
`requireMention: false`のグループでは、すべてのメッセージがAIに送信されるため、プロンプトインジェクションリスクが増大。
{{< /callout >}}

---

## 🛡️ サンドボックス

### サンドボックスモード

```json5
{
  agents: {
    defaults: {
      sandbox: {
        mode: "non-main",  // off | non-main | all
        scope: "session",  // session | agent | shared
        workspaceAccess: "none"  // none | ro | rw
      }
    }
  }
}
```

| mode | 説明 |
|------|------|
| `off` | サンドボックス無効（デフォルト） |
| `non-main` | メインエージェント以外をサンドボックス化（推奨） |
| `all` | すべてのエージェントをサンドボックス化 |

| scope | 説明 |
|-------|------|
| `session` | セッションごとに専用コンテナ（デフォルト） |
| `agent` | エージェントごとに専用コンテナ |
| `shared` | 全エージェントで共有コンテナ |

| workspaceAccess | 説明 |
|-----------------|------|
| `none` | ワークスペースアクセスなし（デフォルト） |
| `ro` | 読み取り専用 |
| `rw` | 読み書き可能 |

### Docker セットアップ

```bash
# サンドボックス用Dockerイメージのビルド
./scripts/sandbox-setup.sh
```

### ネットワーク設定

デフォルト: コンテナ内からのネットワークアクセスなし（隔離）。

### カスタムバインドマウント

```json5
{
  agents: {
    defaults: {
      sandbox: {
        docker: {
          binds: [
            "/host/data:/container/data:ro",
            "/host/output:/container/output:rw"
          ]
        }
      }
    }
  }
}
```

### コンテナ初期化コマンド

```json5
{
  agents: {
    defaults: {
      sandbox: {
        setupCommand: "apt-get update && apt-get install -y python3-pip"
      }
    }
  }
}
```

### ブラウザサンドボックス

```json5
{
  agents: {
    defaults: {
      sandbox: {
        browser: {
          allowHostControl: false  // ホストブラウザ制御を禁止
        }
      }
    }
  }
}
```

{{< callout type="info" >}}
サンドボックスはDockerが必要。事前に`./scripts/sandbox-setup.sh`を実行すること。
{{< /callout >}}

---

## 🔧 ツールポリシー

### ツールプロファイル

```json5
{
  tools: {
    profile: "base",  // ベース許可リスト
    allow: [
      "read",
      "web_fetch",
      "group:fs"  // ファイルシステムツールグループ
    ],
    deny: [
      "exec",  // deny は always wins
      "write"
    ]
  }
}
```

### ツールグループ

| グループ | 含まれるツール |
|----------|----------------|
| `group:runtime` | exec, process |
| `group:fs` | read, write, edit |
| `group:sessions` | sessions_* |
| `group:memory` | memory_* |
| `group:ui` | browser, canvas |
| `group:automation` | browser, canvas, nodes |
| `group:messaging` | message |
| `group:nodes` | nodes |
| `group:openclaw` | OpenClaw内部ツール |

### サンドボックス内ツールポリシー

```json5
{
  tools: {
    sandbox: {
      tools: {
        allow: ["exec", "write"],  // サンドボックス内でのみ許可
        deny: ["message", "nodes"]  // サンドボックス内でも拒否
      }
    }
  }
}
```

### エージェントごとのオーバーライド

```json5
{
  agents: {
    list: [
      {
        name: "researcher",
        tools: {
          allow: ["read", "web_fetch"],
          deny: ["exec", "write", "edit"]
        }
      },
      {
        name: "coder",
        tools: {
          allow: ["group:fs", "exec"]
        }
      }
    ]
  }
}
```

### 読み取り専用モードパターン

```json5
{
  agents: {
    defaults: {
      sandbox: {
        mode: "all",
        workspaceAccess: "ro"
      }
    }
  },
  tools: {
    deny: ["write", "edit", "exec"]
  }
}
```

---

## ⚡ Elevated exec

ホスト上で昇格権限でコマンドを実行する機能。

### 設定

```json5
{
  tools: {
    elevated: {
      enabled: true,
      allowFrom: {
        discord: ["your_discord_id"],
        telegram: ["@your_username"]
      }
    }
  }
}
```

### エージェントごとの設定

```json5
{
  agents: {
    list: [
      {
        name: "admin-agent",
        tools: {
          elevated: {
            enabled: true
          }
        }
      }
    ]
  }
}
```

### セッションコマンド `/exec`

```bash
# セッション内で一時的にelevated exec有効化（設定ファイルには書き込まれない）
/exec ls -la
```

{{< callout type="warning" >}}
Elevated execはホスト上で任意コードを実行可能。信頼できる送信者のみに許可すること。
{{< /callout >}}

---

## 🔐 Exec approvals

### 承認ファイル

`~/.openclaw/exec-approvals.json`

### セキュリティモード

| モード | 説明 |
|--------|------|
| `deny` | すべて拒否 |
| `allowlist` | 許可リストのコマンドのみ実行 |
| `full` | すべて許可 |

### Ask モード

| モード | 説明 |
|--------|------|
| `off` | 確認なし（allowlistに従う） |
| `on-miss` | allowlistにない場合のみ確認 |
| `always` | 常に確認 |

### 設定例

```json5
{
  security: {
    execApprovals: {
      mode: "allowlist",
      ask: "on-miss",
      askFallback: "deny",  // 確認がタイムアウトした場合の動作
      agents: {
        main: {
          allow: [
            "ls",
            "cat",
            "git *",
            "npm install *",
            "python3 scripts/*.py"
          ]
        },
        "coder": {
          allow: [
            "make",
            "cargo build",
            "npm *"
          ]
        }
      }
    }
  }
}
```

### Safe binaries（stdin専用バイナリ）

```json5
{
  tools: {
    exec: {
      safeBins: ["jq", "sed", "awk", "grep"]  // stdin経由のみ実行可能
    }
  }
}
```

### Skill CLIの自動許可

```json5
{
  tools: {
    exec: {
      autoAllowSkillClis: true  // スキルが提供するCLIを自動許可
    }
  }
}
```

### 承認のチャットチャンネルへの転送

```json5
{
  security: {
    execApprovals: {
      forwardTo: ["discord:your_channel_id"]
    }
  }
}
```

---

## 🌍 ブラウザ制御

### ブラウザプロファイル

OpenClaw専用のブラウザプロファイルの使用を推奨。

```json5
{
  browser: {
    profile: "openclaw"  // 専用プロファイル（推奨）
    // profile: "chrome"  // 日常使用のChromeプロファイル（非推奨）
  }
}
```

### ホスト制御の許可

```json5
{
  agents: {
    defaults: {
      sandbox: {
        browser: {
          allowHostControl: false  // サンドボックス内からホストブラウザ制御を禁止
        }
      }
    }
  }
}
```

### Chrome拡張リレー

Chrome拡張リレーはオペレーターレベルのアクセス権限を持つ。

{{< callout type="warning" >}}
- Chrome拡張リレーは信頼できる環境でのみ使用
- リレー/制御ポートはTailscaleネットワーク内のみに限定
- 個人の日常ブラウザプロファイルとの接続は避ける
{{< /callout >}}

### ブラウザノード機能の無効化

```json5
{
  gateway: {
    nodes: {
      browser: {
        mode: "off"  // ブラウザノード機能を無効化
      }
    }
  }
}
```

---

## 🔌 プラグイン/拡張

### リスク

- プラグインはOpenClawプロセス内で実行（信頼できるコードのみ）
- `npm install`はライフサイクルスクリプトを実行（コード実行リスク）

### 許可リスト推奨

```json5
{
  plugins: {
    allow: [
      "@openclaw/plugin-github",
      "@openclaw/plugin-jira",
      "my-trusted-plugin"
    ]
  }
}
```

### バージョン固定

```bash
# 常に特定バージョンを指定
openclaw plugin install @openclaw/plugin-github@1.2.3

# package.jsonで固定
{
  "dependencies": {
    "@openclaw/plugin-github": "1.2.3"
  }
}
```

{{< callout type="warning" >}}
プラグインは信頼できるソースからのみインストールすること。
{{< /callout >}}

---

## 📝 ログ＆秘匿化

### 機密情報の秘匿化

```json5
{
  logging: {
    redactSensitive: "tools",  // デフォルト、推奨
    // redactSensitive: "off"  // 秘匿化なし（デバッグ時のみ）
    // redactSensitive: "full"  // すべての引数を秘匿化
    redactPatterns: [
      "password=.*",
      "token=.*",
      "api_key=.*",
      "sk-[a-zA-Z0-9]+"  // OpenAI APIキーパターン
    ]
  }
}
```

### セッショントランスクリプト

- すべての会話が`~/.openclaw/sessions/`に保存される
- 機密情報（パスワード、APIキー等）が含まれる可能性
- 定期的な古いトランスクリプトの削除を推奨

```bash
# 古いセッションの削除
find ~/.openclaw/sessions -name "*.jsonl" -mtime +90 -delete
```

---

## 📁 ファイルパーミッション

### 推奨パーミッション

```bash
chmod 700 ~/.openclaw
chmod 600 ~/.openclaw/openclaw.json
chmod 600 ~/.openclaw/credentials.json
chmod 600 ~/.openclaw/auth-profiles.json
chmod 700 ~/.openclaw/sessions
```

### 機密ファイル

- `openclaw.json` - Gateway認証トークン、APIキー
- `credentials.json` - 外部サービスのクレデンシャル
- `auth-profiles.json` - チャンネル認証情報
- `sessions/` - セッショントランスクリプト（会話履歴）

### 自動修正

```bash
openclaw security audit --fix
```

### フルディスク暗号化

OpenClawディレクトリを含むディスク全体の暗号化を推奨。

---

## 🤖 モデル選択の指針

### プロンプトインジェクション耐性

| モデルサイズ/世代 | 耐性 | ツール使用 |
|-------------------|------|-----------|
| 最新Opus（例: Claude Opus 4） | ⭐⭐⭐ 高い | ✅ 推奨 |
| Sonnet（最新） | ⭐⭐ 中程度 | ✅ OK |
| 小型モデル（Haiku等） | ⚠️ 低い | ⚠️ サンドボックス必須 |
| 古い世代のモデル | ⚠️ 低い | ⚠️ サンドボックス必須 |

### 推奨構成

```json5
{
  agents: {
    defaults: {
      model: "anthropic/claude-opus-4-6"  // 最新Opus推奨
    },
    list: [
      {
        name: "chat-only",
        model: "anthropic/claude-haiku-3-5",  // チャット専用なら小型OK
        tools: {
          deny: ["*"]  // ツールなし
        }
      },
      {
        name: "tooled-agent",
        model: "anthropic/claude-opus-4-6",  // ツール使用は大型モデル
        sandbox: {
          mode: "all"  // 加えてサンドボックス
        }
      }
    ]
  }
}
```

{{< callout type="warning" >}}
小型モデルでツール使用を有効にする場合は、必ずサンドボックスを併用すること。
{{< /callout >}}

---

## 📋 セキュアベースライン設定

以下は、インストール後の最小セキュア構成。`~/.openclaw/openclaw.json`にコピーして使用可能。

```json5
{
  // Gateway認証（必須）
  gateway: {
    bind: "loopback",  // ローカルのみ
    port: 18789,
    auth: {
      mode: "token",
      token: "REPLACE_WITH_GENERATED_TOKEN"  // openclaw doctor --generate-gateway-token
    }
  },

  // mDNS最小化
  discovery: {
    mdns: {
      mode: "minimal"
    }
  },

  // DMペアリング必須
  channels: {
    "*": {  // すべてのチャンネル
      dmPolicy: "pairing",
      groups: {
        "*": {
          requireMention: true  // すべてのグループでメンション必須
        }
      }
    }
  },

  // DMセッション分離（マルチユーザー環境）
  session: {
    dmScope: "per-channel-peer"
  },

  // サンドボックス有効化（non-mainエージェント）
  agents: {
    defaults: {
      model: "anthropic/claude-opus-4-6",  // 最新Opus推奨
      sandbox: {
        mode: "non-main",
        scope: "session",
        workspaceAccess: "none",
        browser: {
          allowHostControl: false
        }
      }
    }
  },

  // ツールポリシー
  tools: {
    profile: "base",
    // Elevated exec無効（必要なら個別有効化）
    elevated: {
      enabled: false
    },
    // Exec承認
    exec: {
      safeBins: ["jq", "sed", "awk", "grep"]
    }
  },

  // Exec承認設定
  security: {
    execApprovals: {
      mode: "allowlist",
      ask: "on-miss",
      askFallback: "deny",
      agents: {
        main: {
          allow: [
            "ls",
            "cat",
            "git status",
            "git log",
            "git diff"
          ]
        }
      }
    }
  },

  // ログ秘匿化
  logging: {
    redactSensitive: "tools",
    redactPatterns: [
      "password=.*",
      "token=.*",
      "api_key=.*",
      "sk-[a-zA-Z0-9]+"
    ]
  },

  // プラグイン許可リスト
  plugins: {
    allow: []  // 必要なプラグインを個別追加
  }
}
```

### 適用手順

1. 上記設定を`~/.openclaw/openclaw.json`に保存
2. `REPLACE_WITH_GENERATED_TOKEN`を実際のトークンに置換: `openclaw doctor --generate-gateway-token`
3. チャンネル名を実際の使用チャンネルに変更（`discord`, `telegram`等）
4. Docker サンドボックスセットアップ: `./scripts/sandbox-setup.sh`
5. パーミッション設定: `chmod 600 ~/.openclaw/openclaw.json`
6. 監査実行: `openclaw security audit --fix`
7. Gatewayリスタート: `openclaw gateway restart`

---

## 🚨 インシデント対応

### 封じ込め（Containment）

```bash
# 即座にGatewayを停止
openclaw gateway stop

# 実行中のサンドボックスコンテナを停止
docker ps --filter "label=openclaw.sandbox=true" -q | xargs docker stop
```

### シークレットローテーション

#### 1. Gateway認証トークン

```bash
# 新しいトークン生成
openclaw doctor --generate-gateway-token

# openclaw.jsonを更新
# gateway.auth.token を新しい値に変更

# Gatewayリスタート
openclaw gateway restart
```

#### 2. リモートCLIトークン

```json5
{
  gateway: {
    remote: {
      token: "NEW_REMOTE_TOKEN"
    }
  }
}
```

#### 3. プロバイダークレデンシャル

- `~/.openclaw/credentials.json`内の該当クレデンシャルを更新
- Discord bot token、Telegram bot token等を各サービスで再生成

### ログ監査

#### 確認すべきログ

```bash
# Gateway ログ
tail -f ~/.openclaw/logs/gateway.log

# セッショントランスクリプト
ls -lt ~/.openclaw/sessions/*.jsonl

# 最近実行されたexecコマンド
rg '"tool":"exec"' ~/.openclaw/sessions/*.jsonl | tail -20

# 機密ファイルへのアクセス
rg '"tool":"read".*credentials' ~/.openclaw/sessions/*.jsonl
```

#### 確認ポイント

- 予期しないexecコマンド実行
- 機密ファイル（credentials.json、.env等）への読み取り
- 外部への大量データ送信（message、web_fetch等）
- 設定ファイルの変更（write、edit）

### 設定変更の確認

```bash
# 設定ファイルの変更履歴（Git管理している場合）
git log -p ~/.openclaw/openclaw.json

# 最終変更日時
stat ~/.openclaw/openclaw.json

# 現在の設定監査
openclaw security audit --deep
```

---

## 🔗 関連リンク

- [OpenClaw公式ドキュメント - Security](https://docs.openclaw.ai/gateway/security)
- [OpenClaw公式ドキュメント - Sandboxing](https://docs.openclaw.ai/gateway/sandboxing)
- [OpenClaw公式ドキュメント - Tool Policy vs Sandbox vs Elevated](https://docs.openclaw.ai/gateway/sandbox-vs-tool-policy-vs-elevated)
- [OpenClaw公式ドキュメント - DM Policy](https://docs.openclaw.ai/gateway/dm-policy)
- [OpenClaw公式ドキュメント - Group Policy](https://docs.openclaw.ai/gateway/group-policy)
- [OpenClaw公式ドキュメント - Exec Approvals](https://docs.openclaw.ai/gateway/exec-approvals)

---

**最終更新:** 2026-02-14
