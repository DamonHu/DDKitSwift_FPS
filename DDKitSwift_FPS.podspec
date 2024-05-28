Pod::Spec.new do |s|
s.name = 'DDKitSwift_FPS'
s.swift_version = '5.0'
s.version = '3.0.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'FPS plugin for ZXKit. build by fps'
s.homepage = 'https://github.com/DamonHu/DDKitSwift_FPS'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/DDKitSwift_FPS.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.resource_bundles = {
    'DDKitSwift_FPS' => ['pod/assets/**/*']
}
s.source_files = "pod/*.swift"
s.dependency 'DDKitSwift/core', '~> 3.0.0'
s.dependency 'DDKitFPS', '~> 3.0.0'
s.documentation_url = 'https://blog.hudongdong.com/ios/1169.html'
end
