#!/usr/bin/env python3
import sys
target, patch = sys.argv[1], sys.argv[2]
data = bytearray(open(target, 'rb').read())
n = 0
for line in open(patch):
    if line.startswith('#') or not line.strip():
        continue
    off, old, new = line.split()
    off = int(off, 16); old = bytes.fromhex(old); new = bytes.fromhex(new)
    if bytes(data[off:off + len(old)]) != old:
        sys.exit("KHONG KHOP tai offset %x: file khong phai ban goc 260809" % off)
    data[off:off + len(new)] = new
    n += 1
open(target, 'wb').write(data)
print("da ap dung %d doan vao %s" % (n, target))
