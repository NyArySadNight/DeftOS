# DeftOS — Cachy Rebranded KDE Plasma 6

High-performance Arch-based Linux ISO rebranded from CachyOS with KDE Plasma 6, featuring custom wallpaper, optimized kernel (Linux 7.2.10), and Calamares installer.

## Features

- **KDE Plasma 6**: Modern, responsive desktop environment
- **Linux 7.2.10 Kernel**: Performance-tuned for latency & throughput
- **Calamares Installer**: Streamlined installation workflow
- **DeftOS Branding**: Custom wallpaper, SDDM theme, system colors
- **pacman Repository**: `deftos-branding` package with logo and wallpaper assets
- **Snapper Integration**: LTS kernel fallback & snapshot rollback on boot panic

## Installation

1. Download ISO from [GitHub Releases](https://github.com/NyArySadNight/DeftOS/releases)
2. Write to USB: `sudo dd if=deftosv8.3-x86_64.iso of=/dev/sdX bs=4M status=progress`
3. Boot and run Calamares installer
4. Select timezone, keyboard, disk, user during setup
5. Reboot

## Recovery

If kernel panic or boot fails:
- **Snapper rollback**: `snapper list` → `snapper undochange <pre> <post>`
- **LTS fallback**: Grub menu → Linux LTS (5.15.x)
- **Chroot recovery**: Boot Arch ISO → mount rootfs → `arch-chroot /mnt` → troubleshoot

## System Info

- **Base**: CachyOS (Arch Linux)
- **DE**: KDE Plasma 6
- **Kernel**: Linux 7.2.10 (custom compile)
- **Installer**: Calamares
- **Repo**: [NyArySadNight/DeftOS](https://github.com/NyArySadNight/DeftOS)

---

**v8.3+**: Wallpaper fixed (deftoswall.png → desktop.png), deftos-branding package added, kernel 7.2.10 verified.
