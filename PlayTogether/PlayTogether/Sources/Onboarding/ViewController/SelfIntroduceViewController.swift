//
//  SelfIntroduceViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/09.
//

import UIKit
import RxSwift
import RxCocoa

class SelfIntroduceViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SelfIntroduceViewModel()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 0.75
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        let title = OnboardingDataModel.shared
        $0.text = "\(title.meetingTitle ?? "테스트 동아리")에서\n나는 어떤 사람인가요?"
        $0.font = .pretendardMedium(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
    }
    
    private let nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private lazy var existingNicknameButton = UIButton().then {
        $0.backgroundColor = .ptBlack01
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.layer.cornerRadius = 5
    }
    
    private let inputNicknameTextField = UITextField().then {
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
        $0.setupPlaceholderText(title: "닉네임 입력", color: .ptGray01)
        $0.addLeftPadding()
        $0.autocorrectionType = .no
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let noticeNicknameLabel = UILabel().then {
        $0.text = "10자 이내(공백 제외) 한글,영문,숫자,특수문자"
        $0.textColor = .ptGray02
        $0.font = .pretendardMedium(size: 12)
    }
    
    private let noticeExistingNicknameLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 12)
        $0.isHidden = true
    }
    
    private let briefIntroductionLabel = UILabel().then {
        $0.text = "간단 소개"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let briefIntroductionSubLabel = UILabel().then {
        $0.text = "200자 이내"
        $0.textColor = .ptGray02
        $0.font = .pretendardMedium(size: 10)
    }
    
    private let inputBriefIntroduceTextView = UITextView().then {
        $0.text = "간단 소개 입력"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptGray01
        $0.textContainerInset = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let preferredSubwayStationLabel = UILabel().then {
        $0.text = "선호하는 지하철역"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let preferredSubwayStationSubLabel = UILabel().then {
        $0.text = "최대 2개 추가"
        $0.textColor = .ptGray02
        $0.font = .pretendardMedium(size: 10)
    }
    
    private lazy var addPreferredSubwayStationButton = UIButton().then {
        $0.setTitle("추가하기", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.setImage(.ptImage(.plusIcon), for: .normal)
    }
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        let width = 123 * (UIScreen.main.bounds.width / 375)    // TODO: 지하철 데이터를 받아오면 해당 width 동적으로 처리할 예정
        let height = 32 * (UIScreen.main.bounds.height / 812)
        $0.itemSize = CGSize(width: width, height: height)
    }

    private lazy var subwayStationCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.backgroundColor = .white
        $0.register(SubwayStationCollectionViewCell.self, forCellWithReuseIdentifier: "SubwayStationCollectionViewCell")
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setupBottomButtonUI(title: "다음", size: 15)
        $0.isButtonEnableUI(check: false)
    }
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: SelfIntroduceViewController.self, action: nil)
    
    private var isEnableNickname = BehaviorRelay<Bool>(value: false)
    private var isFillBriefIntroduceText = BehaviorRelay<Bool>(value: false)
    private var registerUserStations = BehaviorRelay<[String]>(value: [])
    private var ableNickname: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func changeNextButtonUI(_ button: UIButton , _ status: Bool) {
        guard status == true else {
            button.isEnabled = false
            button.backgroundColor = .ptGray03
            button.layer.borderColor = UIColor.ptGray02.cgColor
            return
        }
        button.isEnabled = true
        button.backgroundColor = .ptGreen
        button.layer.borderColor = UIColor.ptBlack01.cgColor
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(nickNameLabel)
        view.addSubview(inputNicknameTextField)
        view.addSubview(existingNicknameButton)
        view.addSubview(noticeNicknameLabel)
        view.addSubview(noticeExistingNicknameLabel)
        view.addSubview(briefIntroductionLabel)
        view.addSubview(briefIntroductionSubLabel)
        view.addSubview(inputBriefIntroduceTextView)
        view.addSubview(preferredSubwayStationLabel)
        view.addSubview(preferredSubwayStationSubLabel)
        view.addSubview(addPreferredSubwayStationButton)
        view.addSubview(subwayStationCollectionView)
        view.addSubview(nextButton)
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
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(headerLabel.snp.bottom).offset(36)
        }
        
        noticeNicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel.snp.centerY)
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(6)
        }
        
        inputNicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * (UIScreen.main.bounds.height / 812))
        }
        
        noticeExistingNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(inputNicknameTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(24)
        }
        
        existingNicknameButton.snp.makeConstraints {
            $0.centerY.equalTo(inputNicknameTextField)
            $0.trailing.equalTo(inputNicknameTextField.snp.trailing).inset(16)
            $0.width.equalTo(67 * (UIScreen.main.bounds.width / 375))
        }
        
        briefIntroductionLabel.snp.makeConstraints {
            $0.top.equalTo(noticeExistingNicknameLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        briefIntroductionSubLabel.snp.makeConstraints {
            $0.centerY.equalTo(briefIntroductionLabel.snp.centerY)
            $0.leading.equalTo(briefIntroductionLabel.snp.trailing).offset(6)
        }
        
        inputBriefIntroduceTextView.snp.makeConstraints {
            $0.top.equalTo(briefIntroductionLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100 * (UIScreen.main.bounds.height / 812))
        }
        
        preferredSubwayStationLabel.snp.makeConstraints {
            $0.top.equalTo(inputBriefIntroduceTextView.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        preferredSubwayStationSubLabel.snp.makeConstraints {
            $0.centerY.equalTo(preferredSubwayStationLabel.snp.centerY)
            $0.leading.equalTo(preferredSubwayStationLabel.snp.trailing).offset(4)
        }
        
        addPreferredSubwayStationButton.snp.makeConstraints {
            $0.centerY.equalTo(preferredSubwayStationLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        subwayStationCollectionView.snp.makeConstraints {
            $0.top.equalTo(preferredSubwayStationLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(nextButton.snp.top).offset(75)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(39)
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
        
        existingNicknameButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let nickname = self?.inputNicknameTextField.text else { return }
                self?.viewModel.checkNickname(102, nickname) {  // TODO: 추후 동아리 번호 받아올 예정
                    self?.isEnableNickname.accept($0)
                    self?.noticeExistingNicknameLabel.isHidden = false
                    self?.noticeExistingNicknameLabel.text = $0 ? "사용 가능한 닉네임입니다" : "이미 사용중인 닉네임입니다"
                    self?.noticeExistingNicknameLabel.textColor = $0 ? .ptCorrect : .ptIncorrect
                    guard $0 == true else { return }
                    self?.ableNickname = nickname
                }
            })
            .disposed(by: disposeBag)
        
        inputNicknameTextField.rx.controlEvent(.touchDown)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.inputNicknameTextField.layer.borderColor = UIColor.ptBlack02.cgColor
            })
            .disposed(by: disposeBag)

        inputNicknameTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let textCount = self?.inputNicknameTextField.text?.count else { return }
                self?.inputNicknameTextField.layer.borderColor =
                        textCount > 0 ?
                        UIColor.ptGray02.cgColor : UIColor.ptGray01.cgColor
            })
            .disposed(by: disposeBag)
        
        inputNicknameTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] in
                guard $0 == self?.ableNickname else {
                    self?.noticeExistingNicknameLabel.isHidden = true
                    self?.isEnableNickname.accept(false)
                    guard $0.count > 10 else { return }
                    self?.inputNicknameTextField.text = String(self?.inputNicknameTextField.text?.dropLast() ?? "")
                    return
                }
            })
            .disposed(by: disposeBag)
        
        inputBriefIntroduceTextView.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] in
                guard $0.count > 0,
                      self?.inputBriefIntroduceTextView.textColor == .ptBlack01
                else {
                    self?.isFillBriefIntroduceText.accept(false)
                    return
                }
                self?.isFillBriefIntroduceText.accept(true)
            })
            .disposed(by: disposeBag)
        
        inputBriefIntroduceTextView.rx.didBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard self?.inputBriefIntroduceTextView.textColor == .ptGray01 else { return }
                self?.inputBriefIntroduceTextView.layer.borderColor = UIColor.ptBlack02.cgColor
                self?.inputBriefIntroduceTextView.textColor = .ptBlack01
                self?.inputBriefIntroduceTextView.text = nil
            })
            .disposed(by: disposeBag)
        
        inputBriefIntroduceTextView.rx.didEndEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard self?.inputBriefIntroduceTextView.text.isEmpty == false else {
                    self?.inputBriefIntroduceTextView.layer.borderColor = UIColor.ptGray03.cgColor
                    self?.inputBriefIntroduceTextView.text = "간단 소개 입력"
                    self?.inputBriefIntroduceTextView.textColor = .ptGray01
                    self?.isFillBriefIntroduceText.accept(false)
                    return
                }
                self?.inputBriefIntroduceTextView.textColor = .ptBlack01
                self?.inputBriefIntroduceTextView.layer.borderColor = UIColor.ptGray01.cgColor
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(
            isEnableNickname.asDriver(),
            isFillBriefIntroduceText.asDriver(),
            registerUserStations.asDriver()
        ) { $0 && $1 && !$2.isEmpty }
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.changeNextButtonUI(self.nextButton, $0)
            })
            .disposed(by: disposeBag)
        
        addPreferredSubwayStationButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let controller = AddSubwayStationViewController()
                controller.delegate = self
                self?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self,
                      let nickname = self.inputNicknameTextField.text,
                      let briefIntroduceText = self.inputBriefIntroduceTextView.text,
                      let isCreate = OnboardingDataModel.shared.isCreated
                else { return }
                
                OnboardingDataModel.shared.nickName = nickname
                OnboardingDataModel.shared.introduceSelfMessage = briefIntroduceText
                OnboardingDataModel.shared.preferredSubway = self.registerUserStations.value
                
                let controller = isCreate ? OpendThunViewController() : ParticipationCompletedViewController()
                self.viewModel.registerUserProfile(
                    OnboardingDataModel.shared.crewId ?? -1,
                    nickname,
                    briefIntroduceText,
                    self.registerUserStations.value.first!,
                    self.registerUserStations.value.last
                ) {
                    guard $0 == true else { return }
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}


extension SelfIntroduceViewController: AddSubwayStationDelegate {
    func registerSubwayStation(_ stations: [String]) {
        registerUserStations.accept(stations)
    }
}
