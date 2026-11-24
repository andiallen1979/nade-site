#!/usr/bin/env bash
set -euo pipefail

CHROOT="${NADE_CHROOT:-/srv/nade-chroot}"
REPO="/var/db/repos/nade"

cleanup() {
  for m in var/cache/distfiles var/db/repos/nade run dev sys proc; do
    mountpoint -q "${CHROOT}/${m}" && umount -R -l "${CHROOT}/${m}" || true
  done
}
trap cleanup EXIT

mountpoint -q "${CHROOT}/proc" || mount --types proc /proc "${CHROOT}/proc"
mountpoint -q "${CHROOT}/sys"  || { mount --rbind /sys "${CHROOT}/sys" && mount --make-rslave "${CHROOT}/sys"; }
mountpoint -q "${CHROOT}/dev"  || { mount --rbind /dev "${CHROOT}/dev" && mount --make-rslave "${CHROOT}/dev"; }
mountpoint -q "${CHROOT}/run"  || { mount --bind /run "${CHROOT}/run" && mount --make-slave "${CHROOT}/run"; }

mountpoint -q "${CHROOT}/var/db/repos/nade"   || mount --bind "${REPO}" "${CHROOT}/var/db/repos/nade"
mountpoint -q "${CHROOT}/var/cache/distfiles" || mount --bind /var/cache/distfiles "${CHROOT}/var/cache/distfiles"

chroot "${CHROOT}" /usr/bin/env -i PATH=/usr/sbin:/usr/bin:/sbin:/bin HOME=/root TERM="${TERM}" \
  /bin/bash -c 'env-update && source /etc/profile && export PS1="\[\e[1;31m\](nade-chroot)\[\e[0m\] \w # " && exec /bin/bash'
