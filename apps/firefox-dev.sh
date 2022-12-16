#!/usr/bin/env bash

TMP="/tmp/firefox-dev"
ARCHIVE="$TMP/firefox-dev.tar.bz2"
INSTALL_DIR="$HOME/.local/apps/firefox-dev"

mkdir -p "$TMP"
mkdir -p "$INSTALL_DIR"

cd "$TMP" || exit 1 
echo "Temp dir: $TMP"

echo "Download firefox-dev archive"
curl -L -o "$ARCHIVE" \
    "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"

echo "Extract and move to $INSTALL_DIR"
tar xf "$ARCHIVE"
mv firefox/* "$INSTALL_DIR"

echo "Creating desktop entry"
cat > "$HOME/.local/share/applications/firefox-developer.desktop" <<EOL
[Desktop Entry]
Name=Firefox Developer
Exec=$INSTALL_DIR/firefox
Comment=The firefox developer browser
Terminal=false
Icon=$INSTALL_DIR/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;
EOL
