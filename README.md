# Tesseract OCR PowerShell Script

画像ファイルから文字を抽出するためのPowerShellスクリプトです。　Tesseract OCRエンジンを使用して、日本語を含むテキストを画像から認識・抽出します。

## 機能

- GUIダイアログによる画像ファイルの選択（PNG, JPG, JPEG, GIF対応）
- Tesseract OCRの自動セットアップ（ネットワーク共有から自動配置）
- 日本語OCR対応
- 抽出したテキストをデスクトップの`out`フォルダに保存

## 前提条件

tessaractOCR本体はファイル共有サーバ上にZIP圧縮ファイルを解凍・展開して配置する仕様とし、スクリプトを実行したPCのDドライブの所定のフォルダに配置されることを想定しています。　PCのDドライブにtessaractOCRがなければファイル共有サーバからフォルダがコピーされます。　したがって、ファイル共有サーバ上のtessaractOCRを最新版に上書きするとこのスクリプトを実行したPCのDドライブ上のtessaractOCRも最新版に更新されます。　ファイル共有サーバ上のtessaractOCRはコピーの際に読み取られるだけであり、PC上で実行中にファイル共有サーバ上のファイルがロックされる等がないことから最新バージョンへの上書き更新でいつでもPC側に最新版を配置することが可能なスクリプトとしています。

- Windows環境
- PowerShell
- Tesseract OCRのセットアップ用ネットワーク共有へのアクセス権
  - 共有パス: `\\whereis\ourshare\hereitis\共有\tools\tesseract4win64-master`

## インストール

1. このスクリプトを任意の場所に保存します
2. スクリプトを実行する前に、PowerShellの実行ポリシーを確認してください
   ```powershell
   Get-ExecutionPolicy
   ```
   必要に応じて実行ポリシーを変更します：
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## 使用方法

1. PowerShellでスクリプトを実行します：
   ```powershell
   .\tesseractOCR.ps1
   ```

2. ファイル選択ダイアログが表示されるので、文字を抽出したい画像ファイルを選択します

3. スクリプトが自動的にTesseract OCRの環境をチェック・セットアップします

4. OCR処理が実行され、結果がデスクトップの`out`フォルダに保存されます
   - テキストファイル: `out.txt`
   - （オプションで他のフォーマットも出力可能）

## 設定

スクリプト内の以下の変数を環境に合わせて変更してください：

```powershell
# Tesseractのインストール先
$Tess4J_dir  = "d:\tesseract4win64-master"

# ネットワーク共有のパス
$Shared_Path = "\\whereis\ourshare\hereitis\共有\tools\tesseract4win64-master"

# OCR言語設定（日本語）
$OCR_OPT      = "jpn"
```

## 出力ファイル

OCR処理の結果は以下の場所に保存されます：
- パス: `本スクリプトを実行したPCのデスクトップ\out\`
- ファイル名: `out.txt`

## トラブルシューティング

### Tesseractが見つからない場合
スクリプトは自動的にネットワーク共有からTesseractをダウンロード・配置します。ネットワーク共有にアクセスできない場合は、手動でTesseractをインストールし、`$Tess4J_dir`のパスを変更してください。

### 日本語が正しく認識されない場合
`tessdata`フォルダに日本語の言語データ（`jpn.traineddata`）が含まれていることを確認してください。

### 実行ポリシーのエラー
PowerShellの実行ポリシーが制限されている場合、以下のコマンドで変更してください：
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## サポートされている画像フォーマット

- PNG (.png)
- JPEG (.jpg, .jpeg)
- GIF (.gif)

## ライセンス

このスクリプトはTesseract OCRエンジンを使用しています。Tesseractのライセンスに従ってください。

## 注意事項

- 現在、1回の実行で1つの画像ファイルのみ処理可能です
- ネットワーク共有パスは環境に合わせて変更してください
- Dドライブへのインストールを前提としていますが、パスを変更することで他の場所にも対応可能です
