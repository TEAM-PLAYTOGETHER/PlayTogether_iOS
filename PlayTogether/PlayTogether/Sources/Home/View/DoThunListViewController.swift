//
//  DoThunListViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/11.
//

import UIKit
import RxSwift

class DoThunListViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let cellCnt = 2 // TODO: - 임시로 해둔거고 서버 연결하면 없앨 것
    
    private let titleLabel = UILabel().then {
        $0.text = "같이 할래?"
        $0.font = .pretendardBold(size: 20)
        $0.textColor = .ptBlack01
    }
    
    private let newButton = UIButton().then {
        $0.setTitle("최신순", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.layer.borderColor = UIColor.ptGray01.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.tag = 0
    }
    
    private let likeButton = UIButton().then {
        $0.setTitle("찜 많은순", for: .normal)
        $0.setTitleColor(.ptGray02, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.tag = 1
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [newButton,likeButton]).then {
        $0.spacing = 5
        $0.backgroundColor = .ptGray04
        $0.layer.cornerRadius = 5
        $0.distribution = .fillProportionally
    }
    
    private let emptyLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "아직 만들어진 번개가 없어요!\n새로운 번개를 열어보세요"
        $0.textAlignment = .center
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGray02
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(ThunListTableViewCell.self, forCellReuseIdentifier: ThunListTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 110
        $0.dataSource = self
        $0.delegate = self
    }
    
    private func toggleButtonDidTap(buttonTag:Int) {
        switch buttonTag {
        case 0:
            newButton.layer.borderWidth = 1
            newButton.layer.cornerRadius = 5
            newButton.layer.borderColor = UIColor.ptGray01.cgColor
            newButton.setTitleColor(.ptGray01, for: .normal)
            likeButton.layer.borderWidth = 0
            likeButton.setTitleColor(.ptGray02, for: .normal)
        case 1:
            likeButton.layer.borderWidth = 1
            likeButton.layer.cornerRadius = 5
            likeButton.layer.borderColor = UIColor.ptGray01.cgColor
            likeButton.setTitleColor(.ptGray01, for: .normal)
            newButton.layer.borderWidth = 0
            newButton.setTitleColor(.ptGray02, for: .normal)
        default:
            break
        }
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(tableView)
        tableView.addSubview(emptyLabel)
    }
    
    override func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.equalTo(117 * (UIScreen.main.bounds.width / 375))
            $0.height.equalTo(24 * (UIScreen.main.bounds.height / 812))
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-60)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        newButton.rx.tap
            .bind { [weak self] in
                self?.toggleButtonDidTap(buttonTag: 0)
            }
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .bind { [weak self] in
                self?.toggleButtonDidTap(buttonTag: 1)
            }
            .disposed(by: disposeBag)
    }
}

extension DoThunListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellCnt == 0 {
            tableView.isScrollEnabled = false
            return 0
        } else {
            emptyLabel.isHidden = true
            return cellCnt
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThunListTableViewCell.identifier, for: indexPath) as? ThunListTableViewCell else { return UITableViewCell() }
        return cell
    }
}

