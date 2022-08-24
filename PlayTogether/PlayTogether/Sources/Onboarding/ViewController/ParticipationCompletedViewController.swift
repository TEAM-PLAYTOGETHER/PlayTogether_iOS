//
//  ParticipationCompletedViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class ParticipationCompletedViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 1.0
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        let dataModel = OnboardingDataModel.shared
        $0.text = "\(dataModel.nickName ?? "닉네임")님, 반가워요!\n\(dataModel.meetingTitle ?? "동아리명") 번개에 참여해볼까요?"
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
        $0.addSpacingLabelText($0)
    }
    
    private let bottomImageView = UIImageView().then {
        $0.image = .ptImage(.onboardingBottomImage)
        $0.backgroundColor = .white
    }
    
    private lazy var completedButton = UIButton().then {
        $0.setupBottomButtonUI(title: "참여하기", size: 16)
        $0.isButtonEnableUI(check: true)
    }
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: ParticipationCompletedViewController.self, action: nil)
    
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
        view.addSubview(completedButton)
        view.addSubview(bottomImageView)
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
            $0.height.equalTo(60 * (UIScreen.main.bounds.height / 812))
        }
        
        completedButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56 * (UIScreen.main.bounds.height / 812))
        }
        
        bottomImageView.snp.makeConstraints {
            $0.bottom.equalTo(completedButton.snp.top).offset(-20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func setupBinding() {
        completedButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                        as? SceneDelegate else { return }
                let rootViewController = TabBarController()
                sceneDelegate.window?.rootViewController = rootViewController
            })
            .disposed(by: disposeBag)
    }
}
