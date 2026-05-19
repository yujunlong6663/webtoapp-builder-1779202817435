#!/bin/bash

# Permission patch script for Capacitor Android project
# This script adds missing permissions to AndroidManifest.xml

MANIFEST_FILE="android/app/src/main/AndroidManifest.xml"

if [ ! -f "$MANIFEST_FILE" ]; then
    echo "AndroidManifest.xml not found. Skipping permission patch."
    exit 0
fi

# Add CALL_PHONE permission for phone intent
if ! grep -q "android.permission.CALL_PHONE" "$MANIFEST_FILE"; then
    sed -i '/<uses-permission/a\    <uses-permission android:name="android.permission.CALL_PHONE" />' "$MANIFEST_FILE"
fi

# Add media permissions for photos access
if ! grep -q "android.permission.READ_MEDIA_IMAGES" "$MANIFEST_FILE"; then
    sed -i '/<uses-permission/a\    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />' "$MANIFEST_FILE"
fi
if ! grep -q "android.permission.READ_EXTERNAL_STORAGE" "$MANIFEST_FILE"; then
    sed -i '/<uses-permission/a\    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />' "$MANIFEST_FILE"
fi

# Add dial intent query if not present
if ! grep -q "android.intent.action.DIAL" "$MANIFEST_FILE"; then
    sed -i '/<queries>/a\        <intent>\n            <action android:name="android.intent.action.DIAL" />\n            <data android:scheme="tel" />\n        </intent>' "$MANIFEST_FILE"
fi

# Replace app icon if custom icon exists
if [ -f "../app-icon.png" ]; then
    echo "Custom icon detected, copying to Android project..."
    # Capacitor uses cordova-res to generate icons, but for CI we use a simple copy
    mkdir -p android/app/src/main/res/mipmap-hdpi
    mkdir -p android/app/src/main/res/mipmap-mdpi
    mkdir -p android/app/src/main/res/mipmap-xhdpi
    mkdir -p android/app/src/main/res/mipmap-xxhdpi
    mkdir -p android/app/src/main/res/mipmap-xxxhdpi
    # For simplicity, copy to all mipmap directories
    # In production, use cordova-res to generate proper sizes
    cp ../app-icon.png android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
    cp ../app-icon.png android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
    cp ../app-icon.png android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
    cp ../app-icon.png android/app/src/main/res/mipmap-hdpi/ic_launcher.png
    cp ../app-icon.png android/app/src/main/res/mipmap-mdpi/ic_launcher.png
fi

echo "Permission patch completed!"