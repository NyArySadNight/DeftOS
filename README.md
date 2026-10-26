# DeftOS vs. Stock CachyOS — What Is Different

DeftOS starts from CachyOS and makes a set of deliberate changes. This document lists them so you can judge whether they fit your needs. Each point describes a real difference in the repository, not a benchmark claim.

## Differences

| Area | CachyOS (base) | DeftOS |
|---|---|---|
| Branding | CachyOS identity | DeftOS wallpaper, SDDM theme, colors, logo, `deftos-branding` package |
| Base packages | Broader default set | Trimmed: non-essential packages such as python, perl, and plymouth removed |
| Installer | Standard flow | Calamares flow without CPU/GPU selection screens |
| Mirrors | Stock configuration | Cleaned mirror list with fake entries removed and UTF-8 encoding fixed |
| Recovery | Standard boot options | Snapper integration with a first-boot init service, plus LTS kernel fallback in GRUB |

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
