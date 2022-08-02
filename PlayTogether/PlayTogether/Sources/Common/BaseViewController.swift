//
//  BaseViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import UIKit
import SnapKit
import Then

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        setupViews()
        setupLayouts()
        setupBinding()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    
    func setupViews() {}
    
    func setupLayouts() {}
    
    func setupBinding() {}
}
