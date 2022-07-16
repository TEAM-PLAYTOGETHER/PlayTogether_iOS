//
//  OnboardingViewModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import Foundation
import UIKit


struct OnboardingViewModel {
    
}


extension OnboardingViewModel {
    var numberOfItemsInSection: Int {
        return 2
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return section
    }
    
    func sizeForItemAt(_ viewWidth: CGFloat, _ viewHeight: CGFloat) -> CGSize {
        let height = 86 * (viewHeight / 812)
        return CGSize(width: viewWidth, height: height)
    }
    
    func cellWasTapped(_ count: Int) -> Bool {
        return count == 1
    }
}
