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
    case exitIcon = "exitIcon"
    
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
    
    case logoSelect = "logoSelect"
    case logoNotSelect = "logoNotSelect"
    case inactiveIcon = "inactiveIcon"
    case activeIcon = "activeIcon"
    case cameraIcon = "cameraIcon"
    case deleteIcon = "deleteIcon"
    
    case beforeIcon = "beforeIcon"
    case afterIcon = "afterIcon"
    case onboardingBottomImage = "OnboardingBottomImage"
    
    case profileIcon = "profileIcon"
    
    case likeFilledGrayIcon = "likeFilledGrayIcon"
    case likeFilledGreenIcon = "likeFilledGreenIcon"
    
    case navLikeDefaultIcon = "navLikeDefaultIcon"
    case navLikeFilledGreenIcon = "navLikeFilledGreenIcon"
    
    case arrowRightIcon = "arrowRightIcon"
    
    case clearIcon = "clearIcon"
}
