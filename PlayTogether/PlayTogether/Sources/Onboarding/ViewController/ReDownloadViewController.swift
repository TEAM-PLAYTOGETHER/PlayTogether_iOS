//
//  ReDownloadViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/01.
//

import UIKit
import RxSwift
import RxCocoa

class ReDownloadViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let headerLabel = UILabel().then {
        $0.text = "PLAY TOGETHER,\n다시 만나서 기뻐요!"
        $0.numberOfLines = 0
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .ptBlack01
        $0.addSpacingLabelText($0)
    }
    
    private let headerSubLabel = UILabel().then {
        $0.text = "어떤 동아리의 번개가 궁금하세요?"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
    }
    
//    private lazy var meetingListTableView = UITableView().then {
//        
//    }
    
    private lazy var participationButton = UIButton().then {
        $0.setupBottomButtonUI(title: "입장하기", size: 16)
        $0.isButtonEnableUI(check: false)
    }
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: ReDownloadViewController.self, action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNaigationvBar()
    }
    
    private func configureNaigationvBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .ptBlack01
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(headerSubLabel)
        view.addSubview(participationButton)
    }
    
    override func setupLayouts() {
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        headerSubLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        participationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56 * (UIScreen.main.bounds.height / 812))
        }
    }
    
    override func setupBinding() {
        
    }
}
