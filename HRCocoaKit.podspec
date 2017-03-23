
Pod::Spec.new do |s|


  s.name         = "HRCocoaKit"
  s.version      = "0.0.2"
  s.summary      = "An Objective-C library for FiberhomeCloud by Xu Haoran"
  s.homepage     = "https://github.com/xuhaoranLeo"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "许昊然" => "xuhaoranleo@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/xuhaoranLeo/HRCocoaKit.git", :tag => "#{s.version}" }
  s.source_files  = "HRCocoaKit/HRCocoaKit/**/*.{h,m}"
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.0"
  s.dependency "Masonry"
  s.dependency "MBProgressHUD", "~> 1.0.0"
  s.dependency "SAMKeychain"
  # s.prefix_header_contents = <<-EOS
 	#   ifdef __OBJC__
 	#   import "CommonConfiguration.h"
 	#   endif 
  # EOS

end
