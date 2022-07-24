//
//  OpenThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/20.
//

import UIKit
import SnapKit
import Then

class OpenedThunViewController: BaseViewController {
    private lazy var tableView = UITableView().then {
        $0.register(ThunListTableViewCell.self, forCellReuseIdentifier: ThunListTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 110
        $0.delegate = self
        $0.dataSource = self
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
}
extension OpenedThunViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThunListTableViewCell.identifier, for: indexPath) as? ThunListTableViewCell else { return UITableViewCell() }
        return cell
    }
}
