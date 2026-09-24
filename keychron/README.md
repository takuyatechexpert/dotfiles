# Keychron

Keychron Q4 ANSI のキーマップ定義。キーマップ本体はキーボード側の EEPROM に保存されるため、
このファイルは **書き戻し用のバックアップ**であり、`stow` / シンボリックリンクの対象ではない。

| ファイル | 内容 |
|---|---|
| `keychron_q4_ansi.layout.json` | VIA 形式のキーマップ（5 レイヤー） |

## 書き戻し（インポート）

1. [VIA](https://usevia.app/) または Keychron Launcher をブラウザで開く
2. キーボードを USB 接続して認識させる
3. `Configure` → `Save + Load` → `Load Saved Layout` でこのファイルを選ぶ

## バックアップの更新（エクスポート）

キーマップを変更したら、同じ `Save + Load` の `Save Current Layout` でエクスポートし、
このディレクトリのファイルを上書きしてコミットする。
