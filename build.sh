#!/bin/zsh
set -euo pipefail

PROJECT_DIR="${0:A:h}"
APP_DIR="$PROJECT_DIR/MacBook Duo.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
BUILD_CACHE="$PROJECT_DIR/.build-cache"

if [[ -z "${DEVELOPER_DIR:-}" ]] && [[ -d "/Applications/Xcode.app/Contents/Developer" ]]; then
  export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

mkdir -p "$MACOS_DIR"
mkdir -p "$CONTENTS_DIR/Resources"
mkdir -p "$BUILD_CACHE"
cp "$PROJECT_DIR/Assets/MacBookDuo.icns" "$CONTENTS_DIR/Resources/"
cp "$PROJECT_DIR/Assets/MacBookDuo.png" "$CONTENTS_DIR/Resources/"
cp "$PROJECT_DIR/Info.plist" "$CONTENTS_DIR/Info.plist"

TMPDIR="$BUILD_CACHE" xcrun swiftc \
  -target arm64-apple-macos14.0 \
  -module-cache-path "$BUILD_CACHE/modules" \
  -parse-as-library \
  -O \
  -framework SwiftUI \
  -framework AppKit \
  -framework IOKit \
  -framework QuartzCore \
  -framework MetalKit \
  -framework ScreenCaptureKit \
  -framework Carbon \
  -framework Security \
  -o "$MACOS_DIR/HingeGlass" \
  "$PROJECT_DIR"/Sources/*.swift

rm -rf "$BUILD_CACHE"

codesign --force --deep --sign - "$APP_DIR"
echo "Built: $APP_DIR"
