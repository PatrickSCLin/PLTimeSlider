Pod::Spec.new do |s|

  s.name          = "PLTimeSlider"
  s.version       = "0.0.2"
  s.summary       = "Simple custom time slider by Swift."
  s.homepage      = "https://github.com/PatrickSCLin/PLTimeSlider"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Patrick Lin" => "patricksclin@gmail.com" }
  s.platform      = :ios, "9.0"
  s.source        = { :git => "https://github.com/PatrickSCLin/PLTimeSlider.git", :tag => "0.0.1" }
  s.source_files  = Dir['PLTimeSlider/*']
  s.requires_arc  = true
  
end