# Makefile 活用

## 原則

- プロジェクトに Makefile がある場合、まず `make help` または Makefile を読んで利用可能なコマンドを把握する
- Docker・テスト・ビルド等のコマンドは Makefile 経由で実行する（直接 `docker compose` や `phpunit` を叩かない）
- Makefile に定義されていない操作を行う前に、既存ターゲットで代替できないか確認する

## 新規プロジェクト参加時

1. `Makefile` を読み、主要ターゲット（build, up, test, lint 等）を把握する
2. `make help` が定義されていれば実行して一覧を確認する
3. Docker 関連のターゲット構成（コンテナ名・サービス名）を理解する

## コマンド実行の優先順位

1. **Makefile ターゲット** — `make test`, `make lint` 等
2. **Makefile 内で使われているコマンド** — Makefile に定義がない場合、Makefile 内の記法に合わせる
3. **直接コマンド** — Makefile が存在しない場合のみ
