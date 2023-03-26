//
//  DeleteAccountViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/10/30.
//

import UIKit
import RxSwift

final class DeleteCrewViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SettingViewModel()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "SOPT\n동아리를 삭제하시겠어요?"
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .ptBlack01
        $0.changeFontColorSize(targetString: "삭제", color: .ptIncorrect, font: .pretendardBold(size: 22))
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "삭제 후, 재가입을 원하시는 경우\n다시 초대코드를 입력하셔야 합니다.\n\n현재 설정되어 있는 동아리가 아닌 다른 동아리를\n삭제하고 싶으시다면, 먼저 마이페이지 또는\n메인 화면에서 삭제를 원하시는 동아리를 선택해주세요!"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
        $0.changeFontColor(targetString: "삭제를 원하시는 동아리를 선택", color: .ptIncorrect)
    }
    
    private let deleteAccountButton = UIButton().then {
        $0.setupDeleteButtonUI(title: "삭제하기", size: 16)
    }
    
    override func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(deleteAccountButton)
    }
    
    override func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(titleLabel)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56 * UIScreen.main.bounds.height/812)
        }
    }
    
    override func setupBinding() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        deleteAccountButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let popupViewController = PopUpViewController(title: "정말 동아리를 삭제하시겠어요?", viewType: .twoButton)
                self?.present(popupViewController, animated: false, completion: nil)
                popupViewController.twoButtonDelegate = self
            })
            .disposed(by: disposeBag)
    }
}

extension DeleteCrewViewController: TwoButtonDelegate {
    func firstButtonDidTap() {}
    func secondButtonDidTap() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                as? SceneDelegate else { return }
        // 루트뷰어디로가는지물어보기
        let rootViewController = LogInViewController()
        viewModel.deleteCrew { response in
            guard response != true else {
                sceneDelegate.window?.rootViewController = rootViewController
                return
            }
        }
    }
}

