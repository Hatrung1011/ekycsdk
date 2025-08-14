# Hướng dẫn tích hợp nlekycsdk Framework

## 📋 Yêu cầu hệ thống
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+
- **Lưu ý**: Framework này chỉ hỗ trợ iOS Device (arm64), không hỗ trợ iOS Simulator (x86_64)

## 🚀 Cách tích hợp

### 1. Thêm Framework vào project

#### Cách 1: Sử dụng XCFramework (Khuyến nghị)
1. Copy `nlekycsdk.xcframework` vào project của bạn
2. Trong Xcode, chọn target của app
3. Vào tab "General" → "Frameworks, Libraries, and Embedded Content"
4. Click "+" và chọn "Add Other..." → "Add Files..."
5. Chọn `nlekycsdk.xcframework`
6. Đảm bảo "Embed & Sign" được chọn

**⚠️ Framework này là static library - cần thêm dependencies riêng biệt vào project!**

#### Cách 2: Sử dụng Framework thủ công
1. Copy `nlekycsdk.xcframework` vào project của bạn
2. Trong Xcode, chọn target của app
3. Vào tab "General" → "Frameworks, Libraries, and Embedded Content"
4. Click "+" và chọn "Add Other..." → "Add Files..."
5. Chọn `nlekycsdk.xcframework`
6. Đảm bảo "Embed & Sign" được chọn

### 2. Framework Dependencies

**⚠️ Framework này là static library - cần thêm dependencies riêng biệt**

Framework này cần các dependencies sau được thêm vào project:
- Alamofire, CryptoSwift, FlashLiveness
- FontAwesome_iOS, IDCardReader, KeychainSwift
- LivenessCloud, ObjectMapper, OpenSSL
- QKMRZParser, SVProgressHUD, SignManager
- SwiftyTesseract, libtesseract, iProov

**Tất cả dependencies đã được cung cấp trong thư mục Framework/**

### 3. Cấu hình Build Settings

Trong target của app, thêm các cấu hình sau:

#### Framework Search Paths:
```
$(PROJECT_DIR)/nlekycsdk.xcframework
$(PROJECT_DIR)/Framework
```

#### Other Linker Flags:
```
$(inherited)
-framework Alamofire
-framework CryptoSwift
-framework FlashLiveness
-framework FontAwesome_iOS
-framework IDCardReader
-framework KeychainSwift
-framework LivenessCloud
-framework ObjectMapper
-framework OpenSSL
-framework QKMRZParser
-framework SVProgressHUD
-framework SignManager
-framework SwiftyTesseract
-framework libtesseract
-framework iProov
```

### 4. Thêm Permissions

Thêm các permissions sau vào `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần sử dụng camera để quét mã mrz căn cước công dân và thực hiện liveness</string>

<key>NFCReaderUsageDescription</key>
<string>Ứng dụng cần scan nfc để đọc thông tin từ thẻ căn cước công dân</string>

<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000002471001</string>
    <string>A0000002472001</string>
    <string>00000000000000</string>
</array>
```

### 5. Sử dụng Framework

```swift
import nlekycsdk

// Khởi tạo SDK
let sdk = NLEKYCManager.shared

// Cấu hình
sdk.configure(with: "YOUR_API_KEY")

// Sử dụng các tính năng
sdk.scanMRZ { result in
    switch result {
    case .success(let data):
        print("MRZ Data: \(data)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

## 🔧 Troubleshooting

### Lỗi "framework not found"
1. Kiểm tra Framework Search Paths đã đúng chưa
2. Đảm bảo framework đã được thêm vào "Frameworks, Libraries, and Embedded Content"
3. Clean và rebuild project

### Lỗi "Could not find or use auto-linked framework"
1. Đảm bảo framework đã được thêm vào "Embedded Binaries"
2. Kiểm tra framework có tồn tại trong project không
3. Đảm bảo framework được build cho đúng architecture

### Lỗi "Library not loaded: @rpath/...framework/..."
1. Framework đã được cấu hình để embed tất cả dependencies
2. Dependencies được link với `@loader_path/SharedFrameworks`
3. Không cần thêm dependencies riêng biệt vào project

### Lỗi "Code signature not valid" hoặc "completely unsigned"
1. Framework đã được code sign với ad-hoc signature
2. Tất cả dependencies đã được cung cấp riêng biệt
3. Framework sẵn sàng để sử dụng trên device

### Lỗi "search path not found"
1. Kiểm tra đường dẫn trong Framework Search Paths
2. Đảm bảo đường dẫn tương đối với project
3. Sử dụng `$(PROJECT_DIR)` thay vì đường dẫn tuyệt đối

### Lỗi "unsupported Swift architecture"
1. Framework chỉ hỗ trợ iOS Device (arm64)
2. Không thể build cho iOS Simulator (x86_64)
3. Test trên device thật thay vì simulator

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng liên hệ:
- Email: support@nganluong.vn
- Hotline: 1900-xxxx

## 📝 Lưu ý quan trọng

1. **Architecture**: Framework chỉ hỗ trợ arm64 (device), không hỗ trợ x86_64 (simulator)
2. **iOS Version**: Tối thiểu iOS 13.0
3. **Dependencies**: Tất cả dependencies đã được embed vào framework
4. **Permissions**: Camera và NFC permissions là bắt buộc
5. **Code Signing**: Đảm bảo framework được sign đúng cách
6. **Testing**: Phải test trên device thật, không thể test trên simulator
