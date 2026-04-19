# ファイル操作

## rm 禁止・ゴミ箱 mv ルール

**`rm` コマンドは絶対に使用しない。**

ファイルやディレクトリを削除する際は、`~/dotlogs/delete/` へ移動すること。

```bash
# NG
rm somefile.txt
rm -rf somedir/

# OK
mv somefile.txt ~/dotlogs/delete/
mv somedir/ ~/dotlogs/delete/
```

### 注意事項

- `~/dotlogs/delete/` が存在しない場合は `mkdir -p ~/dotlogs/delete/` で作成してから mv する
- 同名ファイルが衝突する場合はタイムスタンプを付ける: `mv foo.txt ~/dotlogs/delete/foo.txt.$(date +%s)`
- `rmdir` も同様に禁止。空ディレクトリも mv で対応する
- Makefile やスクリプト内の `rm` を修正する必要がある場合は、ユーザーに確認を取ってから対応する
