//
//  CALayer+Extensions.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/23.
//

import UIKit

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.05,
        xValue: CGFloat = 0,
        yValue: CGFloat = -2,
        blur: CGFloat = 10,
        spread: CGFloat = 0
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xValue, height: yValue)
        shadowRadius = blur / 2.0
        
        guard spread != 0 else { shadowPath = nil; return }
        
        let dxValue = -spread
        let rect = bounds.insetBy(dx: dxValue, dy: dxValue)
        shadowPath = UIBezierPath(rect: rect).cgPath
    }
}
