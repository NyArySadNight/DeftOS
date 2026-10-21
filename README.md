# DeftOS

Custom Linux distribution based on CachyOS KDE with BORE kernel and easy recovery.

## Features

- **BORE Kernel** (7.2.10): Better responsiveness
- **Btrfs + Snapper**: Auto-snapshots, easy rollback
- **Recovery Tiers**: Old kernel boot, LTS fallback, snapshot recovery
- **DeftOS Branding**: Custom logo, wallpaper, Plasma theme
- **Minimal Setup**: No preconfig (add your own)

## Installation

1. Boot `deftos-build.iso`
2. Calamares opens → Select GRUB, Btrfs, defaults
3. Reboot → Done

## Recovery

```bash
# Old kernel: GRUB menu → DeftOS (oldkernels)
# Snapshot rollback:
sudo snapper list
sudo snapper rollback <number>
reboot
```

## System Info

- Kernel: deftos-kernel-cachyos-bore-7.2.10-1
- Base: CachyOS Arch
- Repo: [deftos] for kernel updates
