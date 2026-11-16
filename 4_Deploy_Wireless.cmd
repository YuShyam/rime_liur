@echo off
chcp 65001 >nul
color 0b
title 同文輸入法 (Trime) Android 無線偵錯自動推送工具

echo ====================================================
echo   Android 無線偵錯 (Wireless ADB) 快速部署工具
echo ====================================================
echo.

where adb >nul 2>nul
if %errorlevel% neq 0 (
    echo [錯誤] 找不到 adb.exe，請確認 Android SDK 或 scrcpy 已加入 PATH。
    pause
    exit /b 1
)

echo 請選擇操作項目：
echo   [1] 首次裝置配對 (Pair)
echo   [2] 連線並推送安裝包到手機 (Connect ^& Push)
echo   [3] 僅推送最新版設定檔到 /sdcard/rime/
echo.
set /p "CHOICE=請輸入選項 (預設 2): "
if "%CHOICE%"=="" set "CHOICE=2"

if "%CHOICE%"=="1" goto DO_PAIR
if "%CHOICE%"=="2" goto DO_PUSH_ZIP
if "%CHOICE%"=="3" goto DO_PUSH_FILE

:DO_PAIR
echo.
echo ====================================================
echo   【裝置配對】
echo   請打開手機「開發人員選項」-^>「無線偵錯」-^>「使用配對碼配對裝置」
echo ====================================================
set /p "PAIR_ADDR=請輸入配對 IP:Port (例如 192.168.1.100:46767): "
set /p "PAIR_CODE=請輸入 6 位數 Wi-Fi 配對碼: "
echo 正在配對...
adb pair %PAIR_ADDR% %PAIR_CODE%
echo.
echo 配對完成後，請關閉配對視窗，回到無線偵錯主畫面查看「IP 位址和通訊埠」。
pause
goto MENU_END

:DO_PUSH_ZIP
echo.
echo ====================================================
echo   【連線並推送安裝包】
echo ====================================================
set /p "CONN_ADDR=請輸入無線偵錯主畫面的 IP:Port (例如 192.168.1.100:39123): "
echo 正在連線到 %CONN_ADDR%...
adb connect %CONN_ADDR%
echo.
set "ZIP_PATH=%~dp0rime_liur_android.zip"
if not exist "%ZIP_PATH%" (
    echo [提示] 未找到安裝包，正在自動執行打包...
    call "%~dp03_Pack_Android.cmd"
)
echo 正在推送安裝包到手機 /sdcard/Download/ ...
adb push "%ZIP_PATH%" /sdcard/Download/
echo.
echo [完成] 安裝包已送達手機「Download」資料夾！
echo 請在同文輸入法 App 內點選「從 ZIP 匯入」，選取並重新部署即可。
pause
goto MENU_END

:DO_PUSH_FILE
echo.
echo ====================================================
echo   【熱更新主題檔到 /sdcard/rime/】
echo ====================================================
set /p "CONN_ADDR=請輸入無線偵錯主畫面的 IP:Port: "
adb connect %CONN_ADDR%
echo 正在推送最新主題檔...
adb push "%~dp0liur_shyam_2026.11.trime.yaml" /sdcard/rime/
adb push "%~dp0liur.custom.yaml" /sdcard/rime/
adb push "%~dp0default.custom.yaml" /sdcard/rime/
echo.
echo [完成] 檔案已推送，請在同文輸入法點選「重新部署 (Deploy)」。
pause
goto MENU_END

:MENU_END

