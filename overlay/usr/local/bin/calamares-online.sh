#!/bin/bash
# Launcher cho DeftOS Installer (goi tu DeftOS Hello va autostart).
# Ghi log ngay tu dong dau de loi nao cung de lai dau vet.

LOG=/home/liveuser/cachy-install.log
mode="online"

exec >>"$LOG" 2>&1
echo "########## $(basename "$0") started (UTC): $(date -u '+%x %X') as $(id -un) uid=$(id -u)"
echo "########## DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"

# Chi cho chay 1 ban: autostart va nut Hello cung goi script nay, 2 ban cung luc se tranh khoa pacman / xoa gnupg cua nhau
exec 9>/tmp/deftos-installer.lock
if ! flock -n 9; then
    echo "########## Installer da dang chay (khoa /tmp/deftos-installer.lock), bo qua lan goi nay"
    command -v notify-send >/dev/null && notify-send "DeftOS Installer" "Installer dang khoi dong, vui long cho trong giay lat."
    exit 0
fi

notify_fail() {
    echo "########## FAIL: $1"
    command -v notify-send >/dev/null && notify-send -u critical "DeftOS Installer" "$1 - xem log: $LOG"
}

# Lam moi keyring nhung KHONG de no lam treo/chet installer (can mang, co the cham trong VM)
refresh_keyring() {
    sudo rm -rf /etc/pacman.d/gnupg
    timeout 180 sudo pacman -Sy --noconfirm archlinux-keyring cachyos-keyring || echo "WARN: pacman -Sy keyring failed/timeout"
    timeout 180 sudo pacman-key --init || echo "WARN: pacman-key --init failed/timeout"
    timeout 180 sudo pacman-key --populate archlinux cachyos || echo "WARN: pacman-key --populate failed/timeout"
    sudo timedatectl set-ntp true || echo "WARN: timedatectl failed"
}

main() {
    refresh_keyring

    local SYSTEM
    if [ -d /sys/firmware/efi ]; then SYSTEM="UEFI SYSTEM"; else SYSTEM="BIOS/MBR SYSTEM"; fi
    echo "########## ISO version: $(cat /etc/version-tag 2>/dev/null)"
    echo "########## System: $SYSTEM"
    command -v inxi >/dev/null && inxi -F

    if [ ! -f "/usr/share/calamares/settings_${mode}.conf" ]; then
        notify_fail "Thieu /usr/share/calamares/settings_${mode}.conf"
        return 1
    fi
    sudo cp "/usr/share/calamares/settings_${mode}.conf" /etc/calamares/settings.conf || { notify_fail "Khong copy duoc settings.conf"; return 1; }

    command -v pkexec-wrapper >/dev/null || { notify_fail "Thieu pkexec-wrapper"; return 1; }
    pkexec-wrapper calamares -D6
    local rc=$?
    echo "########## calamares exited with code $rc"
    [ $rc -ne 0 ] && notify_fail "Calamares thoat voi ma loi $rc"
    return $rc
}

main "$@"
