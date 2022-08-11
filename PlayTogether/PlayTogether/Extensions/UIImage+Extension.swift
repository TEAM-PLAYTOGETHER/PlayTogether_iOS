//
//  UIImage+Extension.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/18.
//

import UIKit

extension UIImage {
    static func ptImage(_ imageCase: ImageCase) -> UIImage {
        guard let image = UIImage(named: imageCase.rawValue) else { return UIImage() }
        return image
    }
}

enum ImageCase: String {
    case backIcon = "backIcon"
    case floatingIcon = "floatingIcon"
    case searchIcon = "searchIcon"
    case showIcon = "showIcon"
    case plusIcon = "plus"
    
    case homeActive = "homeActive"
    case homeInactive = "homeInactive"
    case thunActive = "thunActive"
    case thunInactive = "thunInactive"
    case chatActive = "chatActive"
    case chatInactive = "chatInactive"
    case mypageActive = "mypageActive"
    case mypageInactive = "mypageInactive"
    
    case eatIcon = "eatIcon"
    case goIcon = "goIcon"
    case doIcon = "doIcon"
}
