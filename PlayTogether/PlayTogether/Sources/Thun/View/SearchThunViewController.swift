//
//  SearchThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/27.
//

import UIKit
import RxSwift
import RxCocoa

class SearchThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel = SearchThunViewModel()
    private let isSelected = true
    
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
    }

    private lazy var buttonStackView = UIStackView(arrangedSubviews: [eatButton,goButton,doButton]).then {
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
        $0.register(ThunListTableViewCell.self,
                    forCellReuseIdentifier: ThunListTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 110
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
        getApiInSearchBar()
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
        
        viewModel.emptyThunList
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.thunList
            .bind(to: self.tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "ThunListTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? ThunListTableViewCell else { return UITableViewCell() }
                cell.setupData(
                    item.title,
                    item.date ?? "날짜미정",
                    item.time ?? "시간미정",
                    item.peopleCnt ?? 0,
                    item.place ?? "장소미정",
                    item.lightMemberCnt,
                    item.category,
                    item.scpCnt)
                return cell
            }
            .disposed(by: self.disposeBag)

        eatButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                switch self.eatButton.isSelected {
                case true:
                    self.isSeletedButtonState(self.eatButton, false)
                case false:
                    self.isSeletedButtonState(self.eatButton, true)
                    self.isSeletedButtonState(self.goButton, false)
                    self.isSeletedButtonState(self.doButton, false)
                }
            })
            .disposed(by: disposeBag)
        
        goButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                switch self.goButton.isSelected {
                case true:
                    self.isSeletedButtonState(self.goButton, false)
                case false:
                    self.isSeletedButtonState(self.goButton, true)
                    self.isSeletedButtonState(self.eatButton, false)
                    self.isSeletedButtonState(self.doButton, false)
                }
            })
            .disposed(by: disposeBag)

        doButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                switch self.doButton.isSelected {
                case true:
                    self.isSeletedButtonState(self.doButton, false)
                case false:
                    self.isSeletedButtonState(self.doButton, true)
                    self.isSeletedButtonState(self.eatButton, false)
                    self.isSeletedButtonState(self.goButton, false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func isSeletedButtonState(_ button: UIButton,_ state: Bool) {
        button.isSelected = state
        if state {
            button.backgroundColor = .ptBlack02
            button.layer.borderWidth = 0
            getApiInSearchBar()
        } else {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.ptGray02.cgColor
            button.backgroundColor = .ptGray04
            getApiInSearchBar()
        }
    }
    
    private func getApiInSearchBar() {
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                if !(query.count >= 2) {
                    self.tableView.isHidden = false
                    self.viewModel.thunList.onNext([])
                } else {
                    switch self.isSelected {
                    case self.eatButton.isSelected:
                        self.viewModel.searchThunData(query, "먹을래") { response in
                            if response.isEmpty { self.viewModel.emptyThunList.onNext(true) } else { self.tableView.isHidden = false
                                self.viewModel.thunList.onNext(response)}}
                    case self.goButton.isSelected:
                        self.viewModel.searchThunData(query, "갈래") { response in
                            if response.isEmpty { self.viewModel.emptyThunList.onNext(true) } else { self.tableView.isHidden = false
                                self.viewModel.thunList.onNext(response)}}
                    case self.doButton.isSelected:
                        self.viewModel.searchThunData(query, "할래") { response in
                            if response.isEmpty { self.viewModel.emptyThunList.onNext(true) } else { self.tableView.isHidden = false
                                self.viewModel.thunList.onNext(response)}}
                    default:
                        self.viewModel.searchThunData(query, "") { response in
                            if response.isEmpty { self.viewModel.emptyThunList.onNext(true) } else { self.tableView.isHidden = false
                                self.viewModel.thunList.onNext(response)}}
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
