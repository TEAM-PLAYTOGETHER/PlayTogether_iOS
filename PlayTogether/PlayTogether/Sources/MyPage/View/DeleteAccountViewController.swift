//
//  DeleteAccountViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/10/30.
//

import UIKit
import RxSwift

final class DeleteAccountViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SettingViewModel()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "정말 탈퇴하시겠어요?"
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .ptBlack01
        $0.changeFontColorSize(targetString: "탈퇴", color: .ptIncorrect, font: .pretendardBold(size: 22))
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "서비스를 탈퇴하시면 개인 정보, 동아리 정보를 비롯한\n모든 회원 정보가 삭제되며 다시 복구할 수 없습니다."
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let deleteAccountButton = UIButton().then {
        $0.setupDeleteButtonUI(title: "탈퇴하기", size: 16)
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
                let popupViewController = PopUpViewController(title: "서비스를 탈퇴합니다.", viewType: .twoButton)
                self?.present(popupViewController, animated: false, completion: nil)
                popupViewController.twoButtonDelegate = self
            })
            .disposed(by: disposeBag)
    }
}

extension DeleteAccountViewController: TwoButtonDelegate {
    func firstButtonDidTap() {}
    func secondButtonDidTap() {
        viewModel.deleteAccount { response in
            guard response != true else {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
        }
    }
}
