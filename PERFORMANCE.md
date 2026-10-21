# DeftOS v8.3+ - Build Changes Log

## Fixes Applied

### Wallpaper
- Issue: Plasma showed CachyOS wallpaper instead of DeftOS
- Fix: Updated plasma-org.kde.plasma.desktop-appletsrc Image= path to deftoswall.png
- Status: ✅ Fixed in overlay

### Branding Package
- Created: deftos-branding-1.0-1 (logo + wallpaper)
- Added to: [deftos] pacman repo
- Status: ✅ Built & pushed

### Kernel
- Using: deftos-kernel-cachyos-bore-7.2.10-1
- CONFIG_SCHED_BORE=y verified
- Fallback: linux-cachyos-lts
- Status: ✅ Installed

## Build Status
- ISO: deftos-build.iso (Run latest)
- Ready: ✅ for hardware test
- Pending: Snapper recovery tier test (await SSD NVMe)
