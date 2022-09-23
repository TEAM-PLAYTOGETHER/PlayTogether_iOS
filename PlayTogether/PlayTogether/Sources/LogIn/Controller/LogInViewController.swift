//
//  LogInViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/02.
//

import UIKit
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

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
    
    private var userAccessToken: String = ""
    private let userFCMToken = UserDefaults.standard.string(forKey: "FCMToken")
    private let viewModel = LoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
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
        kakaoLogin()
    }
    
    func appleButtonDidTap() {
        print("DEBUG: Apple login button did tap!")
    }
}

private extension LogInViewController {
    func kakaoLogin() {
        func requestLogin(accessToken: String, fcmToken: String) {
            let loginInput = LoginViewModel.loginTokenInput(accessToken: accessToken,
                                                            fcmToken: fcmToken)
            viewModel.tryLogin(loginInput) {
                guard $0.status == 200 else { return }
                let loggedInUserInfo = $0.data
                guard loggedInUserInfo.isSignup == true else {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                            as? SceneDelegate else { return }
                    sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                    return
                }
                // TODO: 키체인 변경 예정
                UserDefaults.standard.set(loggedInUserInfo.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(loggedInUserInfo.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.set(loggedInUserInfo.userName, forKey: "userName")
                
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                        as? SceneDelegate else { return }
                let rootViewController = TabBarController()
                sceneDelegate.window?.rootViewController = rootViewController
            }
        }
        
        guard UserApi.isKakaoTalkLoginAvailable() == true else {
            UserApi.shared.loginWithKakaoAccount(prompts:[.Login]) { oauthToken, error  in
                guard let accessToken = oauthToken?.accessToken else { return }
                guard let fcmToken = self.userFCMToken else { return }
                self.userAccessToken = accessToken
                requestLogin(accessToken: accessToken, fcmToken: fcmToken)
            }
            return
        }
        
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            guard let accessToken = oauthToken?.accessToken else { return }
            guard let fcmToken = self.userFCMToken else { return }
            self.userAccessToken = accessToken
            requestLogin(accessToken: accessToken, fcmToken: fcmToken)
        }
    }
}
