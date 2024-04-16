@Echo off
Color 0a
Mode con cols=54 lines=9
Set UD=2024/04/16 By Shyam
Set rime-liur=https://github.com/hsuanyi-chou/rime-liur/archive/refs/heads/master.zip
Set Shyam-liur=https://github.com/YuShyam/rime_liur/archive/refs/heads/main.zip
Title 小狼豪 - 嘸蝦米安裝... %UD%

::Force to Download a zip file 
@Powershell Write-Host 'Starting downloading the GitHub Repository'
@Powershell New-Item -Path '%temp%\rime-liur' -ItemType Directory
@Powershell Invoke-RestMethod -Uri %rime-liur% -OutFile '%temp%\rime-liur\master.zip'
::@Powershell Invoke-RestMethod -Uri %Shyam-liur% -OutFile '%temp%\rime-liur\main.zip'
@Powershell Write-Host 'Download finished'
::Extract zip file
@Powershell Write-Host 'Starting unzipping the GitHub Repository locally'
@Powershell Expand-Archive -Path '%temp%\rime-liur\master.zip' -DestinationPath '%temp%\rime-liur\' -Force
::@Powershell Expand-Archive -Path '%temp%\rime-liur\main.zip' -DestinationPath '%temp%\rime-liur\' -Force
@Powershell Write-Host 'Unzip finished'
xcopy /s /q /d /y %temp%\rime-liur\rime-liur-master\Rime\ %temp%\AppData\Roaming\Rime\
::robocopy /s /e %temp%\rime-liur\rime-liur-master\Rime\ %temp%\AppData\Roaming\Rime