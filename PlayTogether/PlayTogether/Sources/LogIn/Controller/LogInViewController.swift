//
//  LogInViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/02.
//

import UIKit
import RxSwift

class LogInViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let kakaoLoginView = LoginButtonView()
    private let appleLoginView = LoginButtonView()
    
    private let headerLabel = UILabel().then {
        $0.text = "함께 놀아요\nPLAY TOGETHER!"
        $0.font = .pretendardRegular(size: 24)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
        $0.addSpacingLabelText($0)
    }
    
    private let logoImageView = UIImageView().then {
        $0.image = .ptImage(.loginCenterIcon)
        $0.backgroundColor = .white
    }
    
    private let bottomLabel = UILabel().then {
        $0.text = "문제가 있으신가요?"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptGray01
    }
    
    private lazy var contactTextButton = UIButton().then {
        $0.setTitle("문의하기", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
        $0.backgroundColor = .white
        $0.setUnderline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // TODO: 상태 표시줄 색상 흰색인데 검은색으로 변경
    // TODO: 카카오 로그인 패키지 추가
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(logoImageView)
        view.addSubview(kakaoLoginView)
        view.addSubview(appleLoginView)
        view.addSubview(bottomLabel)
        view.addSubview(contactTextButton)
    }
    
    override func setupLayouts() {
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(93)
            $0.leading.equalToSuperview().inset(20)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        kakaoLoginView.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginView.snp.top).offset(-4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(46 * (UIScreen.main.bounds.height / 812))
        }
        
        appleLoginView.snp.makeConstraints {
            $0.bottom.equalTo(bottomLabel).inset(45)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(46 * (UIScreen.main.bounds.height / 812))
        }
        
        bottomLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(56)
            $0.leading.equalToSuperview().inset(105)
        }
        
        contactTextButton.snp.makeConstraints {
            $0.centerY.equalTo(bottomLabel)
            $0.trailing.equalToSuperview().inset(105)
        }
    }
    
    override func setupBinding() {
        kakaoLoginView.setupUI(.kakaoLogin)
        appleLoginView.setupUI(.appleLogin)
        
        kakaoLoginView.delegate = self
        appleLoginView.delegate = self
        
        contactTextButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                print("DEBUG: Contact button did tap")
            })
            .disposed(by: disposeBag)
    }
}

extension LogInViewController: LoginButtonDelegate {
    func kakaoButtonDidTap() {
        print("DEBUG: Kakao login button did tap!")
    }
    
    func appleButtonDidTap() {
        print("DEBUG: Apple login button did tap!")
    }
}
