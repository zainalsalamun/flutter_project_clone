#!/bin/bash

# Pastikan menggunakan path ADB yang benar
ADB="/Users/macbookpro/Library/Android/sdk/platform-tools/adb"
OUT_DIR="assets/screenshot"

mkdir -p "$OUT_DIR"

APPS=(
  "aura_wallet.png:Aura Wallet"
  "brewez_coffee.png:Brewez Coffee"
  "glossy_music.png:Glossy Music"
  "glossy_shop.png:Glossy Shop"
  "habit_tracker.png:Habit Tracker"
  "inventory_app.png:Inventory App"
  "lumina_home.png:Lumina Home"
  "notification_center.png:Notification Center"
  "nova_ai.png:Nova AI"
  "shark_fit.png:Shark Fit"
  "talenta.png:Talenta"
  "task_manager.png:Task Manager"
  "tix_id.png:Tix ID"
  "zenith_task.png:Zenith Task"
)

echo "=========================================="
echo "    Alat Pengambil Screenshot Otomatis    "
echo "=========================================="
echo "Pastikan emulator Android Anda berjalan."
echo ""

for item in "${APPS[@]}"; do
  file="${item%%:*}"
  appName="${item##*:}"
  
  echo -e "\n👉 Buka halaman \033[1;32m$appName\033[0m di emulator."
  read -p "Tekan [ENTER] jika sudah siap..."
  
  echo "Mengambil screenshot untuk $appName..."
  # Eksekusi ADB screencap, perbaiki line endings agar file tidak corrupt di macOS
  $ADB exec-out screencap -p > "$OUT_DIR/$file"
  
  echo -e "\033[1;34mBerhasil disimpan sebagai $OUT_DIR/$file\033[0m"
done

echo -e "\nSemua screenshot berhasil diambil! 🎉"
