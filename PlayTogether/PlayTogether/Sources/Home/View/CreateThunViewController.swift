//
//  CreateThunViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/29.
//

import RxSwift
import UIKit

final class CreateThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private lazy var viewModel = CreateThunViewModel()
    
    private let leftBarItem = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    private let rightBarItem = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 16)
        $0.setTitleColor(.ptGreen, for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
        $0.bounces = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let topView = UIView().then {
        $0.backgroundColor = .ptBlack01
    }
    
    private let topLabel = UILabel().then {
        $0.text = "번개를\n오픈해 볼까요?"
        $0.numberOfLines = 2
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "번개 이름은 무엇인가요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let titleTextField = UITextField().then {
        $0.textAlignment = .center
        $0.placeholder = "제목"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
        $0.backgroundColor = .ptGray04
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let categoryLabel = UILabel().then {
        $0.text = "카테고리를 골라주세요"
        $0.font = .pretendardSemiBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let categoryLayout = UICollectionViewFlowLayout().then {
        let size = UIScreen.main.bounds.width * 0.2746
        $0.minimumLineSpacing = 13
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: size, height: size)
    }
    
    private lazy var categoryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: categoryLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            CreateThunCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: "CreateThunCategoryCollectionViewCell"
        )
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private let whenLabel = UILabel().then {
        $0.text = "언제 열리는 번개인가요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let whenTextField = UITextField().then {
        $0.textAlignment = .center
        $0.placeholder = "YYYY.MM.DD"
        $0.font = .pretendardRegular(size: 14)
        $0.tintColor = .clear
        $0.textColor = .ptBlack01
        $0.backgroundColor = .ptGray04
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let unlockDateButton = UIButton().then {
        $0.setImage(.ptImage(.inactiveIcon), for: .normal)
        $0.setImage(.ptImage(.activeIcon), for: .selected)
        $0.setTitle("  날짜 미정", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 12)
    }
    
    private let whenDatePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
        
        var components = DateComponents()
        components.day = 365
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        components.day = 0
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        $0.minimumDate = minDate
        $0.maximumDate = maxDate
    }
    
    private let timeDatePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko-KR")
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "몇 시에 열리는 번개인가요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let unlockTimeButton = UIButton().then {
        $0.setImage(.ptImage(.inactiveIcon), for: .normal)
        $0.setImage(.ptImage(.activeIcon), for: .selected)
        $0.setTitle("  시간 미정", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 12)
    }
    
    private let timeTextField = UITextField().then {
        $0.textAlignment = .center
        $0.placeholder = "NN:NN"
        $0.font = .pretendardRegular(size: 14)
        $0.tintColor = .clear
        $0.textColor = .ptBlack01
        $0.backgroundColor = .ptGray04
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let placeLabel = UILabel().then {
        $0.text = "어디서 열리는 번개인가요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let unlockPlaceButton = UIButton().then {
        $0.setImage(.ptImage(.inactiveIcon), for: .normal)
        $0.setImage(.ptImage(.activeIcon), for: .selected)
        $0.setTitle("  장소 미정", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 12)
    }
    
    private let placeTextField = UITextField().then {
        $0.textAlignment = .center
        $0.placeholder = "장소"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
        $0.backgroundColor = .ptGray04
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let memberCountLabel = UILabel().then {
        $0.text = "몇 명이 모이나요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let memberCountTextField = UITextField().then {
        $0.textAlignment = .center
        $0.placeholder = "최대 20명"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
        $0.backgroundColor = .ptGray04
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let unlockMemberCountButton = UIButton().then {
        $0.setImage(.ptImage(.inactiveIcon), for: .normal)
        $0.setImage(.ptImage(.activeIcon), for: .selected)
        $0.setTitle("  인원제한 없음", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 12)
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = "번개 소개글을 작성해주세요."
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let borderLayer = CAShapeLayer().then {
        $0.strokeColor = UIColor.ptGray02.cgColor
        $0.lineDashPattern = [2, 2]
        $0.fillColor = nil
    }
    
    private let introduceButton = UIButton()
    
    private let introduceImageView = UIImageView().then {
        $0.image = .ptImage(.cameraIcon)
    }
    
    private let introduceImageLabel = UILabel().then {
        $0.text = "0/3"
        $0.textColor = .ptGray01
        $0.font = .pretendardRegular(size: 14)
    }
    
    private let introduceTextView = UITextView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.cornerRadius = 10
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        $0.text = "만나서 무엇을 할지, 위치 등을 구체적으로 적어주세요.\n200자까지 쓸 수 있어요."
        $0.textColor = .ptGray01
        $0.font = .pretendardRegular(size: 14)
        $0.backgroundColor = .ptGray04
    }
    
    private let introduceTextLabel = UILabel().then {
        $0.text = "0/200"
        $0.textColor = .ptGray02
        $0.font = .pretendardRegular(size: 14)
    }
    
    private lazy var introduceLayout = UICollectionViewFlowLayout().then {
        let size = UIScreen.main.bounds.height * 0.126
        $0.minimumLineSpacing = 13
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: size, height: size)
    }
    
    private lazy var introduceCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: introduceLayout
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            CreateThunIntroduceCollectionViewCell.self,
            forCellWithReuseIdentifier: "CreateThunIntroduceCollectionViewCell"
        )
    }
    
    private lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.delegate = self
    }
    
    private let tapGesture = UITapGestureRecognizer(
        target: CreateThunViewController.self,
        action: nil
    ).then {
        $0.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupIntroduceButton()
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarItem)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        topView.addSubview(topLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(whenLabel)
        contentView.addSubview(unlockDateButton)
        contentView.addSubview(whenTextField)
        contentView.addSubview(timeLabel)
        contentView.addSubview(unlockTimeButton)
        contentView.addSubview(timeTextField)
        contentView.addSubview(placeLabel)
        contentView.addSubview(unlockPlaceButton)
        contentView.addSubview(placeTextField)
        contentView.addSubview(memberCountLabel)
        contentView.addSubview(memberCountTextField)
        contentView.addSubview(unlockMemberCountButton)
        contentView.addSubview(introduceLabel)
        contentView.addSubview(introduceButton)
        introduceButton.addSubview(introduceImageView)
        introduceButton.addSubview(introduceImageLabel)
        contentView.addSubview(introduceCollectionView)
        contentView.addSubview(introduceTextView)
        introduceTextView.addSubview(introduceTextLabel)
    }
    
    override func setupLayouts() {
        let viewHeight = UIScreen.main.bounds.height
        let viewWidth = UIScreen.main.bounds.width
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(viewHeight * 0.144)
        }
        
        topLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(viewHeight * 0.07)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(viewWidth * 0.2746)
        }
        
        whenLabel.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        unlockDateButton.snp.makeConstraints {
            $0.centerY.equalTo(whenLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        whenTextField.snp.makeConstraints {
            $0.top.equalTo(whenLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(viewHeight * 0.07)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(whenTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        unlockTimeButton.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        timeTextField.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(viewHeight * 0.07)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(timeTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        unlockPlaceButton.snp.makeConstraints {
            $0.centerY.equalTo(placeLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(viewHeight * 0.07)
        }
        
        memberCountLabel.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        memberCountTextField.snp.makeConstraints {
            $0.top.equalTo(memberCountLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(viewHeight * 0.07)
        }
        
        unlockMemberCountButton.snp.makeConstraints {
            $0.centerY.equalTo(memberCountLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(memberCountTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(17)
        }
        
        introduceButton.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(viewHeight * 0.126)
        }
        
        introduceCollectionView.snp.makeConstraints {
            $0.top.equalTo(introduceButton.snp.top)
            $0.leading.equalTo(introduceButton.snp.trailing).offset(13)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(introduceButton.snp.bottom)
        }
        
        introduceImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewHeight * 0.038)
            $0.centerX.equalToSuperview()
        }
        
        introduceImageLabel.snp.makeConstraints {
            $0.top.equalTo(introduceImageView.snp.bottom).offset(1)
            $0.centerX.equalToSuperview()
        }
        
        introduceTextView.snp.makeConstraints {
            $0.top.equalTo(introduceButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(viewHeight * 0.27)
            $0.bottom.equalToSuperview().inset(60)
        }
        
        introduceTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewHeight * 0.237)
            $0.trailing.equalToSuperview().offset(viewWidth * 0.853)
        }
    }
    
    override func setupBinding() {
        createWhenDatePickerView()
        createTimeDatePickerView()
        
        leftBarItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] in
                guard $0.count > 20 else { return }
                let index = $0.index($0.startIndex, offsetBy: 20)
                self?.titleTextField.text = String($0[..<index])
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        scrollView.addGestureRecognizer(tapGesture)
        
        Observable.of(["먹을래", "할래", "갈래"])
            .bind(to: self.categoryCollectionView.rx.items) { _, row, item -> UICollectionViewCell in
                guard let cell = self.categoryCollectionView.dequeueReusableCell(
                    withReuseIdentifier: "CreateThunCategoryCollectionViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? CreateThunCategoryCollectionViewCell
                else { return UICollectionViewCell() }
                
                cell.setupData(titleText: item)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        categoryCollectionView.rx.modelSelected(String.self)
            .bind { _ in
                //TODO: 추후 서버 연동 단계에서 구현 예정
            }
            .disposed(by: disposeBag)
        
        unlockDateButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.unlockDateButton.isSelected.toggle()
                self?.whenTextField.isEnabled.toggle()
                self?.whenTextField.text = nil
            })
            .disposed(by: disposeBag)
        
        unlockTimeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.unlockTimeButton.isSelected.toggle()
                self?.timeTextField.isEnabled.toggle()
                self?.timeTextField.text = nil
            })
            .disposed(by: disposeBag)
        
        unlockPlaceButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.unlockPlaceButton.isSelected.toggle()
                self?.placeTextField.isEnabled.toggle()
                self?.placeTextField.text = nil
            })
            .disposed(by: disposeBag)
        
        unlockMemberCountButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.unlockMemberCountButton.isSelected.toggle()
                self?.memberCountTextField.isEnabled.toggle()
                self?.memberCountTextField.text = nil
            })
            .disposed(by: disposeBag)
        
        introduceButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self,
                      self.viewModel.introduceImageRelay.value.count < 3
                else { return }
                
                self.present(self.imagePicker, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.introduceImageRelay
            .bind(to: self.introduceCollectionView.rx.items) { _, row, item -> UICollectionViewCell in
                guard let cell = self.introduceCollectionView.dequeueReusableCell(
                    withReuseIdentifier: "CreateThunIntroduceCollectionViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? CreateThunIntroduceCollectionViewCell
                else { return UICollectionViewCell() }
                
                cell.setupDate(image: item, indexKey: row)
                cell.deleteImageButton.addTarget(self, action: #selector(self.deleteImageButtonDidTap(_:)),
                                                 for: .touchUpInside)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        viewModel.introduceImageRelay
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.introduceImageLabel.text = "\($0.count)/3"
            })
            .disposed(by: disposeBag)
        
        let textViewPlaceHolderString = "만나서 무엇을 할지, 위치 등을 구체적으로 적어주세요.\n200자까지 쓸 수 있어요."
        introduceTextView.rx.didBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard self?.introduceTextView.text == textViewPlaceHolderString else { return }
                self?.introduceTextView.text = nil
                self?.introduceTextView.textColor = .ptBlack01
            })
            .disposed(by: disposeBag)
        
        introduceTextView.rx.didEndEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard self?.introduceTextView.text == "" else { return }
                self?.introduceTextView.text = textViewPlaceHolderString
                self?.introduceTextView.textColor = .ptGray01
            })
            .disposed(by: disposeBag)
        
        introduceTextView.rx.text
            .asDriver()
            .drive(onNext: { [weak self] in
                guard $0 != textViewPlaceHolderString, let text = $0 else { return }
                self?.introduceTextLabel.text = "\(text.count)/200"
                
                guard text.count > 200 else { return }
                let index = text.index(text.startIndex, offsetBy: 200)
                self?.introduceTextView.text = String(text[..<index])
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension CreateThunViewController {
    func setupTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
    
    func createWhenDatePickerView() {
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
        let acceptButton = UIBarButtonItem(title: "완료", style: .plain, target: target, action: nil)
        
        acceptButton.rx.tap
            .bind { [weak self] in
                guard let date = self?.whenDatePicker.date else { return }
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateFormat = "yyyy.MM.dd"
                
                self?.whenTextField.text = formatter.string(from: date)
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        let toolBar = UIToolbar().then {
            $0.sizeToFit()
            $0.setItems([cancelButton, flexible, acceptButton], animated: false)
        }
        
        whenTextField.rx.inputAccessoryView.onNext(toolBar)
        whenTextField.rx.inputView.onNext(whenDatePicker)
    }
    
    func createTimeDatePickerView() {
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
        let acceptButton = UIBarButtonItem(title: "완료", style: .plain, target: target, action: nil)
        
        acceptButton.rx.tap
            .bind { [weak self] in
                guard let date = self?.timeDatePicker.date else { return }
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateFormat = "HH:mm"
                
                self?.timeTextField.text = formatter.string(from: date)
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        let toolBar = UIToolbar().then {
            $0.sizeToFit()
            $0.setItems([cancelButton, flexible, acceptButton], animated: false)
        }
        
        timeTextField.rx.inputAccessoryView.onNext(toolBar)
        timeTextField.rx.inputView.onNext(timeDatePicker)
    }
    
    func setupIntroduceButton() {
        borderLayer.path = UIBezierPath(roundedRect: introduceButton.bounds, cornerRadius: 10).cgPath
        borderLayer.frame = introduceButton.bounds
        introduceButton.layer.addSublayer(borderLayer)
    }
    
    @objc func deleteImageButtonDidTap(_ sender: UICollectionViewCell) {
        guard let index = sender.layer.value(forKey: "index") as? Int else { return }
        var imageList = viewModel.introduceImageRelay.value
        imageList.remove(at: index)
        
        viewModel.introduceImageRelay.accept(imageList)
    }
}

extension CreateThunViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else { return }
        
        var imageList = viewModel.introduceImageRelay.value
        imageList.append(newImage)
        viewModel.introduceImageRelay.accept(imageList)
        
        picker.dismiss(animated: true, completion: {
            self.introduceCollectionView.reloadData()
        })
    }
}
