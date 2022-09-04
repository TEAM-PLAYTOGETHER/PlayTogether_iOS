//
//  InputGenderBirthViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/05.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

class InputGenderBirthYearViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let headerLabel = UILabel().then {
        $0.text = "안전한 번개를 위해\n정보를 입력해주세요"
        $0.textColor = .ptBlack01
        $0.font = .pretendardRegular(size: 22)
        $0.numberOfLines = 0
        $0.addSpacingLabelText($0)
    }
    
    private let headerSubLabel = UILabel().then {
        $0.text = "아래 정보는 입력 완료 후 수정이 불가해요!"
        $0.textColor = .ptBlack02
        $0.font = .pretendardRegular(size: 14)
    }
    
    private let noticeGenderLabel = UILabel().then {
        $0.text = "성별"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let genderStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.clipsToBounds = true
        $0.spacing = 7
    }
    
    private lazy var maleButton = UIButton().then {
        $0.setTitle("남", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.setTitleColor(.ptGreen, for: .selected)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
        $0.isSelected = true
        $0.layer.cornerRadius = 10.0
        $0.setupSeletedGenderButtonUI(true)
    }
    
    private lazy var femaleButton = UIButton().then {
        $0.setTitle("여", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.setTitleColor(.ptGreen, for: .selected)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
        $0.layer.cornerRadius = 10.0
        $0.setupSeletedGenderButtonUI(false)
    }
    
    private let noticeBirthYearLabel = UILabel().then {
        $0.text = "태어난 연도"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let birthYearTextField = UITextField().then {
        $0.setupPlaceholderText(title: "태어난 연도 선택", color: .ptGray01)
        $0.textColor = .ptBlack02
        $0.font = .pretendardRegular(size: 14)
        $0.addLeftPadding()
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.cornerRadius = 10.0
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.setupBottomButtonUI(title: "완료", size: 15)
        $0.isButtonEnableUI(check: false)
    }
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: CheckTermsServiceViewController.self, action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(headerSubLabel)
        view.addSubview(noticeGenderLabel)
        view.addSubview(genderStackView)
        
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(femaleButton)
        
//        view.addSubview(maleButton)
//        view.addSubview(femaleButton)
        view.addSubview(noticeBirthYearLabel)
        view.addSubview(birthYearTextField)
        view.addSubview(confirmButton)
    }
    
    override func setupLayouts() {
        let height = UIScreen.main.bounds.height / 812
        
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(28)
            $0.leading.equalToSuperview().inset(20)
        }
        
        headerSubLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        noticeGenderLabel.snp.makeConstraints {
            $0.top.equalTo(headerSubLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(20)
        }
        
        genderStackView.snp.makeConstraints {
            $0.top.equalTo(noticeGenderLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(45 * height)
        }
        
        noticeBirthYearLabel.snp.makeConstraints {
            $0.top.equalTo(genderStackView.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        birthYearTextField.snp.makeConstraints {
            $0.top.equalTo(noticeBirthYearLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * height)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56 * height)
        }
    }
    
    override func setupBinding() {
        
    }
}
