@echo off
chcp 65001 >nul
color 0a
title 小狼毫 - 嘸蝦米一鍵安裝與部署 (Windows Weasel)

echo ====================================================
echo   開始安裝 Shyam 特製版 嘸蝦米 (Windows 小狼毫)
echo   【精準過濾：僅安裝設定與字典，不污染用戶目錄】
echo ====================================================
echo.

set "DEST=%AppData%\Rime"
if not exist "%DEST%" (
    echo [建立目錄] 正在建立 Rime 用戶資料夾: %DEST%
    mkdir "%DEST%"
)

echo [1/2] 正在拷貝設定檔與字典至 %DEST% ...
for %%F in ("%~dp0*.yaml" "%~dp0*.txt") do (
    if exist "%%F" (
        copy /y "%%F" "%DEST%\" >nul
        echo   [更新設定] %%~nxF
    )
)

if exist "%~dp0opencc\" (
    if not exist "%DEST%\opencc" mkdir "%DEST%\opencc"
    xcopy /e /y /q "%~dp0opencc" "%DEST%\opencc\" >nul
    echo   [更新字表] opencc 目錄
)

echo.
echo [2/2] 正在偵測小狼毫主程式並觸發重新部署...

set "DEPLOYER="
for /d %%D in ("%ProgramFiles%\Rime\weasel-*") do if exist "%%D\WeaselDeployer.exe" set "DEPLOYER=%%D\WeaselDeployer.exe"
if not defined DEPLOYER for /d %%D in ("%ProgramFiles(x86)%\Rime\weasel-*") do if exist "%%D\WeaselDeployer.exe" set "DEPLOYER=%%D\WeaselDeployer.exe"
if not defined DEPLOYER if exist "%ProgramFiles%\Rime\WeaselDeployer.exe" set "DEPLOYER=%ProgramFiles%\Rime\WeaselDeployer.exe"
if not defined DEPLOYER if exist "%ProgramFiles(x86)%\Rime\WeaselDeployer.exe" set "DEPLOYER=%ProgramFiles(x86)%\Rime\WeaselDeployer.exe"

if defined DEPLOYER (
    echo [找到主程式] %DEPLOYER%
    echo 正在送出重新部署指令 ^(/deploy^)...
    "%DEPLOYER%" /deploy
    echo [成功] 重新部署完成！
) else (
    echo [提示] 未能自動定位 WeaselDeployer.exe。
    echo 請在右下角工作列的小狼毫圖示按右鍵，點擊「重新部署 ^[Deploy^]」即可套用。
)

echo.
echo ====================================================
echo   安裝與部署流程已全數完成！
echo   請按 Ctrl + \ 或 F4 切換至「嘸蝦米」開始打字。
echo ====================================================
echo.
pause
