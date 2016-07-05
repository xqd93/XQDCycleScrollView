Pod::Spec.new do |s|
  s.name         = "XQDCycleScrollView"
  s.version      = "1.0.1"
  s.ios.deployment_target = '6.0'
  s.summary      = "可高度自定义的轮播图控件"
  s.homepage     = "https://github.com/xqd93/XQDCycleScrollView"
  s.license      = "MIT"
  s.author             = { "xqd93" => "418162366@qq.com" }
  s.source       = { :git => "https://github.com/xqd93/XQDCycleScrollView.git", :tag => s.version }
  s.source_files  = "XQDCycleScrollView"
  s.requires_arc = true
end
