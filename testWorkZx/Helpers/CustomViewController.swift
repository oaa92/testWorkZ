//
//  CustomViewController.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class CustomViewController<CustomView: UIView>: UIViewController {
    var customView: CustomView {
        return view as! CustomView
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func loadView() {
        view = CustomView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
}
