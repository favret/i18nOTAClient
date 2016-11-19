Pod::Spec.new do |s|

  s.name         = "i18nOTAClient"
  s.version      = "0.0.1"
  s.summary      = "Over-the-air translation update for your iOS apps with your i18n Server"

  #s.description  = <<-DESC
  #                 DESC

  s.homepage     = "https://github.com/favret/i18nOTAClient"

  #s.license      = "MIT (example)"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "favre" => "" }
  # Or just: s.author    = "favre"
  # s.authors            = { "favre" => "" }
  # s.social_media_url   = "http://twitter.com/favre"

  s.platform     = :ios, "9.0"
  #s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/favret/i18nOTAClient.git", :tag => s.version }

  s.module_name = 'i18nOTAClient'
  s.source_files  = "**/*.swift"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
