//
//  ShareExtensionView.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/24.
//

import UIKit
import RxSwift

protocol shareExtensionProtocol: class {
    func shareButtonDidTap()
}

class ShareExtensionView: UIView {
    private let disposeBag = DisposeBag()
    weak var delegate: shareExtensionProtocol?
    
    private let thunTitleLabel = UILabel().then {
        $0.text = OnboardingDataModel.shared.meetingTitle ?? "동아리명"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 20)
    }
    
    private let noticeIntroduceLabel = UILabel().then {
        $0.text = "한줄소개"
        $0.textColor = .ptGray01
        $0.font = .pretendardRegular(size: 14)
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = OnboardingDataModel.shared.introduceMessage ?? "한 줄 소개"
        $0.textColor = .ptBlack01
        $0.font = .pretendardMedium(size: 14)
    }
    
    private let noticeInvatationCodeLable = UILabel().then {
        $0.text = "초대코드"
        $0.textColor = .ptGray01
        $0.font = .pretendardRegular(size: 14)
    }
    
    private let invatationCodeLabel = UILabel().then {
        $0.text = OnboardingDataModel.shared.inviteCode ?? "초대코드"
        $0.textColor = .ptBlack01
        $0.font = .pretendardMedium(size: 14)
    }
    
    private let dottedLineImageView = UIImageView().then {
        $0.image = .ptImage(.dottedLineImage)
        $0.backgroundColor = .white
    }
    
    private lazy var shareButton = UIButton().then {
        $0.setTitle("초대코드 공유하기", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
        $0.layer.cornerRadius = 10.0
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ShareExtensionView {
    func setupView() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.ptBlack01.cgColor
        layer.cornerRadius = 10.0
        
        addSubview(thunTitleLabel)
        addSubview(noticeIntroduceLabel)
        addSubview(introduceLabel)
        addSubview(noticeInvatationCodeLable)
        addSubview(invatationCodeLabel)
        addSubview(dottedLineImageView)
        addSubview(shareButton)
        
        setupLayout()
    }
    
    func setupLayout() {
        thunTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        noticeIntroduceLabel.snp.makeConstraints {
            $0.top.equalTo(thunTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.centerY.equalTo(noticeIntroduceLabel.snp.centerY)
            $0.leading.equalTo(noticeIntroduceLabel.snp.trailing).offset(10)
        }
        
        noticeInvatationCodeLable.snp.makeConstraints {
            $0.top.equalTo(noticeIntroduceLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        invatationCodeLabel.snp.makeConstraints {
            $0.centerY.equalTo(noticeInvatationCodeLable.snp.centerY)
            $0.leading.equalTo(noticeInvatationCodeLable.snp.trailing).offset(10)
        }
        
        dottedLineImageView.snp.makeConstraints {
            $0.top.equalTo(noticeInvatationCodeLable.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(dottedLineImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(45 * (UIScreen.main.bounds.height / 812))
        }
    }
    
    func setupBinding() {
        shareButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.shareButtonDidTap()
            })
            .disposed(by: disposeBag)
    }
}
