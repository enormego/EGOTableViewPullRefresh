Pod::Spec.new do |s|
  s.name     = 'EGOTableViewPullRefresh'
  s.version  = '0.1.1'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = 'A similar control to the pull down to refresh control created by atebits in Tweetie 2.'
  s.homepage = 'https://github.com/enormego/EGOTableViewPullRefresh'
  s.author   = { 'Devin Doty' => 'devin.r.doty@gmail.com' }
  s.source   = { :git     => 'https://github.com/basecom/EGOTableViewPullRefresh.git',
                 :tag     => '0.1.1' }

  s.source_files = 'EGOTableViewPullRefresh/Classes/View/*.{h,m}'
  s.resources    = 'EGOTableViewPullRefresh/EgoTableViewResources.bundle'

  s.framework    = 'QuartzCore'
end
