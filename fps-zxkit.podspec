Pod::Spec.new do |s|
s.name = 'fps-zxkit'
s.swift_version = '5.0'
s.version = '2.0.1'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'FPS plugin for ZXKit. build by fps'
s.homepage = 'https://github.com/ZXKitCode/fps-zxkit'
s.authors = { 'ZXKitCode' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/ZXKitCode/fps-zxkit.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.resource_bundles = {
    'fps-zxkit' => ['pod/assets/**/*']
}
s.source_files = "pod/zxkit/*.swift"
s.dependency 'ZXKitCore', '~> 2.0'
s.dependency 'ZXKitFPS', '~> 2.0'
s.documentation_url = 'https://blog.hudongdong.com/ios/1169.html'
end
