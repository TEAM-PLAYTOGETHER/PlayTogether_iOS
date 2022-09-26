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
    private let viewModel = InputGenderBirthYearViewModel()
    
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
        setupSeletedGenderButtonUI($0, true)
    }
    
    private lazy var femaleButton = UIButton().then {
        $0.setTitle("여", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.setTitleColor(.ptGreen, for: .selected)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
        $0.layer.cornerRadius = 10.0
        setupSeletedGenderButtonUI($0, false)
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
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.cornerRadius = 10.0
        $0.addLeftPadding()
    }
    
    private var textFieldRightImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.image = .ptImage(.calendarInActiveIcon)
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.setupBottomButtonUI(title: "완료", size: 15)
        $0.isButtonEnableUI(check: false)
    }
    
    private lazy var yearPickerView = UIPickerView().then {
        $0.backgroundColor = .white
        $0.tintColor = .clear
    }
    
    private var yearList: [Int] = []
    private var userGender: String = "남"
    private var userBirthYear: Int = 0
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: CheckTermsServiceViewController.self, action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(headerSubLabel)
        view.addSubview(noticeGenderLabel)
        view.addSubview(genderStackView)
        
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(femaleButton)
        
        view.addSubview(noticeBirthYearLabel)
        view.addSubview(birthYearTextField)
        view.addSubview(textFieldRightImageView)
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
        
        textFieldRightImageView.snp.makeConstraints {
            $0.centerY.equalTo(birthYearTextField)
            $0.trailing.equalTo(birthYearTextField.snp.trailing).inset(18.2)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56 * height)
        }
    }
    
    override func setupBinding() {
        setupYearData()
        
        leftButtonItem.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        maleButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let buttonState = self?.maleButton.isSelected else { return }
                guard let self = self else { return }
                guard self.maleButton.isSelected == false else { return }
                self.setupSeletedGenderButtonUI(self.maleButton, !buttonState)
                self.setupSeletedGenderButtonUI(self.femaleButton, buttonState)
                self.userGender = "남"
            })
            .disposed(by: disposeBag)
        
        femaleButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let buttonState = self?.femaleButton.isSelected else { return }
                guard let self = self else { return }
                guard self.femaleButton.isSelected == false else { return }
                self.setupSeletedGenderButtonUI(self.femaleButton, !buttonState)
                self.setupSeletedGenderButtonUI(self.maleButton, buttonState)
                self.userGender = "여"
            })
            .disposed(by: disposeBag)
        
        birthYearTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: {[weak self] in
                guard $0.count > 0 else {
                    self?.textFieldRightImageView.image = .ptImage(.calendarInActiveIcon)
                    self?.confirmButton.isButtonEnableUI(check: false)
                    self?.birthYearTextField.layer.borderColor = UIColor.ptGray03.cgColor
                    return
                }
                self?.textFieldRightImageView.image = .ptImage(.calendarActiveIcon)
                self?.confirmButton.isButtonEnableUI(check: true)
                self?.birthYearTextField.layer.borderColor = UIColor.ptGray01.cgColor
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let gender = self?.userGender else { return }
                guard let year = self?.userBirthYear else { return }
                
                let userInfoInput = InputGenderBirthYearViewModel
                    .updateUserInfoInput(userGender: gender, userBirthYear: year)
                
                self?.viewModel.updateUserInfo(userInfoInput) {
                    guard $0 == true else { return }
                    self?.navigationController?.pushViewController(OnboardingViewController(), animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension InputGenderBirthYearViewController {
    func configureNavBar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func setupSeletedGenderButtonUI(_ button: UIButton ,_ state: Bool) {
        button.isSelected = state
        guard state == true else {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.ptGray01.cgColor
            button.backgroundColor = .white
            return
        }
        button.layer.borderWidth = 0.0
        button.backgroundColor = .ptBlack01
    }
}

// MARK: Setup Picker View
private extension InputGenderBirthYearViewController {
    func setupYearData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        guard let intCurrentYear = Int(dateFormatter.string(from: Date())) else { return }
        
        for year in 1900...intCurrentYear {
            yearList.append(year)
        }
        
        _ = Observable.just(yearList)
            .bind(to: yearPickerView.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        setupPickerView()
    }
    
    func setupPickerView() {
        guard let defaultIndex = yearList.firstIndex(of: 2000) else { return }
        yearPickerView.selectRow(defaultIndex, inComponent: 0, animated: true)
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancleButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
        let acceptButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
        
        acceptButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let selectedIndex = self?.yearPickerView.selectedRow(inComponent: 0) else { return }
                guard let year = self?.yearList[selectedIndex] else { return }
                self?.userBirthYear = year
                self?.birthYearTextField.text = String(describing: year)
                self?.birthYearTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        cancleButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        let toolBar = UIToolbar().then {
            $0.sizeToFit()
            $0.setItems([cancleButton, flexible, acceptButton], animated: false)
        }
        
        birthYearTextField.rx.inputAccessoryView.onNext(toolBar)
        birthYearTextField.rx.inputView.onNext(yearPickerView)
    }
}
