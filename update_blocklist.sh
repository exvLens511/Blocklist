#!/bin/bash

# Mengatur variabel
TARGET_DIR=$(pwd)
SOURCE_URL="${SOURCE_URL}"
GIT_USERNAME="${GIT_USERNAME}"
GIT_EMAIL="${GIT_EMAIL}"
PART_SIZE=100000  # Jumlah baris per file bagian

# Hapus file domains_isp lama jika ada
if [ -f "$TARGET_DIR/domains_isp" ]; then
    rm "$TARGET_DIR/domains_isp"
fi

# Unduh data terbaru dari sumber
curl --insecure -o "$TARGET_DIR/domains_isp" "$SOURCE_URL"

# Memisahkan file domains_isp menjadi beberapa bagian
split -l $PART_SIZE "$TARGET_DIR/domains_isp" "$TARGET_DIR/domains_isp_part"

# Mengganti nama file bagian
mv "${TARGET_DIR}/domains_isp_parta"* "${TARGET_DIR}/domains_isp_part1"
mv "${TARGET_DIR}/domains_isp_partb"* "${TARGET_DIR}/domains_isp_part2"
mv "${TARGET_DIR}/domains_isp_partc"* "${TARGET_DIR}/domains_isp_part3"

# Git konfigurasi
git config user.name "$GIT_USERNAME"
git config user.email "$GIT_EMAIL"

# Tambahkan file ke staging area
git add domains_isp_part1 domains_isp_part2 domains_isp_part3 update_blocklist.sh

# Commit dan dorong perubahan ke GitHub
git commit -m "Updated blocklist from Kominfo and split into parts"
git pull --rebase origin main
git push -u origin main

# Selesai
echo "Script completed successfully."
