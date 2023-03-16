Pod::Spec.new do |s|
  s.name         = "DSFSecureTextField"
  s.version      = "2.0.0"
  s.summary      = "macOS secure password field with a 'visibility' button"
  s.description  = <<-DESC
    macOS secure password field with a 'visibility' button
  DESC
  s.homepage     = "https://github.com/dagronf"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Darren Ford" => "dford_au-reg@yahoo.com" }
  s.social_media_url   = ""
  s.osx.deployment_target = "10.11"
  s.source       = { :git => ".git", :tag => s.version.to_s }
  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/DSFSecureTextField/**/*.swift"
  end

  s.osx.framework  = 'AppKit'
  s.swift_version = "5.0"
end
