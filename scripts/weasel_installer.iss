; 嘸蝦米 Liu - 小狼毫一鍵整合安裝包 Inno Setup 腳本
; (Weasel Boshiamy One-Click All-in-One Installer Script)

#define MyAppName "嘸蝦米 Liu (小狼毫特製版)"
#define MyAppVersion "2026.11"
#define MyAppPublisher "Shyam"
#define MyAppURL "https://github.com/YuShyam/rime_liur"

[Setup]
AppId={{9F57E42D-C3A5-42E1-9988-E1C65B329B41}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={autopf}\RimeWeaselLiur
DisableDirPage=yes
DisableProgramGroupPage=yes
SourceDir=..
OutputDir=dist
OutputBaseFilename=weasel-liur-setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
RestartIfNeededByRun=no
CloseApplications=no

[Languages]
Name: "default"; MessagesFile: "compiler:Default.isl"

[Files]
; 官方小狼毫主程式安裝檔 (放置於暫存目錄，裝完自動清理)
Source: "temp_weasel\weasel-installer.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall ignoreversion
; 嘸蝦米方案、自訂詞庫、opencc 目錄 (動態拷貝至註冊表感知之真實用戶資料夾)
Source: "rime_files\*"; DestDir: "{code:GetRimeUserDir}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Run]
; 1. 完全靜默安裝小狼毫底層驅動 (NSIS /S 旗標，絕不彈出路徑與配色確認視窗)
Filename: "{tmp}\weasel-installer.exe"; Parameters: "/S"; StatusMsg: "正在安裝小狼毫輸入法底層驅動與核心模組..."; Flags: waituntilterminated
; 2. 調用動態定位之 WeaselDeployer 觸發重新部署
Filename: "{code:GetDeployerPath}"; Parameters: "/deploy"; StatusMsg: "正在編譯嘸蝦米字根庫並重新部署輸入法..."; Flags: waituntilterminated

[Code]
// 註冊表動態感應：精準定位小狼毫官方當前認定的 RimeUserDir
function GetRimeUserDir(Param: String): String;
var
  UserDir: String;
begin
  if RegQueryStringValue(HKCU, 'Software\Rime\Weasel', 'RimeUserDir', UserDir) then
  begin
    if Length(UserDir) > 0 then
    begin
      Result := UserDir;
      Exit;
    end;
  end;
  // 回退防禦：若註冊表尚未生成，使用標準用戶路徑
  Result := ExpandConstant('{userappdata}\Rime');
end;

// 註冊表動態感應：精準定位當前安裝版本之 WeaselDeployer.exe 實體路徑
function GetDeployerPath(Param: String): String;
var
  WeaselRoot: String;
  FallbackPath: String;
begin
  if RegQueryStringValue(HKCU, 'Software\Rime\Weasel', 'WeaselRoot', WeaselRoot) then
  begin
    if Length(WeaselRoot) > 0 then
    begin
      Result := WeaselRoot + '\WeaselDeployer.exe';
      Exit;
    end;
  end;
  
  // 回退防禦：搜尋標準 64/32 位元安裝路徑
  FallbackPath := ExpandConstant('{autopf}\Rime\weasel-0.17.4\WeaselDeployer.exe');
  if FileExists(FallbackPath) then
  begin
    Result := FallbackPath;
    Exit;
  end;

  FallbackPath := ExpandConstant('{autopf}\Rime\WeaselDeployer.exe');
  Result := FallbackPath;
end;
