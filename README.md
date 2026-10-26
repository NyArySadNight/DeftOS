# DeftOS — Technical Overview for Developers

DeftOS is an overlay-based remaster of a CachyOS ISO. Customizations live in a single `overlay/` tree, which is copied into the target system during installation. The build runs in CI, so contributors can change the distribution without maintaining a full fork of the base.

## Architecture

- **`overlay/`**: all customizations, mirroring the target filesystem (`/etc`, `/usr`, `/home`). Files here are applied during installation.
- **`iso-overlay/`**: boot configuration for GRUB and syslinux.
- **`pkg/deftos-branding/`**: PKGBUILD for the branding package, which ships the wallpaper, logo, and theme assets.
- **`patches/`**: kernel and optimization patches, applied via `apply_bpatch.py`.
- **`.github/workflows/`**: CI pipeline that builds the ISO when changes are merged to `main`.

## Installer

The installer is Calamares, configured under `overlay/etc/calamares/` with per-module files for partitioning, bootloader, pacstrap, and welcome screens. A custom pacstrap module lives at `overlay/usr/lib/calamares/modules/pacstrap/main.py`, and branding is applied by `overlay/usr/libexec/deftos/apply-branding.sh`.

## Recovery and snapshots

Snapper is initialized at first boot through `deftos-snapper-init.service`, backed by `overlay/usr/lib/deftos/snapper-init.sh`. The service is enabled in `multi-user.target`. Rollback uses standard `snapper` commands, and an LTS kernel remains available in GRUB.

## Build requirements

- Linux host
- Arch build tooling: `mkinitcpio`, `archiso`
- Calamares for installer testing

## Contribution workflow

1. Branch from `main` using a `feature/...` name.
2. Make changes under `overlay/` or `pkg/`.
3. Open a pull request. The maintainer reviews and merges.
4. CI builds the ISO on merge.

Direct pushes to `main` are not part of the workflow.

---

Repository: https://github.com/NyArySadNight/DeftOS
