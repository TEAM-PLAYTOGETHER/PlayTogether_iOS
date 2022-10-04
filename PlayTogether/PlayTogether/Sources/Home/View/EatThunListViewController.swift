//
//  EatThunListViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/11.
//

import UIKit
import SnapKit
import Then
import RxSwift

class EatThunListViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private var superView = UIViewController()
    private var viewModel = ThunListViewModel()
    
    private let titleLabel = UILabel().then {
        $0.text = "같이 먹을래?"
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
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(emptyLabel)
        view.addSubview(tableView)
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        viewModel.fetchMoreDatas.onNext(())
        
        newButton.rx.tap
            .bind { [weak self] in
                self?.toggleButtonDidTap(buttonTag: 0)
                self?.viewModel.sortIdx = 0
                self?.viewModel.fetchMoreDatas.onNext(())
            }
            .disposed(by: disposeBag)

        likeButton.rx.tap
            .bind { [weak self] in
                self?.toggleButtonDidTap(buttonTag: 1)
                self?.viewModel.sortIdx = 1
                self?.viewModel.fetchMoreDatas.onNext(())
                print("sortIdx", self?.viewModel.sortIdx)
            }
            .disposed(by: disposeBag)
        
        viewModel.isEmptyThun
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.eatGoDoThunList
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
                    EatDetailThunViewController(
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
    
    func setupSuperView(superView: UIViewController) {
        self.superView = superView
    }
}
