//
//  InvitationCodeViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/30.
//

import UIKit
import RxSwift
import RxCocoa

class InvitationCodeViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 0.67
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        $0.text = "초대코드를\n입력해주세요!"
        $0.font = .pretendardMedium(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
    }
    
    private let headerSubLabel = UILabel().then {
        $0.text = "여섯 자리 코드를 입력해주세요"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptGray02
        $0.numberOfLines = 0
    }
    
    private let inputCodeTextField = UITextField().then {
        $0.font = .pretendardRegular(size: 16)
        $0.textColor = .ptBlack01
        $0.textAlignment = .center
        $0.setupPlaceholderText(title: "대문자 6자리 입력", color: .ptGray01)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .allCharacters
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private lazy var participationButton = UIButton().then {
        $0.setupBottomButtonUI(title: "입장하기", size: 16)
        $0.isButtonEnableUI(check: false)
    }
    
    let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: InvitationCodeViewController.self, action: nil)
    let viewModel = InvitationCodeViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(headerSubLabel)
        view.addSubview(inputCodeTextField)
        view.addSubview(participationButton)
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
        
        headerSubLabel.snp.makeConstraints {
            $0.leading.equalTo(headerLabel.snp.leading)
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
        }
        
        inputCodeTextField.snp.makeConstraints {
            $0.height.equalTo(56 * (UIScreen.main.bounds.height / 812))
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(headerSubLabel.snp.bottom).offset(28)
        }
        
        participationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(39)
            $0.height.equalTo(56 * (UIScreen.main.bounds.height / 812))
        }
    }
    
    override func setupBinding() {
        leftButtonItem.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        participationButton.rx.tap
            .bind { [weak self] in
                // MARK: 서버 응답에 따른 처리해줘야함
//                let popupViewController = PopUpViewController(title: "존재하지 않는 코드입니다", viewType: .oneButton)
//                self?.present(popupViewController, animated: false, completion: nil)
                
                let controller = SelfIntroduceViewController()
                self?.navigationController?.pushViewController(controller, animated: true)
            }.disposed(by: disposeBag)
        
        inputCodeTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] in
                guard $0.count > 6 else { return }
                self?.inputCodeTextField.text = String(self?.inputCodeTextField.text?.dropLast() ?? "")
            }).disposed(by: disposeBag)
        
        inputCodeTextField.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.inputCodeTextField.layer.borderColor = UIColor.ptBlack02.cgColor
            }).disposed(by: disposeBag)
        
        inputCodeTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .subscribe(onNext: { [weak self] in
                guard let textCount = self?.inputCodeTextField.text?.count else { return }
                guard textCount > 0 else {
                    self?.inputCodeTextField.layer.borderColor = UIColor.ptGray03.cgColor
                    return
                }
                self?.inputCodeTextField.layer.borderColor = UIColor.ptGray01.cgColor
            }).disposed(by: disposeBag)
        
        inputCodeTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] in
                guard $0.count == 6 else {
                    self?.participationButton.isButtonEnableUI(check: false)
                    return
                }
                self?.participationButton.isButtonEnableUI(check: true)
            }).disposed(by: disposeBag)
        
        let regularExpressionInput = InvitationCodeViewModel.RegularExpressionInput(inviteCodeText: inputCodeTextField.rx.text.orEmpty.asObservable())
        let regularExpressionDriver = viewModel.regularExpressionCheck(input: regularExpressionInput)
        
        regularExpressionDriver.inviteCodeCheck
            .drive(onNext: { [weak self] in
                guard $0 else {
                    self?.inputCodeTextField.text = String(self?.inputCodeTextField.text?.dropLast() ?? "")
                    return
                }
            }).disposed(by: disposeBag)
    }
}
