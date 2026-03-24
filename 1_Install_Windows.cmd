@Echo off
chcp 65001 >nul
Color 0a
Set UD=2024/04/16 By Shyam (2026/03/24 本地直推優化版)

Title 小狼毫 - 嘸蝦米一鍵安裝 %UD%

echo ====================================================
echo   開始安裝 Shyam 終極版 嘸蝦米 (Windows 小狼毫)
echo ====================================================

echo [1/2] 正在將當前目錄的設定檔，拷貝至 Rime 用戶資料夾...
:: %~dp0 代表此檔案所在的目錄，這將直接推播本地所有修改到 AppData
Xcopy /E /Y /C /H "%~dp0*" "%AppData%\Rime\" >nul 2>&1

echo [2/2] 觸發小狼毫自動重新部署...
:: 搜尋 64 位元路徑下的 Deployer
for /f "delims=" %%i in ('dir /s /b "C:\Program Files\Rime\WeaselDeployer.exe" 2^>nul') do (
    "%%i" /deploy
    goto DeployDone
)

:: 搜尋 32 位元路徑下的 Deployer
for /f "delims=" %%i in ('dir /s /b "C:\Program Files (x86)\Rime\WeaselDeployer.exe" 2^>nul') do (
    "%%i" /deploy
    goto DeployDone
)

Echo 找不到小狼毫 WeaselDeployer.exe，請您手動從工具列右鍵點擊「重新部署」。
goto Cleanup

:DeployDone
Echo 重新部署指令已送出！

:Cleanup
echo.
echo ====================================================
echo   安裝完成！請按 Ctrl + \ 或 F4 切換至嘸蝦米。
echo ====================================================
pause
