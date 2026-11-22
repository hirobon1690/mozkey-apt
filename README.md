# mozkey-apt
## About
Unofficial [Mozkey](https://github.com/koyasi777/mozkey) apt repository.

## Requirements
- Ubuntu 24.04 or later
- Debian 13 or later

## Install
Add the APT source with its embedded signing key:
```sh
sudo curl -fsSLo /etc/apt/sources.list.d/mozkey.sources https://raw.githubusercontent.com/hirobon1690/mozkey-apt/main/mozkey.sources
```

Install:
```sh
sudo apt update
sudo apt install ibus-mozkey
```

## Disclaimer
- 100% vibe-coded, as-is
