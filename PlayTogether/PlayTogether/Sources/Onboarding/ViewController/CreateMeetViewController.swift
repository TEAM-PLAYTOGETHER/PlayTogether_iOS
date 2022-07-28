//
//  CreateMeetViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/19.
//

import UIKit
import RxSwift
import RxCocoa

class CreateMeetViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 0.67
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        $0.text = "개설할 동아리를\n소개해주세요!"
        $0.font = .pretendardMedium(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "동아리명"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private lazy var titleTextField = UITextField().then {
        $0.placeholder = "동아리명 입력"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.autocorrectionType = .no
        $0.addLeftPadding()
        
    }
    
    private let noticeTitleLabel = UILabel().then {
        $0.text = "1~15(공백포함) 이내 한글, 영문, 숫자 사용 가능"
        $0.font = .pretendardMedium(size: 12)
        $0.textColor = .ptGray02
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = "한 줄 소개"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private lazy var introduceTextField = UITextField().then {
        $0.placeholder = "한 줄 소개 입력(15자 이내)"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.autocorrectionType = .no
        $0.addLeftPadding()
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold(size: 16)
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.setTitleColor(.ptGray01, for: .disabled)
    }
    
    let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: CreateMeetViewController.self, action: nil)
    let viewModel = CreateMeetViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    private func nextButtonDidTap() {
        guard let title = titleTextField.text else { return }
        guard let introduce = introduceTextField.text else { return }
        OnboardingDataModel.shared.meetingTitle = title
        OnboardingDataModel.shared.introduceMessage = introduce
        print("DEBUG: titleTextField.text: \(title), introduceTextField.text: \(introduce))")
    }
        
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(noticeTitleLabel)
        view.addSubview(introduceLabel)
        view.addSubview(introduceTextField)
        view.addSubview(nextButton)
    }
    
    override func setupLayouts() {
        progressbar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(4)
        }
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalTo(view).offset(20)
            $0.top.equalTo(progressbar.snp.bottom).offset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * (view.frame.height / 812))
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(24)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * (view.frame.height / 812))
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56 * view.frame.height/812)
        }
    }
    
    override func setupBinding() {
        nextButton.rx.tap
            .bind { [weak self] in
                self?.nextButtonDidTap()
            }.disposed(by: disposeBag)
        
        leftButtonItem.rx.tap
            .bind { [weak self] in
                self?.backButtonDidTap()
            }.disposed(by: disposeBag)
    
        titleTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.meetingTitleText)
            .disposed(by: disposeBag)
        
        titleTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] in
                guard $0.count < 16 else {
                    self?.titleTextField.text = String(self?.introduceTextField.text?.dropLast() ?? "")
                    return
                }
            }).disposed(by: disposeBag)
        
        introduceTextField.rx.text
            .orEmpty
            .bind(to: viewModel.Input.introduceText)
            .disposed(by: disposeBag)
        
        introduceTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] in
                guard $0.count < 16 else {
                    self?.introduceTextField.text = String(self?.introduceTextField.text?.dropLast() ?? "")
                    return
                }
            }).disposed(by: disposeBag)

        let output = viewModel.checkNextButtonStatus(input: input)
        
        output.isEnableNextButton
            .drive(onNext: { [weak self] in
                self?.nextButton.isEnabled = $0
                self?.nextButton.backgroundColor = $0 ? .ptGreen : .ptGray03
                self?.nextButton.layer.borderColor = $0 ? UIColor.ptBlack01.cgColor : UIColor.ptGray02.cgColor
            }).disposed(by: disposeBag)
    }
}


//guard $0.count < 16 else { "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$"
//    self?.introduceTextField.text = String(self?.introduceTextField.text?.dropLast() ?? "")
//    return
//}
//$0.isEmpty ? self?.fillIntroduceCheck.onNext(false) : self?.fillIntroduceCheck.onNext(true)




