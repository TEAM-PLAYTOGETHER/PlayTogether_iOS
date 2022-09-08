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
    case loginCenterIcon = "loginCenterIcon"
    case backIcon = "backIcon"
    case floatingIcon = "floatingIcon"
    case searchIcon = "searchIcon"
    case showIcon = "showIcon"
    case plusIcon = "plus"
    case exitIcon = "exitIcon"
    case seletedIcon = "selectedIcon"
    
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
    case dottedLineImage = "dottedLineImage"
    
    case profileIcon = "profileIcon"
    
    case likeFilledGrayIcon = "likeFilledGrayIcon"
    case likeFilledGreenIcon = "likeFilledGreenIcon"
    
    case navLikeDefaultIcon = "navLikeDefaultIcon"
    case navLikeFilledGreenIcon = "navLikeFilledGreenIcon"
    
    case arrowRightIcon = "arrowRightIcon"
    
    case kakaoLoginIcon = "kakaoIcon"
    case appleLoginIcon = "appleIcon"
    
    case checkActiveIcon = "checkActiveIcon"
    case checkInActiveIcon = "checkInActiveIcon"
    
<<<<<<< HEAD
    case calendarInActiveIcon = "calendarInActiveIcon"
    case calendarActiveIcon = "calendarActiveIcon"
    
=======
>>>>>>> 1dc734aba1808ec0622b906197ee0d6c1af1332a
    case settingIcon = "settingIcon"
    case showIconBlack = "showIconBlack"
    case introduceLabelIcon = "introduceLabelIcon"
    case clearIcon = "clearIcon"
    case optionIcon = "optionIcon"
}
