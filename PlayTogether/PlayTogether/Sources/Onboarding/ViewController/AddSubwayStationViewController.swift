//
//  AddSubwayStationViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/17.
//

import UIKit
import RxSwift
import RxCocoa

class AddSubwayStationViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = AddSubwayStationViewModel()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 0.75
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        let title = OnboardingDataModel.shared
        $0.text = "선호하는 지하철역을\n알려주세요!"
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
        $0.addSpacingLabelText($0)
    }
    
    private let subwayStationLabel = UILabel().then {
        $0.text = "지하철역"
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let noticeSubwayStationLabel = UILabel().then {
        $0.text = "(최대 2개 추가 가능)"
        $0.font = .pretendardRegular(size: 10)
        $0.textColor = .ptGray01
    }
    
    private let inputSubwayStationTextField = UITextField().then {
        $0.setupPlaceholderText(title: "지하철역 검색", color: .ptGray01)
        $0.addLeftPadding()
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
        $0.autocorrectionType = .no
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.cornerRadius = 10
    }
    
//    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
//        let widthSize = UIScreen.main.bounds.width
//        let heightSize = 32 * (UIScreen.main.bounds.height / 812)
//        $0.itemSize = CGSize(width: widthSize, height: heightSize)
//    }
//
//    private lazy var selectedSubwayStationCollectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: collectionViewLayout
//    ).then() {
//        $0.backgroundColor = .white
//        $0.register(SubwayStationCollectionViewCell.self, forCellWithReuseIdentifier: "SubwayStationCollectionViewCell")
//    }
    
    private lazy var subwayStationListTalbeView = UITableView().then {
        $0.backgroundColor = .white
        $0.rowHeight = 57 * (UIScreen.main.bounds.height / 812)
        $0.showsVerticalScrollIndicator = false
        $0.register(SubwayStationListTableViewCell.self, forCellReuseIdentifier: "SubwayStationListTableViewCell")
        $0.separatorInset.left = 0
    }
    
    private lazy var addButton = UIButton().then {
        $0.setupBottomButtonUI(title: "추가하기", size: 15)
        $0.isButtonEnableUI(check: false)
    }
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: AddSubwayStationViewController.self, action: nil)
    
    private lazy var userSubwayStationList = [String : CGFloat]()
    private lazy var test = PublishSubject<[String:CGFloat]>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(subwayStationLabel)
        view.addSubview(noticeSubwayStationLabel)
        view.addSubview(inputSubwayStationTextField)
//        view.addSubview(selectedSubwayStationCollectionView)
        view.addSubview(subwayStationListTalbeView)
        view.addSubview(addButton)
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
        
        subwayStationLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        noticeSubwayStationLabel.snp.makeConstraints {
            $0.centerY.equalTo(subwayStationLabel.snp.centerY)
            $0.leading.equalTo(subwayStationLabel.snp.trailing).offset(4)
        }
        
        inputSubwayStationTextField.snp.makeConstraints {
            $0.top.equalTo(subwayStationLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * (UIScreen.main.bounds.height / 812))
        }
        
//        selectedSubwayStationCollectionView.snp.makeConstraints {
//            $0.top.equalTo(inputSubwayStationTextField.snp.bottom).offset(16)
//            $0.leading.equalToSuperview().inset(20)
//            $0.bottom.equalTo(subwayStationListTalbeView.snp.top).offset(8)
//        }
        
        subwayStationListTalbeView.snp.makeConstraints {
//            $0.top.equalTo(selectedSubwayStationCollectionView.snp.bottom).offset(8)
            $0.top.equalTo(inputSubwayStationTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(addButton.snp.top).offset(-8)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56 * (UIScreen.main.bounds.height / 812))
        }
    }
    
    override func setupBinding() {
        leftButtonItem.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        inputSubwayStationTextField.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.inputSubwayStationTextField.layer.borderColor = UIColor.ptBlack02.cgColor
            })
            .disposed(by: disposeBag)
        
        inputSubwayStationTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .subscribe(onNext: { [weak self] in
                guard let textCount = self?.inputSubwayStationTextField.text?.count else { return }
                guard textCount > 0 else {
                    self?.inputSubwayStationTextField.layer.borderColor = UIColor.ptGray02.cgColor
                    return
                }
                self?.inputSubwayStationTextField.layer.borderColor = UIColor.ptGray01.cgColor
            })
            .disposed(by: disposeBag)
        
        let regularExpressionInput = AddSubwayStationViewModel
                                    .RegularExpressionInput(SubwayStationTitle: inputSubwayStationTextField.rx.text.orEmpty.asObservable())
        let regularExpressionDriver = viewModel.RegularExpressionCheck(input: regularExpressionInput)
        
        regularExpressionDriver.SubwayStationTitleCheck
            .drive(onNext: { [weak self] in
                guard $0 else {
                    self?.inputSubwayStationTextField.text =
                    String(self?.inputSubwayStationTextField.text?.dropLast() ?? "")
                    return
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.filterSubwayStationList(input: regularExpressionInput)
        
        viewModel.subwayStationList
            .bind(to: self.subwayStationListTalbeView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.subwayStationListTalbeView.dequeueReusableCell(
                    withIdentifier: "SubwayStationListTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? SubwayStationListTableViewCell
                else { return UITableViewCell() }

                guard self.inputSubwayStationTextField.text?.isEmpty == false else {
                    self.subwayStationListTalbeView.isHidden = true
                    return UITableViewCell()
                }
                self.subwayStationListTalbeView.isHidden = false
                let matchingString = self.viewModel.makeAttributeString(item, self.inputSubwayStationTextField.text!)
                cell.setupData(matchingString)
                return cell
            }
            .disposed(by: disposeBag)
        
        subwayStationListTalbeView.rx.modelSelected(String.self)
            .asDriver()
            .drive(onNext: { [weak self] name in
                // TODO: UIcollection View 추가해주기
                let fontSize = (name as NSString).size(withAttributes: [
                    NSAttributedString.Key.font: UIFont.pretendardMedium(size: 14)
                ]).width
                let cellSize = fontSize + 10 + 16 * (UIScreen.main.bounds.width / 375)
//                print("DEBUG: seleted item name is \(name), font size is \(fontSize), cell size is \(cellSize)")
                guard (self?.userSubwayStationList.count)! < 2 else {
                    self?.showToast("최대 2개까지 추가할 수 있어요!")
                    return
                }
                self?.userSubwayStationList.updateValue(cellSize, forKey: name)
            })
            .disposed(by: disposeBag)
    }
}
