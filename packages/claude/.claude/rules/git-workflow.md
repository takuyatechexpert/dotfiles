# Git ワークフロー

## コミットメッセージ

フォーマット：
```
<Prefix>: <日本語タイトル> #<番号>
```

例：`feat: ログイン機能を実装 #777`

| Prefix | 用途 |
|--------|------|
| feat | 機能追加・修正 |
| fix | バグ修正 |
| docs | ドキュメント更新 |
| style | フォーマット修正 |
| refactor | リファクタリング |
| perf | パフォーマンス改善 |
| test | テストコードの追加・修正 |
| chore | ビルドツール・依存関係の更新 |
| ci | CI/CD |
| build | ビルドシステム |

**`-m` フラグは使用禁止**（コミットテンプレートをバイパスするため）

### コミット前の確認プロセス

コミット前に必ず以下を実行する：

```bash
git status
git diff
git diff --cached
```

### コミット時の承認フロー

1. コミットメッセージをユーザーに提示する
2. コミット対象ファイル一覧を表示する
3. ユーザーの明示的な承認を待つ
4. 修正要求があれば対応し、再度承認を求める

## ブランチ命名規則

| 種別 | フォーマット | 例 |
|------|------------|-----|
| 作業ブランチ | `issue<番号>` | `issue1234` |
| マイルストーンブランチ | `YYYY-MM-DD` | `2026-03-14` |
| マイルストーン（Suffix付き） | `YYYY-MM-DD-<suffix>` | `2026-03-14-infra`, `2026-03-14-01-hotfix` |

## ブランチの切り元

作業ブランチは原則、最新の `develop` ブランチから切る。ブランチ作成前に `develop` を最新化すること。

```bash
git switch develop
git pull origin develop
git switch -c issue1234
```

## 禁止事項

- `CLAUDE.md` のコミット・プッシュ禁止（ローカル開発ガイド専用）
- `force push` 禁止（`--force`, `--force-with-lease`, `-f` すべて）
- `revert` 禁止
- `git reset` 禁止（`--hard`, `--soft` ともに）
- `git config` の変更禁止（user.name, user.email など）
- 直接マージ禁止（必ず PR 経由）

## push 禁止ブランチ

以下のブランチへの push は絶対に行わない：

- `main`
- `master`
- `develop`
- `YYYY-MM-DD`（マイルストーンブランチ）
- `*staging*`（staging を含むブランチ全般）
- `*production*`（production を含むブランチ全般）

## PR ルール

- タイトルは対応する GitHub Issue のタイトルと完全に一致させる
- レビュワーは必ず2名アサインする
- 2 approve 必須、それ未満でのマージ禁止

### PR 説明テンプレート

```markdown
### 概要
* Issue内容の概要を簡潔に記載

### やったこと
* このPRで実装した変更内容を具体的に記載

### やらなかったこと
* このPRで対応しなかった内容（今後の課題など）

### reviewして欲しいこと
* レビュー時に特に確認してほしいポイント

### テスト手順
* リリース時の手動テスト手順
* 事前準備・実行手段・確認方法
```

## GitHub 操作

GitHub に関する操作は **MCP または `gh` コマンドを使用する**（認証の自動処理・APIバージョン互換性・適切なエラーハンドリングのため）。

```bash
gh pr view 123
gh issue view 456
gh issue list --state open
gh pr status
```

## コンフリクト対応

コンフリクトが発生した場合、独断で解決せずユーザーに報告してガイダンスを求める。
