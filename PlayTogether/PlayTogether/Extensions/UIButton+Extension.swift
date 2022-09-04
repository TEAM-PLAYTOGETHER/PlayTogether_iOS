//
//  UIButton+Extension.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/30.
//

import UIKit

extension UIButton {
    func setupBottomButtonUI(title: String, size: CGFloat) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .pretendardSemiBold(size: size)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.setTitleColor(.ptBlack01, for: .normal)
        self.setTitleColor(.ptGray01, for: .disabled)
    }
    
    func isButtonEnableUI(check: Bool) {
        self.isEnabled = check
        self.backgroundColor = check ? .ptGreen : .ptGray03
        self.layer.borderColor = check ? UIColor.ptBlack01.cgColor : UIColor.ptGray02.cgColor
    }
    
    /// 성별 버튼 UI
    func setupSeletedGenderButtonUI(_ state: Bool) {
        guard state == true else {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.ptGray01.cgColor
            self.backgroundColor = .white
            return
        }
        self.layer.borderWidth = 0.0
        self.backgroundColor = .ptBlack01
    }
    
    /// 이용약관 버튼 이미지 세팅
    func setupToggleButtonUI() {
        self.setImage(.ptImage(.checkInActiveIcon), for: .normal)
        self.setImage(.ptImage(.checkActiveIcon), for: .selected)
    }
    
    /// 버튼에 밑줄
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
