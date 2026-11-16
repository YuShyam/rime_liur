#!/usr/bin/env python3
"""
同文輸入法 (Trime) 嘸蝦米預裝資產注入腳本 (Trime Boshiamy Pre-bundle Injector)

本腳本於 GitHub Actions 流水線或本機環境中執行，負責：
1. 解構官方 Trime 發行版 APK 中的 assets/shared 資產目錄
2. 注入 rime_liur 的嘸蝦米方案、自訂詞庫、opencc 與 liur_shyam_2026.11 旗艦主題
3. 改寫 default.yaml 與 trime.yaml，將開機預設輸入法鎖定為 liur (嘸蝦米)
4. 重新計算並生成 assets/checksums.json SHA-256 校驗清單，確保初次啟動自動同步
5. 抹除舊有簽名檔案，產出待簽署之預裝版 APK

This script injects Boshiamy schemas, dictionaries, and themes into official Trime APK.
"""

import argparse
import hashlib
import json
import os
import re
import sys
import zipfile
from pathlib import Path


def calculate_sha256(data: bytes) -> str:
    """計算資料區塊之 SHA-256 雜湊值 (Calculate SHA-256 hash)."""
    return hashlib.sha256(data).hexdigest()


def patch_default_yaml(content: str) -> str:
    """
    修改 default.yaml 將 liur (嘸蝦米) 置於方案清單首位。
    Prepend 'liur' to schema_list in default.yaml.
    """
    if "- schema: liur" in content:
        return content

    pattern = re.compile(r"(schema_list:\s*\n)", re.MULTILINE)
    if pattern.search(content):
        return pattern.sub(r"\1  - schema: liur\n", content, count=1)
    return content


def patch_trime_yaml(content: str) -> str:
    """
    修改 trime.yaml 將預設鍵盤主題指定為 liur_shyam_2026.11。
    Configure default keyboard theme to liur_shyam_2026.11 in trime.yaml.
    """
    # 若已有 __include 則擴充或在檔頭引入
    if "liur_shyam_2026.11" in content:
        return content

    header = "# Pre-bundled with liur_shyam_2026.11 theme\n__include: liur_shyam_2026.11.trime:/\n\n"
    return header + content


def main():
    parser = argparse.ArgumentParser(description="Inject Boshiamy assets into official Trime APK")
    parser.add_argument("--src-apk", required=True, help="Path to official Trime APK")
    parser.add_argument("--rime-dir", required=True, help="Path to rime_liur source directory")
    parser.add_argument("--out-apk", required=True, help="Path to output injected APK")
    args = parser.parse_args()

    src_apk = Path(args.src_apk).resolve()
    rime_dir = Path(args.rime_dir).resolve()
    out_apk = Path(args.out_apk).resolve()

    if not src_apk.is_file():
        print(f"[ERROR] 找不到官方 Trime APK: {src_apk}")
        sys.exit(1)
    if not rime_dir.is_dir():
        print(f"[ERROR] 找不到 rime_liur 來源目錄: {rime_dir}")
        sys.exit(1)

    print(f"=== 開始注入嘸蝦米預裝資產至 Trime APK ===")
    print(f"  來源 APK: {src_apk.name}")
    print(f"  方案目錄: {rime_dir}")

    # 1. 收集 rime_liur 內所有有效設定、字典與 opencc 檔案
    injected_assets = {}
    for root, dirs, files in os.walk(rime_dir):
        # 排除 git 與備份
        if any(part in root for part in [".git", "backups"]):
            continue
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            if ext in [".yaml", ".txt"] or "opencc" in root:
                rel_path = os.path.relpath(os.path.join(root, f), rime_dir).replace("\\", "/")
                target_key = f"assets/shared/{rel_path}"
                with open(os.path.join(root, f), "rb") as fp:
                    injected_assets[target_key] = fp.read()

    print(f"[OK] 成功收集 {len(injected_assets)} 個嘸蝦米必要資產檔案。")

    # 2. 解包、替換與重構 APK 壓縮流
    out_apk.parent.mkdir(parents=True, exist_ok=True)
    all_shared_hashes = {}

    with zipfile.ZipFile(src_apk, "r") as zin, zipfile.ZipFile(out_apk, "w", compression=zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            # 抹除原版簽名 (META-INF/*.SF, *.RSA, *.MF)，以利後續重新簽章
            if item.filename.startswith("META-INF/") and (
                item.filename.endswith(".SF") or item.filename.endswith(".RSA") or item.filename.endswith(".MF")
            ):
                continue

            # 暫時略過 checksums.json，後續統一重新生成
            if item.filename == "assets/checksums.json":
                continue

            # 若該檔案被 rime_liur 自訂資產覆蓋
            if item.filename in injected_assets:
                data = injected_assets.pop(item.filename)
                # 若為 default.yaml，執行方案首位注入
                if item.filename == "assets/shared/default.yaml":
                    text = data.decode("utf-8", errors="ignore")
                    text = patch_default_yaml(text)
                    data = text.encode("utf-8")
                # 若為 trime.yaml，執行主題首選注入
                elif item.filename == "assets/shared/trime.yaml":
                    text = data.decode("utf-8", errors="ignore")
                    text = patch_trime_yaml(text)
                    data = text.encode("utf-8")

                zout.writestr(item, data)
                if item.filename.startswith("assets/shared/"):
                    rel_name = item.filename[len("assets/") :]
                    all_shared_hashes[rel_name] = calculate_sha256(data)
            else:
                data = zin.read(item.filename)
                # 攔截原版 default.yaml 與 trime.yaml
                if item.filename == "assets/shared/default.yaml":
                    text = data.decode("utf-8", errors="ignore")
                    text = patch_default_yaml(text)
                    data = text.encode("utf-8")
                elif item.filename == "assets/shared/trime.yaml":
                    text = data.decode("utf-8", errors="ignore")
                    text = patch_trime_yaml(text)
                    data = text.encode("utf-8")

                zout.writestr(item, data)
                if item.filename.startswith("assets/shared/"):
                    rel_name = item.filename[len("assets/") :]
                    all_shared_hashes[rel_name] = calculate_sha256(data)

        # 3. 注入剩餘所有 rime_liur 的全新檔案 (如 liur.schema.yaml, liur_shyam_*.trime.yaml)
        for target_asset, data in injected_assets.items():
            zout.writestr(target_asset, data)
            if target_asset.startswith("assets/shared/"):
                rel_name = target_asset[len("assets/") :]
                all_shared_hashes[rel_name] = calculate_sha256(data)

        # 4. 重新建置 assets/checksums.json
        checksum_payload = {
            "sha256": hashlib.sha256("".join(sorted(all_shared_hashes.values())).encode()).hexdigest(),
            "files": {"shared": ""},
        }
        for path_key in sorted(all_shared_hashes.keys()):
            checksum_payload["files"][path_key] = all_shared_hashes[path_key]

        zout.writestr("assets/checksums.json", json.dumps(checksum_payload, indent=4).encode("utf-8"))

    print(f"[OK] 預裝版 Trime APK 封裝完成: {out_apk.name} (大小: {out_apk.stat().st_size / 1024 / 1024:.2f} MB)")
    print(f"[OK] 已成功註冊 {len(all_shared_hashes)} 筆資產校驗雜湊至 checksums.json。")


if __name__ == "__main__":
    main()
