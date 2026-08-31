# Debian 13 Setup

Install:

```bash
proot-distro install debian
proot-distro login debian
```

Update:

```bash
apt update
apt full-upgrade -y
```

Basic packages:

```bash
apt install -y sudo nano curl wget git htop iproute2 net-tools ca-certificates procps
```
