# DeftOS

DeftOS is a custom ISO built on CachyOS Desktop 260809, with rebranded identity, a modified installer (Calamares), and changed configuration.

This repository contains **build source only**. The resulting ISO is not included.

## Status

- Version: v8.3 (first source snapshot)
- Installed and booted successfully on real hardware (per the author).
- Not yet verified: rebuilding this repository produces an ISO equivalent to v8.3. See Verification below.

## Requirements

- Linux (Arch / CachyOS). Should also work in WSL2 with sudo and loop mounts available.
- Packages: `archiso`, `squashfs-tools`, `xorriso`, `rsync`, `python`
- Base ISO `cachyos-desktop-linux-260809.iso`
  - SHA256: `959f6577f45e25ee9fd8c220fd221b08e4ea79412c7315c0f922dd6d86d5e33c`
- `sudo` is required (the build mounts filesystems and uses chroot).

## Layout

```
DeftOS/
├── build.sh                 # Main build script
├── deftos-build.yaml        # Build config (SHA256, compression level)
├── changed-files.txt        # List of files changed from upstream
├── overlay/                 # Files copied over the rootfs, keeping original paths
│   ├── etc/                 # System config, Calamares, skel, systemd
│   ├── home/liveuser/       # Live user config
│   └── usr/                 # Scripts, branding, hooks, services
├── iso-overlay/             # GRUB and syslinux boot menus
├── patches/                 # Binary patches for cachyos-hello and cachyos-installer
│   └── apply_bpatch.py
└── pkg/deftos-branding/     # PKGBUILD for the branding package
```

## Build flow (overview)

```
  CachyOS 260809 base ISO
           │
           ▼
   ┌──────────────────┐
   │ verify SHA256    │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐        ┌──────────────────┐
   │ extract          │───────▶│ patches/         │
   │ airootfs.sfs     │        │ apply_bpatch.py  │
   └────────┬─────────┘        └────────┬─────────┘
            ▼                           │
   ┌──────────────────┐◀───────────────┘
   │ copy overlay/    │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ copy iso-overlay/│
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ recompress       │
   │ squashfs         │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ xorriso → ISO    │
   │ deftos-build.iso │
   └──────────────────┘
```

This diagram shows the general order. The exact steps are defined in `build.sh`.

## How to build

```bash
cd DeftOS
./build.sh /path/to/cachyos-desktop-linux-260809.iso
```

Output: `deftos-build.iso` in the current directory. This file is excluded from the repository by `.gitignore`.

Notes:
- The output file must not already exist (xorriso does not overwrite).
- Before building, make sure nothing is still mounted under `work/` (`mount | grep work`).

## Verification

A build is considered correct when:
1. The base ISO SHA256 matches.
2. `build.sh` completes without errors.
3. The new ISO boots in VirtualBox.
4. `/etc/os-release` and `/etc/xdg/fastfetch/deftos_logo.txt` on the live system match `overlay/`.

Not yet verified:
- Snapper snapshot creation at install time (`deftos-snapper-init.service`).
- Rollback from snapshot and to the LTS kernel.
- The `95-bootbackup` hook (planned change: switch to `rsync -ax`).
- Leftover "CachyOS Kernels" text in the installer slideshow.
- `btrfs-scrub@-.timer` is no longer shipped as a symlink; it must be enabled during installation (see `build.sh` / installer postinstall).

## Notes

- `overlay/etc/systemd/system/multi-user.target.wants/deftos-snapper-init.service` is a regular file copy of the unit in `overlay/usr/lib/systemd/system/`. Symlinks are avoided so the repository can be checked out on Windows.
- This is not a full fork of CachyOS. When upstream CachyOS changes, re-check `patches/`.

## License

Not yet determined. Components from CachyOS and Arch keep their original licenses.
