Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.name = "Swifty3Mesh"
  s.summary = "Swifty3Mesh allows a user to connect as central node in TW Bluetooth Mesh"
  s.requires_arc = true
 
  s.version = "v1.0"
 
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  s.author = { "Shea Clark-Tieche" => "sclarkti@thoughtworks.com" }
 
  s.homepage = "https://github.com/sclark01/Swifty3Mesh"
 
  s.source = { :git => "https://github.com/sclark01/Swifty3Mesh.git", :tag => "#{s.version}"}
 
  s.framework = "Foundation"
  s.framework = "CoreBluetooth"
 
  s.source_files = "Swifty3Mesh/Swifty3Mesh/*.{swift}"
 
end

