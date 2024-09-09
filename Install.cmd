@Echo off
Color 0a
::Mode con cols=54 lines=9
Set UD=2024/04/16 By Shyam
Set rime-liur=https://github.com/hsuanyi-chou/rime-liur/archive/refs/heads/master.zip
Set Shyam-liur=https://github.com/YuShyam/rime_liur/archive/refs/heads/main.zip

Title 小狼豪 - 嘸蝦米安裝... %UD%

::Force to Download a zip file 
@Powershell Write-Host '從 GITHUB 下載 hsuanyi-chou rime-liur'
@Powershell New-Item -Path '%temp%\rime-liur' -ItemType Directory
@Powershell Invoke-RestMethod -Uri %rime-liur% -OutFile '%temp%\rime-liur\master.zip'
@Powershell Write-Host '從 GITHUB 下載 Shyam-liur'
@Powershell New-Item -Path '%temp%\Shyam-liur' -ItemType Directory
@Powershell Invoke-RestMethod -Uri %Shyam-liur% -OutFile '%temp%\Shyam-liur\main.zip'

@Powershell Write-Host '解壓縮檔案到本地端暫存目錄'
@Powershell Expand-Archive -Path '%temp%\rime-liur\master.zip' -DestinationPath '%temp%\rime-liur\' -Force
@Powershell Expand-Archive -Path '%temp%\Shyam-liur\main.zip' -DestinationPath '%temp%\Shyam-liur\' -Force

@Powershell Write-Host '開始進行 Rime-liur 資料佈署'
del /s/q %AppData%\Rime\*.*
del /s/q %AppData%\Rime\opencc\*.*
Xcopy /s /q /d /y %temp%\rime-liur\rime-liur-master\Rime\ %AppData%\Rime
Xcopy /s /q /d /y %temp%\Shyam-liur\Shyam-liur-main\Rime\*.yaml %AppData%\Rime
IF EXIST "C:\Program Files\Rime" (
	For /f %%i in ('dir /b "C:\Program Files\Rime"') do "C:\Program Files\Rime\%%i\WeaselDeployer.exe" /deploy
	) ELSE ( 
		IF EXIST "C:\Program Files\Rime" (
			For /f %%i in ('dir /b "C:\Program Files (x86)\Rime"') do "C:\Program Files (x86)\Rime\%%i\WeaselDeployer.exe" /deploy
		) ELSE (
	Echo 找不到小狼豪輸入法，請自行手動重新佈署
	)
)

:END
