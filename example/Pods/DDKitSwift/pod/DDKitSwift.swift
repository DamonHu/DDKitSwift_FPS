//
//  DDKitSwift.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit
import DDUtils
import DDLoggerSwift

extension String{
    var ZXLocaleString: String {
        guard let bundlePath = Bundle(for: DDKitSwift.self).path(forResource: "DDKitSwift", ofType: "bundle") else { return NSLocalizedString(self, comment: "") }
        guard let bundle = Bundle(path: bundlePath) else { return NSLocalizedString(self, comment: "") }
        let msg = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return msg
    }
}

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: DDKitSwift.self).path(forResource: "DDKitSwift", ofType: "bundle") else { return UIImage(named: name) }
    guard let bundle = Bundle(path: bundlePath) else { return UIImage(named: name) }
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

public extension NSNotification.Name {
    static let DDKitSwiftPluginRegist = NSNotification.Name("DDKitSwiftPluginRegist")
    static let DDKitSwiftShow = NSNotification.Name("DDKitSwiftShow")
    static let DDKitSwiftHide = NSNotification.Name("DDKitSwiftHide")
    static let DDKitSwiftClose = NSNotification.Name("DDKitSwiftClose")
}

public class DDKitSwift: NSObject {
    public static var UIConfig = DDKitSwiftUIConfig()
    public static let DebugFolderPath = DDUtils.shared.createFileDirectory(in: .caches, directoryName: "zxkit")

    //MARK: Private
    private static var hasConfig = false
    private static var window: DDKitSwiftWindow?
    internal static var floatWindow: DDKitSwiftFloatWindow?
    private static var floatChangeTimer: Timer?     //悬浮按钮的修改
    private static var changeQueue = [(DDKitSwiftButtonConfig, DDKitSwiftPluginProtocol)]() //悬浮按钮修改的队列
    static var pluginList = [[DDKitSwiftPluginProtocol](), [DDKitSwiftPluginProtocol](), [DDKitSwiftPluginProtocol]()]
}

public extension DDKitSwift {
    static func regist(plugin: DDKitSwiftPluginProtocol) {
        if !hasConfig {
            self._initConfig()
        }
        var index = 0
        switch plugin.pluginType {
            case .ui:
                index = 0
            case .data:
                index = 1
            case .other:
                index = 2
        }
        if !self.pluginList[index].contains(where: { (tPlugin) -> Bool in
            return tPlugin.pluginIdentifier == plugin.pluginIdentifier
        }) {
            self.pluginList[index].append(plugin)
            plugin.didRegist()
        }
        if let window = self.window, !window.isHidden {
            DispatchQueue.main.async {
                window.reloadData()
            }
        }
        NotificationCenter.default.post(name: .DDKitSwiftPluginRegist, object: self.pluginList)
    }

    static func show() {
        if !hasConfig {
            self._initConfig()
        }
        NotificationCenter.default.post(name: .DDKitSwiftShow, object: nil)
        DispatchQueue.main.async {
            self.floatWindow?.isHidden = true
            if let window = self.window {
                window.isHidden = false
            } else {
                if #available(iOS 13.0, *) {
                    for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                        if windowScene.activationState == .foregroundActive {
                            self.window = DDKitSwiftWindow(windowScene: windowScene)
                            self.window?.frame = UIScreen.main.bounds
                        }
                    }
                }
                if self.window == nil {
                    self.window = DDKitSwiftWindow(frame: UIScreen.main.bounds)
                }
                self.window?.isHidden = false
                self.window?.reloadData()
            }
        }
    }

    static func hide() {
        NotificationCenter.default.post(name: .DDKitSwiftHide, object: nil)
        DispatchQueue.main.async {
            self.window?.isHidden = true
            //float window
            if let window = self.floatWindow {
                window.isHidden = false
            } else {
                if #available(iOS 13.0, *) {
                    for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                        if windowScene.activationState == .foregroundActive {
                            self.floatWindow = DDKitSwiftFloatWindow(windowScene: windowScene)
                            self.floatWindow?.frame = CGRect(x: UIScreen.main.bounds.size.width - 80, y: 100, width: 60, height: 60)
                        }
                    }
                }
                if self.floatWindow == nil {
                    self.floatWindow = DDKitSwiftFloatWindow(frame: CGRect(x: UIScreen.main.bounds.size.width - 80, y: 100, width: 60, height: 60))
                }
                self.floatWindow?.isHidden = false
            }
        }
    }

    static func close() {
        NotificationCenter.default.post(name: .DDKitSwiftClose, object: nil)
        DispatchQueue.main.async {
            self.window?.isHidden = true
            self.floatWindow?.isHidden = true
            self.floatWindow?.menuButtonType = .default
            self.floatChangeTimer?.invalidate()
            self.floatChangeTimer = nil
        }
    }
    
    static func updateFloatButton(config: DDKitSwiftButtonConfig, plugin: DDKitSwiftPluginProtocol) {
        if let last = self.changeQueue.last, last.0 == config, last.1.pluginIdentifier == plugin.pluginIdentifier {
            //如果和最后一次重复就不再添加
            return
        }
        self.changeQueue.append((config, plugin))
        //更新
        self._floatButtonChange()
    }
    
    static func getCurrentNavigationVC() -> UINavigationController? {
        return self.window?.currentNavVC
    }
}

private extension DDKitSwift {
    static func _initConfig() {
        if hasConfig {
            return
        }
        self.hasConfig = true
        //初始化内置插件
        self.regist(plugin: DDLoggerSwift.shared)
    }
    
    static func _floatButtonChange() {
        guard let firstQueue = self.changeQueue.first else { return }
        if let floatWindow = self.floatWindow {
            if self.floatChangeTimer == nil {
                self.floatChangeTimer = Timer(timeInterval: 2, repeats: true, block: { timer in
                    DispatchQueue.main.async {
                        if self.changeQueue.isEmpty {
                            //队列已循环完毕
                            floatWindow.menuButtonType = .default
                            self.floatChangeTimer?.invalidate()
                            self.floatChangeTimer = nil
                        } else {
                            floatWindow.menuButtonType = .info(config: firstQueue.0, image: firstQueue.1.pluginIcon)
                            self.changeQueue.removeFirst()
                        }
                    }
                })
                RunLoop.main.add(self.floatChangeTimer!, forMode: .common)
                self.floatChangeTimer?.fire()
            }
        }
    }
}
