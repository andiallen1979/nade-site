#!/usr/bin/env bash
set -euo pipefail

BRANCH="${1:-main}"
BASE_URL="https://steamdeck-packages.steamos.cloud/archlinux-mirror"
CACHE_DIR="${HOME}/.cache/nade-steamos"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

mkdir -p "${CACHE_DIR}"
OUT="${CACHE_DIR}/packages.tsv"
: > "${OUT}"

for REPO in "jupiter-${BRANCH}" "holo-${BRANCH}"; do
  DB_URL="${BASE_URL}/${REPO}/os/x86_64/${REPO}.db"
  DB_FILE="${TMP_DIR}/${REPO}.db"
  EXTRACT_DIR="${TMP_DIR}/${REPO}"

  echo "Fetching ${DB_URL}..."
  curl -fsSL "${DB_URL}" -o "${DB_FILE}"

  mkdir -p "${EXTRACT_DIR}"
  tar -xf "${DB_FILE}" -C "${EXTRACT_DIR}"

  find "${EXTRACT_DIR}" -name desc -print0 | xargs -0 awk -v repo="${REPO}" '
    /^%NAME%$/    { getline name; next }
    /^%VERSION%$/ { getline ver; print name "\t" ver "\t" repo; next }
  ' >> "${OUT}"
done

sort -u -o "${OUT}" "${OUT}"
echo "Wrote $(wc -l < "${OUT}") packages to ${OUT}"
