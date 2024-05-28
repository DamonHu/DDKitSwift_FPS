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
    guard let bundlePath = Bundle(for: FPSZXKit.self).path(forResource: "DDKitSwift_FPS", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

class FPSZXKit: NSObject {
    
}

//ZXKitPlugin
extension DDKitFPS: DDKitSwiftPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.zxkitFPS"
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
        self.start { (fps) in
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
}
