
Pod::Spec.new do |spec|

  spec.name         = "ADAlertController"
  spec.version      = "1.0.0"
  spec.summary      = "ADAlertController 是一个与 UIAlertController 类似风格的 UI 控件"
  spec.description  = <<-DESC "ADAlertController 是一个与 UIAlertController 类似风格的 UI 控件,包含 Alert 和 ActionSheet 以及无边距的 ActionSheet(ADAlertControllerStyleSheet) 等 UI类型.与UIAlertController 有相似的 API.并支持自定义视图,以及优先级队列"
                   DESC

  spec.homepage     = "https://github.com/huangxianhui001/ADAlertController"
  spec.license      = "MIT"
  spec.author             = { "huangxianhuiMacBook" => "756673457@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/huangxianhui001/ADAlertController.git", :tag => "#{spec.version}" }
  spec.source_files  = "ADAlertController/**/*.{h,m}"

  spec.frameworks = "UIKit", "Foundation"

  spec.requires_arc = true

end
