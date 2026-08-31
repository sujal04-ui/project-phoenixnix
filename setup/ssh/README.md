# SSH Setup

Install OpenSSH in Termux:

```bash
pkg install openssh -y
passwd
```

Enable Termux services:

```bash
source $PREFIX/etc/profile.d/start-services.sh
sv-enable sshd
sv status sshd
```

If an older manually started sshd occupies port 8022:

```bash
pkill sshd
sv up sshd
```

Windows:

```powershell
ssh -p 8022 u0_a339@PHONE_IP
```
