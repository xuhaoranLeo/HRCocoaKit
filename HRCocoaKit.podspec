
Pod::Spec.new do |s|

# pod trunk push HRCocoaKit.podspec --allow-warnings --verbose --use-libraries

  s.name         = "HRCocoaKit"
  s.version      = "0.0.9"
  s.license      = 'MIT'
  s.summary      = "An Objective-C library for FiberhomeCloud by Xu Haoran"
  s.homepage     = "https://github.com/xuhaoranLeo/HRCocoaKit"
  s.author       = { "许昊然" => "liang_andy@163.com" }
  s.source       = { :git => "https://github.com/xuhaoranLeo/HRCocoaKit.git", :tag => "#{s.version}", :submodules => true}
  s.requires_arc = true
  s.public_header_files = 'HRCocoaKit/HRCocoaKit/HRCocoaKit.h'
  s.source_files = 'HRCocoaKit/HRCocoaKit/HRCocoaKit.h'
  s.ios.deployment_target = '8.0'

  s.subspec 'Category' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Category/*.{h,m}', 'HRCocoaKit/HRCocoaKit/Category/Effect/*.{h,m}', 'HRCocoaKit/HRCocoaKit/Category/Safe/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Category/*.h', 'HRCocoaKit/HRCocoaKit/Category/Effect/*.h', 'HRCocoaKit/HRCocoaKit/Category/Safe/*.h'
  end

  s.subspec 'Common' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Common/CommonDefine.h'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Common/CommonDefine.h'
  end

  s.subspec 'HUDManager' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/HUDManager/HRHUDManager.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/HUDManager/HRHUDManager.h'
  end

  s.subspec 'StorageManager' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/StorageManager/HRStorageManager.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/StorageManager/HRStorageManager.h'
  end

  s.subspec 'RSA' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/RSA/RSA.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/RSA/RSA.h'
  end

  s.subspec 'HRViewModel' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/HRViewModel/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/HRViewModel/*.h'
  end

  s.subspec 'HRQrCodeViewController' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/HRQrCodeViewController/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/HRQrCodeViewController/HRQrCodeViewController.h'
    ss.ios.frameworks = 'AVFoundation'
    ss.resources = 'HRCocoaKit/HRCocoaKit/Manager/HRQrCodeViewController/HRQrCodeViewController.bundle', 'HRCocoaKit/HRCocoaKit/Manager/HRQrCodeViewController/HRQrCodeViewController.xib'
  end

  s.subspec 'HRPopupMenuView' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/HRPopupMenuView/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/HRPopupMenuView/*.h'
    ss.dependency 'HRCocoaKit/Category'
    ss.dependency 'HRCocoaKit/Common'
  end

  s.subspec 'SecurityManager' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/SecurityManager/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/SecurityManager/*.h'
  end

  s.subspec 'AuthorityManager' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/AuthorityManager/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/AuthorityManager/*.h'
    ss.dependency 'HRCocoaKit/Category'
  end
  
  s.subspec 'Networking' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/Networking/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/Networking/*.h'
    ss.dependency 'HRCocoaKit/HUDManager'
    ss.dependency 'HRCocoaKit/Common'
  end

  s.subspec 'HRWebViewController' do |ss|
    ss.source_files = 'HRCocoaKit/HRCocoaKit/Manager/HRWebViewController/*.{h,m}'
    ss.public_header_files = 'HRCocoaKit/HRCocoaKit/Manager/HRWebViewController/*.h'
    ss.dependency 'HRCocoaKit/HUDManager'
    ss.dependency 'HRCocoaKit/Common'
  end

  s.dependency "AFNetworking", "~> 3.0"
  s.dependency "Masonry"
  s.dependency "MBProgressHUD", "~> 1.0.0"
  s.dependency "SAMKeychain"

end
