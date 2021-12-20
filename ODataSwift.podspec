#
# Be sure to run `pod lib lint ODataSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ODataSwift'
  s.version          = '1.0.1'
  s.summary          = 'The utility package for OData Client in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ODataSwift is simple utility swift wrapper to generate OData Query V4 that works on iOS and OS X. Makes using ODataSwift builder pattern APIs extremely easy and much more palatable to use in Swift
                       DESC

  s.homepage         = 'https://github.com/developer-celusion/ODataSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'developer@celusion.com' => 'developer@celusion.com' }
  s.source           = { :git => 'https://github.com/developer-celusion/ODataSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/ODataSwift/**/*'
  
  # s.resource_bundles = {
  #   'ODataSwift' => ['ODataSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.dependency 'Alamofire'
end
