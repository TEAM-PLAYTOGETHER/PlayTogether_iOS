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
    
    case calendarInActiveIcon = "calendarInActiveIcon"
    case calendarActiveIcon = "calendarActiveIcon"
    
    case settingIcon = "settingIcon"
    case showIconBlack = "showIconBlack"
    case introduceLabelIcon = "introduceLabelIcon"
    case clearIcon = "clearIcon"
    case optionIcon = "optionIcon"
    case cancleIcon = "cancleIcon"
    
    // Subway Icon
    case firstLine = "sub_line1"
    case secondLine = "sub_line2"
    case thirdLine = "sub_line3"
    case fourthLine = "sub_line4"
    case fifthLine = "sub_line5"
    case sixthLine = "sub_line6"
    case seventhLine = "sub_line7"
    case eighthLine = "sub_line8"
    case ninthLine = "sub_ninthLine"
    
    case airportLine = "sub_Airport"
    case everLine = "sub_Everline"
    case gimpogoldLine = "sub_GimpoGold"
    case gyeongchunLine = "sub_Gyeongchun"
    case gyeonggangLine = "sub_Gyeonggang"
    case incheon1Line = "sub_Incheon1"
    case incheon2Line = "sub_Incheon2"
    case shinbundangLine = "sub_Shinbundang"
    case sinlimLine = "sub_Sinlim"
    case suinbundangLine = "sub_Suinbundang"
    case uijeongbuLine = "sub_Uijeongbu"
    case westseaLine = "sub_WestSea"
    case wooishinseolLine = "sub_WooiShinseol"
    case woouiLine = "sub_Wooui"
    case gyeonguiCenterLine = "sub_GyeonguiCenter"
}
