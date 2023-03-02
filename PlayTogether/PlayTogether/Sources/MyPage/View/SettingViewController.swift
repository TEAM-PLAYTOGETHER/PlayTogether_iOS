//
//  SettingViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SettingViewModel()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private lazy var tableView = UITableView().then {
        $0.rowHeight = UIScreen.main.bounds.height * 0.061
        $0.register(MyPageMenuTableViewCell.self, forCellReuseIdentifier: "MyPageMenuTableViewCell")
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "설정"
        view.addSubview(tableView)
    }
    
    override func setupLayouts() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 4
        case 2: return 1
        default: break
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyPageMenuTableViewCell",
            for: indexPath
        ) as? MyPageMenuTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0: cell.setupCell(menuName: viewModel.firstSectionList[indexPath.row])
        case 1: cell.setupCell(menuName: viewModel.secondSectionList[indexPath.row])
        case 2: cell.setupCell(menuName: viewModel.thirdSectionList[indexPath.row])
        default: break
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 5 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                navigationController?.pushViewController(ManageAccountViewController(), animated: true)
            }
        case 1:
            guard let url = URL(string: viewModel.url[indexPath.row]) else {return}
            UIApplication.shared.open(url, options: [:])
        case 2:
            if indexPath.row == 0 {}
        default: break
        }
    }
}
