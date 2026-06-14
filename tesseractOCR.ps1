# ==============================================================================
# Tesseract OCR 実行スクリプト gemini で修正&整形
# ==============================================================================

# 実行ログ用のユーザー情報生成（必要に応じてログ出力等に使用）
$USR_INFO = "Tess4j $($env:USERNAME)@$($env:COMPUTERNAME) -> $(Get-Date -DisplayHint DateTime) "

# ------------------------------------------------------------------------------
# 1. 画像ファイルの選択（ダイアログ表示）
# ------------------------------------------------------------------------------
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "画像ファイル(*.PNG;*.JPG;*.GIF)|*.PNG;*.JPG;*.JPEG;*.GIF"
$dialog.InitialDirectory = Join-Path $env:USERPROFILE "Desktop"
$dialog.Title = "文字を取り出したい画像ファイルを選択してください"
$dialog.Multiselect = $false # ※現状の処理に合わせて単一選択に最適化（複数選択にする場合はループ処理が必要）

$IMG_FILE_NAME = ""
if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    Write-Output "$($dialog.FileName) が選択されました。"
    $IMG_FILE_NAME = $dialog.FileName
} else {
    Write-Output "キャンセルされたか、ファイルが見つかりません。"
    exit
}

# ------------------------------------------------------------------------------
# 2. Tesseractの環境チェックと配置（自動セットアップ）
# ------------------------------------------------------------------------------
$Tess4J_dir  = "d:\tesseract4win64-master"
$Tess4J_exe  = "$Tess4J_dir\x64\tesseract.exe"

if (Test-Path $Tess4J_exe) {
    Write-Host "Tesseract OCR の起動準備中..."
} else {
    # Tesseract.exe が見つからない場合は最新版を再配置
    Write-Host "Tesseract OCR 最新版を設定中..."
    
    # Dドライブの既存フォルダを削除
    Write-Host "古いバージョンを削除中..."
    if (Test-Path $Tess4J_dir) {
        Remove-Item $Tess4J_dir -Recurse -Force
    }
    
    # 共有ディレクトリからD:ドライブ直下にリカーシブコピー
    Write-Host "最新版を共有ネットワークからコピー中..."
    $Shared_Path = "\\whereis\ourshare\hereitis\共有\tools\tesseract4win64-master"
    Copy-Item -Path $Shared_Path -Destination "d:\" -Force -Recurse
}

# ------------------------------------------------------------------------------
# 3. Tesseract OCR の実行
# ------------------------------------------------------------------------------
$USER_DESKTOP = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
$OCR_OUT      = Join-Path $USER_DESKTOP "out"
$OCR_OPT      = "jpn" # OCR言語設定（日本語）

# 環境変数の指定（traindataのフォルダパス）
$env:TESSDATA_PREFIX = "$Tess4J_dir\tessdata"

# 実行コマンド文字列の生成（パスのスペース対策を含めてクォーテーションで囲む）
$EXECUTE_CMD = "& `"$Tess4J_exe`" `"$IMG_FILE_NAME`" `"$OCR_OUT`" -l $OCR_OPT"

Write-Host "実行コマンド: $EXECUTE_CMD"

# コマンドを実行
Invoke-Expression $EXECUTE_CMD
