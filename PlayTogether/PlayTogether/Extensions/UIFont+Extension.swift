//
//  UIFont+Extension.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import UIKit

extension UIFont {
    static func pretendardRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendardBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendardSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendardMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
