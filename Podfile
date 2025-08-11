# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!
target 'nlekycsdk' do

  # Pods for nlekycsdk
  pod 'FlashLiveness', :git => 'https://github.com/stevienguyen1988/FlashLivenessPod.git'
  pod 'QKMRZParser', '~> 2.0.0'
  pod 'SwiftyTesseract', '~> 3.1.3'
  pod 'iProov'
  pod 'QTSCardReader'
  pod 'SVProgressHUD'
  pod "FontAwesome+iOS", :git => 'https://github.com/trungnguyen1791/ios-fontawesome.git', :commit => '0e6bf65'
  pod 'Alamofire'
  pod 'LivenessCloud'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
#    if target.name == 'IDCardReader' then
#      target.build_configurations.each do |config|
#        config.build_settings['SWIFT_INSTALL_OBJC_HEADER'] = 'No'
#      end
#    end
#    if target.name == 'LivenessUtility' then
#      target.build_configurations.each do |config|
#        config.build_settings['SWIFT_INSTALL_OBJC_HEADER'] = 'No'
#      end
#    end
  
  if target.name == 'JOSESwift' then
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    elsif
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
    
  end
  
end
