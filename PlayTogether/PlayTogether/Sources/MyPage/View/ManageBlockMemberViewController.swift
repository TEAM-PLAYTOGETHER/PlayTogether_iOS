//
//  ManageBlockMemberViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2023/03/26.
//

import UIKit
import RxSwift

class ManageBlockMemberViewController: BaseViewController {
    
    private var viewmodel = ["수정님","문수제비","이비석"]
    private lazy var disposeBag = DisposeBag()

    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let blockLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "차단한 유저와는 서로의 게시물, 댓글, 마이페이지를\n확인할 수 없으며, 채팅 또한 보낼 수 없습니다."
        $0.font = .pretendardMedium(size: 12)
        $0.textColor = .ptBlack01
    }
    
    private lazy var tableView = UITableView().then {
        $0.separatorInset.left = 0
        $0.register(BlockMemberTableViewCell.self,
                    forCellReuseIdentifier: BlockMemberTableViewCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = (UIScreen.main.bounds.height / 812) * 72
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "차단사용자 관리하기"
        view.addSubview(blockLabel)
        view.addSubview(tableView)
    }
    
    override func setupLayouts() {
        blockLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(blockLabel.snp.bottom).offset(10)
            $0.leading.equalTo(blockLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
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
        
        // TODO: - 서버 고쳐지면 연동할거야~!
        Observable.of(viewmodel)
            .bind(to: self.tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "BlockMemberTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? BlockMemberTableViewCell else { return UITableViewCell() }
                
                cell.setupData(item, nil)
                
                cell.unblockButton.rx.tap
                    .asDriver()
                    .drive(onNext: { _ in
                        print("차단해제 눌렀음", row)
                    })
                    .disposed(by: self.disposeBag)
                
                return cell
            }
            .disposed(by: self.disposeBag)
    }
}
