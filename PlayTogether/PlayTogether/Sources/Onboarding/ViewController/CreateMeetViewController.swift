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
        $0.font = .pretendardMedium(size: 12)
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
            .subscribe(onNext: { [weak self] in
                guard $0.count > 15 else { return }
                self?.titleTextField.text = String(self?.titleTextField.text?.dropLast() ?? "")
            }).disposed(by: disposeBag)
        
        introduceTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] in
                guard $0.count > 15 else { return }
                self?.introduceTextField.text = String(self?.introduceTextField.text?.dropLast() ?? "")
            }).disposed(by: disposeBag)
        
        let input = CreateMeetViewModel.RegularExpressionInput(meetingTitleText: titleTextField.rx.text.orEmpty.asObservable())
        let output = viewModel.regularExpressionCheck(input: input)
        var isTitleValid = false
        
        output.titleTextCheck
            .drive(onNext: { [weak self] in
                guard self?.titleTextField.text?.isEmpty == false else {
                    self?.noticeTitleLabel.text = "1~15(공백포함) 이내 한글, 영문, 숫자 사용 가능"
                    self?.noticeTitleLabel.textColor = .ptGray02
                    return
                }
                isTitleValid = $0
                self?.noticeTitleLabel.text = $0 ? "사용 가능한 동아리명입니다" : "한글, 영문, 숫자만 사용 가능합니다"
                self?.noticeTitleLabel.textColor = $0 ? .ptCorrect : .ptIncorrect
            }).disposed(by: disposeBag)
        
        let isTextEmpty = CreateMeetViewModel.Input(meetingTitleText: titleTextField.rx.text.orEmpty.asObservable(),
                                                        introduceText: introduceTextField.rx.text.orEmpty.asObservable())
        let isTextEmptyOutput = viewModel.isTextEmpty(input: isTextEmpty)
        
        isTextEmptyOutput.isTextEmpty
            .drive(onNext: { [weak self] in
                self?.nextButton.isEnabled = $0 && isTitleValid
                self?.nextButton.backgroundColor = $0 && isTitleValid ? .ptGreen : .ptGray03
                self?.nextButton.layer.borderColor = $0 && isTitleValid ? UIColor.ptBlack01.cgColor : UIColor.ptGray02.cgColor
            }).disposed(by: disposeBag)
    }
}




