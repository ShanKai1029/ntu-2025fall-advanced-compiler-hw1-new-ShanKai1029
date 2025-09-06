#!/bin/bash

# TODO: Add the commands to install the Bril environment tools.
# Make sure your script installs Deno, Flit, and the Bril tools.
# Ensure the script works on any machine and sets up the PATH correctly.
set -e
# 啟用 "exit on error" 模式，當任何指令失敗時，腳本會立即結束，避免錯誤繼續傳播

echo "=== Installing Bril environment ==="
# 印出提示訊息，告知使用者正在安裝 Bril 環境

# ======================
# 1. 安裝 Deno
# ======================
echo "=== Installing deno ==="
if ! command -v unzip >/dev/null 2>&1 
then
    echo 'Installing unzip...'
    sudo apt-get install unzip -y
    echo 'Unzip installing complete...'
fi
if ! command -v deno >/dev/null 2>&1 
then
  # 如果系統上找不到 deno 指令，就執行安裝
  echo "Deno not found. Installing..."
  # 從官方網站下載並執行安裝腳本
  curl -fsSL https://deno.land/x/install/install.sh | sh
  export PATH="$HOME/.deno/bin:$PATH" >> ~/.bashrc
else
  # 如果已經安裝 Deno，給使用者提示
  echo "Deno already installed."
fi

# ======================
# 2. 安裝 Flit
# ======================
echo "=== Installing Flit ==="
if ! command -v flit >/dev/null 2>&1 
then
  # 如果系統上找不到 flit 指令，就執行安裝
  echo "Flit not found. Installing..."
  # 使用 pip 安裝 flit 到使用者目錄
  pip install --user flit
  export PATH="$HOME/.local/bin:$PATH" >> ~/.bashrc
else
  # 如果已經安裝 Flit，給使用者提示
  echo "Flit already installed."
fi

# ======================
# 3. 安裝 Bril 工具
# ======================
echo "=== Installing Bril tool ==="
# 安裝 bril2json 與 bril2txt（在 bril-txt 目錄內)
if [ -d "bril/bril-txt" ]; then
  # 檢查是否存在 bril-txt 資料夾
  echo "Installing bril2json and bril2txt..."
  # 進入 bril-txt 資料夾並執行 flit 安裝，--symlink 讓修改能即時生效
  (cd bril/bril-txt && flit install --symlink)
  else
    echo "skip"
fi

# 安裝 brili（在 bril 目錄內）
if [ -d "bril" ]; then
  # 檢查是否存在 bril 資料夾
  echo "Installing brili..."
  # 進入 bril 資料夾並執行 flit 安裝
  (cd bril && deno install -g ./brili.ts)
fi

# ======================
# 4. 完成提示
# ======================
echo "=== Installation complete! ==="
# 印出完成訊息

echo "Make sure your PATH includes: \$HOME/.local/bin and \$HOME/.deno/bin"
# 提醒使用者要把 ~/.local/bin 和 ~/.deno/bin 加到 PATH，這樣才能在任何地方使用這些工具