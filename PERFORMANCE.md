# DeftOS v8.3+ - Build Changes Log

## Fixes Applied

### Wallpaper
- Issue: Plasma showed CachyOS wallpaper instead of DeftOS
- Fix: Updated plasma-org.kde.plasma.desktop-appletsrc Image= path to deftoswall.png
- Status: ✅ Fixed in overlay

### Branding Package (outdated)
- The `deftos-branding` package and the `[deftos]` repo no longer exist. Branding is now copied from `overlay/` by `build.sh` and `apply-branding.sh`.
- The old `pkg/` folder was removed.

### Kernel (current)
- Only `linux-cachyos-bore` (with headers) is installed. The `deftos-kernel-*` package and the LTS fallback were removed.
- To add kernels later, edit `base_packages` in `overlay/usr/lib/calamares/modules/pacstrap/main.py`.

## Build Status
- ISO: deftos-build.iso (Run latest)
- Ready: ✅ for hardware test
- Pending: Snapper recovery tier test (await SSD NVMe)
