
Pod::Spec.new do |s|


  s.name         = "HRCocoaKit"
  s.version      = "0.0.1"
  s.summary      = "Framework for FiberhomeCloud by Xu Haoran"
  s.homepage     = "https://github.com/xuhaoranLeo"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "许昊然" => "liang_andy@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/xuhaoranLeo/HRCocoaKit.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  s.requires_arc = true
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "JSONKit", "~> 1.4"

end
