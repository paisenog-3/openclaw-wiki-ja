---
title: "Clawdbotからの移行"
weight: 15
description: "ClawdbotからOpenClawへの移行手順、設定の変更点、トラブルシューティング方法を解説します。"
---

# Clawdbotからの移行

ClawdbotはOpenClawにリブランドされました。このガイドでは、既存のClawdbot環境からOpenClawへの移行手順、設定の変更点、よくあるトラブルとその対処法を解説します。

{{< callout type="info" >}}
**マシン間での移行について**: 新しいマシンにOpenClawを移行する場合は、[公式の移行ガイド](https://docs.openclaw.ai/install/migrating)もあわせて参照してください。
{{< /callout >}}

---

## 移行の概要

2026年2月のリリースで、パッケージ名・コマンド名・設定ファイルのパスがすべて変更されました。

| 項目 | 旧（Clawdbot） | 新（OpenClaw） |
|------|----------------|----------------|
| パッケージ名 | `clawdbot` | `openclaw` |
| CLI コマンド | `clawdbot` | `openclaw` |
| 設定ファイル | `~/.clawdbot/clawdbot.json` | `~/.openclaw/openclaw.json` |
| セッションデータ | `~/.clawdbot/agents/` | `~/.openclaw/agents/` |
| ドキュメント | `https://docs.clawd.bot/` | `https://docs.openclaw.ai/` |

{{< callout type="warning" >}}
旧コマンド `clawdbot` はアップデート後も残る場合がありますが、新コマンド `openclaw` を使用してください。
{{< /callout >}}

---

## 事前準備

### バックアップ

移行前に設定ファイルとカスタムスクリプトをバックアップします：

```bash
# 設定ディレクトリ全体をバックアップ
cp -r ~/.clawdbot/ ~/.clawdbot.bak/

# カスタムスクリプトの確認
ls ~/.clawdbot/scripts/
ls ~/.clawdbot/telegram-error-handler.js
```

{{< callout type="warning" >}}
**セキュリティ上の注意**: バックアップには以下の機密情報が含まれます：
- API キー（Anthropic、OpenAI等）
- OAuth トークン（Telegram、Discord等）
- デバイス認証情報

バックアップファイルは適切に保護し、クラウドストレージへのアップロードやバージョン管理システムへのコミットは避けてください。
{{< /callout >}}

### state ディレクトリの構造

OpenClawは `~/.openclaw/` ディレクトリ（state directory）にすべての設定・認証情報・セッションデータを保存します：

```
~/.openclaw/
├── openclaw.json          # メイン設定ファイル
├── credentials/           # API キー、OAuth トークンなど
│   ├── anthropic.json
│   ├── telegram.json
│   └── ...
├── agents/                # エージェントのセッションデータ
│   └── main/
│       ├── sessions/      # JSONL形式のセッション履歴
│       ├── memory/        # エージェントの長期記憶
│       └── ...
├── devices/               # デバイス認証情報
│   ├── pending.json
│   └── approved.json
└── plugins/               # プラグイン設定・データ
```

**主要ファイル・ディレクトリの役割**:
- `openclaw.json`: Gateway設定、モデル選択、プロファイル設定
- `credentials/`: 各サービスのAPI キー・トークンを保存
- `agents/main/sessions/`: 会話履歴をJSONL形式で保存
- `devices/`: デバイス認証（ペアリング）の情報

### プロファイル管理

OpenClawは複数のプロファイルをサポートしており、設定を切り替えることができます：

**プロファイルの使い分け**:
```bash
# デフォルトプロファイル
openclaw gateway

# 別プロファイルを指定
openclaw --profile work gateway
openclaw --profile dev gateway
```

**state ディレクトリの変更**:
```bash
# 環境変数でstate ディレクトリを変更
export OPENCLAW_STATE_DIR=/custom/path/to/state
openclaw gateway
```

プロファイルごとに独立した設定・セッション・認証情報を持つため、用途別（開発用・本番用など）に環境を分離できます。

---

## アップデート手順

### Step 1: パッケージの更新

```bash
# WSL2またはLinux環境で実行
npm install -g openclaw@latest

# 旧パッケージの削除（オプション）
# npm uninstall -g clawdbot
```

### Step 2: 設定の移行と修復

OpenClawは初回起動時に旧設定の一部を自動移行しますが、一部のフィールドは手動修正が必要な場合があります。

```bash
# 設定の自動修復
openclaw doctor --fix
```

**`openclaw doctor` の機能**:
- 設定ファイルのスキーマ検証
- 非互換フィールドの自動修正
- 認証情報の整合性チェック
- セッションデータの破損検出
- ファイルパーミッションの確認
- 必要なディレクトリの作成

`--fix` オプションを付けると、検出された問題を自動的に修正します。

### Step 3: デバイスの再ペアリング

OpenClaw 2026.2.x ではデバイス認証が厳格化されました。初回アクセス時にペアリング承認が必要です。

```bash
# 保留中のデバイス一覧を確認
openclaw devices list

# Pending 状態のデバイスを承認
openclaw devices approve <request-id>
```

### Step 4: 動作確認

```bash
# ヘルスチェック
openclaw doctor

# Gateway 起動
openclaw gateway --port 18789
```

ブラウザで `http://localhost:18789/` にアクセスし、Control UIが表示されれば成功です。

---

## トラブルシューティング

### Config Invalid: `gateway.auth.mode`

**症状**: Gateway起動直後に以下のエラーが出て再起動ループに陥る：

```
Invalid config at /root/.openclaw/openclaw.json:
- gateway.auth.mode: Invalid input
```

**原因**: 旧Clawdbotの設定ファイルの `gateway.auth.mode` フィールドがOpenClawと互換性がありません。

**解決方法**:

{{< callout type="warning" >}}
systemdやsupervisor等の自動再起動サービスを使用している場合は、まずサービスを停止してから修復作業を行ってください：
```bash
# systemdの例
sudo systemctl stop openclaw-gateway

# supervisorの例
sudo supervisorctl stop openclaw-gateway
```
{{< /callout >}}

```bash
# 自動修復（推奨）
openclaw doctor --fix

# 手動修正が必要な場合
# 設定ファイルを確認
cat ~/.openclaw/openclaw.json | jq '.gateway.auth'
```

手動で起動している場合は `Ctrl+C` で停止してから修復作業を行ってください。

---

### `disconnected (1008): device identity required`

**症状**: Gatewayは起動するが、ブラウザでControl UIを開くとWebSocket接続が切断される。

**原因**: デバイス認証（ペアリング）が未完了、または認証情報の不一致。

**解決方法**:

**1. ペアリング承認（最も多いパターン）**:
```bash
# 保留中のデバイスを確認
openclaw devices list

# 承認
openclaw devices approve <request-id>
```

**2. アクセスURLの確認**:
- `http://localhost:18789` または `http://127.0.0.1:18789` でアクセス
- リモートアクセスの場合は必ずHTTPSを使用

**3. トークンの確認**:
```bash
# 設定ファイルのトークンを確認
jq -r '.gateway.auth.token' ~/.openclaw/openclaw.json
```

**4. キャッシュクリア**:

旧Clawdbot時代のブラウザキャッシュが干渉している可能性があります：

```bash
# ブラウザのキャッシュとローカルストレージをクリア
# または専用のChromeプロファイルを使用（推奨）
google-chrome --user-data-dir=/tmp/openclaw-chrome
```

専用プロファイルを使うことで、旧Clawdbotの認証情報やキャッシュの影響を完全に排除できます。

**5. 強制リセット（最終手段）**:
```bash
# デバイス情報のバックアップと削除
cp -r ~/.openclaw/devices/ ~/.openclaw/devices.bak/
rm ~/.openclaw/devices/pending.json
```

---

### Telegram クラッシュ再起動ループ

**症状**: Gateway起動直後にクラッシュし、exit code 1で終了。Telegram関連のエラーがログに出力される。

**原因**: Telegramプロバイダの初期化時のネットワークエラーが未ハンドルの Promise rejection を引き起こします。

**解決方法**: エラーハンドラを導入します。

`~/.openclaw/scripts/telegram-error-handler.js` を作成：

```javascript
// telegram-error-handler.js
// Catches unhandled promise rejections from Telegram provider
// to prevent process crash on network failures

const STARTUP_GRACE_MS = 30000;
const startTime = Date.now();

process.on('unhandledRejection', (reason, promise) => {
    const elapsed = Date.now() - startTime;
    const isTelegram = reason && (
        String(reason).includes('telegram') ||
        String(reason).includes('setMyCommands') ||
        String(reason).includes('GrammyError') ||
        String(reason).includes('bot.api')
    );

    if (isTelegram || elapsed < STARTUP_GRACE_MS) {
        console.error(
            `[telegram-error-handler] Caught rejection (${elapsed}ms after start):`,
            reason
        );
        return;
    }

    console.error('[telegram-error-handler] Non-Telegram unhandled rejection:', reason);
    process.exit(1);
});

console.log(
    `[telegram-error-handler] Error handler loaded successfully (${STARTUP_GRACE_MS / 1000}s startup grace period)`
);
```

起動時に読み込む：
```bash
export NODE_OPTIONS="--require $HOME/.openclaw/scripts/telegram-error-handler.js"
openclaw gateway
```

---

### Chat タブのフリーズ

**症状**: Control UIのChatタブを開くとブラウザがフリーズする、または極端に遅くなる。

**原因**: セッションのJSONLファイルに200KBを超える巨大なメッセージが含まれていると、UIのレンダリングが追いつきません。

**解決方法**: セッションガードスクリプトで巨大なセッションを事前にアーカイブします。

`~/.openclaw/scripts/session-guard.sh` を作成：

```bash
#!/bin/bash
# session-guard.sh — 巨大メッセージを含むセッションを検出・アーカイブ

SESSIONS_DIR="${HOME}/.openclaw/agents/main/sessions"
MAX_LINE_BYTES=204800  # 200KB

if [ ! -d "$SESSIONS_DIR" ]; then
    echo "[session-guard] Sessions directory not found: $SESSIONS_DIR"
    exit 1
fi

archived=0
for jsonl in "$SESSIONS_DIR"/*.jsonl; do
    [ -f "$jsonl" ] || continue
    filename=$(basename "$jsonl")
    max_line=$(awk '{ if (length > max) max = length } END { print max+0 }' "$jsonl")

    if [ "$max_line" -gt "$MAX_LINE_BYTES" ]; then
        size_kb=$((max_line / 1024))
        mv "$jsonl" "${jsonl}.bak"
        echo "[session-guard] Archived: $filename (largest message: ${size_kb}KB)"
        archived=$((archived + 1))
    fi
done

if [ "$archived" -eq 0 ]; then
    echo "[session-guard] All sessions OK"
fi
```

実行権限を付与：
```bash
chmod +x ~/.openclaw/scripts/session-guard.sh
```

Gateway起動前に実行：
```bash
~/.openclaw/scripts/session-guard.sh
openclaw gateway
```

---

### Opus 4.6 モデルが選択できない

**症状**: モデル一覧に `claude-opus-4-6` が表示されない。

**原因**: OpenClawのモデル定義ファイルに該当モデルが含まれていません。

**解決方法**: `models.generated.js` にモデル定義を追加するパッチスクリプトを作成します。

```bash
#!/bin/bash
# patch-opus46.sh — claude-opus-4-6 をモデル一覧に追加

MODELS_FILE=$(find ~/.nvm/versions/node/ -path '*/openclaw/dist/*models.generated.js' 2>/dev/null | head -1)

if [ -z "$MODELS_FILE" ]; then
    echo "[patch-opus46] models.generated.js not found"
    exit 1
fi

if grep -q 'claude-opus-4-6' "$MODELS_FILE"; then
    echo "[patch-opus46] Already patched"
    exit 0
fi

echo "[patch-opus46] Patching $MODELS_FILE..."
# パッチ処理（モデル定義を追加）
# ...
echo "[patch-opus46] Done"
```

{{< callout type="warning" >}}
`npm update -g openclaw` を実行するたびに `models.generated.js` は上書きされます。起動スクリプトでパッチを毎回自動適用するようにしてください。
{{< /callout >}}

---

## 起動スクリプトの更新

### Windows + WSL2 環境

**Windows側ランチャー（`OpenClaw起動.bat`）**:

```batch
@echo off
title OpenClaw Gateway Launcher
echo   OpenClaw Gateway Launcher
echo.

REM --- 既存プロセスの停止 ---
wsl -u root bash -c "pkill -f 'node.*[o]penclaw' 2>/dev/null"
wsl -u root bash -c "rm -f /tmp/openclaw/.gateway.lock 2>/dev/null"
timeout /t 2 /nobreak >nul

REM --- Gateway をバックグラウンドで起動 ---
start /b wsl -u root bash -c "nohup openclaw gateway --port 18789 > /tmp/openclaw-gateway.log 2>&1 &"

REM --- ポート待機 ---
echo Waiting for gateway to start on port 18789...
:wait_loop
timeout /t 3 /nobreak >nul
wsl -u root bash -c "curl -s -o /dev/null -w '%%{http_code}' http://127.0.0.1:18789/" | findstr "200 302" >nul
if %errorlevel%==0 goto :ready
goto :wait_loop

:ready
echo Gateway is ready!
start "" "http://localhost:18789/"
```

### Linux/macOS 環境

**起動スクリプト（`start-openclaw.sh`）**:

```bash
#!/bin/bash
# start-openclaw.sh — OpenClaw Gateway 起動スクリプト

# NVMの読み込み
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 22

# Telegramエラーハンドラの読み込み
export NODE_OPTIONS="--require $HOME/.openclaw/scripts/telegram-error-handler.js"

# セッションガードの実行
~/.openclaw/scripts/session-guard.sh

# Gateway起動
openclaw gateway --port 18789
```

---

## 移行後のチェックリスト

- [ ] `openclaw doctor` がエラーなしで通る
- [ ] `openclaw gateway` でGatewayが起動する
- [ ] ブラウザでControl UIにアクセスできる
- [ ] デバイスペアリングが承認済み（1008エラーが出ない）
- [ ] Chatタブでメッセージの送受信ができる
- [ ] 使用したいモデルが選択できる
- [ ] Telegramボットが応答する（使用している場合）

---

## よくある質問

### 旧 `~/.clawdbot/` ディレクトリは削除してよい？

カスタムスクリプトをまだ参照している場合は残してください。すべてのスクリプトを `~/.openclaw/scripts/` に移動し、起動スクリプトのパスを変更すれば削除可能です。

### `npm update` するたびにパッチが消える？

はい。`models.generated.js` はnpmパッケージの一部なので、アップデートで上書きされます。起動スクリプトで毎回パッチを自動適用する仕組みにしてください。

### Telegramボットの名前が旧名のままだが問題ない？

Telegram側のボット名はBotFatherで変更しない限りそのままです。機能的には問題ありません。変更したい場合はTelegramのBotFatherで `/setname` コマンドを使用してください。

---

## 参考リンク

- [OpenClaw 公式ドキュメント](https://docs.openclaw.ai/)
- [マシン間の移行ガイド](https://docs.openclaw.ai/install/migrating)
- [Gateway トラブルシューティング](https://docs.openclaw.ai/gateway/troubleshooting)
- [GitHub リポジトリ](https://github.com/openclaw/openclaw)
