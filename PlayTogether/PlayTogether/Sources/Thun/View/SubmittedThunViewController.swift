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
    private var superView = UIViewController()
    private var viewModel: ThunViewModel?
    
    private lazy var tableView = UITableView().then {
        $0.register(
            ThunListTableViewCell.self,
            forCellReuseIdentifier: ThunListTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 110
    }
    
    private let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 28))
    
    func setupSuperView(superView: UIViewController) {
        self.superView = superView
    }
    
    func setupViewModel(viewModel: ThunViewModel) {
        self.viewModel = viewModel
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
    
    override func setupBinding() {
        viewModel?.submittedThunList
            .bind(to: self.tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "ThunListTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? ThunListTableViewCell,
                      let item = item
                else { return UITableViewCell() }
                
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
        
        tableView.rx.modelSelected(ThunResponseList.self)
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let viewmodel = self?.viewModel else { return }
                self?.superView.navigationController?.pushViewController(
                    SubmittedDetailThunViewController(
                        lightID: $0.lightID,
                        superViewModel: viewmodel),
                    animated: true)
            })
            .disposed(by: disposeBag)
    }
}
