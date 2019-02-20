#
# Be sure to run `pod lib lint VaultSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VaultSDK'
  s.version          = '0.1.0'
  s.summary          = 'The SDK for 2019 Mithril Hackathon'
  s.homepage         = 'https://github.com/mithio/vault-oauth-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alex Huang' => 'alex@mith.io' }
  s.source           = { :git => 'https://github.com/mithio/vault-oauth-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'VaultSDK/Classes/**/*'
  s.swift_version = '4.2'
  s.dependency 'AppAuth', '1.0.0.beta1'
  s.dependency 'SwiftyJSON', '~> 4.2.0'
  s.dependency 'CryptoSwift', '~> 0.14.0'
end
