//
//  CheckTermsServiceViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/04.
//

import UIKit
import RxSwift
import RxCocoa

class CheckTermsServiceViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let headerLabel = UILabel().then {
        $0.text = "PLAY TOGETHER\n약관 동의"
        $0.textColor = .ptBlack01
        $0.font = .pretendardRegular(size: 22)
        $0.numberOfLines = 0
        $0.addSpacingLabelText($0)
    }
    
    private let headerSubLabel = UILabel().then {
        $0.text = "서비스 이용을 위해 약관 동의가 필요해요!"
        $0.textColor = .ptBlack02
        $0.font = .pretendardRegular(size: 14)
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.setupBottomButtonUI(title: "확인", size: 15)
        $0.isButtonEnableUI(check: false)
    }
    
    private let checkTermsView = CheckTermsView()
    
    private let viewModel = CheckTermsServiceViewModel()
    
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
        view.addSubview(checkTermsView)
        view.addSubview(confirmButton)
    }
    
    override func setupLayouts() {
        let height = UIScreen.main.bounds.height / 812
        
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            $0.leading.equalToSuperview().inset(20)
        }
        
        headerSubLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        checkTermsView.snp.makeConstraints {
            $0.top.equalTo(headerSubLabel.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(257 * height)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56 * height)
        }
    }
    
    override func setupBinding() {
        leftButtonItem.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        checkTermsView.ageCheckButton.rx.tap
            .bind { [weak self] in
                guard let buttonState = self?.checkTermsView.ageCheckButton.isSelected else { return }
                self?.checkTermsView.ageCheckButton.isSelected = !buttonState
                self?.viewModel.ageCheck.onNext(!buttonState)
            }
            .disposed(by: disposeBag)
        
        checkTermsView.termsCheckButton.rx.tap
            .bind { [weak self] in
                guard let buttonState = self?.checkTermsView.termsCheckButton.isSelected else { return }
                self?.checkTermsView.termsCheckButton.isSelected = !buttonState
                self?.viewModel.termsCheck.onNext(!buttonState)
            }
            .disposed(by: disposeBag)
        
        checkTermsView.privacyCheckButton.rx.tap
            .bind { [weak self] in
                guard let buttonState = self?.checkTermsView.privacyCheckButton.isSelected else { return }
                self?.checkTermsView.privacyCheckButton.isSelected = !buttonState
                self?.viewModel.privacyCheck.onNext(!buttonState)
            }
            .disposed(by: disposeBag)
        
        checkTermsView.marketingCheckButton.rx.tap
            .bind { [weak self] in
                guard let buttonState = self?.checkTermsView.marketingCheckButton.isSelected else { return }
                self?.checkTermsView.marketingCheckButton.isSelected = !buttonState
                self?.viewModel.marketingCheck.onNext(!buttonState)
            }
            .disposed(by: disposeBag)
         
        // TODO: 전체동의 액션
        
        let buttonAllCheckDriver = viewModel.buttonAllStateCheck()
        
        buttonAllCheckDriver.allCheck
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.checkTermsView.allCheckButton.isSelected = $0
            })
            .disposed(by: disposeBag)
    }
}
