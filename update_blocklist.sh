#!/bin/bash

# Mengatur variabel
TARGET_DIR=$(pwd)
SOURCE_URL="${SOURCE_URL}"
GIT_USERNAME="${GIT_USERNAME}"
GIT_EMAIL="${GIT_EMAIL}"

# Instal wrangler jika belum terinstal
npm install -g wrangler

# Hapus file domains_isp lama jika ada
if [ -f "$TARGET_DIR/domains_isp" ]; then
    rm "$TARGET_DIR/domains_isp"
fi

# Unduh data terbaru dari sumber
curl --insecure -o "$TARGET_DIR/domains_isp" "$SOURCE_URL"

# Menghitung total baris dalam file domains_isp
TOTAL_LINES=$(wc -l < "$TARGET_DIR/domains_isp")
echo "Total lines in domains_isp: $TOTAL_LINES"

# Menghitung jumlah baris per bagian
LINES_PER_PART=$((($TOTAL_LINES + 2) / 3))
echo "Lines per part: $LINES_PER_PART"

# Memisahkan file domains_isp menjadi tiga bagian
split -l $LINES_PER_PART "$TARGET_DIR/domains_isp" "$TARGET_DIR/domains_isp_part"

# Mengganti nama file bagian
mv "${TARGET_DIR}/domains_isp_partaa" "${TARGET_DIR}/domains_isp_part1"
mv "${TARGET_DIR}/domains_isp_partab" "${TARGET_DIR}/domains_isp_part2"
mv "${TARGET_DIR}/domains_isp_partac" "${TARGET_DIR}/domains_isp_part3"

# Upload data ke KV
wrangler kv:key put --namespace-id "${KV_NAMESPACE_ID}" "domains_part1" "$(cat ${TARGET_DIR}/domains_isp_part1)"
wrangler kv:key put --namespace-id "${KV_NAMESPACE_ID}" "domains_part2" "$(cat ${TARGET_DIR}/domains_isp_part2)"
wrangler kv:key put --namespace-id "${KV_NAMESPACE_ID}" "domains_part3" "$(cat ${TARGET_DIR}/domains_isp_part3)"

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
