#pod lib lint CardInput.podspec

Pod::Spec.new do |s|
  s.name = 'CardInput'
  s.version = '0.5.0'
  s.license = 'MIT'
  s.summary = 'Fancy Credit Card Input'
  s.homepage = 'https://github.com/mahmutpinarbasi/CardInput.git'
  s.authors = { 'Mahmut Pınarbaşı' => 'pinarbasimahmut@gmail.com' }
  s.source = { :git => 'https://github.com/mahmutpinarbasi/CardInput.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'CardInput/Classes/**/*.swift'
  s.resource_bundles = { 'CardInput' => [ "CardInput/**/*.{xib,png,ttf}"] }
  s.swift_version = "4.2"
  s.dependency 'AKMaskField'
end
