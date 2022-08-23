//
//  ApplyThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/20.
//

import UIKit
import SnapKit
import Then
import RxSwift

class SubmittedThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    let viewModel = ThunViewModel()
    let cancelViewModel = CancelSubmittedViewModel()
    
    lazy var tableView = UITableView().then {
        $0.register(ThunListTableViewCell.self, forCellReuseIdentifier: ThunListTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 110
    }
    
    private let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 28))
    
    func setBinding() {
        viewModel.fetchSubmittedThunList { response in
            Observable.of(response)
                .bind(to: self.tableView.rx.items) { _, row, item -> UITableViewCell in
                    guard let cell = self.tableView.dequeueReusableCell(
                        withIdentifier: "ThunListTableViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as? ThunListTableViewCell,
                          let item = item
                    else { return UITableViewCell() }
                    
                    cell.setupData(item.title, item.date ?? "날짜미정", item.time ?? "시간미정", item.peopleCnt ?? 0, item.place ?? "장소미정", item.lightMemberCnt, item.category, item.scpCnt)
                    
                    return cell
                }
                .disposed(by: self.disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.dataSource = nil
        setBinding()
    }
    
    override func setupViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }
    
    override func setupLayouts() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupBinding() {}
}
