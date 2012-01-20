Pod::Spec.new do |s|
  s.name     = 'NLCoreData'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'Library that wraps Core Data for iOS for easier and more readable operations.'
  s.homepage = 'https://www.github.com/jksk/NLCoreData'
  s.author   = { 'Jesper Skrufve' => 'jesper@neolo.gy' }
  s.source   = { :git => 'https://github.com/jksk/NLCoreData.git', :tag => '0.1.0' }
  s.platform = :ios
  s.source_files = 'NLCoreDataExample/NLCoreData'
  s.framework = 'CoreData'
  s.requires_arc = true
end
