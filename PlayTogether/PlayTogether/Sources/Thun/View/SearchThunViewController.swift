//
//  SearchThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/27.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel = SearchThunViewModel()
    private var submittedViewModel = SubmittedThunViewModel()
    private var openedViewModel = OpenedThunViewModel()
    private var existViewModel = ExistThunViewModel()
    private let isSelected = true
    private var buttonIdx = 3
    
    init(buttonIndex: Int) {
        self.buttonIdx = buttonIndex
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private lazy var searchBar = UISearchBar().then {
        $0.barStyle = .default
        $0.backgroundImage = UIImage()
        $0.placeholder = "검색어를 입력해주세요"
        $0.searchTextField.clearButtonMode = .never
        $0.searchTextField.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptGray01.cgColor
        $0.layer.cornerRadius = 10
        $0.searchTextField.font = UIFont.pretendardRegular(size: 14)
        $0.searchTextField.textColor = .ptGray01
        $0.setImage(.ptImage(.graySearchIcon), for: .search, state: .normal)
    }

    private lazy var eatButton = UIButton().then {
        $0.setTitle("먹을래", for: .normal)
        $0.setTitleColor(.ptGray02, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptGray02.cgColor
        $0.layer.cornerRadius = (UIScreen.main.bounds.height / 812) * 21
        $0.backgroundColor = .ptGray04
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        if self.buttonIdx == 0 {
            isButtonState($0, true)
        }
    }
    
    private lazy var goButton = UIButton().then {
        $0.setTitle("갈래", for: .normal)
        $0.setTitleColor(.ptGray02, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptGray02.cgColor
        $0.layer.cornerRadius = (UIScreen.main.bounds.height / 812) * 21
        $0.backgroundColor = .ptGray04
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        if self.buttonIdx == 1 {
            isButtonState($0, true)
        }
    }

    private lazy var doButton = UIButton().then {
        $0.setTitle("할래", for: .normal)
        $0.setTitleColor(.ptGray02, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptGray02.cgColor
        $0.layer.cornerRadius = (UIScreen.main.bounds.height / 812) * 21
        $0.backgroundColor = .ptGray04
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        if self.buttonIdx == 2 {
            isButtonState($0, true)
        }
    }

    private lazy var buttonStackView = UIStackView(arrangedSubviews:
                                                    [eatButton,goButton,doButton]).then {
        $0.spacing = 23
        $0.distribution = .fillEqually
    }

    private let underlineView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과가 없어요!"
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGray02
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(
            ThunListTableViewCell.self,
            forCellReuseIdentifier:ThunListTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = (UIScreen.main.bounds.height/812) * 110
        $0.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.addSubview(searchBar)
        view.addSubview(eatButton)
        view.addSubview(goButton)
        view.addSubview(doButton)
        view.addSubview(buttonStackView)
        view.addSubview(underlineView)
        view.addSubview(emptyLabel)
        view.addSubview(tableView)
    }
    
    override func setupLayouts() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo((UIScreen.main.bounds.height/812)*44)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(searchBar)
            $0.height.equalTo((UIScreen.main.bounds.height/812)*38)
        }

        underlineView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(14)
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(buttonStackView)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(underlineView.snp.bottom).offset(27)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .bind { [weak self] in
                guard let self = self else { return }
                self.searchBar.searchTextField.textColor = .ptBlack01
                self.searchBar.setImage(.ptImage(.blackSearchIcon), for: .search, state: .normal)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing
            .bind { [weak self] in
                guard let self = self else { return }
                self.searchBar.setImage(.ptImage(.graySearchIcon), for: .search, state: .normal)
                self.searchBar.searchTextField.textColor = .ptGray01
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                switch self.isSelected {
                case self.eatButton.isSelected:
                    self.thunResponseData(query, "먹을래")
                case self.goButton.isSelected:
                    self.thunResponseData(query, "갈래")
                case self.doButton.isSelected:
                    self.thunResponseData(query, "할래")
                default:
                    self.thunResponseData(query, "")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.emptyThunList
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.thunList
            .bind(to: self.tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "ThunListTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? ThunListTableViewCell else { return UITableViewCell() }
                switch item.isOpened {
                case true:
                    cell.setupData(
                        item.title,
                        item.date ?? "날짜미정",
                        item.time ?? "시간미정",
                        item.peopleCnt ?? 0,
                        item.place ?? "장소미정",
                        item.lightMemberCnt,
                        item.category,
                        item.scpCnt)
                    cell.isUserInteractionEnabled = true
                case false:
                    cell.setupClosedData(
                        item.title,
                        item.date ?? "날짜미정",
                        item.time ?? "시간미정",
                        item.peopleCnt ?? 0,
                        item.place ?? "장소미정",
                        item.lightMemberCnt,
                        item.category,
                        item.scpCnt)
                    cell.isUserInteractionEnabled = false
                }
                return cell
            }
            .disposed(by: self.disposeBag)
        
        // 오픈한 번개일경우 추가하기
        tableView.rx.modelSelected(ThunResponseList.self)
            .asDriver()
            .drive(onNext: { [weak self] in
                let lightId = $0.lightID
                self?.existViewModel.getExistThun(lightId: lightId, completion: { response in
                    guard let viewmodel = self?.submittedViewModel else { return }
                    switch response {
                    case true:
                        self?.navigationController?.pushViewController(
                            SubmittedDetailThunViewController(
                                lightID: lightId,
                                superViewModel: viewmodel),
                            animated: true)
                    case false:
                        self?.navigationController?.pushViewController(
                            EnterDetailThunViewController(lightID: lightId),
                            animated: true)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        eatButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.isSelectedButton(self.eatButton, 1, 2)
            })
            .disposed(by: disposeBag)
        
        goButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.isSelectedButton(self.goButton, 0, 2)
            })
            .disposed(by: disposeBag)

        doButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.isSelectedButton(self.doButton, 0, 1)
            })
            .disposed(by: disposeBag)
    }
    
    private func isButtonState(_ button: UIButton,_ state: Bool) {
        button.isSelected = state
        if state {
            button.backgroundColor = .ptBlack02
            button.layer.borderWidth = 0
        } else {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.ptGray02.cgColor
            button.backgroundColor = .ptGray04
        }
    }
    
    private func isSelectedButton(_ button: UIButton,_ firstIndex: Int,_ secondIndex: Int) {
        guard let searchText = searchBar.text else { return }
        guard let buttonCategory = button.titleLabel?.text else { return }
        let buttons = [eatButton,goButton,doButton]
        switch button.isSelected {
        case true:
            self.isButtonState(button, false)
            thunResponseData(searchText, "")
        case false:
            self.isButtonState(button, true)
            self.isButtonState(buttons[firstIndex], false)
            self.isButtonState(buttons[secondIndex], false)
            thunResponseData(searchText, buttonCategory)
        }
    }
    
    private func thunResponseData(_ query: String,_ category: String) {
        if !(query.count >= 2) {
            self.tableView.isHidden = false
            self.viewModel.thunList.onNext([])
        } else {
            self.viewModel.searchThunData(query, category) { response in
                switch response.isEmpty {
                case true:
                    self.viewModel.emptyThunList.onNext(true)
                case false:
                    self.tableView.isHidden = false
                    self.viewModel.thunList.onNext(response)
                }
            }
        }
    }
}
