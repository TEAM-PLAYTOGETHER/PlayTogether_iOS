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
        $0.progress = 0.5
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
    
    private let titleTextField = UITextField().then {
        $0.setupPlaceholderText(title: "동아리명 입력", color: .ptGray01)
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.autocorrectionType = .no
        $0.addLeftPadding()
    }
    
    private lazy var checkTitleButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.layer.cornerRadius = 5.0
        $0.backgroundColor = .ptGray03
        $0.isEnabled = false
    }
    
    private let noticeWrongTitleLabel = UILabel().then {
        $0.text = "1 ~ 15자(공백 포함) 한글, 영문, 숫자 사용 가능"
        $0.font = .pretendardMedium(size: 10)
        $0.textColor = .ptGray02
    }
    
    private let noticePassTitleLabel = UILabel().then {
        $0.text = "사용 가능한 동아리명입니다"
        $0.isHidden = true
        $0.font = .pretendardMedium(size: 12)
        $0.textColor = .ptCorrect
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = "한 줄 소개"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let introduceTextField = UITextField().then {
        $0.setupPlaceholderText(title: "한 줄 소개 입력(15자 이내)", color: .ptGray01)
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.autocorrectionType = .no
        $0.addLeftPadding()
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setupBottomButtonUI(title: "다음", size: 16)
        $0.isButtonEnableUI(check: false)
    }
    
    private var isEnableMeetingTitle = BehaviorRelay<Bool>(value: false)
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: CreateMeetViewController.self, action: nil)
    private let viewModel = CreateMeetViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
        
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(checkTitleButton)
        view.addSubview(noticeWrongTitleLabel)
        view.addSubview(noticePassTitleLabel)
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
        
        checkTitleButton.snp.makeConstraints {
            $0.top.bottom.equalTo(titleTextField).inset(13.5)
            $0.trailing.equalTo(titleTextField.snp.trailing).inset(16)
            $0.width.equalTo(67 * (UIScreen.main.bounds.width / 375))
        }
        
        noticeWrongTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
        }
        
        noticePassTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(24)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(noticePassTitleLabel.snp.bottom).offset(36)
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
            .asDriver()
            .drive(onNext: { [weak self] in
                guard OnboardingDataModel.shared.madeCrew == false else {
                    self?.navigationController?.pushViewController(SelfIntroduceViewController(), animated: true)
                    return
                }
                
                guard let title = self?.titleTextField.text,
                      let introduce = self?.introduceTextField.text
                else { return }
                
                OnboardingDataModel.shared.meetingTitle = title
                OnboardingDataModel.shared.introduceMessage = introduce
                
                let requestInput = CreateMeetViewModel.CreateMeetInput(
                    crewName: title,
                    description: introduce,
                    jwt: UserDefaults.standard.string(forKey: "accessToken") ?? ""
                )
                self?.viewModel.createMeetRequest(requestInput) { response in
                    OnboardingDataModel.shared.crewId = response.data?.id
                    OnboardingDataModel.shared.madeCrew = response.success
                    self?.navigationController?.pushViewController(SelfIntroduceViewController(), animated: true)
                }
                // FIXME: 동아리 만드는 오류 팝업 띄어주기 에러 참조
            })
            .disposed(by: disposeBag)
        
        leftButtonItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] in
                guard $0.count > 0 else {
                    self?.checkTitleButton.isEnabled = false
                    self?.checkTitleButton.backgroundColor = .ptGray03
                    return
                }
                self?.checkTitleButton.isEnabled = true
                self?.checkTitleButton.backgroundColor = .ptBlack01
                
                guard $0.count > 15 else { return }
                self?.titleTextField.text = String(self?.titleTextField.text?.dropLast() ?? "")
            }).disposed(by: disposeBag)
        
        titleTextField.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.noticePassTitleLabel.isHidden = true
                self?.noticeWrongTitleLabel.textColor = .ptGray02
                self?.isEnableMeetingTitle.accept(false)
            })
            .disposed(by: disposeBag)
        
        titleTextField.rx.controlEvent(.touchDown)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.titleTextField.layer.borderColor = UIColor.ptBlack02.cgColor
            }).disposed(by: disposeBag)

        titleTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let textCount = self?.titleTextField.text?.count else { return }
                guard textCount > 0 else {
                    self?.titleTextField.layer.borderColor = UIColor.ptGray03.cgColor
                    return
                }
                self?.titleTextField.layer.borderColor = UIColor.ptGray01.cgColor
            }).disposed(by: disposeBag)
        
        introduceTextField.rx.controlEvent(.touchDown)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.introduceTextField.layer.borderColor = UIColor.ptBlack02.cgColor
            }).disposed(by: disposeBag)
        
        introduceTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let textCount = self?.introduceTextField.text?.count else { return }
                guard textCount > 0 else {
                    self?.introduceTextField.layer.borderColor = UIColor.ptGray03.cgColor
                    return
                }
                self?.introduceTextField.layer.borderColor = UIColor.ptGray01.cgColor
            }).disposed(by: disposeBag)
        
        introduceTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] in
                guard $0.count > 15 else { return }
                self?.introduceTextField.text = String(self?.introduceTextField.text?.dropLast() ?? "")
            }).disposed(by: disposeBag)
        
        let regularExpressionInput = CreateMeetViewModel.RegularExpressionInput(meetingTitleText: titleTextField.rx.text.orEmpty.asObservable())
        let regularExpressionDriver = viewModel.regularExpressionCheck(input: regularExpressionInput)
        
        regularExpressionDriver.titleTextCheck
            .asDriver()
            .drive(onNext: { [weak self] in
                guard self?.titleTextField.text?.isEmpty == false else {
                    self?.noticeWrongTitleLabel.textColor = .ptGray02
                    self?.noticePassTitleLabel.isHidden = true
                    return
                }
                self?.noticeWrongTitleLabel.textColor = $0 ? .ptGray02 : .ptIncorrect
                self?.noticePassTitleLabel.isHidden = !$0
                self?.checkTitleButton.isEnabled = $0
                self?.checkTitleButton.backgroundColor = $0 ? .ptBlack01 : .ptGray03
                
            })
            .disposed(by: disposeBag)
        
        checkTitleButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.isEnableMeetingTitle.accept(true)
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        let isTextEmptyInput = CreateMeetViewModel.Input(checkMeetingTitle: isEnableMeetingTitle.asObservable(),
                                                        introduceText: introduceTextField.rx.text.orEmpty.asObservable())
        let isTextEmptyDriver = viewModel.isNextButtonEnable(input: isTextEmptyInput)
        
        isTextEmptyDriver.nextButtonEnableCheck
            .drive(onNext: { [weak self] in
                self?.nextButton.isButtonEnableUI(check: $0)
            })
            .disposed(by: disposeBag)
    }
}
