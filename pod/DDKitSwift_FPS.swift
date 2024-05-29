//
//  ZXKitFPS+zxkit.swift
//  ZXKitFPS
//
//  Created by Damon on 2021/4/27.
//

import Foundation
import DDKitFPS
import DDKitSwift

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: DDKitSwift_FPS.self).path(forResource: "DDKitSwift_FPS", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}


//ZXKitPlugin
open class DDKitSwift_FPS: DDKitSwiftPluginProtocol {
    private var fps = DDKitFPS()
    
    public init() {
        
    }
    
    public var pluginIdentifier: String {
        return "com.ddkit.DDKitSwift_FPS"
    }
    
    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "logo")
    }
    
    public var pluginTitle: String {
        return NSLocalizedString("FPS", comment: "")
    }
    
    public var pluginType: DDKitSwiftPluginType {
        return .ui
    }
    
    public func start() {
        DDKitSwift.hide()
        self.fps.start { (fps) in
            var backgroundColor = UIColor.dd.color(hexValue: 0xaa2b1d)
            if fps >= 55 {
                backgroundColor = UIColor.dd.color(hexValue: 0x5dae8b)
            } else if (fps >= 50 && fps < 55) {
                backgroundColor = UIColor.dd.color(hexValue: 0xf0a500)
            }
            let config = DDKitSwiftButtonConfig(title: "\(fps)FPS", titleColor: UIColor.dd.color(hexValue: 0xffffff), titleFont: UIFont.systemFont(ofSize: 13, weight: .bold), backgroundColor: backgroundColor)
            DDKitSwift.updateFloatButton(config: config, plugin: self)
        }
    }
    
    public var isRunning: Bool {
        return self.fps.isRunning
    }
    
    public func stop() {
        self.fps.stop()
    }
}
