Pod::Spec.new do |s|

s.name         = "JXPageView"
s.version      = "1.0.3"
s.summary      = "封装简单、支持定制、页面控制器,可以滚动内容和标题栏,包含多种style"

s.homepage     = "https://github.com/HJXIcon/JXPageView"

s.license      = "MIT"

s.author       = { "HJXIcon" => "x1248399884@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/HJXIcon/JXPageView.git", :tag => "1.0.3"}


s.source_files  = "JXPageContentView/JXPageContentView/JXPageView/**/*.{swift}"


s.requires_arc = true


end