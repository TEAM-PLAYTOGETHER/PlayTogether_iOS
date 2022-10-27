//
//  SettingViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/10/21.
//

import UIKit
import RxSwift

class SettingViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MyPageViewModel()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private lazy var tableView = UITableView().then {
        $0.bounces = false
        $0.rowHeight = UIScreen.main.bounds.height * 0.061
        $0.register(MyPageMenuTableViewCell.self, forCellReuseIdentifier: "MyPageMenuTableViewCell")
        $0.backgroundColor = .red
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
        
        Observable.just(viewModel.menuList)
            .bind(to: tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "MyPageMenuTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? MyPageMenuTableViewCell else { return UITableViewCell() }
                
                cell.setupCell(menuName: item)
                
//                guard row == self.viewModel.menuList.count - 1
//                else { return cell }
//
//                let halfWidth = self.view.frame.width / 2
//                cell.separatorInset = UIEdgeInsets(
//                    top: 0,
//                    left: halfWidth,
//                    bottom: 0,
//                    right: halfWidth
//                )
                return cell
            }
            .disposed(by: self.disposeBag)
    }
}
