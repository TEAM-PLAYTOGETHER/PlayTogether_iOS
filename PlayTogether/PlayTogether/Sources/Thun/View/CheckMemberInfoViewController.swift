//
//  CheckMemberInfoViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/21.
//

import UIKit
import RxSwift

class CheckMemberInfoViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let navigationBarView = UIView().then {
        $0.backgroundColor = .ptBlack01
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "문수제비님의 프로필" // TODO: - 서버연동 후 변경
        $0.textColor = .white
        $0.font = .pretendardBold(size: 18)
    }
    
    private let optionButton = UIButton().then {
        $0.setImage(.ptImage(.optionIcon), for: .normal)
    }
    
    private let blockButton = UIButton().then {
        $0.setTitle("차단", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 14)
        let border = UIView()
        border.backgroundColor = .ptBlack01
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: $0.frame.width, height: 1)
        $0.addSubview(border)
    }
    
    private let reportButton = UIButton().then {
        $0.setTitle("신고", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 14)
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [blockButton,reportButton]).then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptBlack01.cgColor
        $0.layer.cornerRadius = 10
        $0.distribution = .fillEqually
        $0.isHidden = true
    }

    private let profileView = ProfileView(
        frame: .zero,
        crew: "SOPT",
        name: "안드_김세훈이아니라",
        birth: "1998",
        gender: "M",
        profileImage: .ptImage(.doIcon),
        stationName: ["강남역", "동대문역사문화공원역"],
        introduce: "한줄 소개임 ㅋ 뭐요 왜요 팍시~! 아유.... 하기 싫어! 아아 제 진심이 아니고요 와프입니다? 하하하"
    )
    
    private let chatButton = UIButton().then {
        $0.setupBottomButtonUI(title: "문수제비님과 채팅하기", size: 16)
        $0.isButtonEnableUI(check: true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(navigationBarView)
        view.addSubview(titleLabel)
        view.addSubview(profileView)
        view.addSubview(buttonStackView)
        view.addSubview(chatButton)
        
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(optionButton)
    }
    
    override func setupLayouts() {
        navigationBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            let height = UIScreen.main.bounds.height/812 * 44
            let navigationBarHeight = navigationController?.navigationBar.frame.height
            $0.height.equalTo(height+navigationBarHeight!)
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalTo(navigationBarView.snp.leading).offset(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        optionButton.snp.makeConstraints {
            $0.bottom.equalTo(backButton.snp.bottom)
            $0.trailing.equalTo(navigationBarView.snp.trailing).offset(-20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-54)
            $0.bottom.equalTo(navigationBarView.snp.bottom).offset(40)
            $0.width.equalTo((UIScreen.main.bounds.width/375)*113)
            $0.height.equalTo((UIScreen.main.bounds.height/812)*82)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.262)
        }
        
        chatButton.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(profileView)
            $0.height.equalTo((UIScreen.main.bounds.height/812)*56)
        }
    }
    
    override func setupBinding() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.navigationController?.navigationBar.isHidden = false
                self?.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: disposeBag)
        
        optionButton.rx.tap
            .bind { [weak self] in
                if self?.buttonStackView.isHidden == true {
                    self?.buttonStackView.isHidden = false
                } else {
                    self?.buttonStackView.isHidden =  true
                }
            }
            .disposed(by: disposeBag)
        
        blockButton.rx.tap
            .bind { [weak self] in
                self?.buttonStackView.isHidden = true
                print("차단버튼") // TODO: - 수정부분 서버 완료되면 연결할 것
            }
            .disposed(by: disposeBag)
        
        reportButton.rx.tap
            .bind { [weak self] in
                self?.buttonStackView.isHidden = true
                print("신고버튼")
            }
            .disposed(by: disposeBag)
    }
}
