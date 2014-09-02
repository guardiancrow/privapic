﻿privapic - Keep PRIVAcy for PICture（画像のプライバシーを保とう！）
=================================================================

概要
--------------
JPEGファイルのメタデータを削除するツールです。

詳細
--------------
JPEGファイルに含まれているコメント・Exifデータなどの情報を見つけ出し、それらを除いたものを出力します。JFIFデータは削除されません。  
画像データの再圧縮・劣化はありません。但し、Exif情報に色情報が入っている場合には色が変化する場合があります。

想定用途
-------------
- インターネットにJPEGファイルを公開する際に、撮影機種・撮影日時・GPS情報などまでをもうっかり公開してしまうことを防ぐ。
- 余分な情報を削除することによって画像ファイルサイズを抑制する。

実行方法
--------------
```bash
$ruby privapic.rb <JPEGファイル>
```


ライセンス
--------------
MITライセンス


使用言語
--------------
Ruby （1.9.3以降推奨）


必要なライブラリ・モジュール
--------------
特に追加のモジュールをご用意する必要ありません。  
ランダムな文字列作成に標準ライブラリSecureRandomを使用しています。