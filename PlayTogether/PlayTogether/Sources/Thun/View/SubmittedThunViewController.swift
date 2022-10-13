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
    private var viewModel = SubmittedThunViewModel()
    
    private let emptyLabel = UILabel().then {
        $0.text = "아직 신청한 번개가 없어요!\n관심 있는 번개를 신청해 보세요"
        $0.numberOfLines = 0
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGray02
        $0.textAlignment = .center
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPageCount = 1
        viewModel.fetchSubmittedThunList(pageSize: self.viewModel.maxSize, curpage: viewModel.currentPageCount) { response in
            self.viewModel.submittedThunList.onNext(response.lightData)
            self.viewModel.isLoading = false
        }
    }
    
    override func setupViews() {
        view.addSubview(emptyLabel)
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }
    
    override func setupLayouts() {
        emptyLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        viewModel.isEmptyThun
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.submittedThunList
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
        
        tableView.rx.didScroll
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                if offsetY > (contentHeight - self.tableView.frame.size.height) {
                    self.viewModel.fetchMoreDatas.onNext(())
                }
            }
            .disposed(by: disposeBag)
    }
}
