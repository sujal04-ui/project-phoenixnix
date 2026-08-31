# Termux Setup

```bash
pkg update
pkg upgrade -y
pkg install proot-distro openssh coreutils iproute2 -y
```

Verify:

```bash
uname -m
getprop ro.product.model
getprop ro.build.version.release
```

Expected architecture:

```text
aarch64
```
