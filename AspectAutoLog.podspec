Pod::Spec.new do |s|

  s.name          = "AspectAutoLog"
  s.version       = "0.0.1"
  s.summary       = "iOS auto log based on aop"

  s.description   = <<-DESC
   中文: 基于 methodswizzle 原理和切面(AOP)编程思想，实现了 iOS 的自动埋点。目前支持页面展示和按钮点击(touchUpInside)。

   English: Based on the principle of method swizzling and the aspect-oriented programming (AOP) concept,
   automatic tracking (auto-burial point) has been implemented in iOS. 
   Currently supports page displays and button clicks (touchUpInside).
                   DESC

  s.homepage      = "https://github.com/wujingcheng7/AspectAutoLog"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "wujc" => "love@jingchengwu.cn" }
  s.platform      = :ios, "9.0"
  s.frameworks    = 'UIKit'
  s.requires_arc  = true
  s.swift_version = '5.0'

  s.source        = { :git => "https://github.com/wujingcheng7/AspectAutoLog.git", :tag => "#{s.version}" }

  s.source_files  = 'Class/**/*.{swift,h,m}'

end
