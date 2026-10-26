# DeftOS — Feature Highlights

DeftOS is a Linux distribution with a clean KDE Plasma 6 desktop, a performance-tuned kernel, and a simplified installation experience. Below is a closer look at what you actually get.

## KDE Plasma 6

DeftOS uses KDE Plasma 6, the current generation of the Plasma desktop. It offers a responsive interface, fine-grained customization of panels, widgets, and window behavior, and a consistent look that matches the DeftOS theme out of the box.

## Linux 7.2.10 kernel

The kernel is version 7.2.10, configured for responsiveness and throughput. Users who prefer stability can select the LTS kernel from the GRUB menu at any time.

## A minimal base system

Many distributions ship with a large set of preinstalled tools. DeftOS deliberately keeps the base small. Packages that are not essential to a working desktop were removed, which means a smaller installation, fewer background services, and less to update.

## A simpler installer

The Calamares installer asks only what matters: timezone, keyboard layout, disk partitioning, and user credentials. There are no CPU or GPU selection screens. Drivers and the rest of the system are set up automatically during installation.

## Snapshots and rollback

Snapper creates filesystem snapshots, so a broken update or a misconfigured change can be undone with a single command:

```
snapper list
snapper undochange <pre> <post>
```

## Recovery options

If the system fails to boot after a kernel update, choose the Linux LTS entry in GRUB. If the installed system is unbootable, boot an Arch live ISO, mount the root filesystem, and use `arch-chroot` to repair it.

## Consistent branding

Wallpaper, SDDM theme, system colors, and the logo ship together in the `deftos-branding` package. The installer applies the same branding, so the look is consistent from installation through daily use.

---

Repository: https://github.com/NyArySadNight/DeftOS
