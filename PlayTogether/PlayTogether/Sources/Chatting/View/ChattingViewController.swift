//
//  ChatViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import RxSwift
import UIKit

final class ChattingViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UIScreen.main.bounds.height * 0.093
        $0.register(
            ChattingRoomTableViewCell.self,
            forCellReuseIdentifier: "ChattingRoomTableViewCell"
        )
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
        // 삭제 예정
        let mockData = [
            [nil, "문수제비", "네 가능합니다.", "2022.04.13. 14:00"],
            [nil, "궈뇽민", "제가 7시부터 가능한데 혹시 5시 시작이지만 늦참할 수 있을까요?", "2022.04.13. 14:00"]
        ]
        // 변경 예정
        Observable.just(mockData)
        .bind(to: tableView.rx.items) { _, row, item -> UITableViewCell in
            guard let cell = self.tableView.dequeueReusableCell(
                withIdentifier: "ChattingRoomTableViewCell",
                for: IndexPath(row: 0, section: 0)
            ) as? ChattingRoomTableViewCell else { return UITableViewCell() }
            
            cell.setupCell(
                profileImage: nil,
                name: item[1]!,
                lastChat: item[2]!,
                date: item[3]!
            )
            return cell
        }
        .disposed(by: disposeBag)
    }
}
