#!/bin/bash
# Chay trong Calamares sau pacstrap. $1 = @@ROOT@@ (goc may dich).
set -e
ROOT="$1"

# os-release va branding: copy tu live sang may dich
install -Dm644 /usr/lib/os-release "$ROOT/usr/lib/os-release"
ln -sf ../usr/lib/os-release "$ROOT/etc/os-release"
for f in etc/lsb-release etc/issue etc/issue.net etc/motd; do
    if [ -f "/$f" ]; then install -Dm644 "/$f" "$ROOT/$f"; fi
done
install -Dm644 /etc/xdg/fastfetch/config.jsonc "$ROOT/etc/xdg/fastfetch/config.jsonc"
install -Dm644 /etc/xdg/fastfetch/deftos_logo.txt "$ROOT/etc/xdg/fastfetch/deftos_logo.txt"

# skel: bo autostart cua CachyOS va installer, copy skel DeftOS
rm -f "$ROOT/etc/skel/.config/autostart/cachyos-hello.desktop"
rm -f "$ROOT/etc/skel/.config/autostart/deftos-installer.desktop"
cp -a /etc/skel/. "$ROOT/etc/skel/"
rm -f "$ROOT/etc/skel/.config/autostart/cachyos-hello.desktop"
rm -f "$ROOT/etc/skel/.config/autostart/deftos-installer.desktop"

# hooks
install -Dm644 /etc/pacman.d/hooks/95-bootbackup.hook "$ROOT/etc/pacman.d/hooks/95-bootbackup.hook"
install -Dm644 /etc/pacman.d/hooks/99-deftos-branding.hook "$ROOT/etc/pacman.d/hooks/99-deftos-branding.hook"
install -Dm755 /usr/share/deftos/hooks/restore-branding.sh "$ROOT/usr/share/deftos/hooks/restore-branding.sh"

# go cachyos-hello khoi may dich neu co
if chroot "$ROOT" pacman -Q cachyos-hello >/dev/null 2>&1; then
    chroot "$ROOT" pacman -Rns --noconfirm cachyos-hello
fi
