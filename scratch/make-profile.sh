#!/bin/bash
# Dung ISO bang mkarchiso tu profile releng. Khong unpack/repack ISO CachyOS.
# Chi lay DANH SACH package tu base ISO (de giu bo package giong CachyOS), con lai lay tu repo.
# Chay trong container archlinux, can --privileged. Usage: make-profile.sh <repo_dir> <base_iso>
set -euo pipefail
REPO=$(realpath "$1"); BASE=$(realpath "$2")
WORK="$REPO/work-scratch"
PROFILE="$WORK/profile"
rm -rf "$WORK"; mkdir -p "$WORK/iso" "$WORK/out"
mount -o loop,ro "$BASE" "$WORK/iso"
trap 'umount "$WORK/iso" 2>/dev/null || true' EXIT

cp -r /usr/share/archiso/configs/releng "$PROFILE"

# 1. Danh sach package: lay ten tu pacman local db trong airootfs cua base ISO
unsquashfs -l "$WORK/iso/arch/x86_64/airootfs.sfs" \
  | sed -n 's#^squashfs-root/var/lib/pacman/local/\([^/]*\)/desc$#\1#p' \
  | sed -E 's/-[^-]+-[^-]+$//' | sort -u > "$WORK/base-pkgs.txt"
echo "So package tu base ISO: $(wc -l < "$WORK/base-pkgs.txt")"
{ cat "$WORK/base-pkgs.txt"; printf '%s\n' archiso mkinitcpio-archiso linux linux-firmware; } \
  | sort -u > "$PROFILE/packages.x86_64"

# 2. Overlay DeftOS vao airootfs
rsync -rlptD "$REPO/overlay/" "$PROFILE/airootfs/"

# 3. pacman.conf cua DeftOS (co [cachyos])
cp "$REPO/overlay/etc/pacman.conf" "$PROFILE/pacman.conf"

# 4. Ten ISO
sed -i -e 's/^iso_name=.*/iso_name="deftos"/' \
       -e 's/^iso_label=.*/iso_label="DEFTOS_$(date +%Y%m)"/' \
       -e 's/^iso_publisher=.*/iso_publisher="DeftOS"/' \
       -e 's/^iso_application=.*/iso_application="DeftOS Live\/Install"/' "$PROFILE/profiledef.sh"

# 5. Quyen thuc thi cho script DeftOS
cat >> "$PROFILE/airootfs/root/customize_airootfs.sh" <<'CHMOD'
chmod 755 /usr/local/bin/calamares-online.sh \
          /usr/libexec/deftos/apply-branding.sh \
          /usr/share/deftos/hooks/restore-branding.sh \
          /usr/lib/deftos/snapper-init.sh \
          /etc/calamares/scripts/btrfs-installation-snapshot \
          /etc/calamares/scripts/update-mirrorlist 2>/dev/null || true
CHMOD
[ -f "$PROFILE/airootfs/root/customize_airootfs.sh" ] || echo "WARN: releng khong co customize_airootfs.sh"

# 6. Build
mkarchiso -v -w "$WORK/work" -o "$WORK/out" "$PROFILE"
ls -lh "$WORK/out"/*.iso
