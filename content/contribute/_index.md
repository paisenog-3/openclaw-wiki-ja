---
title: "貢献ガイド・利用規約"
weight: 30
description: "投稿ルール、禁止事項、寄与ルール、ライセンス"
tags: ["貢献", "コミュニティ", "利用規約"]
toc: true
type: docs
---

## 利用規約

### 禁止事項

以下の内容を含む投稿は、予告なく削除されます。

| 禁止事項 | 例 |
|---------|-----|
| **悪意あるコマンド・コード** | `rm -rf /`、`curl \| bash`、バックドア設置、権限変更 |
| **プロンプトインジェクション** | OpenClawに読ませた時にシステムを乗っ取る隠し指示 |
| **フィッシング・詐欺** | 偽サイトへの誘導、偽の公式ページ |
| **個人情報の収集** | APIキー・パスワード・個人情報の入力を促す記述 |
| **マルウェア配布** | 不審なスクリプトのダウンロード・実行を促す内容 |
| **スパム・宣伝** | 記事を装った広告、アフィリエイト目的の投稿 |
| **攻撃的表現・ハラスメント** | 人種・性別・宗教等に基づく差別的表現 |
| **著作権侵害** | 他者のコンテンツの無断転載 |
| **虚偽の情報** | 意図的な誤情報、未検証の内容を事実として記述 |

投稿内容は定期的にセキュリティチェックされています。悪質な違反者はアクセス制限の対象となります。

### ライセンス

| 対象 | ライセンス |
|------|-----------|
| 記事 | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.ja) — 自由に利用・改変可。クレジット表示と同一ライセンス継承が条件 |
| コード例 | [MIT License](https://opensource.org/licenses/MIT) — 自由に利用可 |

### 免責事項

{{< callout type="warning" >}}
このWikiの情報は**無保証**です。利用は自己責任でお願いします。本番環境での利用前にテスト環境で確認してください。
{{< /callout >}}

---

## 記事を投稿する

<div style="margin: 1.5rem 0;">
  <a href="https://github.com/paisenog-3/openclaw-wiki-ja/issues/new?template=article-submission.yml" target="_blank" style="display: inline-block; padding: 12px 32px; background: #2563eb; color: white; border-radius: 8px; text-decoration: none; font-weight: bold;">📝 記事を投稿する</a>
</div>

フォームから記事を投稿できます（[GitHubアカウント](https://github.com/signup)が必要です）。

### 投稿者情報

| フィールド | 必須 | 説明 |
|-----------|------|------|
| 投稿者名 | 任意 | 空欄なら「匿名」と表示 |
| SNS / Webサイト | 任意 | 記事にリンク付きで表示 |

### 寄与ルール

| 状況 | 処理 |
|------|------|
| 単独投稿 | 投稿者の寄与 **100%** |
| 類似記事のマージ | 内容量に基づいて按分（合計100%） |
| 同一内容の重複 | 先に投稿した人を原著者として優先 |

記事フッターに投稿者名・日付・寄与割合が表示されます。

---

## お問い合わせ

- [GitHub Issues](https://github.com/paisenog-3/openclaw-wiki-ja/issues) — バグ報告・機能提案
- [GitHub Discussions](https://github.com/paisenog-3/openclaw-wiki-ja/discussions) — 質問・議論

---

このWikiは [パイセン｜AIと暮らす](https://x.com/OG3_gata) が運営する非公式コミュニティWikiです。
