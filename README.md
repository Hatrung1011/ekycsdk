# NLE KYC SDK

NLE KYC SDK là một framework iOS mạnh mẽ cung cấp các tính năng xác thực danh tính điện tử (eKYC) cho ứng dụng iOS.

## Tính năng

- ✅ Quét và đọc thông tin CCCD/CMND (MRZ)
- ✅ Kiểm tra liveness detection
- ✅ Xác thực khuôn mặt
- ✅ Đọc thông tin NFC từ thẻ chip
- ✅ Chữ ký số
- ✅ Tích hợp API eKYC
- ✅ Hỗ trợ OCR với Tesseract
- ✅ Giao diện người dùng thân thiện

## Yêu cầu

- iOS 11.0+
- Xcode 12.0+
- Swift 5.0+

## Cài đặt

### CocoaPods

Thêm dòng sau vào `Podfile` của bạn:

```ruby
pod 'nlekycsdk', '~> 1.0.0'
```

Sau đó chạy:

```bash
pod install
```

### Swift Package Manager

Thêm dependency vào `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/nlekycsdk.git", from: "1.0.0")
]
```

## Sử dụng

### 1. Import framework

```swift
import nlekycsdk
```

### 2. Khởi tạo SDK

```swift
// Khởi tạo SDK
NLeKYCSdkManager.shared.initSDK()
```

### 3. Sử dụng các tính năng

```swift
// Kiểm tra liveness
NLeKYCSdkManager.shared.livenessCheck(clienttransaction: "your-transaction-id")
```

## Cấu hình

### Info.plist

Thêm các quyền cần thiết vào `Info.plist`:

```xml
<!-- Camera permission -->
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần quyền truy cập camera để quét CCCD/CMND</string>

<!-- NFC permission -->
<key>NFCReaderUsageDescription</key>
<string>Ứng dụng cần quyền truy cập NFC để đọc thông tin từ thẻ chip</string>

<!-- Face ID permission -->
<key>NSFaceIDUsageDescription</key>
<string>Ứng dụng sử dụng Face ID để xác thực danh tính</string>
```

### Capabilities

Trong Xcode, thêm các capabilities sau:
- Near Field Communication Tag Reading
- Face ID

## API Reference

### NLeKYCSdkManager

#### Methods

- `initSDK()`: Khởi tạo SDK
- `livenessCheck(clienttransaction: String)`: Thực hiện kiểm tra liveness

## Ví dụ

Xem thêm ví dụ chi tiết trong thư mục `Example/`.

## Đóng góp

Chúng tôi hoan nghênh mọi đóng góp! Vui lòng tạo issue hoặc pull request.

## License

NLE KYC SDK được phát hành dưới MIT License. Xem file `LICENSE` để biết thêm chi tiết.

## Hỗ trợ

Nếu bạn gặp vấn đề hoặc có câu hỏi, vui lòng tạo issue trên GitHub hoặc liên hệ:

- Email: your.email@example.com
- GitHub: https://github.com/yourusername/nlekycsdk
