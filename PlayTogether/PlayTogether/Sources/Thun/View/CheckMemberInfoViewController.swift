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
    private var viewModel = DetailMemberInfoViewModel()
    private var superViewModel = DetailThunViewModel()
    private var userID: Int?
    
    init(userId: Int) {
        self.userID = userId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private var profileView = ProfileView(
        frame: .zero,
        crew: "",
        name: "ddfd",
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
                self?.viewModel.detailMemberInfo(memberId: self?.userID ?? -1) { response in
                    let popupViewController = PopUpViewController(title: "\(response.profile.nickname ?? "-")님을 차단할까요? [내 동아리 관리하기]에서 해제할 수 있습니다!", viewType: .twoButton)
                    self?.present(popupViewController, animated: false, completion: nil)
                    popupViewController.twoButtonDelegate = self
                }
            }
            .disposed(by: disposeBag)
        
        reportButton.rx.tap
            .bind { [weak self] in
                self?.buttonStackView.isHidden = true
                guard let url = URL(string: "https://forms.gle/7deZ5JgtVqrbTifG8") else { return }
                UIApplication.shared.open(url, options: [:])
            }
            .disposed(by: disposeBag)
        
//        viewModel.detailMemberInfo(memberId: userID ?? -1) { data in
//            guard let image = Data(base64Encoded: data.profile.profileImage ?? "", options: .ignoreUnknownCharacters) else { return }
//            self.profileView = ProfileView(
//                frame: .zero,
//                crew: data.crewName,
//                name: data.profile.nickname ?? "이라어리ㅏ어",
//                birth: data.profile.birth ?? "1998",
//                gender: data.profile.gender ?? "M",
//                profileImage: .ptImage(.doIcon),
//                stationName: [data.profile.firstStation ?? "강남역", data.profile.secondStation ?? "계양역"] ,
//                introduce: data.profile.description ?? "한줄 소개임 ㅋ 뭐요 왜요 팍시~! 아유.... 하기 싫어! 아아 제 진심이 아니고요 와프입니다? 하하하"
//            )
//            print("@@@@@@@@@@@@@@@@", data.profile)
//            print("@@@@@@@@@@@@@@@@", data.crewName)
//        }
    }
}

extension CheckMemberInfoViewController: TwoButtonDelegate {
    func firstButtonDidTap() {}
    func secondButtonDidTap() {
        // 사용자를 차단하면 어케되는지 물어보기
        // 사용자 리스트를 없애야하는건지? or 그냥 안눌리게 해야하는지 등
        viewModel.blockMember(memberId: userID ?? -1) { response in
            guard let originData = try? self.superViewModel.memberList.value() else { return }
            let filterData = originData.filter{ $0.userID != self.userID }
            if !(filterData.isEmpty) {
                self.superViewModel.memberList.onNext(filterData)
            }
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}
