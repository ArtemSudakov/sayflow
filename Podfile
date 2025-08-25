# Uncomment the next line to define a global platform for your project
# platform :ios, '15.5'
platform :ios, '16'

use_frameworks!

target 'SayFlow' do

  pod 'GoogleMLKit/TextRecognition'
  pod 'GoogleMLKit/LanguageID'
  pod 'GoogleMLKit/Translate'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end