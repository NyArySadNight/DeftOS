#!/usr/bin/bash
# Re-apply DeftOS identity files if a package replaced them. Never fails a transaction.
ROOT="${DEFTOS_ROOT:-}"
SRC="$ROOT/usr/share/deftos/branding"

restore() {  # <name-in-SRC> <destination> <mode>
  if ! cmp -s "$SRC/$1" "$ROOT$2"; then
    install -Dm"$3" "$SRC/$1" "$ROOT$2" && echo "deftos-branding: restored $2"
  fi
}

restore os-release  /usr/lib/os-release 644
restore lsb-release /etc/lsb-release    644
restore issue       /etc/issue          644
restore issue.net   /etc/issue.net      644

# /etc/os-release must remain a relative symlink to /usr/lib/os-release
if [[ "$(readlink "$ROOT/etc/os-release" 2>/dev/null)" != "../usr/lib/os-release" ]]; then
  ln -sfn ../usr/lib/os-release "$ROOT/etc/os-release" && echo "deftos-branding: relinked /etc/os-release"
fi
exit 0
