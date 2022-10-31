//
//  ManageAccountViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/10/31.
//

import UIKit
import RxSwift

final class ManageAccountViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let etcLabel = UILabel().then {
        $0.text = "기타"
        $0.textColor = .ptGray02
        $0.font = .pretendardMedium(size: 12)
    }
    
    private let deleteAccountButton = UIButton().then {
        $0.setTitle("서비스 탈퇴하기", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "계정 관리"
        view.backgroundColor = .white
        view.addSubview(etcLabel)
        view.addSubview(deleteAccountButton)
    }
    
    override func setupLayouts() {
        etcLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(24)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(etcLabel.snp.bottom).offset(23)
            $0.leading.equalTo(etcLabel)
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
                guard let self = self else { return }
                self.navigationController?.pushViewController(DeleteAccountViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
