#!/usr/bin/env bash
set -euo pipefail

cd "$1"
packages=(pool/*.deb)
test "${#packages[@]}" -eq 1
test "$(dpkg-deb -f "${packages[0]}" Package)" = ibus-mozkey
test "$(dpkg-deb -f "${packages[0]}" Architecture)" = amd64
dpkg-deb -f "${packages[0]}" Version > version.txt

export GNUPGHOME
GNUPGHOME=$(mktemp -d)
trap 'gpgconf --kill all; rm -r -- "$GNUPGHOME"' EXIT
printf '%s' "${APT_SIGNING_KEY:?APT_SIGNING_KEY is required}" | gpg --batch --import
unset APT_SIGNING_KEY
fingerprint=$(gpg --batch --with-colons --list-secret-keys | awk -F: '/^sec:/ {primary=1; next} primary && /^fpr:/ {print $10; primary=0}')
[[ "$fingerprint" =~ ^[A-F0-9]{40}$ ]]

apt-ftparchive packages pool > Packages
gzip -n -9 < Packages > Packages.gz
apt-ftparchive -o APT::FTPArchive::Release::Origin='Mozkey APT' \
  -o APT::FTPArchive::Release::Label='Mozkey APT' \
  -o APT::FTPArchive::Release::Architectures=amd64 release . > Release.tmp
mv Release.tmp Release
gpg --batch --local-user "$fingerprint" --digest-algo SHA256 --clearsign --output InRelease Release
gpg --batch --local-user "$fingerprint" --export > mozkey-archive-keyring.gpg
printf '%s\n' "$fingerprint" > fingerprint.txt
