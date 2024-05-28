//
//  ViewController.swift
//  DDKitSwift_FPS
//
//  Created by Damon on 2023/4/14.
//

import UIKit
import DDKitSwift
import DDKitFPS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DDKitSwift.regist(plugin: DDKitFPS())
        self._createUI()
    }
}

extension ViewController {
    func _createUI() {
        self.view.backgroundColor = UIColor.white
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        button.setTitle("open debug tool", for: .normal)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(_click), for: .touchUpInside)
    }

    @objc func _click() {
        DDKitSwift.show()
    }
}
