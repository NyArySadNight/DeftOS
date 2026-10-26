# DeftOS — Overview

DeftOS is an Arch Linux–based distribution built on top of CachyOS. It pairs the KDE Plasma 6 desktop with a lean base system, a tuned Linux 7.2.10 kernel, and a Calamares graphical installer, all wrapped in DeftOS branding.

## What it is

DeftOS is a custom ISO remaster. It takes the CachyOS foundation, which already carries performance-oriented Arch packaging and kernel tuning, and removes what it does not need, then adds its own identity, installer flow, and recovery tooling. The result is a distribution meant to feel fast and uncluttered from the first boot.

## Core strengths

- **Lean by default.** The base system ships only essential packages. Python, Perl, and Plymouth, among others, were removed to shrink the image and reduce what is running out of the box.
- **Modern desktop.** KDE Plasma 6 provides a current, responsive desktop environment with extensive configurability.
- **Tuned kernel.** The Linux 7.2.10 kernel is configured for low latency and good throughput.
- **Streamlined installation.** The Calamares installer walks users through timezone, keyboard, partitioning, and account setup, and it does not present CPU or GPU selection screens.
- **Built-in safety net.** Snapper snapshots let users roll back a bad change, and an LTS kernel is available in the boot menu as a fallback if a new kernel fails to start.
- **Coherent branding.** The DeftOS wallpaper, SDDM theme, system colors, and logo are packaged together in a `deftos-branding` pacman package.

## Who it is for

DeftOS suits users who want a fast, modern Plasma desktop without a heavily loaded default install, and who value a recovery path when updates go wrong.

---

Repository: https://github.com/NyArySadNight/DeftOS
