# 嘸蝦米 Liu - 同文 & 小狼毫專用特製版 (YuShyam/rime_liur)

這是一個基於 [RIME (中州韻輸入法引擎)](https://rime.im) 的全功能嘸蝦米輸入法方案。  
特別針對 **Android 同文輸入法 (Trime)** 進行了深度的按鍵佈局、語音輸入與手勢客製化，並為 **Windows 小狼毫 (Weasel)** 提供全自動一鍵安裝與部署支援。

---

## ⚡ 【防失憶】30 秒極速安裝速查卡 (Quickstart)

> **換新手機或重灌電腦時，看這裡 2 步搞定，免翻說明書！**

### 📱 Android 同文輸入法 (Trime) · 30 秒安裝
1. **下載最新安裝包**：
   手機瀏覽器直接點擊下載 ➔ 👉 **[最新 rime_liur_android.zip 下載直鏈](https://github.com/YuShyam/rime_liur/releases/latest/download/rime_liur_android.zip)**
2. **匯入與部署**：
   - 打開手機端 **同文輸入法 (Trime)** App。
   - 進入 **「主題 / 方案」** ➔ 點擊選單中的 **「從 ZIP 匯入」** ➔ 選取下載的 `rime_liur_android.zip`。
   - 在主題清單中點選 **`liur_Shyam_2026.11`**。
   - 回到 App 首頁點擊大顆的 **「重新部署 (Deploy)」** ➔ 大功告成！

---

### 💻 Windows 小狼毫 (Weasel) · 一鍵無腦安裝
1. **下載並安裝小狼毫主程式**（若新電腦尚未安裝）：[小狼毫官方下載](https://rime.im/download/)。
2. **一鍵套用特製方案**：
   - 下載 ➔ 👉 **[最新 rime_liur_windows.zip 下載直鏈](https://github.com/YuShyam/rime_liur/releases/latest/download/rime_liur_windows.zip)**。
   - 解壓縮後，直接雙擊執行 **`1_Install_Windows.cmd`**。
   - 腳本將自動完成檔案精準過濾拷貝與觸發重新部署。
   - 按快捷鍵 `Ctrl + \` 或 `F4` 切換至「嘸蝦米」即可開始打字！

---

## ✨ 獨家特色 (Shyam 特製版)

與市面上一般的 RIME 嘸蝦米相比，本專案最大的不同在於 **完美適配 Android 觸控環境與高頻打字工學**：

1. **同文輸入法專用旗艦主題版型 (`liur_shyam_2026.11`)**
   - **A 鍵觸控熱區擴展**：徹底解決手機左側邊緣 A 鍵盲區容易按空、誤觸的問題，邊界點擊精準觸發。
   - **流暢中英文切換**：解除舊版鎖定，點擊 `Mode_switch` 即按即切。
   - **Google 語音輸入**：長按空白鍵即可呼叫系統 Google 語音輸入，隨按隨講。
   - **全手勢滑動支援**：字母鍵綁定上、下、左、右滑動捷徑（快速輸入特定數字、標點符號與特殊符號）。
   - **進階文章編輯捷徑**：長按或滑動可觸發「剪下」、「複製」、「貼上」、「全選」與剪貼簿歷史。
   - **版本獨立封裝**：專案同時完整保留歷史版型（`2024`、`2026`、`2026.11`），隨選隨切。

2. **嘸蝦米引擎核心強化**
   - **Unicode 符號預設可用**：預設開啟「擴充字集」模式，自訂詞庫內的上標、下標、圓圈數字、方向箭頭、數學符號與 Emoji 免手動切換直接可用。
   - 預設開啟「連打自動記憶造詞」及「逐碼提示」，提升打字流暢度。
   - 複合輸入模式：打不出字時，可用 `';` 進入注音模式，或用 `` ` `` 進入拼音模式輔助。
   - 支援讀音與形碼反查。

---

## 🛠️ 本機工具腳本功能速查

| 腳本檔名 | 適用平台 | 功能說明 |
| :--- | :--- | :--- |
| **`1_Install_Windows.cmd`** | Windows | **一鍵安裝與部署**：精準拷貝配置至 `%AppData%\Rime`，自動定位 `weasel-0.17.*` 等各版本主程式並發送重新部署指令。 |
| **`2_Update_Dictionary.cmd`** | Windows | **上游字典同步**：自動從 `hsuanyi-chou/rime-liur` 下載最新字庫，以白名單保護機制合併，絕不覆蓋你的客製化主題與詞庫。 |
| **`3_Pack_Android.cmd`** | 本機離線 | **Android ZIP 打包**：離線將最新方案與 opencc 精準封裝為手機 Trime 安裝包。 |
| **`4_Deploy_Wireless.cmd`** | 本機 ➔ 手機 | **無線 ADB 直推**：免插線，透過 Wi-Fi 無線偵錯一鍵將安裝包或主題檔推送到手機 `/sdcard/Download/` 或 `/sdcard/rime/`。 |

---

## 🚀 雲端自動化 (GitHub Actions CI/CD)

本專案已配置全自動發布工作流 (`.github/workflows/package-and-release.yml`)：
* 每次 Push 調整鍵盤配置或更新詞庫時，雲端將於 10 秒內自動封裝最新版的 **`rime_liur_android.zip`** 與 **`rime_liur_windows.zip`**。
* 自動更新 GitHub Releases，確保你隨時存取的「固定下載直鏈」永遠都是最新的心血成果！
