# DeftOS vs. Stock CachyOS — What Is Different

DeftOS starts from the CachyOS live ISO and makes a set of deliberate changes. This document lists them so you can judge whether they fit your needs. Each point describes a real difference in the repository, not a benchmark claim.

## How the ISO is built

`build.sh` takes the CachyOS base ISO, unpacks its live filesystem (`airootfs.sfs`), copies in the `overlay/` tree, and repacks it. The GitHub Actions workflow runs this on every push to `main`. Changes in `overlay/` therefore affect the live session. Changes in `overlay/etc/calamares/modules/pacstrap.conf` affect only the system installed to disk.

## Differences

| Area | CachyOS (base) | DeftOS |
|---|---|---|
| Branding | CachyOS identity | DeftOS wallpaper, logo, colors, SDDM theme, `deftos-branding` package files |
| Base packages | Broader default set | Trimmed: non-essential packages such as python, perl, and plymouth removed |
| Installer | Standard flow with CPU, GPU, desktop and netinstall pages | Calamares sequence in `overlay/usr/share/calamares/settings_online.conf`: welcome, locale, keyboard, partition, users, summary. No CPU, GPU, bootloader, desktop or netinstall pages |
| Kernel | CachyOS kernel set | Installs `linux-cachyos-bore` and `linux-cachyos-lts` (with headers). GRUB boots `/boot/vmlinuz-linux-cachyos-bore` by default |
| Mirrors | Stock configuration | Cleaned mirror list with fake entries removed and UTF-8 encoding fixed |
| Recovery | Standard boot options | Snapper integration with a first-boot init service, plus LTS kernel fallback in GRUB |

The CachyOS installer was used only as a reference for the module pipeline. Its sequence is not applied to DeftOS.

## Known issues

- The live installer launcher (`overlay/usr/local/bin/calamares-online.sh`) can exit with code 1 right after it starts. The cause is not yet confirmed. The launcher writes its log to `/home/liveuser/cachy-install.log` in the live session.
- `packagechooser_*.conf` module configs are not in this repository. They come from the CachyOS base ISO, so they can change without notice.
- `pkg/deftos-branding/` holds older copies of some module configs. `build.sh` does not use them.
- `apply-branding.sh` copies `/etc/pacman.conf` into the installed system. That file no longer contains a `[deftos]` repository, so any package that only exists in that repository will fail to install.

## What stays the same

DeftOS keeps the CachyOS foundation: Arch Linux packaging, CachyOS optimization hooks, and the kernel tuning approach. Software compatibility with Arch repositories is unchanged.

## Who should choose DeftOS

- Users who want a branded KDE Plasma 6 system with fewer preinstalled packages.
- Users who want a simpler installer and snapshot-based rollback set up out of the box.

## Who should choose stock CachyOS

- Users who need the full default package set or want to keep the upstream branding.
- Users who prefer to configure drivers and packages manually from the start.

---

Repository: https://github.com/NyArySadNight/DeftOS
