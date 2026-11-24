#!/usr/bin/env bash
set -euo pipefail

GENTOO="/var/db/repos/gentoo"
NADE="/var/db/repos/nade"
LIST="/tmp/nade-stage3-atoms.txt"
TMP_CFG="/tmp/nade-seed-cfg"
TMP_ROOT="/tmp/nade-empty-root"

rm -rf "${TMP_CFG}" "${TMP_ROOT}"
mkdir -p "${TMP_CFG}/etc/portage/repos.conf" "${TMP_ROOT}"

cat <<'REPOEOF' > "${TMP_CFG}/etc/portage/repos.conf/gentoo.conf"
[DEFAULT]
main-repo = gentoo

[gentoo]
location = /var/db/repos/gentoo
REPOEOF

# Resolve using the base nade profile (no Plasma/KDE) against an empty ROOT
ln -s "${NADE}/profiles/default/linux/amd64/23.0/nade" "${TMP_CFG}/etc/portage/make.profile"

PORTAGE_CONFIGROOT="${TMP_CFG}" ROOT="${TMP_ROOT}" \
  emerge --pretend --emptytree --root-deps --columns --color=n \
  @system \
  sys-apps/systemd \
  sys-apps/portage \
  dev-vcs/git \
  sys-kernel/installkernel \
  sys-kernel/dracut \
  sys-boot/grub \
  sys-boot/efibootmgr \
  net-misc/networkmanager \
  | awk -F']' '/^\[ebuild/{print $2}' \
  | awk '{print $1}' \
  | sort -u > "${LIST}"

echo "Resolved $(wc -l < "${LIST}") unique category/package atoms."

while IFS= read -r cp; do
  [[ -z "$cp" || "$cp" != */* ]] && continue
  if [[ -d "${GENTOO}/${cp}" && ! -d "${NADE}/${cp}" ]]; then
    mkdir -p "${NADE}/$(dirname "$cp")"
    cp -a "${GENTOO}/${cp}" "${NADE}/${cp}"
  fi
done < "${LIST}"

find "${NADE}" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | grep -E '^[a-z0-9]+-[a-z0-9]+$|^virtual$' \
  | sort -u > "${NADE}/profiles/categories"

rm -rf "${TMP_CFG}" "${TMP_ROOT}"
echo "Categories written: $(wc -l < "${NADE}/profiles/categories")"
