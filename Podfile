# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

# This line is needed until OGVKit is fully published to CocoaPods
# Remove once packages published:
source 'https://github.com/brion/OGVKit-Specs.git'

target 'Lennach' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lennach
  pod 'Alamofire'
  pod 'Kingfisher' #imagff=es
  pod 'OGVKit/WebM'
  pod 'Toaster'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'USE_ALLOCA', 'OPUS_BUILD']
        end
    end
end

  target 'LennachTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LennachUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
