//
//  MyPageSubwayLabel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/28.
//

import UIKit

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    
    func setupPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
