#!/bin/bash

# Script build static library nlekycsdk không embed dependencies
# Sử dụng: ./build_static.sh

set -e

echo "🚀 Bắt đầu build static library nlekycsdk..."

# Xóa build cũ
echo "🧹 Xóa build cũ..."
rm -rf build/
rm -rf DerivedData/
rm -rf nlekycsdk.xcframework/
rm -rf Distribution/

# Build cho iOS Device
echo "📱 Build cho iOS Device..."
xcodebuild clean build \
    -project nlekycsdk.xcodeproj \
    -scheme nlekycsdk \
    -configuration Release \
    -destination 'generic/platform=iOS' \
    -derivedDataPath build \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO \
    EXCLUDED_ARCHS="x86_64"

# Tạo XCFramework chỉ cho device
echo "📦 Tạo XCFramework (device only)..."
mkdir -p nlekycsdk.xcframework/ios-arm64/nlekycsdk.framework
cp -R build/Build/Products/Release-iphoneos/nlekycsdk.framework/* nlekycsdk.xcframework/ios-arm64/nlekycsdk.framework/

# Tạo Info.plist cho XCFramework
cat > nlekycsdk.xcframework/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>AvailableLibraries</key>
    <array>
        <dict>
            <key>LibraryIdentifier</key>
            <string>ios-arm64</string>
            <key>LibraryPath</key>
            <string>nlekycsdk.framework</string>
            <key>SupportedArchitectures</key>
            <array>
                <string>arm64</string>
            </array>
            <key>SupportedPlatform</key>
            <string>ios</string>
        </dict>
    </array>
    <key>CFBundlePackageType</key>
    <string>XFWK</string>
    <key>XCFrameworkFormatVersion</key>
    <string>1.0</string>
</dict>
</plist>
EOF

echo "✅ Static library đã được build thành công!"

# Kiểm tra dependencies
echo "🔍 Kiểm tra dependencies..."
if [ -d "nlekycsdk.xcframework/ios-arm64/nlekycsdk.framework/SharedFrameworks" ]; then
    echo "⚠️ SharedFrameworks vẫn tồn tại - sẽ xóa..."
    rm -rf nlekycsdk.xcframework/ios-arm64/nlekycsdk.framework/SharedFrameworks
fi

# Kiểm tra rpath
echo "🔍 Kiểm tra rpath..."
otool -L nlekycsdk.xcframework/ios-arm64/nlekycsdk.framework/nlekycsdk | grep "@rpath" || echo "✅ Không có @rpath dependencies!"

# Tạo thư mục distribution
echo "📋 Tạo thư mục distribution..."
mkdir -p Distribution
cp -R nlekycsdk.xcframework Distribution/
cp -R Framework Distribution/
cp INTEGRATION_GUIDE.md Distribution/

echo "🎉 Hoàn thành! Static library đã sẵn sàng để distribute."
echo "📂 Distribution folder: $(pwd)/Distribution"
echo ""
echo "⚠️ Lưu ý: Framework này là static library"
echo "   Client cần thêm dependencies riêng biệt vào project"
echo ""
echo "📦 Kích thước framework:"
du -sh Distribution/
