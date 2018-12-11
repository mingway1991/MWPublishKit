Pod::Spec.new do |s|
  s.name             = 'MWPublishKit'
  s.version          = '0.5.4'
  s.summary          = '发表文字图片'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/mingway1991/MWPublishKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mingway1991' => 'mingwei.shi@hotmail.com' }
  s.source           = { :git => 'https://github.com/mingway1991/MWPublishKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'MWPublishKit/Classes/**/*'
  s.resources = 'MWPublishKit/Assets/**/*'
  s.dependency 'ZLPhotoBrowser'
  s.dependency 'SDWebImage'
end
