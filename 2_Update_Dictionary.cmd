@echo off
chcp 65001 >nul
echo ==========================================
echo   Rime Liur 上游方案同步更新腳本
echo ==========================================
echo 本腳本將自動下載 hsuanyi-chou/rime-liur 最新版本
echo 並更新本機資料，同時【自動保護】您的客製化檔案。
echo.

echo [1/4] 正在下載最新版壓縮檔...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/hsuanyi-chou/rime-liur/archive/refs/heads/master.zip' -OutFile 'upstream.zip'"

echo [2/4] 解壓縮中...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path 'upstream.zip' -DestinationPath 'upstream_temp' -Force"

echo [3/4] 開始合併並覆蓋舊有字典檔... (使用防護機制)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$source = 'upstream_temp\rime-liur-master\Rime'; $target = '.\'; $excludes = @('liur_customWords.dict.yaml', 'default.custom.yaml', 'liur.custom.yaml', 'default.yaml'); Get-ChildItem -Path $source -Recurse | Where-Object { -not $_.PSIsContainer } | ForEach-Object { $basePath = (Get-Item $source).FullName; $rel = $_.FullName.Substring($basePath.Length + 1); if ($excludes -notcontains (Split-Path $rel -Leaf)) { $dest = Join-Path $target $rel; $dir = Split-Path $dest; if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }; Copy-Item -Path $_.FullName -Destination $dest -Force; Write-Host '[更新/寫入]' $rel -ForegroundColor Green } else { Write-Host '[保護自定義]' $rel -ForegroundColor Yellow } }"

echo.
echo [4/4] 清理暫存檔...
if exist upstream.zip del upstream.zip
if exist upstream_temp rmdir /s /q upstream_temp

echo.
echo ==========================================
echo   同步更新完成！您可以安心維護您的自訂檔了。
echo ==========================================
pause
