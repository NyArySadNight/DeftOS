#!/usr/bin/env python3
"""Kiem tra tinh settings*.conf cua Calamares tren cay file da gop (ISO goc + overlay).
Dung: check-calamares.py <rootfs> <settings.conf> [...]"""
import os, re, sys
import yaml

root = sys.argv[1]
bad = 0

def P(*a):  # duong dan trong rootfs
    return os.path.join(root, *a)

def find_conf(name):
    for d in ("etc/calamares/modules", "usr/share/calamares/modules"):
        if os.path.exists(P(d, name)):
            return d + "/" + name
    return None

def report(level, msg):
    global bad
    if level == "FAIL":
        bad += 1
    print(f"  [{level}] {msg}")

for sp in sys.argv[2:]:
    print(f"\n##### {sp}")
    s = yaml.safe_load(open(P(sp)))
    inst = {}
    for i in s.get("instances", []) or []:
        inst[(i["module"], i["id"])] = i
    br = s.get("branding")
    bd = P("usr/share/calamares/branding", str(br), "branding.desc")
    report("OK" if os.path.exists(bd) else "FAIL", f"branding '{br}' -> {bd[len(root):]}")
    for stage in s.get("sequence", []):
        for kind, items in stage.items():
            for it in items:
                name, _, iid = it.partition("@")
                md = P("usr/lib/calamares/modules", name)
                if not os.path.isdir(md):
                    report("FAIL", f"{kind}: module '{it}' khong co thu muc usr/lib/calamares/modules/{name}")
                    continue
                if iid:
                    i = inst.get((name, iid))
                    if i is None:
                        report("FAIL", f"{kind}: '{it}' khong co trong instances")
                        continue
                    cfg = i.get("config")
                    if cfg and not find_conf(cfg):
                        report("FAIL", f"{kind}: '{it}' thieu file config '{cfg}'")
                        continue
                    cfgname = cfg
                else:
                    cfgname = name + ".conf"
                    if not find_conf(cfgname):
                        report("WARN", f"{kind}: '{it}' khong co {cfgname} (dung mac dinh neu module khong can)")
                        continue
                # shellprocess: kiem tra script tro toi file ton tai
                if name == "shellprocess" and cfgname:
                    c = find_conf(cfgname)
                    txt = open(P(c)).read()
                    for m in re.findall(r'(/(?:usr|etc|opt)/[\w./@-]+)', txt):
                        if m.startswith("/usr/bin") or m.startswith("/etc/calamares"):
                            continue
                        if not os.path.exists(P(m.lstrip("/"))):
                            report("WARN", f"{it}: script tham chieu {m} (khong thay trong cay da trich)")
    print("  ... xong")

print(f"\nTONG: {bad} loi FAIL")
sys.exit(1 if bad else 0)
