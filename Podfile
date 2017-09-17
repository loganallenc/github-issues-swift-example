platform :ios, '9.0'
use_frameworks!

target 'GithubIssuesApp' do

pod 'RxSwift'
pod 'RxCocoa'
pod 'Moya/RxSwift'
pod 'Moya-ObjectMapper/RxSwift'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
              config.build_settings['ENABLE_TESTABILITY'] = 'YES'
              config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
