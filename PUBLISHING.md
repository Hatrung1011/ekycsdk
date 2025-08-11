# Hướng dẫn Publish Pod nlekycsdk

## Bước 1: Chuẩn bị

### 1.1 Cài đặt CocoaPods
```bash
sudo gem install cocoapods
```

### 1.2 Đăng ký CocoaPods Trunk
```bash
pod trunk register your.email@example.com "Your Name"
```

### 1.3 Verify email
Kiểm tra email và click vào link xác nhận từ CocoaPods.

## Bước 2: Cập nhật thông tin

### 2.1 Cập nhật podspec
Chỉnh sửa file `nlekycsdk.podspec`:
- Thay đổi `homepage` URL
- Cập nhật `author` email
- Cập nhật `source` URL (GitHub repository)

### 2.2 Cập nhật version
Khi release version mới, cập nhật:
- `spec.version` trong podspec
- Tag trên Git repository

## Bước 3: Validate Podspec

### 3.1 Validate locally
```bash
pod spec lint nlekycsdk.podspec --allow-warnings
```

### 3.2 Validate với dependencies
```bash
pod spec lint nlekycsdk.podspec --allow-warnings --verbose
```

## Bước 4: Publish to CocoaPods

### 4.1 Push to trunk
```bash
pod trunk push nlekycsdk.podspec --allow-warnings
```

### 4.2 Verify publication
```bash
pod search nlekycsdk
```

## Bước 5: Sử dụng trong ứng dụng khác

### 5.1 Thêm vào Podfile
```ruby
pod 'nlekycsdk', '~> 1.0.0'
```

### 5.2 Install
```bash
pod install
```

### 5.3 Import và sử dụng
```swift
import nlekycsdk

// Khởi tạo SDK
NLeKYCSdkManager.shared.initSDK()

// Sử dụng các tính năng
NLeKYCSdkManager.shared.livenessCheck(clienttransaction: "your-transaction-id")
```

## Troubleshooting

### Lỗi thường gặp

1. **Validation failed**
   - Kiểm tra syntax trong podspec
   - Đảm bảo tất cả dependencies đều có sẵn
   - Chạy với `--verbose` để xem chi tiết lỗi

2. **Push failed**
   - Đảm bảo đã đăng ký và verify email
   - Kiểm tra quyền truy cập repository
   - Đảm bảo tag version đã được push lên Git

3. **Dependencies not found**
   - Kiểm tra tên và version của dependencies
   - Đảm bảo dependencies đã được publish trên CocoaPods

### Best Practices

1. **Versioning**
   - Sử dụng Semantic Versioning (MAJOR.MINOR.PATCH)
   - Tạo Git tag cho mỗi version

2. **Documentation**
   - Cập nhật README.md với hướng dẫn sử dụng
   - Thêm ví dụ code
   - Mô tả rõ các tính năng

3. **Testing**
   - Test pod trong project khác trước khi publish
   - Đảm bảo tất cả dependencies hoạt động

## Script tự động

Sử dụng script `scripts/validate_pod.sh` để tự động validate và publish:

```bash
./scripts/validate_pod.sh
```

## Liên hệ

Nếu gặp vấn đề, vui lòng:
- Tạo issue trên GitHub
- Liên hệ: your.email@example.com
