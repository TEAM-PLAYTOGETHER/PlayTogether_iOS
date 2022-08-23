//
//  UILabel + Extension.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/12.
//

import Foundation
import UIKit

extension UILabel {
    /// 특정 글자색 변경
    func changeFontColor(targetString: String) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        let font = UIFont.pretendardRegular(size: 14)
        let color = UIColor.ptGreen
        attributedString.addAttributes([.font: font, .foregroundColor: color], range: range)
        attributedText = attributedString
    }
}
