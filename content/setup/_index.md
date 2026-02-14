---
title: "初期設定ガイド"
weight: 20
cascade:
  type: docs
---



OpenClawのインストールから初期設定、移行までの手順をまとめています。

このセクションでは、OpenClawを初めて使う方から、既存のClawdbot環境から移行する方まで、セットアップに関するすべての情報を提供します。

---

## 推奨セットアップ順序

初めてOpenClawを使う方は、以下の順序で進めることをお勧めします：

### ステップ 1: インストールと初期設定
まずはOpenClawをインストールして起動するまでの基本手順を確認してください。

### ステップ 2: WebChat設定
WebChat UIの詳細設定を行い、より快適な環境を構築します。

### ステップ 3: Clawdbotからの移行（該当する場合）
既存のClawdbot環境がある場合は、移行手順を確認してください。

---

## セットアップガイド一覧

<div class="hx:mt-6"></div>

{{< cards >}}
  {{< card link="/setup/getting-started" title="1. インストールと初期設定" subtitle="OpenClawのインストールから起動までの基本手順 | 所要時間: 15分" >}}
  {{< card link="/setup/webchat-settings" title="2. WebChat設定リファレンス" subtitle="WebChat UIの設定項目と使い方の詳細ガイド | 所要時間: 10分" icon="cog" >}}
  {{< card link="/setup/migration-from-clawdbot" title="3. Clawdbotからの移行" subtitle="Clawdbot環境からOpenClawへの移行手順とトラブルシューティング | 所要時間: 30分" >}}
{{< /cards >}}

---

## セットアップのチェックリスト

セットアップ完了後、以下の項目を確認してください：

- [ ] **Node.js 18以上** がインストールされている
- [ ] **Anthropic APIキー** が設定されている
- [ ] **Gateway** が正常に起動する（`openclaw gateway status`）
- [ ] **WebChat UI** にブラウザでアクセスできる
- [ ] **モデル選択** が正しく動作する（claude-sonnet-4等）
- [ ] **日本語表示** が正しく機能する

---

## トラブルシューティング

セットアップ中に問題が発生した場合は、以下を確認してください：

### よくある問題

| 問題 | 確認項目 | 関連記事 |
|------|----------|----------|
| Gatewayが起動しない | ポート8080が使用中でないか確認 | [初期設定ガイド](/setup/getting-started) |
| APIキーエラー | 環境変数が正しく設定されているか | [初期設定ガイド](/setup/getting-started) |
| WebChat UIにアクセスできない | ファイアウォール設定を確認 | [初期設定ガイド](/setup/getting-started) |
| Clawdbotから移行できない | `openclaw doctor --fix` を実行 | [移行ガイド](/setup/migration-from-clawdbot) |

---

## 次のステップ

セットアップが完了したら、以下をお試しください：

- **[WebChat日本語化パッチ](/wiki-notes/webchat-ja)** - UIを日本語化して使いやすく
- **[最新リリースノート](/releases)** - 新機能と変更点を確認
- **[OpenClaw公式ドキュメント](https://openclaw.io/docs)** - 詳細な機能ガイド

---

## サポート

セットアップに関するご質問は、[GitHub Discussions](https://github.com/yozora4416/openclaw-wiki-ja/discussions)でお気軽にお尋ねください。

---

**最終更新:** 2026-02-14
