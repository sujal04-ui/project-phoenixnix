# Nginx Setup

Install inside Debian:

```bash
apt update
apt install nginx -y
```

Use port 8080 instead of privileged port 80:

```bash
sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-available/default
sed -i 's/listen \[::\]:80 default_server;/listen [::]:8080 default_server;/' /etc/nginx/sites-available/default
```

Test:

```bash
nginx -t
```

Start/reload:

```bash
nginx
nginx -s reload
```

Test:

```bash
curl -I http://127.0.0.1:8080
```
