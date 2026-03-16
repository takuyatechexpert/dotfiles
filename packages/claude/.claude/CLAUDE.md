# 原則

## コアワークフロー
- **理解→計画→実装→検証** のサイクルを徹底
- 実装前に既存コードとアーキテクチャを理解
- 変更の影響範囲を事前に評価
- テスト駆動開発を優先

## 実行ガイドライン
- 不確実性がある場合は質問で明確化してから実行
- ツール結果を慎重に評価し、最適な次のアクションを判断
- 不要な空白や過剰なリファクタリングを避ける
- 読みやすくテスト可能なコードを優先する（動くだけでは不十分）
- skills コマンドを活用して、適切なスキルセットを選択
- 過去の決定・経験は `~/.claude/projects/.../memory/` に蓄積されている

## コンテキスト管理
- プロジェクト固有のパターンと規則を CLAUDE.md で文書化
- 視覚的な参照（ファイルパス:行番号）を提供
- 関連する背景情報と制約を含める

## Code Intelligence

Prefer LSP over Grep/Read for code navigation:
- `workspaceSymbol` to find where something is defined
- `findReferences` to see all usages across the codebase
- `goToDefinition` / `goToImplementation` to jump to source
- `hover` for type info without reading the file

Use Grep only when LSP isn't available or for text/pattern searches.
After writing or editing code, check LSP diagnostics and fix errors before proceeding.
Always fetch the LSP tool schema via ToolSearch before first use in a session.

## コーディングスタイル（必要に応じて追加）
<!-- 例：
- TypeScript の厳格な型定義を優先
- 関数型プログラミングスタイルを推奨
- エラーハンドリングは Result 型を使用
-->
