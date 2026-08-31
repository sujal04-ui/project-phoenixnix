# 🔥 Project PhoenixNix

## Samsung Galaxy S21 FE → Debian Homelab Server

**Project PhoenixNix** is an experiment in repurposing a Samsung Galaxy S21 FE 5G into a practical ARM64 Linux homelab server.

The project keeps Android as the host operating system and runs **Debian 13 (Trixie)** inside **Termux + PRoot-Distro**.

> **Current status:** 🟢 Working LAN server  
> **Bare-metal Linux:** Not installed  
> **Bootloader:** Not unlocked

---

## 📱 Hardware

| Component | Details |
|---|---|
| Device | Samsung Galaxy S21 FE 5G |
| Model | SM-G990B2/DS |
| SoC | Qualcomm Snapdragon 888 |
| Architecture | ARM64 / aarch64 |
| RAM visible to Debian | ~7.2 GiB |
| CPU cores visible | 6 |
| USB-C | Currently not working |

---

## 💻 Software Stack

- Android 16
- One UI 8.0
- Termux
- Termux:Boot
- Termux:Services
- PRoot-Distro
- Debian GNU/Linux 13 (Trixie)
- OpenSSH
- Nginx

### Architecture

```text
┌──────────────────────────────────────┐
│        Samsung Galaxy S21 FE         │
│          Android 16 / One UI 8       │
├──────────────────────────────────────┤
│                Termux                │
│        SSH / Services / Boot         │
├──────────────────────────────────────┤
│             PRoot-Distro             │
├──────────────────────────────────────┤
│            Debian 13 ARM64           │
│                                      │
│       Nginx :8080 / Applications    │
└──────────────────────────────────────┘
```

---

## 🚀 Current Services

| Service | Port | Status |
|---|---:|---|
| SSH | 8022 | 🟢 Working |
| SFTP | 8022 | 🟢 Working |
| Nginx | 8080 | 🟢 Working |
| Debian | — | 🟢 Working |
| Automatic SSH startup | — | 🟢 Working |

---

## 🌐 Network

During development, the S21 FE was connected to **another phone's hotspot**.

Example development address:

```text
10.124.197.28
```

Because hotspot addressing is normally DHCP-based, this IP should **not** be treated as permanent.

For production-like use, move the phone to a normal home router and use a **DHCP reservation**.

---

## 🔐 SSH

From Windows PowerShell:

```powershell
ssh -p 8022 u0_a339@PHONE_IP
```

Example:

```powershell
ssh -p 8022 u0_a339@10.124.197.28
```

After connecting, enter Debian:

```bash
proot-distro login debian
```

---

## 🌍 Nginx

Nginx runs on port `8080`.

Test inside Debian:

```bash
curl -I http://127.0.0.1:8080
```

Expected:

```text
HTTP/1.1 200 OK
```

Access from another LAN device:

```text
http://PHONE_IP:8080
```

---

## 📁 SFTP Storage

Current test storage:

```text
/srv/storage/
├── backups/
├── uploads/
└── test.txt
```

The Termux-side bridge is:

```text
~/homelab/storage
        ↓
Debian /srv/storage
```

SFTP example:

```powershell
sftp -P 8022 u0_a339@PHONE_IP
```

---

## 🧩 Challenges We Solved

### 1. OEM unlocking was missing

The device was running Android 16 / One UI 8.0 and the **OEM unlocking** option was not visible.

**Decision:** Do not attempt risky bootloader exploits or random firmware flashing.

**Solution:** Keep Android as the host and use Termux + PRoot-Distro.

---

### 2. `sv-enable sshd` failed

The service manager initially had no `SVDIR`.

**Solution:**

```bash
source $PREFIX/etc/profile.d/start-services.sh
```

Then:

```bash
sv-enable sshd
```

---

### 3. SSH service reported port 8022 already in use

A manually launched `sshd` was already running.

**Solution:**

```bash
pkill sshd
sv up sshd
sv status sshd
```

After that, `termux-services` controlled SSH.

---

### 4. Nginx could not bind to port 80

Error:

```text
bind() to 0.0.0.0:80 failed (13: Permission denied)
```

**Solution:** Use unprivileged port `8080`.

---

### 5. Nginx port 8080 was already in use

Nginx was already running, so starting a second instance failed.

**Solution:** Test/reload instead of starting another instance:

```bash
curl http://127.0.0.1:8080
nginx -s reload
```

---

### 6. PRoot-Distro storage path was different

The actual Debian rootfs was found at:

```text
$PREFIX/var/lib/proot-distro/containers/debian/rootfs
```

---

### 7. SFTP relative path failed

This:

```text
cd homelab/storage
```

did not resolve correctly.

Using the absolute path worked:

```text
cd /data/data/com.termux/files/home/homelab/storage
```

---

### 8. Wi-Fi security tooling limitation

Debian could see:

```text
wlan0
```

but:

```bash
iw dev
```

returned:

```text
Failed to connect to generic netlink.
```

Therefore the Android internal Wi-Fi interface is not exposed to Debian with the kernel control access normally required for monitor-mode tooling.

---

### 9. USB-C port is not working

This prevents adding:

- USB Ethernet
- USB SSD
- USB Wi-Fi adapter

These upgrades are deferred until the port is repaired.

---

## 🔧 Useful Commands

### Start Debian

```bash
proot-distro login debian
```

### Check Debian

```bash
cat /etc/os-release
uname -m
```

### SSH service

```bash
sv status sshd
sv up sshd
```

### Keep phone awake

```bash
termux-wake-lock
```

### Nginx

```bash
nginx -t
nginx -s reload
curl -I http://127.0.0.1:8080
```

### Windows SSH

```powershell
ssh -p 8022 u0_a339@PHONE_IP
```

### Windows SFTP

```powershell
sftp -P 8022 u0_a339@PHONE_IP
```

---

## 🛣️ Roadmap

### Phase 1 — Foundation
- [x] Termux
- [x] Debian 13 ARM64
- [x] SSH
- [x] Termux:Boot
- [x] Nginx
- [x] SFTP

### Phase 2 — Server Reliability
- [ ] Home router
- [ ] DHCP reservation
- [ ] Automatic Debian service startup
- [ ] Health monitoring
- [ ] Log management

### Phase 3 — Storage
- [ ] Repair USB-C
- [ ] USB-C OTG
- [ ] External SSD
- [ ] Automated backups

### Phase 4 — Applications
- [ ] Python
- [ ] Node.js
- [ ] Database
- [ ] Git deployment
- [ ] Personal web applications

### Phase 5 — Remote Access
- [ ] VPN
- [ ] Tailscale/WireGuard
- [ ] Secure remote administration
- [ ] No direct public SSH exposure

### Phase 6 — Security Lab
- [ ] USB Wi-Fi adapter
- [ ] Monitor-mode capable hardware
- [ ] Authorized Wi-Fi lab
- [ ] Airgorah evaluation

---

## ⚠️ Important Limitations

This is a **Linux userspace homelab**, not a bare-metal Linux phone.

Android still controls:

- Kernel
- Hardware drivers
- Power management
- Wi-Fi hardware
- USB hardware
- Thermal management

For a reliable 24/7 deployment, external storage, wired networking, power/thermal management and Android background restrictions should be addressed.

---

## 📚 Documentation

See:

`docs/S21_FE_Debian_Homelab_Server_Documentation.pdf`

for the complete step-by-step project history, including the challenges and fixes.

---

## 📜 License

This project documentation and scripts are provided for personal learning and experimentation.

Use security-testing tools only on systems and networks you own or have explicit permission to test.

---

## ⭐ Project

**Project PhoenixNix**

> *Reviving a smartphone as a Linux server.*
