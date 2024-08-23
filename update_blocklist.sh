#!/bin/bash

# Mengatur variabel
TARGET_DIR=$(pwd)
SOURCE_URL="${SOURCE_URL}"
GIT_USERNAME="${GIT_USERNAME}"
GIT_EMAIL="${GIT_EMAIL}"

# Hapus file domains_isp lama jika ada
if [ -f "$TARGET_DIR/domains_isp" ]; then
    rm "$TARGET_DIR/domains_isp"
fi

# Unduh data terbaru
curl --insecure -o "$TARGET_DIR/domains_isp" "$SOURCE_URL"

# Git konfigurasi
git config user.name "$GIT_USERNAME"
git config user.email "$GIT_EMAIL"

# Tambahkan file ke staging area
git add domains_isp update_blocklist.sh

# Commit dan dorong perubahan ke GitHub
git commit -m "Updated blocklist from Kominfo"
git pull --rebase origin main
git push -u origin main

# Selesai
echo "Script completed successfully."