#pod lib lint CardInput.podspec

Pod::Spec.new do |s|
  s.name = 'CardInput'
  s.version = '0.2'
  s.license = 'MIT'
  s.summary = 'Fancy Credit Card Input'
  s.homepage = 'https://github.com/mahmutpinarbasi/CardInput.git'
  s.authors = { 'Mahmut Pınarbaşı' => 'pinarbasimahmut@gmail.com' }
  s.source = { :git => 'https://github.com/mahmutpinarbasi/CardInput.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.source_files = 'CardInput/**/*.swift'
  s.resources = "CardInput/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}" 
  s.swift_version = "4.2"

#dependincies
  s.dependency 'AKMaskField'
end