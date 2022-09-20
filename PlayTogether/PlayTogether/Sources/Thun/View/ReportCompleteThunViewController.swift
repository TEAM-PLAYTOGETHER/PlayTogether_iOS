//
//  ReportCompleteThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/20.
//

import UIKit
import RxSwift

class ReportCompleteThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let exiteButton = UIButton().then {
        $0.setImage(.ptImage(.clearIcon), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "신고 내용이\n접수되었습니다"
        $0.textColor = .ptBlack01
        $0.font = .pretendardRegular(size: 22)
        $0.addSpacingLabelText($0)
        $0.numberOfLines = 0
    }
    
    private let ptImageView = UIImageView().then {
        $0.image = .ptImage(.onboardingBottomImage)
    }
    
    private let completeButton = UIButton().then {
        $0.setupBottomButtonUI(title: "확인", size: 16)
        $0.isButtonEnableUI(check: true)
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exiteButton)
        view.addSubview(titleLabel)
        view.addSubview(ptImageView)
        view.addSubview(completeButton)
    }
    
    override func setupLayouts() {
        let height = UIScreen.main.bounds.height/812
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(height*56)
        }
        
        ptImageView.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(-20)
            $0.trailing.equalTo(completeButton.snp.trailing)
        }
    }
    
    override func setupBinding() {
        exiteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
