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
        contactTextButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                print("DEBUG: 문의하기 버튼 클릭")
            })
            .disposed(by: disposeBag)
    }
}
