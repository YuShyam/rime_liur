@echo off
chcp 65001 >nul
color 0b
title 同文輸入法 (Trime) Android 精準安裝包打包工具

echo ====================================================
echo   正在為 Android 同文輸入法 (Trime) 打包部署檔案
echo   【精準白名單機制：自動排除 Windows/Mac/備份等雜項】
echo ====================================================
echo.

set "OUTPUT_ZIP=%~dp0rime_liur_android.zip"

if exist "%OUTPUT_ZIP%" (
    echo [提示] 偵測到舊的安裝包，正在刪除舊檔...
    del /f /q "%OUTPUT_ZIP%"
)

echo [1/2] 正在收集 Android Trime 必要檔案...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$src = '%~dp0';" ^
    "$out = '%OUTPUT_ZIP%';" ^
    "Add-Type -AssemblyName 'System.IO.Compression.FileSystem';" ^
    "$zip = [System.IO.Compression.ZipFile]::Open($out, 'Create');" ^
    "$whiteList = @(" ^
    "    'liur.schema.yaml'," ^
    "    'default.yaml'," ^
    "    'default.custom.yaml'," ^
    "    'liur.custom.yaml'," ^
    "    'trime.custom.yaml'," ^
    "    'liur_shyam_2026.11.trime.yaml'," ^
    "    'liur_shyam_2026.trime.yaml'," ^
    "    'liur_shyam_2024.trime.yaml'," ^
    "    'liur.extended.dict.yaml'," ^
    "    'liur_customWords.dict.yaml'," ^
    "    'liur_Trad.dict.yaml'," ^
    "    'liur_TradExt.dict.yaml'," ^
    "    'liur_TradToSimp.dict.yaml'," ^
    "    'liur_English.dict.yaml'," ^
    "    'liur_Japan.dict.yaml'" ^
    ");" ^
    "$count = 0;" ^
    "foreach ($f in $whiteList) {" ^
    "    $full = Join-Path $src $f;" ^
    "    if (Test-Path $full) {" ^
    "        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $full, $f) | Out-Null;" ^
    "        Write-Host ('  [納入] ' + $f) -ForegroundColor Green;" ^
    "        $count++;" ^
    "    }" ^
    "};" ^
    "if (Test-Path (Join-Path $src 'opencc')) {" ^
    "    $openccDir = Join-Path $src 'opencc';" ^
    "    Get-ChildItem -Path $openccDir -Recurse -File | ForEach-Object {" ^
    "        $rel = 'opencc/' + $_.FullName.Substring($openccDir.Length + 1).Replace('\', '/');" ^
    "        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $rel) | Out-Null;" ^
    "        Write-Host ('  [納入] ' + $rel) -ForegroundColor Green;" ^
    "        $count++;" ^
    "    };" ^
    "};" ^
    "$zip.Dispose();" ^
    "Write-Host '';" ^
    "Write-Host ('共精準打包 ' + $count + ' 個 Android 必要檔案。') -ForegroundColor Cyan;"

echo.
echo [2/2] 打包完成！已排除 weasel/squirrel/backups/cmd/README 等非 Android 檔案。
echo.
echo ====================================================
echo   安裝包已生成於：
echo   %OUTPUT_ZIP%
echo.
echo   【Android 安裝方式】：
echo   1. 將此 zip 傳送至手機（例如 Download 下載資料夾）。
echo   2. 打開同文輸入法 App -^> 進入「主題/方案」-^> 選擇「從 ZIP 匯入」。
echo   3. 選取 liur_Shyam_2026.11 主題並點擊「重新部署 (Deploy)」。
echo ====================================================
echo.
pause
