#!/usr/bin/env bash
# Copyright (c) 2018-Present Lea Anthony
# SPDX-License-Identifier: MIT

# Fail script on any error
set -euxo pipefail

# Define variables
APP_DIR="${APP_NAME}.AppDir"

# Create AppDir structure
mkdir -p "${APP_DIR}/usr/bin"
cp -r "${APP_BINARY}" "${APP_DIR}/usr/bin/"
cp "${ICON_PATH}" "${APP_DIR}/"
cp "${DESKTOP_FILE}" "${APP_DIR}/"

# 复制 WebKit2GTK 辅助进程
echo "Copying WebKit2GTK auxiliary processes..."
WEBKIT_LIB_DIR="/usr/lib/x86_64-linux-gnu/webkit2gtk-4.1"
if [ -d "${WEBKIT_LIB_DIR}" ]; then
    mkdir -p "${APP_DIR}/usr/lib/x86_64-linux-gnu/webkit2gtk-4.1"
    cp -r "${WEBKIT_LIB_DIR}"/* "${APP_DIR}/usr/lib/x86_64-linux-gnu/webkit2gtk-4.1/"
    echo "✓ WebKit auxiliary processes copied"
else
    echo "⚠ Warning: WebKit library directory not found at ${WEBKIT_LIB_DIR}"
    echo "  AppImage may fail to run if WebKit is required"
fi

if [[ $(uname -m) == *x86_64* ]]; then
    # Download linuxdeploy and make it executable
    wget -q -4 -N https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
    chmod +x linuxdeploy-x86_64.AppImage

    # Run linuxdeploy to bundle the application
    ./linuxdeploy-x86_64.AppImage --appdir "${APP_DIR}" --output appimage
else
    # Download linuxdeploy and make it executable (arm64)
    wget -q -4 -N https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage
    chmod +x linuxdeploy-aarch64.AppImage

    # Run linuxdeploy to bundle the application (arm64)
    ./linuxdeploy-aarch64.AppImage --appdir "${APP_DIR}" --output appimage
fi

# Rename the generated AppImage
mv "${APP_NAME}*.AppImage" "${APP_NAME}.AppImage"

