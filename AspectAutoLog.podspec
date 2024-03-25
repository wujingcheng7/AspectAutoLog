Pod::Spec.new do |spec|

  spec.name         = "AspectAutoLog"
  spec.version      = "0.0.1"
  spec.summary      = "iOS auto log based on aop"

  spec.description  = <<-DESC
   中文: 基于 methodswizzle 原理和切面(AOP)编程思想，实现了 iOS 的自动埋点。目前支持页面展示和按钮点击(touchUpInside)。

   English: Based on the principle of method swizzling and the aspect-oriented programming (AOP) concept,
   automatic tracking (auto-burial point) has been implemented in iOS. 
   Currently supports page displays and button clicks (touchUpInside).
                   DESC

  spec.homepage     = "https://github.com/wujingcheng7/AspectAutoLog"

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "wujc" => "love@jingchengwu.cn" }
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/wujingcheng7/AspectAutoLog.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m,swift}"
  spec.exclude_files = "Classes/Exclude"

end
