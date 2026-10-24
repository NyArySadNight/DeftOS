#!/bin/bash
set -euo pipefail
SELF=$(realpath "$0")
ARG_ISO=""
[ $# -ge 1 ] && ARG_ISO=$(realpath "$1")
cd "$(dirname "$SELF")"
[ "$(id -u)" = 0 ] || exec sudo -E bash "$SELF" "$@"
Y=deftos-build.yaml
get() { sed -n "s/^$1:[[:space:]]*//p" "$Y" | head -1; }
BASE_ISO="${ARG_ISO:-$(get base_iso)}"
URL=$(get base_iso_url); SHA=$(get base_iso_sha256)
OUT=$(get output_iso); LVL=$(get squashfs_level)
WORK="${WORK:-$PWD/work}"
for t in unsquashfs mksquashfs xorriso rsync python3 sha256sum sha512sum curl; do
  command -v $t >/dev/null || { echo "Thieu cong cu: $t"; exit 1; }
done
if [ ! -f "$BASE_ISO" ]; then curl -L -o "$BASE_ISO" "$URL"; fi
echo "$SHA  $BASE_ISO" | sha256sum -c - || { echo "ISO goc sai ma bam"; exit 1; }
mountpoint -q "$WORK/iso" && umount "$WORK/iso" || true
rm -rf "$WORK"; mkdir -p "$WORK/iso"
trap 'mountpoint -q "$WORK/iso" && umount "$WORK/iso" || true' EXIT
mount -o loop,ro "$BASE_ISO" "$WORK/iso"
unsquashfs -f -d "$WORK/rootfs" "$WORK/iso/arch/x86_64/airootfs.sfs" >/dev/null
umount "$WORK/iso"
rsync -rlptD overlay/ "$WORK/rootfs/"
# Script trong overlay phai co quyen thuc thi (git/rsync co the lam mat bit x)
chmod 755 "$WORK/rootfs/usr/local/bin/calamares-online.sh" \
          "$WORK/rootfs/usr/libexec/deftos/apply-branding.sh" \
          "$WORK/rootfs/usr/share/deftos/hooks/restore-branding.sh" \
          "$WORK/rootfs/usr/lib/deftos/snapper-init.sh"
# Calamares branding: deftos/ needs the image/QML assets shipped in the base ISO's cachyos/ folder
BR="$WORK/rootfs/usr/share/calamares/branding"
[ -d "$BR/cachyos" ] && cp -rn "$BR/cachyos/." "$BR/deftos/"
for f in branding.desc logo.png icon.png welcome.png show.qml; do
  [ -f "$BR/deftos/$f" ] || { echo "LOI: thieu $BR/deftos/$f - Calamares se khong khoi dong"; exit 1; }
done
grep -q '^componentName:[[:space:]]*deftos' "$BR/deftos/branding.desc" || { echo "LOI: componentName trong deftos/branding.desc khong phai deftos"; exit 1; }
find overlay/home/liveuser -mindepth 1 2>/dev/null | sed 's|^overlay/||' | while IFS= read -r p; do
  chown 1000:1000 "$WORK/rootfs/$p"
done
for p in patches/*.bpatch; do
  f=$(basename "$p" .bpatch)
  python3 patches/apply_bpatch.py "$WORK/rootfs/usr/bin/$f" "$p"
done
mksquashfs "$WORK/rootfs" "$WORK/airootfs.sfs" -comp zstd -Xcompression-level "$LVL" -b 1M -noappend
( cd "$WORK" && sha512sum airootfs.sfs > airootfs.sha512 )
rm -f "$OUT"
MAPS=(-map "$WORK/airootfs.sfs" /arch/x86_64/airootfs.sfs -map "$WORK/airootfs.sha512" /arch/x86_64/airootfs.sha512)
while IFS= read -r f; do MAPS+=(-map "iso-overlay/$f" "/$f"); done < <(cd iso-overlay && find . -type f | sed 's|^\./||')
xorriso -indev "$BASE_ISO" -outdev "$OUT" -boot_image any replay "${MAPS[@]}" -commit
echo "Xong: $OUT"; sha256sum "$OUT"
