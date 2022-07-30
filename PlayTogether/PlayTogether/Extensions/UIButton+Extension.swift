//
//  UIButton+Extension.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/30.
//

import UIKit

extension UIButton {
    func setupBottomButtonUI(title: String) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .pretendardSemiBold(size: 16)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.setTitleColor(.ptBlack01, for: .normal)
        self.setTitleColor(.ptGray01, for: .disabled)
    }
}
