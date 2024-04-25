Pod::Spec.new do |s|

  s.name          = "AspectAutoLog"
  s.version       = "2.1.0"
  s.summary       = "iOS auto log based on aop"

  s.description   = <<-DESC
   中文:
   基于 methodswizzle 原理和切面编程(AOP)思想，实现了 iOS 的自动埋点。
   目前支持:
       1.页面展示和消失
       2.UIControl 按钮点击(touchUpInside)
       3.UITableViewCell/UICollectionViewCell 展示&隐藏

   English:
   Based on the principle of method swizzling and the concept of aspect-oriented programming (AOP),
   automatic instrumentation for iOS has been implemented.
   Currently supports:
       1.Page display and disappearance
       2.UIControl clicks (touchUpInside)
       3.UITableViewCell/UICollectionViewCell display & hide
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
