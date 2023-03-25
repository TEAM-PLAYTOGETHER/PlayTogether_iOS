//
//  SelfIntroduceViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/09.
//

import UIKit
import RxSwift
import RxCocoa

final class SelfIntroduceViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SelfIntroduceViewModel()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 0.75
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        let title = OnboardingDataModel.shared.meetingTitle
        $0.text = "\(title ?? "테스트 동아리")에서\n나는 어떤 사람인가요?"
        $0.font = .pretendardMedium(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
    }
    
    private let nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let nickNameCheckButton = UIButton().then {
        $0.backgroundColor = .ptGray03
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.isEnabled = false
        $0.layer.cornerRadius = 5
    }
    
    private let nickNameTextField = UITextField().then {
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
        $0.setupPlaceholderText(title: "닉네임 입력", color: .ptGray01)
        $0.addLeftPadding()
        $0.autocorrectionType = .no
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let noticeNickNameLabel = UILabel().then {
        $0.text = "2 ~ 10자(공백 불가) 한글, 영문, 숫자, 언더바(_) 사용 가능"
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
    
    private let briefIntroduceTextView = UITextView().then {
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
    
    private let addPreferredSubwayStationButton = UIButton().then {
        $0.setTitle("추가하기", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.setImage(.ptImage(.plusIcon), for: .normal)
    }
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 10.0
    }

    private lazy var subwayStationCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.backgroundColor = .white
        $0.contentInset = .zero
        $0.register(
            SubwayStationCollectionViewCell.self,
            forCellWithReuseIdentifier: "SubwayStationCollectionViewCell"
        )
        $0.register(
            PreferredStationCollectionViewCell.self,
            forCellWithReuseIdentifier: "PreferredStationCollectionViewCell"
        )
        
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let nextButton = UIButton().then {
        $0.setupBottomButtonUI(title: "다음", size: 15)
        $0.isButtonEnableUI(check: false)
    }
    
    private let leftButtonItem = UIBarButtonItem(
        image: UIImage.ptImage(.backIcon),
        style: .plain,
        target: SelfIntroduceViewController.self,
        action: nil
    )

    private let subwayRelay = BehaviorRelay<[String?]>(value: [nil, nil])
    private let isPassedNickNameCheck = PublishSubject<Bool>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(nickNameCheckButton)
        view.addSubview(noticeNickNameLabel)
        view.addSubview(noticeExistingNicknameLabel)
        view.addSubview(briefIntroductionLabel)
        view.addSubview(briefIntroductionSubLabel)
        view.addSubview(briefIntroduceTextView)
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
        
        noticeNickNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel.snp.centerY)
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(6)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * (UIScreen.main.bounds.height / 812))
        }
        
        noticeExistingNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(24)
        }
        
        nickNameCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(nickNameTextField)
            $0.trailing.equalTo(nickNameTextField.snp.trailing).inset(16)
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
        
        briefIntroduceTextView.snp.makeConstraints {
            $0.top.equalTo(briefIntroductionLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100 * (UIScreen.main.bounds.height / 812))
        }
        
        preferredSubwayStationLabel.snp.makeConstraints {
            $0.top.equalTo(briefIntroduceTextView.snp.bottom).offset(36)
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
            $0.height.equalTo(32)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(39)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56 * (UIScreen.main.bounds.height / 812))
        }
    }
    
    override func setupBinding() {
        let input = SelfIntroduceViewModel.Input(
            tapNickNameButton: nickNameCheckButton.rx.tap,
            tapNextButton: nextButton.rx.tap,
            nickNameInput: nickNameTextField.rx.text.orEmpty.asObservable(),
            descriptionInput: briefIntroduceTextView.rx.text.orEmpty.asObservable(),
            subwayInput: subwayRelay.asObservable()
        )

        let output = viewModel.transform(input)

        output.checkNickNameOutput
            .asSignal(onErrorJustReturn: false)
            .emit(with: self, onNext: { owner, isEnable in
                owner.noticeExistingNicknameLabel.isHidden = false
                owner.noticeExistingNicknameLabel.text = isEnable ? "사용 가능한 닉네임입니다" : "이미 사용중인 닉네임입니다"
                owner.noticeExistingNicknameLabel.textColor = isEnable ? .ptCorrect : .ptIncorrect
                owner.isPassedNickNameCheck.onNext(isEnable)
            })
            .disposed(by: disposeBag)

        output.registUserProfileOutput
            .withUnretained(self)
            .filter { owner, response in
                let isSuccess = response.status == 200
                if !isSuccess { owner.showToast(response.message) }

                return isSuccess
            }
            .asSignal(onErrorSignalWith: .empty())
            .emit(with: self, onNext: { owner, _ in
                OnboardingDataModel.shared.nickName = owner.nickNameTextField.text ?? ""
                OnboardingDataModel.shared.introduceSelfMessage = owner.briefIntroduceTextView.text
                OnboardingDataModel.shared.preferredSubway = owner.subwayRelay.value

                let isCreate: Bool = OnboardingDataModel.shared.isCreated ?? false
                let controller = isCreate ? OpendThunViewController() : ParticipationCompletedViewController()
                owner.navigationController?.pushViewController(controller, animated:  true)
            })
            .disposed(by: disposeBag)

        leftButtonItem.rx.tap
            .asSignal()
            .emit(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        nickNameTextField.rx.controlEvent(.touchDown)
            .asSignal()
            .map { UIColor.ptBlack02.cgColor }
            .emit(to: nickNameTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)

        nickNameTextField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .asSignal(onErrorSignalWith: .empty())
            .map { owner, _ in
                let count = owner.nickNameTextField.text?.count ?? 0
                return count > 0 ? UIColor.ptBlack02.cgColor : UIColor.ptGray03.cgColor
            }
            .emit(to: nickNameTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)

        nickNameTextField.rx.text.orEmpty
            .map(changeValidNickName)
            .map(setupNickNameCheckButton)
            .bind(to: nickNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        briefIntroduceTextView.rx.didBeginEditing
            .withUnretained(self)
            .filter { owner, _ in owner.briefIntroduceTextView.textColor == .ptGray01 }
            .asSignal(onErrorSignalWith: .empty())
            .emit(with: self, onNext: { owner, _ in
                owner.briefIntroduceTextView.layer.borderColor = UIColor.ptBlack02.cgColor
                owner.briefIntroduceTextView.textColor = .ptBlack01
                owner.briefIntroduceTextView.text = nil
            })
            .disposed(by: disposeBag)
        
        briefIntroduceTextView.rx.didEndEditing
            .withUnretained(self)
            .map { owner, _ in owner.briefIntroduceTextView.text.isEmpty }
            .asSignal(onErrorJustReturn: true)
            .emit(with: self, onNext: { owner, textIsEmpty in
                if textIsEmpty { owner.briefIntroduceTextView.text = "간단 소개 입력" }
                owner.briefIntroduceTextView.textColor = textIsEmpty ? .ptGray01 : .ptBlack01
                owner.briefIntroduceTextView.layer.borderColor = textIsEmpty ?
                    UIColor.ptGray03.cgColor : UIColor.ptGray01.cgColor
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            isPassedNickNameCheck.asObservable(),
            briefIntroduceTextView.rx.text.orEmpty.asObservable()
        )
        .map { $0 && !$1.isEmpty && $1 != "간단 소개 입력" }
        .asSignal(onErrorJustReturn: false)
        .emit(with: self, onNext: { owner, isEnable in
            owner.nextButton.isEnabled = isEnable
            owner.nextButton.backgroundColor = isEnable ? .ptGreen : .ptGray03
            owner.nextButton.layer.borderColor = isEnable ? UIColor.ptBlack01.cgColor : UIColor.ptGray02.cgColor
        })
        .disposed(by: disposeBag)
        
        addPreferredSubwayStationButton.rx.tap
            .asSignal()
            .emit(with: self, onNext: { owner, _ in
                let viewController = AddSubwayStationViewController()
                viewController.delegate = owner
                owner.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        subwayRelay
            .asSignal(onErrorJustReturn: [nil, nil])
            .emit(with: self, onNext: { owner, _ in
                owner.subwayStationCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private
private extension SelfIntroduceViewController {
    func changeValidNickName(_ text: String) -> String {
        noticeExistingNicknameLabel.isHidden = true
        isPassedNickNameCheck.onNext(false)
        guard let lastText = text.last else { return text }

        let regularExpression = String(lastText).range(
            of: "^[ㄱ-ㅎ가-힣a-zA-Z0-9\\_]$",
            options: .regularExpression
        )

        if lastText == " " || text.count > 10 || regularExpression == nil {
            noticeNickNameLabel.textColor = .ptIncorrect
            return String(text.dropLast())
        }

        noticeNickNameLabel.textColor = .ptGray02
        return text
      }

    func setupNickNameCheckButton(_ text: String) -> String {
        let isEnable = text.count >= 2
        nickNameCheckButton.backgroundColor = isEnable ? .ptBlack01 : .ptGray03
        nickNameCheckButton.isEnabled = isEnable

        return text
    }
}

// MARK: - Etc delegate
extension SelfIntroduceViewController: AddSubwayStationDelegate {
    func registerSubwayStation(_ stations: [String?]) {
        var stations = stations
        if stations.count == 1 { stations.append(nil) }

        subwayRelay.accept(stations)
    }
}

extension SelfIntroduceViewController
: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let dataSource = subwayRelay.value.compactMap {($0)}
        return dataSource.isEmpty ? 1 : dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let dataSource = subwayRelay.value.compactMap {($0)}

        guard !dataSource.isEmpty else {
            let emptyCell = self.subwayStationCollectionView.dequeueReusableCell(
                withReuseIdentifier: "SubwayStationCollectionViewCell",
                for: indexPath
            ) as! SubwayStationCollectionViewCell
            emptyCell.isUserInteractionEnabled = false
            return emptyCell
        }
        
        let row = indexPath.row
        let cell = self.subwayStationCollectionView.dequeueReusableCell(
            withReuseIdentifier: "PreferredStationCollectionViewCell",
            for: indexPath
        ) as! PreferredStationCollectionViewCell

        cell.setupData(dataSource[row], row)

        cell.cancelButtonTapObservable
            .bind(with: self, onNext: { owner, textString in
                var stations = owner.subwayRelay.value
                guard let removeIndex = stations.firstIndex(of: textString) else { return }

                stations.remove(at: removeIndex)
                stations.append(nil)
                owner.subwayRelay.accept(stations)
            })
            .disposed(by: disposeBag)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var textString = subwayRelay.value[indexPath.row]

        if textString == nil {
            guard indexPath.row == 0 else { return .zero }
            textString = "선택 사항 없음"
        }

        guard let textString = textString else { return .zero }

        let fontWidth = (textString as NSString).size(
            withAttributes: [NSAttributedString.Key.font: UIFont.pretendardMedium(size: 14)]
        ).width
        let cellWidth = fontWidth + 34 + 16 * (UIScreen.main.bounds.width / 375)
        
        return CGSize(width: cellWidth, height: 32)
    }
}
