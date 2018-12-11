Pod::Spec.new do |s|
  s.name             = 'GPXParserSwift'
  s.version          = '0.0.1'
  s.summary          = 'Parse .gpx files easily'
  s.description      = <<-DESC
Parse for the .gpx file format entirely written in Swift
                       DESC

  s.homepage         = 'https://github.com/cyborgthefirst/GPXParserSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cyborgthefirst' => 'johannes@ebelingfs.de' }
  s.source           = { :git => 'https://github.com/cyborgthefirst/GPXParserSwift.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'GPXParserSwift/Classes/**/*'
  s.frameworks = 'MapKit'
end
