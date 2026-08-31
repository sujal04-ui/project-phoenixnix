# SFTP Storage

Create Debian storage:

```bash
mkdir -p /srv/storage/uploads
mkdir -p /srv/storage/backups
echo "S21 FE Homelab Storage" > /srv/storage/test.txt
```

The PRoot rootfs used in this project is:

```text
$PREFIX/var/lib/proot-distro/containers/debian/rootfs
```

SFTP from Windows:

```powershell
sftp -P 8022 u0_a339@PHONE_IP
```

The tested absolute storage path was:

```text
/data/data/com.termux/files/home/homelab/storage
```
