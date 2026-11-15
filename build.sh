#!/bin/zsh
set -euo pipefail
# Run from the project folder: ./build.sh [folder] (default: current folder)

APP=${1:-.}/SilentStudio.app
BIN=$APP/Contents/MacOS
HELPER=$BIN/SilentStudio

# Fresh bundle. The old helper is root-owned, but it sits in a folder you own, so rm can delete it.
rm -rf "$APP"
mkdir -p "$BIN" "$APP/Contents/Resources"

# Build both binaries straight into the bundle.
# The menu app runs the helper from its own folder (Contents/MacOS).
swiftc -O SilentStudio.swift IOServiceConnection.swift -o "$HELPER"
swiftc -O SilentStudioMenuApp.swift IOServiceConnection.swift -o "$BIN/SilentStudioMenu"

cp Info.plist "$APP/Contents/"
cp "/System/Library/CoreServices/Automator Application Stub.app/Contents/Resources/ApplicationStub.icns" "$APP/Contents/Resources/"

# Sign the helper first, then the app.
codesign --force -s - "$HELPER"
codesign --force -s - "$APP"

# Make the helper setuid root last: chown clears the setuid bit, and once the file
# belongs to root, nothing later in the script could write to it.
sudo chown root "$HELPER"
sudo chmod +s "$HELPER"