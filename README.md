# DeftOS

DeftOS là bản ISO dựng trên CachyOS Desktop 260809, với thương hiệu, installer (Calamares) và cấu hình được thay đổi.

Repo này chỉ chứa **mã nguồn build**. ISO kết quả không nằm trong repo.

## Trạng thái

- Phiên bản: v8.3 (snapshot nguồn đầu tiên)
- Đã cài và boot thành công trên máy thật (theo ghi nhận của tác giả).
- Chưa xác minh: build lại từ repo này ra ISO tương đương v8.3. Xem mục Kiểm chứng.

## Yêu cầu

- Linux (Arch / CachyOS), chạy được trong WSL2 nếu có đủ quyền sudo và loop mount
- Gói: `archiso`, `squashfs-tools`, `xorriso`, `rsync`, `python`
- ISO gốc `cachyos-desktop-linux-260809.iso`
  - SHA256: `959f6577f45e25ee9fd8c220fd221b08e4ea79412c7315c0f922dd6d86d5e33c`
- Cần `sudo` (build mount và chroot)

## Cấu trúc

```
DeftOS/
├── build.sh                 # Script build chính
├── deftos-build.yaml        # Cấu hình build (SHA256, mức nén)
├── changed-files.txt        # Danh sách file thay đổi so với gốc
├── overlay/                 # File chép đè vào rootfs, giữ đúng đường dẫn
│   ├── etc/                 # cấu hình hệ thống, Calamares, skel, systemd
│   ├── home/liveuser/       # cấu hình người dùng live
│   └── usr/                 # script, branding, hook, service
├── iso-overlay/             # Menu boot GRUB và syslinux
├── patches/                 # Vá nhị phân cachyos-hello, cachyos-installer
│   └── apply_bpatch.py
└── pkg/deftos-branding/     # PKGBUILD đóng gói thương hiệu
```

## Luồng build (tổng quan)

```
  ISO CachyOS 260809 gốc
           │
           ▼
   ┌──────────────────┐
   │ kiểm tra SHA256  │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐        ┌──────────────────┐
   │ giải nén         │───────▶│ patches/         │
   │ airootfs.sfs     │        │ apply_bpatch.py  │
   └────────┬─────────┘        └────────┬─────────┘
            ▼                           │
   ┌──────────────────┐◀───────────────┘
   │ chép overlay/    │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ chép iso-overlay/│
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ nén lại squashfs │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ xorriso → ISO    │
   │ deftos-build.iso │
   └──────────────────┘
```

Sơ đồ mô tả thứ tự chung. Chi tiết đúng theo `build.sh`.

## Cách build

```bash
cd DeftOS
./build.sh /đường/dẫn/tới/cachyos-desktop-linux-260809.iso
```

Kết quả: `deftos-build.iso` trong thư mục hiện tại. File này bị `.gitignore` loại khỏi repo.

Lưu ý:
- File đích phải chưa tồn tại (xorriso không ghi đè).
- Trước khi build, kiểm tra không còn mount nào trong `work/` (`mount | grep work`).

## Kiểm chứng

Build được coi là đúng khi:
1. SHA256 của ISO gốc khớp.
2. `build.sh` chạy hết không lỗi.
3. ISO mới boot được trong VirtualBox.
4. `/etc/os-release` và `/etc/xdg/fastfetch/deftos_logo.txt` trên hệ thống live khớp với `overlay/`.

Chưa xác minh:
- Snapshot snapper tự tạo khi cài (`deftos-snapper-init.service`).
- Rollback từ snapshot và kernel LTS.
- Hook `95-bootbackup` (đề xuất đổi sang `rsync -ax`).
- Chuỗi "CachyOS Kernels" còn sót trong slideshow của installer.

## Ghi chú

- Hai symlink trong `overlay/etc/systemd/system/` trỏ tới đường dẫn tuyệt đối, chỉ đúng khi chạy trên hệ thống đã cài.
- Repo này không phải bản fork đầy đủ của CachyOS. Khi CachyOS gốc thay đổi, cần kiểm tra lại `patches/`.

## Giấy phép

Chưa xác định. Thành phần từ CachyOS và Arch giữ giấy phép gốc của chúng.
