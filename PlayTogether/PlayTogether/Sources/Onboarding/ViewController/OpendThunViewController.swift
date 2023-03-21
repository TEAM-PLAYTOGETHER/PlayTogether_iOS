//
//  OpendThunViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class OpendThunViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let shareInfoView = ShareExtensionView()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 1.0
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        let dataModel = OnboardingDataModel.shared
        $0.text = "\(dataModel.nickName ?? "닉네임")님, 반가워요!\n\(dataModel.meetingTitle ?? "동아리명") 번개를 시작해볼까요?"
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
        $0.addSpacingLabelText($0)
    }
    
    private lazy var startButton = UIButton().then {
        $0.setupBottomButtonUI(title: "시작하기", size: 16)
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
        shareInfoView.delegate = self
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(shareInfoView)
        view.addSubview(startButton)
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
        
        shareInfoView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(179 * (UIScreen.main.bounds.height / 812))
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56 * (UIScreen.main.bounds.height / 812))
        }
    }
    
    override func setupBinding() {
        leftButtonItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                // TODO: Root Viewcontroller 넘어갈 때 애니메이션 넣을지
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                        as? SceneDelegate else { return }
                sceneDelegate.window?.rootViewController = TabBarController()
            })
            .disposed(by: disposeBag)
    }
}


extension OpendThunViewController: shareExtensionProtocol {
    func shareButtonDidTap() {
        // TODO: Share Extension 추가 할 예정
        print("DEBUG: share Button Did Tap!")
    }
}
