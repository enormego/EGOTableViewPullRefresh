Pod::Spec.new do |s|
  s.name         = "NEETPullRefreshTableHeaderView"
  s.version      = "1.1.1"
  s.summary      = "Customizable pull refresh table header view."
  s.homepage     = "https://github.com/neethouse/NEETPullRefreshTableHeaderView"
  s.license      = 'MIT'
  s.author       = { "mtmta" => "mtmta@501dev.org" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/neethouse/NEETPullRefreshTableHeaderView.git", :tag => "1.1.1" }
  s.source_files = 'NEETPullRefreshTableHeaderView/**/*.{h,m}'
  s.public_header_files = 'NEETPullRefreshTableHeaderView/**/*.h'
  s.requires_arc = true
end
