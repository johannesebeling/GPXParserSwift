Pod::Spec.new do |s|
  s.name             = "GPXParserSwift"
  s.version          = "1.1.0"
  s.summary          = "Parse .gpx files easily"
  s.description      = <<-DESC
Parse for the .gpx file format entirely written in Swift
                       DESC
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.homepage         = "https://github.com/cyborgthefirst/GPXParserSwift"
  s.author           = { "cyborgthefirst" => "johannes@ebelingfs.de" }
  s.source           = { :git => 'https://github.com/cyborgthefirst/GPXParserSwift.git', :tag => s.version }

  s.swift_version = "5.0"
  s.ios.deployment_target = "8.0"

  s.source_files = "Sources/GPXParserSwift/**/*"
end
