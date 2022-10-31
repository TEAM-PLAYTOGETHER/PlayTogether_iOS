//
//  MyPageViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import RxSwift
import UIKit

final class MyPageViewController: BaseViewController {
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    private let rightBarItem = UIButton().then {
        $0.setImage(.ptImage(.settingIcon), for: .normal)
    }
    
    // TODO: 변경 예정
    private let profileView = ProfileView(
        frame: .zero,
        crew: "SOPT",
        name: "안드_김세훈이아니라",
        birth: "1998",
        gender: "M",
        profileImage: .ptImage(.doIcon),
        stationName: ["강남역", "동대문역사문화공원역"],
        introduce: "한줄 소개임 ㅋ 뭐요 왜요 팍시~! 아유.... 하기 싫어! 아아 제 진심이 아니고요 와프입니다? 하하하"
    )
    
    private let devideView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private let menuTableView = UITableView().then {
        $0.bounces = false
        $0.rowHeight = UIScreen.main.bounds.height * 0.061
        $0.register(MyPageMenuTableViewCell.self, forCellReuseIdentifier: "MyPageMenuTableViewCell")
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "마이페이지"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarItem)
        
        view.addSubview(profileView)
        view.addSubview(devideView)
        view.addSubview(menuTableView)
    }
    
    override func setupLayouts() {
        profileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.262)
        }
        
        devideView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(5)
        }
        
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(devideView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        Observable.just(viewModel.menuList)
            .bind(to: menuTableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.menuTableView.dequeueReusableCell(
                    withIdentifier: "MyPageMenuTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? MyPageMenuTableViewCell else { return UITableViewCell() }
                
                cell.setupCell(menuName: item)
                
                guard row == self.viewModel.menuList.count - 1
                else { return cell }
                
                let halfWidth = self.view.frame.width / 2
                cell.separatorInset = UIEdgeInsets(
                    top: 0,
                    left: halfWidth,
                    bottom: 0,
                    right: halfWidth
                )
                return cell
            }
            .disposed(by: self.disposeBag)
        
        rightBarItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(SettingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
