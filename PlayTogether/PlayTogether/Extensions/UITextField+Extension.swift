//
//  UITextField+Extension.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/20.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: self.frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
    
    func setupPlaceholderText(title: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
