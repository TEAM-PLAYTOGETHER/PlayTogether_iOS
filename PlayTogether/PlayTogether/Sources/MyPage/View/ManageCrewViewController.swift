//
//  ManageCrewViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2023/04/12.
//

import UIKit
import RxSwift
import RxCocoa

final class ManageCrewViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let userSettingLabel = UILabel().then {
        $0.text = "사용자 설정"
        $0.textColor = .ptGray02
        $0.font = .pretendardMedium(size: 12)
    }
    
    private let blockMemberButton = UIButton().then {
        $0.setTitle("차단사용자 관리하기", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private lazy var userSettingStackView = UIStackView(arrangedSubviews: [userSettingLabel,blockMemberButton]).then {
        $0.axis = .vertical
        $0.spacing = 23
    }
    
    private let etcLabel = UILabel().then {
        $0.text = "기타"
        $0.textColor = .ptGray02
        $0.font = .pretendardMedium(size: 12)
    }
    
    private let deleteCrewButton = UIButton().then {
        $0.setTitle("동아리 삭제하기", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
    }
    
    private lazy var etcStackView = UIStackView(arrangedSubviews:[etcLabel,deleteCrewButton]).then {
        $0.axis = .vertical
        $0.spacing = 23
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "내 동아리 관리하기"
        view.backgroundColor = .white
        view.addSubview(userSettingStackView)
        view.addSubview(underlineView)
        view.addSubview(etcStackView)
    }
    
    override func setupLayouts() {
        userSettingStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(24)
        }
        underlineView.snp.makeConstraints {
            $0.top.equalTo(userSettingStackView.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
        etcStackView.snp.makeConstraints {
            $0.top.equalTo(underlineView.snp.bottom).offset(16)
            $0.leading.equalTo(userSettingStackView)
        }
    }
    
    override func setupBinding() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        blockMemberButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(ManageBlockMemberViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        deleteCrewButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(DeleteCrewViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
