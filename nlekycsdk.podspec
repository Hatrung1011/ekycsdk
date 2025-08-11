Pod::Spec.new do |spec|
  spec.name         = "nlekycsdk"
  spec.version      = "1.0.0"
  spec.summary      = "NLE KYC SDK for iOS - Electronic Know Your Customer verification framework"
  spec.description  = <<-DESC
                      NLE KYC SDK là một framework iOS mạnh mẽ cung cấp các tính năng xác thực danh tính điện tử (eKYC) bao gồm:
                      - Quét và đọc thông tin CCCD/CMND
                      - Kiểm tra liveness detection
                      - Xác thực khuôn mặt
                      - Đọc thông tin NFC
                      - Chữ ký số
                      - Tích hợp API eKYC
                      DESC
  spec.homepage     = "https://github.com/Hatrung1011/ekycsdk.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Sherwin Nguyen" => "trungnhsoft01@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/Hatrung1011/ekycsdk.git", :tag => "#{spec.version}" }
  
  spec.source_files = "nlekycsdk/**/*.{swift,h,m}"
  spec.resources    = [
    "nlekycsdk/Assets.xcassets/**/*",
    "nlekycsdk/Base.lproj/**/*",
    "tessdata/**/*"
  ]
  
  spec.frameworks   = "UIKit", "Foundation", "CoreNFC", "AVFoundation", "CoreML", "Vision"
  spec.libraries    = "c++"
  
  # Dependencies
  spec.dependency 'FlashLiveness', :git => 'https://github.com/stevienguyen1988/FlashLivenessPod.git'
  spec.dependency 'QKMRZParser', '~> 2.0.0'
  spec.dependency 'SwiftyTesseract', '~> 3.1.3'
  spec.dependency 'iProov'
  spec.dependency 'QTSCardReader'
  spec.dependency 'SVProgressHUD'
  spec.dependency 'FontAwesome+iOS', :git => 'https://github.com/trungnguyen1791/ios-fontawesome.git', :commit => '0e6bf65'
  spec.dependency 'Alamofire', '~> 5.0'
  spec.dependency 'LivenessCloud'
  spec.dependency 'CryptoSwift', '~> 1.8'
  spec.dependency 'KeychainSwift', '~> 20.0'
  spec.dependency 'ObjectMapper', '~> 4.2'
  spec.dependency 'OpenSSL-Universal', '~> 1.1'
  
  # Swift version
  spec.swift_version = "5.0"
  
  # Build settings
  spec.pod_target_xcconfig = {
    'SWIFT_VERSION' => '5.0',
    'IPHONEOS_DEPLOYMENT_TARGET' => '11.0',
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '-ObjC'
  }
  
  # Exclude files that shouldn't be included in the pod
  spec.exclude_files = [
    "nlekycsdk.xcodeproj/**/*",
    "nlekycsdk.xcworkspace/**/*",
    "Pods/**/*",
    "Podfile*",
    "*.xcworkspace",
    "*.xcodeproj"
  ]
end
