//
//  ShareExtensionView.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/24.
//

import UIKit

class ShareExtensionView: UIView {
    private let thunTitleLabel = UILabel().then {
        $0.text = OnboardingDataModel.shared.meetingTitle
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 20)
    }
    
    private let noticeIntroduceLabel = UILabel().then {
        $0.text = "한줄소개"
        $0.textColor = .ptGray01
        $0.font = .pretendardRegular(size: 14)
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = OnboardingDataModel.shared.introduceMessage
        $0.textColor = .ptBlack01
        $0.font = .pretendardMedium(size: 14)
    }
    
    private let noticeInvatationCodeLable = UILabel().then {
        $0.text = "초대코드"
        $0.textColor = .ptGray01
        $0.font = .pretendardRegular(size: 14)
    }
    
    private let invatationCodeLabel = UILabel().then {
        $0.text = OnboardingDataModel.shared.inviteCode
        $0.textColor = .ptBlack01
        $0.font = .pretendardMedium(size: 14)
    }
    
    private lazy var shareButton = UIButton().then {
        $0.setTitle("초대코드 공유하기", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
        $0.backgroundColor = .white
    }
    
    // TODO: 개설 완료 뷰 구현
}
