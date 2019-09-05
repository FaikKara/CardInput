#pod lib lint CardInputNew.podspec

Pod::Spec.new do |s|
  s.name = 'CardInputNew'
  s.version = '0.5.8'
  s.license = 'MIT'
  s.summary = 'Fancy Credit Card Input'
  s.homepage = 'https://github.com/FaikKara/CardInputNew.git'
  s.authors = { 'Faij Karazade' => 'faik@mobisem.com' }
  s.source = { :git => 'https://github.com/FaikKara/CardInputNew.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'CardInput/Classes/**/*.swift'
  s.resource_bundles = { 'CardInputNew' => [ "CardInput/New**/*.{xib,png,ttf}"] }
  s.swift_version = "4.2"
  s.dependency 'AKMaskField'
end
