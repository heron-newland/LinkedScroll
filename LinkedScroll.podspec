

Pod::Spec.new do |s|

  s.name         = "LinkedScroll"
  s.version      = "1.0.1"
  s.summary      = "A linked up and down scroll component for iOS in swift"

  s.description  = <<-DESC
		A linked up and down scroll component for iOS in swift. You can use it easily.
                   DESC

  s.homepage     = "https://github.com/heron-newland/LinkedScroll/tree/master"

  s.license      = "MIT"

  s.author             = { "Heron" => "objc_china@163.com" }

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/heron-newland/LinkedScroll.git", :tag => "1.0.1" }

  s.source_files  = "Source/*.swift"


end
