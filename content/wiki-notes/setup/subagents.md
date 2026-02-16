---
title: "サブエージェント設定ガイド"
weight: 15
description: "OpenClawのサブエージェント（Sub-Agent）の役割、設定方法、使い分けの指針を解説します"
tags: ["セットアップ", "サブエージェント", "設定", "中級者向け"]
---

{{< callout type="info" >}}
**サブエージェントはOpenClawの核心機能です。**

メインセッションは「指揮者」として会話とマネジメントに専念し、実際の作業（検索、コーディング、データ処理等）はサブエージェントに委譲します。これにより、メインセッションのコンテキストを圧迫せず、記憶の持続時間を延ばし、並列実行で効率を上げることができます。
{{< /callout >}}

---

## 役割の違い

| 役割 | メインセッション | サブエージェント |
|------|-----------------|----------------|
| **担当** | 会話・判断・意思決定 | 実作業・ツール実行 |
| **やること** | ユーザーとの対話、サブへの指示出し、結果の統合 | 検索、調査、ファイル操作、コーディング、デバッグ |
| **コンテキスト** | 軽く保つ（記憶の維持） | 専用コンテキストで集中作業 |
| **モデル** | Opus（高度な判断） | Sonnet/Opus（タスクに応じて選択） |

### なぜサブに投げる方が良いのか

| 観点 | メリット |
|------|---------|
| **精度** | サブは専用のコンテキストで集中作業するため、精度が高い |
| **記憶** | メインのコンテキストが膨張しない → 記憶が長持ちする |
| **速度** | 並列実行できる → ユーザーの待ち時間が減る |
| **品質** | メインは会話と判断に集中できる → 回答の質が上がる |

{{< callout type="warning" >}}
**「1回のツール呼び出しだから自分でやる」は典型的なアンチパターンです。**

メインエージェントがツールを直接叩くと、コンテキストが肥大化してセッション圧縮が早まり、記憶が失われます。サブに任せることで、メインのコンテキストを軽く保ち、長期的な文脈・関係性を維持できます。
{{< /callout >}}

---

## サブエージェントの仕組み

### 実行フロー

```
1. メインセッション
   └─> sessions_spawn でサブエージェントを起動
       ├─ task: タスク内容
       ├─ model: 使用モデル（省略時はデフォルト設定 or 親を継承）
       ├─ thinking: 推論レベル（省略時はデフォルト設定 or 親を継承）
       └─ label: 識別名

2. サブエージェント
   └─> 専用のセッションで作業実行
       ├─ ツール呼び出し（Read, web_fetch, exec等）
       ├─ 結果をまとめる
       └─ 完了を Announce（メインに通知）

3. メインセッション
   └─> サブの結果を受け取り、ユーザーに報告
```

### セッションキー

サブエージェントは独立したセッションキーで管理されます：

| セッションタイプ | キー形式 | 例 |
|-----------------|---------|---|
| メインセッション | `agent:<agentId>:main` | `agent:main:main` |
| サブエージェント（深度1） | `agent:<agentId>:subagent:<uuid>` | `agent:main:subagent:abc123...` |
| サブエージェント（深度2） | `agent:<agentId>:subagent:<uuid>:subagent:<uuid>` | `agent:main:subagent:abc123...:subagent:def456...` |

---

## 設定方法

サブエージェントの動作は `~/.openclaw/openclaw.json` で制御します。基本設定は `agents.defaults.subagents` セクション、ツールポリシーは `tools.subagents` セクションに分かれています。

### 基本設定

```json5
{
  agents: {
    defaults: {
      subagents: {
        maxConcurrent: 8,        // 同時実行可能なサブの数（デフォルト: 8）
        model: "sonnet",         // デフォルトモデル（省略時は親のモデルを継承）
        thinking: "low",         // デフォルトthinkingレベル（省略時は親を継承）
        maxSpawnDepth: 1,        // ネストの深さ（範囲: 1–5、デフォルト: 1）
        maxChildrenPerAgent: 5,  // 1セッションが持てる子の数（範囲: 1–20、デフォルト: 5）
        archiveAfterMinutes: 60  // サブセッションの自動アーカイブ（デフォルト: 60分）
      }
    }
  }
}
```

{{< callout type="info" >}}
現在の設定を確認するには：

```bash
cat ~/.openclaw/openclaw.json | jq '.agents.defaults.subagents'
```
{{< /callout >}}

### 設定項目の詳細

#### maxConcurrent

同時実行可能なサブエージェントの数です。サブエージェント専用のキュー（レーン名: `subagent`）で管理されます。多すぎるとシステムリソースを消費するため、デフォルトの8が推奨です。

#### model と thinking

サブエージェントのデフォルトモデルと推論レベルを指定します。省略時は親セッション（メイン）のモデル・thinkingを継承します。`sessions_spawn` の呼び出し時に明示的に指定すると、デフォルト設定より優先されます。

```json5
{
  agents: {
    defaults: {
      subagents: {
        model: "sonnet",   // デフォルトは Sonnet（コスト効率）
        thinking: "low"    // 軽い判断・要約タスク向け
      }
    }
  }
}
```

{{< callout type="warning" >}}
サブエージェントもそれぞれ独自のコンテキストを持つため、トークン使用量が増えます。頻繁に使う場合は、サブには軽量モデル（Sonnet）を設定し、メインには高品質モデル（Opus）を使う構成がコスト最適化に有効です。
{{< /callout >}}

#### maxSpawnDepth

サブエージェントがさらにサブエージェントを起動できるかを制御します。範囲は1〜5ですが、実用上は1か2を推奨します。

| 値 | 動作 |
|----|------|
| `1` | サブは子を起動できない（デフォルト） |
| `2` | サブは子を起動できる（オーケストレーターパターン） |
| `3–5` | さらに深いネスト（特殊なユースケース向け） |

詳細は後述の「[ネストされたサブエージェント](#ネストされたサブエージェント)」を参照してください。

---

## モデル × Thinking 使い分けルール

サブエージェントを起動する際、タスクの性質に応じてモデルと推論レベルを選択します。

### 判断フロー

```
手順書を渡せば完成する？
├── Yes → Sonnet
│   └── 判断・取捨選択がある？
│       ├── No  → thinking: off（機械的に実行するだけ）
│       └── Yes → thinking: low（要約の取捨選択など）
│
└── No → Opus
    └── 複数ステップの推論が要る？
        ├── No  → thinking: low（提案・分析）
        └── Yes → thinking: high（研究・複雑な実装）
```

### 具体的な割り当て

| タスクタイプ | model | thinking | 具体例 |
|------------|-------|----------|--------|
| **定型抽出** | sonnet | off | 事実抽出、ファイル分割、テンプレ適用、grep的作業 |
| **要約・整理** | sonnet | low | 会話要約、weekly digest、インデックス生成、ドキュメント統合 |
| **設計・分析** | opus | low | アーキテクチャ提案、比較分析、Feature Request作成 |
| **深い研究・複雑な実装** | opus | high | ソース解析+設計+PoC、デバッグ込み開発、未知の問題解決 |

{{< callout type="tip" >}}
**一言で覚える:**
- **「手順書を渡せば完成する？」→ Yes: Sonnet / No: Opus**
- **「深く考える必要がある？」→ Yes: thinking高め / No: thinking低めorオフ**
{{< /callout >}}

### コスト比較

| 設定 | 概算コスト |
|------|-----------|
| Sonnet (thinking: off) | **最安** |
| Sonnet (thinking: low) | 2-3倍 |
| Opus (thinking: low) | 10倍 |
| Opus (thinking: high) | 15-20倍 |

---

## 実際の使い方の例

### 例1: Sonnetで簡単な調査

メインセッションからサブエージェントを起動するには、AIに以下のように指示します：

```
Sonnetサブで「OpenClaw サブエージェント」を検索して、
上位5件の要約を /tmp/research.md に保存して
```

AIは内部で以下のツール呼び出しを実行します：

```json5
{
  "tool": "sessions_spawn",
  "parameters": {
    "task": "web_searchで「OpenClaw サブエージェント」を検索し、\n上位5件を要約して /tmp/research.md に保存",
    "model": "sonnet",
    "thinking": "low",
    "label": "research-subagents"
  }
}
```

### 例2: Opusで複雑な設計

```
Opusサブで以下を実装して：
- 新規機能XYZの設計案を作成
- 既存のコードベースとの整合性を検証
- 実装手順書を /tmp/xyz-design.md に出力
```

### 例3: 並列実行（複数のサブを同時に起動）

```
以下の3つのタスクを並列で実行して：
1. 株価データの取得（Sonnet）
2. ニュース検索（Sonnet）
3. レポート生成（Opus）
```

AIは3つの `sessions_spawn` を同時に実行し、すべての結果が揃ったらまとめて報告します。

---

## サブエージェントの管理

### スラッシュコマンド

チャット画面で `/subagents` コマンドを使って、サブエージェントの状態を確認・操作できます。

| コマンド | 動作 |
|---------|------|
| `/subagents list` | 現在のサブエージェント一覧 |
| `/subagents kill <id\|#\|all>` | 特定のサブまたは全サブを停止 |
| `/subagents log <id\|#> [limit] [tools]` | サブのログを表示 |
| `/subagents info <id\|#>` | サブの詳細情報（ステータス、タイムスタンプ、セッションID、トランスクリプトパス、cleanup等） |
| `/subagents send <id\|#> <message>` | サブにメッセージを送信 |

### 例: サブエージェントの一覧表示

```
/subagents list
```

出力例：

```
active subagents:
1. research-subagents (claude-sonnet-4-5, 2m) running - web_searchで「OpenClaw サブエージェント」を検索...
2. design-xyz (claude-opus-4-6, 5m) running - 新規機能XYZの設計案を作成...
```

### 例: 特定のサブを停止

```
/subagents kill 1
```

---

## ネストされたサブエージェント

デフォルトでは、サブエージェントはさらにサブエージェントを起動できません（`maxSpawnDepth: 1`）。`maxSpawnDepth: 2` に設定することで、**オーケストレーターパターン**が可能になります。

### オーケストレーターパターン

```
メインセッション（Opus）
  └─> オーケストレーター（Sonnet、深度1）
       ├─> ワーカー1（Sonnet、深度2）
       ├─> ワーカー2（Sonnet、深度2）
       └─> ワーカー3（Sonnet、深度2）
```

メインセッションは「PM（プロジェクトマネージャー）」として全体を管理し、オーケストレーターがタスクをワーカーに分配します。各ワーカーは独立して作業し、結果をオーケストレーターに返します。オーケストレーターが統合した結果をメインに返します。

### 設定例

```json5
{
  agents: {
    defaults: {
      subagents: {
        maxSpawnDepth: 2,          // サブがサブを起動可能に
        maxChildrenPerAgent: 5,    // 1セッションが持てる子の数（範囲: 1–20）
        maxConcurrent: 8           // 全体の並列実行数
      }
    }
  }
}
```

### 深度別のツールポリシー

| 深度 | セッションタイプ | `sessions_spawn` | `subagents` | その他のツール |
|------|-----------------|------------------|------------|---------------|
| 0 | メイン | ✅ 常に可能 | ✅ | ✅ |
| 1 | オーケストレーター（`maxSpawnDepth≥2`） | ✅ | ✅ | ✅ |
| 1 | リーフワーカー（`maxSpawnDepth=1`） | ❌ | ❌ | ✅ |
| 2 | リーフワーカー | ❌ | ❌ | ✅ |

{{< callout type="info" >}}
深度1のサブエージェントは、`maxSpawnDepth≥2` の場合のみ `sessions_spawn`、`subagents`、`sessions_list`、`sessions_history` が許可されます。深度2のサブエージェントは常にリーフワーカーであり、さらにサブを起動できません。
{{< /callout >}}

### 結果の流れ（Announce chain）

```
1. 深度2ワーカー完了 → 深度1オーケストレーターに Announce
2. 深度1オーケストレーター完了 → メインセッションに Announce
3. メインセッション → ユーザーに報告
```

各レベルは直接の子からのAnnounceのみを受け取ります。

### カスケード停止

オーケストレーターを停止すると、その配下のワーカーも自動的に停止します：

| コマンド | 動作 |
|---------|------|
| `/stop` | メインセッションと全サブを停止（カスケード） |
| `/subagents kill <id>` | 特定のサブとその配下の子を停止 |
| `/subagents kill all` | 全サブを停止 |

---

## ツールポリシーの制御

サブエージェントがアクセスできるツールを制御できます。

### デフォルト動作

サブエージェントは**セッション管理ツール以外のすべてのツール**にアクセスできます。

**デフォルトで拒否されるツール:**

- `sessions_list`
- `sessions_history`
- `sessions_send`
- `sessions_spawn`（`maxSpawnDepth=1` の場合）

**例外:** `maxSpawnDepth≥2` の場合、深度1のサブエージェント（オーケストレーター）は `sessions_spawn`、`subagents`、`sessions_list`、`sessions_history` にアクセスできます。

### カスタムツールポリシー

`tools.subagents.tools` で特定のツールを明示的に拒否・許可できます。

```json5
{
  tools: {
    subagents: {
      tools: {
        // deny は常に優先（deny wins）
        deny: ["gateway", "cron"],
        // allow を設定すると許可リスト方式になる（deny は依然として優先）
        // allow: ["read", "exec", "process"]
      }
    }
  }
}
```

{{< callout type="warning" >}}
`deny` は常に `allow` より優先されます。`allow` を設定した場合、リストに含まれないツールはすべて拒否されます（ホワイトリスト方式）。
{{< /callout >}}

---

## 自動アーカイブ

サブエージェントのセッションは、完了後に自動的にアーカイブ（削除）されます。

### 設定

```json5
{
  agents: {
    defaults: {
      subagents: {
        archiveAfterMinutes: 60  // デフォルト: 60分
      }
    }
  }
}
```

### 動作

- サブセッションは完了後、`archiveAfterMinutes` 経過後に自動アーカイブされます
- アーカイブは `sessions.delete` を使用し、トランスクリプトは `*.deleted.<timestamp>` にリネームされて保持されます
- `cleanup: "delete"` をセッション起動時に指定すると、Announce直後に即座にアーカイブされます（トランスクリプトはリネームで保持）
- アーカイブはベストエフォートです。Gatewayを再起動すると、保留中のアーカイブタイマーは失われます
- 深度1・深度2のセッションに等しく適用されます

```json5
{
  "tool": "sessions_spawn",
  "parameters": {
    "task": "...",
    "cleanup": "delete"  // Announce直後にアーカイブ
  }
}
```

---

## 注意点と制限事項

### コンテキストとトークン使用量

サブエージェントはそれぞれ独自のコンテキストを持つため、複数のサブを起動するとトークン使用量が増加します。頻繁に使う場合は、サブには軽量モデル（Sonnet）を設定し、メインには高品質モデル（Opus）を使う構成がコスト効率的です。

### プロジェクトコンテキストの注入

サブエージェントにはメインセッションと異なるワークスペースファイルが注入されます：

| ファイル | メインセッション | サブエージェント |
|---------|:---:|:---:|
| `AGENTS.md` | ✅ | ✅ |
| `TOOLS.md` | ✅ | ✅ |
| `SOUL.md` | ✅ | ❌ |
| `IDENTITY.md` | ✅ | ❌ |
| `USER.md` | ✅ | ❌ |
| `HEARTBEAT.md` | ✅ | ❌ |
| `BOOTSTRAP.md` | ✅ | ❌ |

これは、サブエージェントがタスク実行に特化し、メインセッションの人格・アイデンティティを継承しないようにするためです。サブエージェントに必要なコンテキストは、`sessions_spawn` の `task` パラメータに含めてください。

{{< callout type="warning" >}}
**AGENTS.md の記述に注意:** `AGENTS.md` に「SOUL.md等はシステムプロンプトに自動注入されるため読む必要なし」と記載している場合、それは**メインセッション向けの指示**です。サブエージェントには `AGENTS.md` と `TOOLS.md` のみが注入されます。
{{< /callout >}}

### セキュリティルール

`AGENTS.md` には以下のルールを記載することを推奨します（[セキュリティ初期設定](../security/#-プロンプトインジェクション対策)も参照）：

```markdown
## サブセッションの制約（必須ルール）

- **サブセッションはルートルールファイル（AGENTS.md, SOUL.md, IDENTITY.md, USER.md, SECURITY-INDEX.md）を変更しない。**
- **サブセッションが提案した変更は、メインセッションが判断・適用する。**
```

### Announce の制約

サブエージェントがメインセッションに結果を返す「Announce」はベストエフォートです。Gatewayが再起動すると、保留中のAnnounceは失われます。

Announce結果には以下の統計情報が含まれます：
- 実行時間（例: `runtime 5m12s`）
- トークン使用量（入力/出力/合計）
- 推定コスト（モデル料金が設定されている場合）
- `sessionKey`、`sessionId`、トランスクリプトパス

サブエージェントが `ANNOUNCE_SKIP` と返した場合、Announceはスキップされます。

### タイムアウト

サブエージェントにタイムアウトを設定できます。

```json5
{
  "tool": "sessions_spawn",
  "parameters": {
    "task": "...",
    "runTimeoutSeconds": 300  // 5分でタイムアウト
  }
}
```

タイムアウト後、サブの実行は停止しますが、セッション自体は `archiveAfterMinutes` まで残ります。

### 認証

サブエージェントの認証はエージェントIDに基づきます。メインエージェントの認証プロファイルはフォールバックとして利用可能です（エージェント固有のプロファイルが優先）。

---

## sessions_spawn パラメータ一覧

| パラメータ | 必須 | 説明 |
|-----------|:---:|------|
| `task` | ✅ | タスク内容 |
| `label` | | 識別名 |
| `model` | | 使用モデル（無効な値は警告付きでデフォルトにフォールバック） |
| `thinking` | | 推論レベル |
| `agentId` | | 別のエージェントIDで起動（`allowAgents` で許可が必要） |
| `runTimeoutSeconds` | | タイムアウト秒数（デフォルト: 0 = 無制限） |
| `cleanup` | | `delete` or `keep`（デフォルト: `keep`） |

---

## まとめ

| 項目 | 内容 |
|------|------|
| **メインの役割** | 会話・判断・意思決定 |
| **サブの役割** | 実作業・ツール実行 |
| **基本設定** | `agents.defaults.subagents` セクション |
| **ツールポリシー** | `tools.subagents.tools` セクション（`deny`/`allow`） |
| **注入されるファイル** | `AGENTS.md` + `TOOLS.md` のみ |
| **推奨設定** | `maxConcurrent: 8`, `model: "sonnet"`, `thinking: "low"` |
| **使い分けルール** | 手順書で完成するならSonnet、深い思考が必要ならOpus |
| **管理コマンド** | `/subagents list`, `/subagents kill`, `/subagents info` |
| **応用** | `maxSpawnDepth: 2` でオーケストレーターパターン |

サブエージェントを活用することで、メインセッションのコンテキストを軽く保ち、記憶を長持ちさせながら、効率的に作業を並列実行できます。

---

## 関連ページ

{{< cards >}}
  {{< card link="../workspace" title="📁 ワークスペース設定ガイド" subtitle="AGENTS.md等の設定方法" >}}
  {{< card link="../security" title="🔒 セキュリティ初期設定" subtitle="サブエージェントのツールポリシー設定" >}}
{{< /cards >}}

---

**最終更新:** 2026-02-16

<!--
## 修正箇所サマリー (v1 → v2)

### 1. プロジェクトコンテキスト注入テーブル — 正確性確認済み、表現を改善
- v1の❌/✅テーブルは公式ドキュメント (tools/subagents.md) の記述と一致しており正確だった
  - 公式: "Sub-agent context only injects AGENTS.md + TOOLS.md (no SOUL.md, IDENTITY.md, USER.md, HEARTBEAT.md, or BOOTSTRAP.md)."
- テーブルを「メイン vs サブ」の比較形式に変更し、より分かりやすく
- AGENTS.md の「自動注入」記述との混同を防ぐ警告calloutを追加
- ソース: /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/docs/tools/subagents.md

### 2. ツールポリシーの設定キー — 正確性確認済み
- v1の `deny`/`allow` は公式ドキュメント (tools/subagents.md, gateway/configuration-reference.md) と一致しており正確
  - 公式config referenceにも `tools.subagents.tools.allow` / `tools.subagents.tools.deny` と記載
- ユーザーのopenclaw.jsonに `alsoAllow` キーが存在するが、これは公式ドキュメントでは言及なし
- 設定パスの説明を改善: `agents.defaults.subagents`（基本設定）と `tools.subagents`（ツールポリシー）が別セクションであることを明記

### 3. archiveAfterMinutes — 実在確認済み
- 公式ドキュメントで明記: "automatically archived after agents.defaults.subagents.archiveAfterMinutes (default: 60)"
- configuration-reference.md にも記載あり
- セクション維持、記述を公式に合わせて微修正

### 4. subagents設定項目の正確性
- `thinking`: 公式確認済み。"Default thinking: inherits the caller unless you set agents.defaults.subagents.thinking"
- `maxSpawnDepth`: 公式確認済み。範囲は1–5（v1は"1 or 2"と書いていたのを修正）
- `maxChildrenPerAgent`: 公式確認済み。範囲は1–20、デフォルト5

### 5. 全般的な品質向上
- sessions_spawnパラメータ一覧セクションを追加（公式ドキュメント準拠）
- Announce統計情報の説明を追加
- 認証の仕組みについてセクション追加
- 冗長なコード例を削減（例2のJSON例を省略）
- maxSpawnDepthの説明で「1 or 2」→「1–5（推奨は1か2）」に修正
- ツールポリシーセクションの配置を `tools.subagents.tools` パスに統一
- 「深度1のサブは sessions_list, sessions_history も取得可能」の記述を追加
-->
