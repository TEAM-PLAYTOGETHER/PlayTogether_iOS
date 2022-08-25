//
//  UILabel+Extension.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/24.
//

import UIKit

extension UILabel {
    func addSpacingLabelText(_ label: UILabel) {
        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
    }
}
