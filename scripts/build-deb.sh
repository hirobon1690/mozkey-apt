#!/usr/bin/env bash
set -euo pipefail

source_dir=$(realpath "$1")
version=$2
output_dir=$(realpath -m "$3")
package=ibus-mozkey
architecture=$(dpkg --print-architecture)
dpkg --validate-version "$version"
test "$architecture" = amd64

workdir=$(mktemp -d)
trap 'rm -r -- "$workdir"' EXIT
cd "$workdir"
root="$workdir/package"
mkdir -p "$root/DEBIAN" "$output_dir" debian
unzip -q "$source_dir/src/bazel-bin/unix/mozc.zip" -d "$root"

binaries=(
  "$root/usr/lib/ibus-mozkey/ibus-engine-mozkey"
  "$root/usr/lib/mozkey/mozc_server"
  "$root/usr/lib/mozkey/mozc_renderer"
  "$root/usr/lib/mozkey/mozc_tool"
)
for binary in "${binaries[@]}"; do
  test -f "$binary"
  chmod 0755 "$binary"
done
test -f "$root/usr/share/ibus/component/mozkey.xml"

doc="$root/usr/share/doc/$package"
install -Dm644 "$source_dir/LICENSE" "$doc/copyright"
install -m644 "$source_dir"/{AUTHORS,THIRD_PARTY_NOTICES.md} "$doc/"
install -m644 "$source_dir/src/data/dictionary_oss/README.txt" "$doc/dictionary-notices.txt"
install -m644 "$source_dir/src/data/installer/credits_en.html" "$doc/"

cat > debian/control <<EOF
Source: $package
Section: utils
Priority: optional
Maintainer: Mozkey APT <58695125+hirobon1690@users.noreply.github.com>

Package: $package
Architecture: any
EOF
dependencies=$(dpkg-shlibdeps -O "${binaries[@]}")
dependencies=${dependencies#shlibs:Depends=}
test -n "$dependencies"
# Ubuntu 24.04 and Debian 13 use different names for these Qt libraries.
dependencies=$(sed -E \
  's/(libqt6(gui|widgets)6)t64( \([^)]+\))/\1t64\3 | \1\3/g' <<< "$dependencies")

cat > "$root/DEBIAN/control" <<EOF
Package: $package
Version: $version
Architecture: $architecture
Section: utils
Priority: optional
Maintainer: Mozkey APT <58695125+hirobon1690@users.noreply.github.com>
Depends: ibus, $dependencies
Conflicts: mozkey-local
Replaces: mozkey-local
Homepage: https://github.com/koyasi777/mozkey
Description: Mozkey Japanese input method for IBus
 Linux build of the tagged Mozkey source with the repository's sample dictionary profile.
EOF
dpkg-deb --root-owner-group --build "$root" "$output_dir/${package}_${version}_${architecture}.deb"
