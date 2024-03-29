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
    private var viewModel = LikedThunViewModel()
    private var superView = UIViewController()
    private var existViewModel = ExistThunViewModel()
    private var submittedviewModel = SubmittedThunViewModel()
    
    private let emptyLabel = UILabel().then {
        $0.text = "아직 찜한 번개가 없어요!\n관심 있는 번개를 찜 해보세요"
        $0.numberOfLines = 0
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGray02
        $0.textAlignment = .center
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
    
    func setupSuperView(superView: UIViewController) {
        self.superView = superView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPageCount = 1
        viewModel.fetchLikedThunList(pageSize: self.viewModel.maxSize, curpage: viewModel.currentPageCount) { response in
            self.viewModel.likedThunList.onNext(response)
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
        viewModel.fetchMoreDatas.onNext(())
        
        viewModel.isEmptyThun
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.likedThunList
               .bind(to: self.tableView.rx.items) { _, row, item -> UITableViewCell in
                   guard let cell = self.tableView.dequeueReusableCell(
                       withIdentifier: "ThunListTableViewCell",
                       for: IndexPath(row: row, section: 0)
                   ) as? ThunListTableViewCell,
                         let item = item
                   else { return UITableViewCell() }
                   
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
               .disposed(by: disposeBag)
        
        // MARK: - 본인이 만든 번개는 찜할 수 없으니 해당 번개에 참여중인지, 아닌지만 판단해서 뷰 띄워줌
        tableView.rx.modelSelected(ThunResponseList.self)
            .asDriver()
            .drive(onNext: { [weak self] in
                let lightId = $0.lightID
                self?.existViewModel.getExistThun(lightId: lightId, completion: { response in
                    guard let viewmodel = self?.submittedviewModel else { return }
                    switch response {
                    case true:
                        self?.superView.navigationController?.pushViewController(
                            SubmittedDetailThunViewController(
                                lightID: lightId,
                                superViewModel: viewmodel),
                            animated: true)
                    case false:
                        self?.superView.navigationController?.pushViewController(
                            EnterDetailThunViewController(lightID: lightId),
                            animated: true)
                    }
                })
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
