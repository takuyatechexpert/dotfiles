# 原則

## コアワークフロー
- **理解→計画→実装→検証** のサイクルを徹底
- 実装前に既存コードとアーキテクチャを理解
- 変更の影響範囲を事前に評価
- テスト駆動開発を優先（詳細: `rules/testing.md`）

## タスク委任の原則

実装・調査を依頼する際は、最初のターンで以下を**まとめて**渡す（対話回数を減らすほど品質とトークン効率が上がる）：

- **意図** — 何を達成したいか（ビジネス目的・ユーザー価値）
- **制約** — 使ってよい技術・守るべき規約・触ってはいけない範囲
- **受け入れ基準** — 完了と判断する条件（テストが通る・リンターが通る・画面が表示される等）
- **関連ファイル** — 既存コードの場所（`path:line` 形式で明示）
- **検証手段** — `rules/testing.md` の「検証手段」テーブルから該当コマンドを具体的に指示

1行ずつ指示を出すペアプロではなく、「仕事を丸ごと任せられる有能なエンジニア」として扱う。

## 実行ガイドライン
- 不確実性がある場合は質問で明確化してから実行
- ツール結果を慎重に評価し、最適な次のアクションを判断
- 不要な空白や過剰なリファクタリングを避ける
- 読みやすくテスト可能なコードを優先する（動くだけでは不十分）
- skills コマンドを活用して、適切なスキルセットを選択
- 過去の決定・経験は `~/.claude/projects/.../memory/` に蓄積され、`/crystallize` でナレッジベースに蒸留される

## Code Intelligence

Prefer LSP over Grep/Read for code navigation:
- `workspaceSymbol` to find where something is defined
- `findReferences` to see all usages across the codebase
- `goToDefinition` / `goToImplementation` to jump to source
- `hover` for type info without reading the file

Use Grep only when LSP isn't available or for text/pattern searches.
After writing or editing code, check LSP diagnostics and fix errors before proceeding.
Always fetch the LSP tool schema via ToolSearch before first use in a session.

## ナレッジベース

セッション開始時に読み込む：
- ~/dotlogs/knowledge/user-profile.md
- ~/dotlogs/knowledge/work-patterns.md
- ~/dotlogs/knowledge/collaboration.md

以下は毎回読む必要はないが、該当する作業が発生したら Read すること：
- ~/dotlogs/knowledge/tech-decisions.md — 技術選定の相談、アーキテクチャレビュー、「なぜこの技術を使っているか」の質問時
- ~/dotlogs/knowledge/project-context.md — 特定プロジェクト（di-ddp, vega 等）の作業開始時、プロジェクト間の関係を把握する必要がある時

## 環境ブートストラップ

セッション開始時に hook (`bootstrap-env.sh`) が環境情報を収集し、**`additionalContext` として会話コンテキストに自動注入**される。
- 注入される内容: `## Summary` (DB/Primary Language/Framework/Test) + Languages / Dependencies / Docker Services / Directory / Makefile / Env keys / Test Framework / CI/CD
- 冒頭の `## Summary` セクションに **DB種別・主要言語・フレームワーク** が要約されているので、SQL方言やフレームワーク判断は必ずここを先に確認する（MySQL 前提で書き出す等の思い込みを禁ずる）
- キャッシュ: `~/.claude/cache/bootstrap/<md5(cwd)>.md`、24時間有効、Dockerfile / docker-compose / lock ファイル / .env.example が更新されたら自動再生成
- 手動再生成: `bash ~/.claude/hooks/bootstrap-env.sh --force < <(echo '{"cwd":"'$PWD'"}')`

## 詳細ルール（rules/ 配下）

CLAUDE.md と並んで常時ロードされる。該当作業時は参照ファイルを明記する。

- `rules/design-principles.md` — 設計原則（SRP/DRY/クリーンアーキテクチャ/DDD/命名）
- `rules/testing.md` — テスト方針（TDDサイクル・カバレッジ・**検証手段**・モック方針）
- `rules/git-workflow.md` — Gitワークフロー（コミット規約・ブランチ・PR・push禁止ブランチ）
- `rules/security.md` — セキュリティ（シークレット管理・OWASP Top 10・入力バリデーション）
- `rules/file-operations.md` — ファイル操作（`rm` 禁止・`~/dotlogs/delete/` への mv）
- `rules/makefile.md` — Makefile 活用（コマンド実行の優先順位）
- `rules/context-management.md` — セッション運用・**ツール使用方針**・コンテキスト節約
