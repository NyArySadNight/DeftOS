#!/usr/bin/bash
# First-boot Snapper setup for / on Btrfs. Re-runnable.
set -euo pipefail

if [[ "$(findmnt -no FSTYPE /)" != btrfs ]]; then
  echo "deftos-snapper-init: / is not Btrfs, nothing to do"; exit 0
fi

if ! snapper list-configs 2>/dev/null | awk 'NR>2{print $1}' | grep -qx root; then
  if mountpoint -q /.snapshots; then
    # installer pre-created a dedicated @snapshots subvolume: let Snapper make its own
    # layout, then put the dedicated mount back (Arch wiki procedure)
    umount /.snapshots
    rmdir /.snapshots
    snapper -c root create-config /
    btrfs subvolume delete /.snapshots
    mkdir /.snapshots
    mount /.snapshots
  else
    snapper -c root create-config /
  fi
  chmod 750 /.snapshots
  snapper -c root create -c number -d "DeftOS first-boot baseline"
fi

# pre/post snapshots only (snap-pac); no timeline spam
snapper -c root set-config \
  TIMELINE_CREATE=no \
  NUMBER_CLEANUP=yes NUMBER_MIN_AGE=1800 NUMBER_LIMIT=10 NUMBER_LIMIT_IMPORTANT=5 \
  EMPTY_PRE_POST_CLEANUP=yes EMPTY_PRE_POST_MIN_AGE=1800 \
  SPACE_LIMIT=0.3 FREE_LIMIT=0.2
