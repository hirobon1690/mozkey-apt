# Mozkey APT
## About
Unofficial [Mozkey](https://github.com/koyasi777/mozkey) apt repository.

## Requirements
- Ubuntu 24.04 or later
- Debian 13 or later

## Install
Add repository and gpg key:
```sh
base=https://hirobon1690.github.io/mozkey-apt
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL "$base/mozkey-archive-keyring.gpg" -o /tmp/mozkey-archive-keyring.gpg
gpg --show-keys --with-fingerprint /tmp/mozkey-archive-keyring.gpg
sudo install -m 0644 /tmp/mozkey-archive-keyring.gpg /etc/apt/keyrings/mozkey-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mozkey-archive-keyring.gpg] $base/ ./" |
sudo tee /etc/apt/sources.list.d/mozkey.list >/dev/null
```

Install:
```sh
sudo apt update
sudo apt install ibus-mozkey
```
