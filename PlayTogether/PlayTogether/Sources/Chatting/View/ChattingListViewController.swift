//
//  ChatViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import RxSwift
import UIKit

final class ChattingListViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = ChattingListViewModel()
    
    private let tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UIScreen.main.bounds.height * 0.093
        $0.register(
            ChattingListTableViewCell.self,
            forCellReuseIdentifier: "ChattingListTableViewCell"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.shared.establishConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchChattingRoomList()
    }
    
    override func setupViews() {
        title = "채팅"
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    override func setupLayouts() {
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(tabBarHeight)
        }
    }
    
    override func setupBinding() {
        viewModel.chattingRoomListSubject
            .bind(to: tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "ChattingListTableViewCell",
                    for: IndexPath(row: 0, section: 0)
                ) as? ChattingListTableViewCell,
                      let item = item
                else { return UITableViewCell() }
                
                cell.setupCell(
                    profileImage: nil,
                    name: item.audience,
                    lastChat: item.content,
                    date: item.createdAt,
                    send: item.send,
                    read: item.read
                )
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { view, indexPath in
                guard let values = try? view.viewModel.chattingRoomListSubject.value(),
                      let item = values[indexPath.row]
                else { return }
                
                let chattingRoomViewController = ChattingRoomViewController(
                    userName: item.audience,
                    roomID: item.roomID,
                    receiverID: item.audienceID
                )
                chattingRoomViewController.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(
                    chattingRoomViewController,
                    animated: true
                )
            })
            .disposed(by: disposeBag)
    }
}
