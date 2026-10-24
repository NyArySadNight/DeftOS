#!/bin/bash
# Chi doc: mo ISO goc, in ra thong tin ve installer/hello/polkit de chan doan. Ghi vao $2.
set -uo pipefail
ISO=$(realpath "$1"); OUT=$(realpath -m "$2"); REPO=$(pwd)
W=$(mktemp -d)
sudo apt-get install -y squashfs-tools binutils rsync python3-pip >/dev/null 2>&1
mkdir -p "$W/iso" "$W/rf"
sudo mount -o loop,ro "$ISO" "$W/iso"
sudo unsquashfs -f -d "$W/rf" "$W/iso/arch/x86_64/airootfs.sfs" \
  usr/bin/cachyos-installer usr/bin/cachyos-hello usr/local/bin usr/share/polkit-1 etc/polkit-1 \
  etc/sudoers etc/sudoers.d usr/share/applications etc/xdg/autostart etc/skel home/liveuser \
  etc/os-release usr/lib/os-release etc/version-tag etc/pam.d/sudo etc/calamares usr/lib/calamares usr/share/calamares >/dev/null 2>&1
sudo chown -R "$(id -u)":"$(id -g)" "$W/rf"
R="$W/rf"
{
echo "=== ls usr/local/bin"; ls -la "$R/usr/local/bin"
echo "=== ls autostart (skel / liveuser / xdg)"
ls -la "$R/etc/skel/.config/autostart" "$R/home/liveuser/.config/autostart" "$R/etc/xdg/autostart" 2>&1
echo "=== BASE calamares-online.sh"; cat "$R/usr/local/bin/calamares-online.sh" 2>&1
echo "=== pkexec-wrapper"; cat "$R/usr/local/bin/pkexec-wrapper" 2>&1
echo "=== sudoers.d"; ls -la "$R/etc/sudoers.d"; head -n 20 "$R"/etc/sudoers.d/* 2>&1
echo "=== polkit rules"; ls -R "$R/etc/polkit-1" "$R/usr/share/polkit-1" 2>&1 | head -40
cat "$R"/etc/polkit-1/rules.d/* 2>/dev/null | head -60
echo "=== installer/hello desktop files"; ls "$R/usr/share/applications" | grep -i -E 'install|hello|calamares'
for f in "$R"/usr/share/applications/*install*.desktop "$R"/usr/share/applications/*hello*.desktop; do echo "--- $f"; grep -v -E '^(Comment|Name|GenericName)\[' "$f"; done 2>&1
echo "=== os-release (base)"; cat "$R/usr/lib/os-release"
echo "=== strings: cachyos-installer (filtered)"
strings -n 5 "$R/usr/bin/cachyos-installer" | grep -i -E 'calamares|pkexec|sudo|\.sh|/usr/|/etc/|root priv|launch|DISPLAY|WAYLAND|os-release|archiso|liveuser|cachyos|deftos' | sort -u | head -120
echo "=== strings: cachyos-hello (filtered)"
strings -n 5 "$R/usr/bin/cachyos-hello" | grep -i -E 'installer|calamares|pkexec|sudo|\.sh$|launch|spawn|os-release|archiso|liveuser|/usr/bin|/usr/local' | sort -u | head -120
# Ap patch len ban sao, so sanh chuoi truoc/sau
mkdir -p "$W/p"; cp "$R/usr/bin/cachyos-hello" "$R/usr/bin/cachyos-installer" "$W/p/"
python3 "$REPO/patches/apply_bpatch.py" "$W/p/cachyos-hello" "$REPO/patches/cachyos-hello.bpatch" 2>&1
python3 "$REPO/patches/apply_bpatch.py" "$W/p/cachyos-installer" "$REPO/patches/cachyos-installer.bpatch" 2>&1
for b in cachyos-hello cachyos-installer; do
  echo "=== sizes $b"; stat -c '%s' "$R/usr/bin/$b" "$W/p/$b"
  echo "=== strings diff $b (lines with path/command-like text)"
  diff <(strings -n 4 "$R/usr/bin/$b") <(strings -n 4 "$W/p/$b") | grep '^[<>]' | grep -E '/|-|\.desktop|\.sh|=' | head -60
done
echo "=== all strings in PATCHED hello/installer containing 'DeftOS' near command-ish text"
strings -n 4 "$W/p/cachyos-installer" | grep -E 'DeftOS' | head -20
} > "$OUT" 2>&1

# ---- Gop overlay len ban trich cua ISO goc roi kiem tra cau hinh Calamares ----
M="$W/merged"; mkdir -p "$M"; sudo cp -a "$R/." "$M/" 2>/dev/null; sudo chown -R "$(id -u)":"$(id -g)" "$M"
rsync -rlptD "$REPO/overlay/" "$M/"
[ -d "$M/usr/share/calamares/branding/cachyos" ] && cp -rn "$M/usr/share/calamares/branding/cachyos/." "$M/usr/share/calamares/branding/deftos/"
pip install -q pyyaml >/dev/null 2>&1
{
echo "=== CHECK Calamares (ISO goc + overlay)"
python3 "$REPO/tools/check-calamares.py" "$M" etc/calamares/settings.conf usr/share/calamares/settings.conf usr/share/calamares/settings_online.conf
echo "=== settings_online.conf: modules/ trong /etc/calamares sau khi gop"; ls "$M/etc/calamares/modules" | head -80
} >> "$OUT" 2>&1

# ---- Chu "cachy" hien thi nam trong ISO goc (ngoai overlay) ----
V="$W/vis"; mkdir -p "$V"
sudo unsquashfs -f -d "$V" "$W/iso/arch/x86_64/airootfs.sfs" usr/share/applications usr/share/sddm usr/lib/sddm usr/share/plasma \
  usr/share/plymouth usr/share/grub usr/share/metainfo usr/share/desktop-directories usr/share/color-schemes \
  usr/share/wallpapers usr/share/backgrounds usr/share/kdisplay usr/share/knotifications6 \
  etc/sddm.conf etc/sddm.conf.d etc/issue etc/hostname etc/default etc/plymouth etc/environment etc/xdg >/dev/null 2>&1
sudo chown -R "$(id -u)":"$(id -g)" "$V"
{
echo "=== [VISIBLE] ten file chua 'cachy' (ngoai binary/icon)"
find "$V" -iname '*cachy*' | sed "s|$V||" | head -60
echo "=== [VISIBLE] .desktop: dong Name/Comment/GenericName khong dich chua cachy"
grep -rIn -i -E '^(Name|Comment|GenericName)=.*cachy' "$V/usr/share/applications" "$V/etc/xdg" 2>/dev/null | sed "s|$V||" | cut -c1-200 | head -60
echo "=== [VISIBLE] file text khac chua cachy (sddm/plasma/plymouth/grub/etc)"
grep -rIl -i cachy "$V/usr/share/sddm" "$V/usr/lib/sddm" "$V/usr/share/plasma" "$V/usr/share/plymouth" "$V/usr/share/grub" \
  "$V/usr/share/metainfo" "$V/etc" 2>/dev/null | sed "s|$V||" | head -60
echo "=== [VISIBLE] etc/issue, etc/hostname, etc/default"
cat "$V/etc/issue" "$V/etc/hostname" 2>/dev/null; grep -rn -i cachy "$V/etc/default" "$V/etc/environment" 2>/dev/null | sed "s|$V||" | head
echo "=== [VISIBLE] sddm theme / plasma look-and-feel dirs"
ls "$V/usr/share/sddm/themes" "$V/usr/share/plasma/look-and-feel" "$V/usr/share/plymouth/themes" "$V/usr/share/grub/themes" 2>&1 | head -40
} >> "$OUT" 2>&1
sudo umount "$W/iso"
