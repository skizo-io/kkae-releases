#!/bin/bash
# Public installer only. The application source is not included.
set -euo pipefail
export PATH='/usr/bin:/bin:/usr/sbin:/sbin'
[[ "$(uname -s)" == Darwin ]] || { echo 'Kkae requires macOS.' >&2; exit 1; }
[[ $(sw_vers -productVersion | cut -d. -f1) -ge 13 ]] || { echo 'Kkae requires macOS 13 or newer.' >&2; exit 1; }
[[ $(id -u) -ne 0 ]] || { echo 'Run this as your user, not with sudo.' >&2; exit 1; }
case "${1:-}" in ''|--check) ;; *) echo 'Usage: bash install.sh [--check]' >&2; exit 2 ;; esac
version='0.5.13'
expected='1fcfca4944ac1b931fd4f87625b31a2355cec79b3b299ffdc40b9fb02eab92a1'
work=$(mktemp -d "${TMPDIR:-/tmp}/kkae-download.XXXXXX")
cleanup() {
  case "$work" in
    "${TMPDIR:-/tmp}"/kkae-download.*) [[ ! -L "$work" ]] && /bin/rm -rf -- "$work" ;;
  esac
}
trap cleanup EXIT
archive="$work/Kkae-$version.zip"
echo "Downloading Kkae $version..."
curl --fail --location --silent --show-error --proto '=https' --proto-redir '=https' \
  "https://github.com/skizo-io/kkae-releases/releases/download/v$version/Kkae-$version.zip" -o "$archive"
actual=$(shasum -a 256 "$archive")
[[ "${actual%% *}" == "$expected" ]] || { echo 'Checksum mismatch. Nothing was installed.' >&2; exit 1; }
mkdir "$work/extracted"
ditto -x -k "$archive" "$work/extracted"
app="$work/extracted/Kkae.app"
[[ -d "$app" && ! -L "$app" ]]
codesign --verify --deep --strict -R '=anchor apple generic and certificate leaf[subject.OU] = "J9WMZ4G9PY" and identifier "io.skizo.sbox.kkae"' "$app"
spctl --assess --type execute "$app"
echo 'Checksum, Developer ID signature and Gatekeeper verified.'
if [[ "${1:-}" == --check ]]; then
  echo 'Check only. No app was installed or launched.'
  exit 0
fi
if pgrep -x Kkae >/dev/null; then
  echo 'Quit the running Kkae app first, then run this command again.' >&2
  exit 1
fi
parent="$HOME/Applications"
destination="$parent/Kkae.app"
mkdir -p "$parent"
if [[ -e "$destination" || -L "$destination" ]]; then
  [[ -d "$destination" && ! -L "$destination" ]] || { echo 'Unexpected destination. Nothing was replaced.' >&2; exit 1; }
  [[ "$(plutil -extract CFBundleIdentifier raw "$destination/Contents/Info.plist")" == io.skizo.sbox.kkae ]] || { echo 'This is a different app. Nothing was replaced.' >&2; exit 1; }
fi
stage=$(mktemp -d "$parent/.kkae-install.XXXXXX")
ditto "$app" "$stage/Kkae.app"
codesign --verify --deep --strict "$stage/Kkae.app"
backup=''
if [[ -d "$destination" ]]; then
  backups="$HOME/Library/Application Support/Kkae/Install Backups"
  mkdir -p "$backups"
  backup=$(mktemp -d "$backups/previous.XXXXXX")
  mv "$destination" "$backup/Kkae.app"
fi
if ! mv "$stage/Kkae.app" "$destination"; then
  [[ -z "$backup" ]] || mv "$backup/Kkae.app" "$destination"
  echo 'Installation failed; previous app restored.' >&2
  exit 1
fi
rmdir "$stage"
open "$destination"
echo "Installed: $destination"
[[ -z "$backup" ]] || echo "Previous app preserved: $backup/Kkae.app"
