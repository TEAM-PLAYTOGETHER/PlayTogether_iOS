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
    private let viewModel = CreateThunViewModel()
    
    private let leftBarItem = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    private let rightBarItem = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 16)
        $0.setTitleColor(.ptGreen, for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
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
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        let size = UIScreen.main.bounds.width * 0.2746
        $0.minimumLineSpacing = 13
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: size, height: size)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.backgroundColor = .white
        $0.register(CreateThunCollectionViewCell.self, forCellWithReuseIdentifier: "CreateThunCollectionViewCell")
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "언제 열리는 번개인가요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let dateTextField = UITextField().then {
        $0.textAlignment = .center
        $0.placeholder = "YYYY.MM.DD"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack01
        $0.backgroundColor = .ptGray04
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptGray03.cgColor
    }
    
    private let datePicker = UIDatePicker().then {
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
    
    private let timeLabel = UILabel().then {
        $0.text = "몇 시에 열리는 번개인가요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let timeTextField = UITextField().then {
        $0.textAlignment = .center
        $0.placeholder = "NN:NN"
        $0.font = .pretendardRegular(size: 14)
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
        $0.setTitle(" 인원제한 없음", for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 14)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.setImage(.ptImage(.inactiveIcon), for: .normal)
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = "몇 명이 모이나요?"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarItem)
        
        view.addSubview(topView)
        topView.addSubview(topLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateTextField)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeTextField)
        contentView.addSubview(placeLabel)
        contentView.addSubview(placeTextField)
        contentView.addSubview(memberCountLabel)
        contentView.addSubview(memberCountTextField)
        contentView.addSubview(unlockMemberCountButton)
        contentView.addSubview(introduceLabel)
    }
    
    override func setupLayouts() {
        let viewHeight = UIScreen.main.bounds.height
                
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(viewHeight * 0.144)
        }
        
        topLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 0.2746)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        dateTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(viewHeight * 0.07)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(dateTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
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
            $0.bottom.equalToSuperview().inset(30)
        }
        
    }
    
    override func setupBinding() {
        createDatePickerView()
        
        Observable.of(["먹을래", "할래", "갈래"])
            .bind(to: self.collectionView.rx.items) { _, row, item -> UICollectionViewCell in
                guard let cell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: "CreateThunCollectionViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? CreateThunCollectionViewCell
                else { return UICollectionViewCell() }
                
                cell.setupData(titleText: item)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        collectionView.rx.modelSelected(String.self)
            .bind {
                print($0)
            }
            .disposed(by: disposeBag)
    }
}

private extension CreateThunViewController {
    func createDatePickerView() {
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
        let acceptButton = UIBarButtonItem(title: "완료", style: .plain, target: target, action: nil)
        
        acceptButton.rx.tap
            .bind { [weak self] in
                guard let date = self?.datePicker.date else { return }
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateFormat = "yyyy.MM.dd"
                
                self?.dateTextField.text = formatter.string(from: date)
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)

        let toolBar = UIToolbar().then {
            $0.sizeToFit()
            $0.setItems([cancelButton, flexible, acceptButton], animated: false)
        }
        
        dateTextField.rx.inputAccessoryView.onNext(toolBar)
        dateTextField.rx.inputView.onNext(datePicker)
    }
}
