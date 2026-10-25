# DeftOS — KDE Plasma 6

High-performance Arch-based Linux ISO rebranded from CachyOS with KDE Plasma 6, featuring custom wallpaper (DeftOSHole), optimized kernel (Linux 7.2.10), and Calamares installer.

## Features

- **KDE Plasma 6**: Modern, responsive desktop environment
- **Linux 7.2.10 Kernel**: Performance-tuned for latency & throughput
- **Minimal Base System**: Only essential packages, optimized for speed
- **Calamares Installer**: Streamlined installation workflow (no CPU/GPU selection bloat)
- **DeftOS Branding**: Custom wallpaper (DeftOSHole.jpg), SDDM theme, system colors
- **pacman Repository**: `deftos-branding` package with logo and wallpaper assets
- **Snapper Integration**: LTS kernel fallback & snapshot rollback on boot panic
- **CachyOS Base**: Leverages CachyOS optimization hooks and kernel tuning

## Installation

1. Download latest ISO from [GitHub Releases](https://github.com/NyArySadNight/DeftOS/releases) or build from source
2. Write to USB: `sudo dd if=deftos-*.iso of=/dev/sdX bs=4M status=progress` and sync
3. Boot from USB and launch Calamares installer
4. Configure: timezone, keyboard, disk partitioning, user credentials
5. Installer applies DeftOS branding and minimal base packages automatically
6. Reboot into installed system

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

## Build & Development

- **Repository Structure**: 
  - `overlay/` — All DeftOS customizations (branding, configs, wallpaper)
  - `.github/workflows/` — GitHub Actions auto-build pipeline
  - `patches/` — Kernel patches for optimization
  - `tools/` — Build scripts and utilities

- **Build Requirements**: Linux, Arch base tools, mkinitcpio, Calamares
- **CI/CD**: GitHub Actions automatically builds ISO on PR merge to main

## Contributing

See [DeftOS Team Developer Guide](./docs/DEVELOPER.md) for setup instructions, Git workflow, and best practices.

---

### Changelog

**Latest (v8.4+)**: 
- ✅ Minimal base system: removed bloat packages (python, perl, plymouth, etc.)
- ✅ Fixed mirror configuration: removed fake servers, clean UTF-8 encoding
- ✅ Standardized wallpaper naming: deftos-wallpaper.jpg → DeftOSHole.jpg
- ✅ Cleaner Calamares installer (no CPU/GPU selection UI)

**v8.3**: Wallpaper fixed (deftoswall.png → desktop.png), deftos-branding package added, kernel 7.2.10 verified.
