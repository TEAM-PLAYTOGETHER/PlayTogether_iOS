//
//  JjimThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/20.
//

import UIKit
import SnapKit
import Then
import RxSwift

class LikedThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel: ThunVIewModel?
    
    init(viewModel: ThunVIewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(
            ThunListTableViewCell.self,
            forCellReuseIdentifier: ThunListTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 110
    }
    
    private let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 28))
    
    override func setupViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }
    
    override func setupLayouts() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        viewModel?.likedThunList
               .bind(to: self.tableView.rx.items) { _, row, item -> UITableViewCell in
                   guard let cell = self.tableView.dequeueReusableCell(
                       withIdentifier: "ThunListTableViewCell",
                       for: IndexPath(row: row, section: 0)
                   ) as? ThunListTableViewCell,
                         let item = item
                   else { return UITableViewCell() }
                   
                   cell.setupData(
                    item.title,
                    item.date ?? "",
                    item.time ?? "",
                    item.peopleCnt ?? 0,
                    item.place ?? "",
                    item.lightMemberCnt,
                    item.category,
                    item.scpCnt
                   )
                   return cell
               }
               .disposed(by: disposeBag)
       }
}
