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
    
    private let progressbar = UIProgressView().then {
        $0.progress = 1.0
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
    
    // TODO: Right View도 Left View와 마찬가지로 frame 잡아보기
    
    private lazy var existingNicknameButton = UIButton().then {
        // TODO: 텍스트 필드 입력시 버튼이 뒤로감
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
        $0.autocapitalizationType = .allCharacters
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
        $0.autocapitalizationType = .allCharacters
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
        let width = 123 * (UIScreen.main.bounds.width / 375)    // MARK: 지하철 데이터를 받아오면 해당 width 동적 처리 해줘야 함
        let height = 32 * (UIScreen.main.bounds.height / 812)
        $0.itemSize = CGSize(width: width, height: height)
    }

    private lazy var subwayStationCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.backgroundColor = .white
        $0.register(SubwayStationCell.self, forCellWithReuseIdentifier: "SubwayStationCell")
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setupBottomButtonUI(title: "다음", size: 15)
        $0.isButtonEnableUI(check: false)
    }
    
    let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: SelfIntroduceViewController.self, action: nil)
    let viewModel = SelfIntroduceViewModel()
    let dataSource = Observable<String>.of("플투역 1호선", "테스트역 2호선")
    
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
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
//         TODO: 동아리 번호 수정예정
        existingNicknameButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let nickname = self?.inputNicknameTextField.text else { return }
                self?.viewModel.checkNickname(102, nickname) {
                    self?.noticeExistingNicknameLabel.isHidden = false
                    self?.noticeExistingNicknameLabel.text = $0 ? "사용 가능한 닉네임입니다" : "이미 사용중인 닉네임입니다"
                    self?.noticeExistingNicknameLabel.textColor = $0 ? .ptCorrect : .ptIncorrect
                }
            }).disposed(by: disposeBag)
        
        inputNicknameTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] in
                self?.noticeExistingNicknameLabel.isHidden = true
                guard $0.count > 10 else { return }
                self?.inputNicknameTextField.text = String(self?.inputNicknameTextField.text?.dropLast() ?? "")
            }).disposed(by: disposeBag)
        
        inputNicknameTextField.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.inputNicknameTextField.layer.borderColor = UIColor.ptBlack02.cgColor
            }).disposed(by: disposeBag)

        inputNicknameTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .subscribe(onNext: { [weak self] in
                guard let textCount = self?.inputNicknameTextField.text?.count else { return }
                guard textCount > 0 else {
                    self?.inputNicknameTextField.layer.borderColor = UIColor.ptGray03.cgColor
                    return
                }
                self?.inputNicknameTextField.layer.borderColor = UIColor.ptGray01.cgColor
            }).disposed(by: disposeBag)
        
        inputBriefIntroduceTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                guard self?.inputBriefIntroduceTextView.textColor == .ptGray01 else { return }
                self?.inputBriefIntroduceTextView.layer.borderColor = UIColor.ptBlack02.cgColor
                self?.inputBriefIntroduceTextView.textColor = .ptBlack01
                self?.inputBriefIntroduceTextView.text = nil
            }).disposed(by: disposeBag)
        
        inputBriefIntroduceTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                guard self?.inputBriefIntroduceTextView.text.isEmpty == true else {
                    self?.inputBriefIntroduceTextView.textColor = .ptBlack01
                    self?.inputBriefIntroduceTextView.layer.borderColor = UIColor.ptGray01.cgColor
                    return
                }
                self?.inputBriefIntroduceTextView.layer.borderColor = UIColor.ptGray03.cgColor
                self?.inputBriefIntroduceTextView.text = "간단 소개 입력"
                self?.inputBriefIntroduceTextView.textColor = .ptGray01
            }).disposed(by: disposeBag)
        
//        viewModel.subwayStationList
//            .bind(to: self.subwayStationCollectionView.rx.items) { _, row, item -> UICollectionViewCell in
//                guard let cell = self.subwayStationCollectionView.dequeueReusableCell(
//                    withReuseIdentifier: "subwayStationCollectionView",
//                    for: IndexPath(row: row, section: 0)
//                ) as? SubwayStationCell,
//                      let item = item?.response.body.items.item
//                else { return UICollectionViewCell() }
//
//                cell.setupData(item[row].subwayStationName)
//                return cell
//            }.disposed(by: disposeBag)
        
    }
}

