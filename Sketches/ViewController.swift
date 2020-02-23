//
//  ViewController.swift
//  Sketches
//
//  Created by Tomoyuki Iwami on 2020/02/23.
//  Copyright © 2020 Tomoyuki Iwami. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    var canvasView: SketchView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canvasView = SketchView(frame: self.view.bounds)
        self.view.addSubview(canvasView!)
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 8)
        title.textAlignment = .center
        title.text = "Let's draw"
        title.textColor = UIColor.black
        self.view.addSubview(title)
    }
}
