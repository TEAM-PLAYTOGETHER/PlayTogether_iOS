//
//  BottomSheetViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/04.
//

import RxSwift
import UIKit

final class BottomSheetViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    var crewDataSource: [CrewResponse]
    
    private let sheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let sheetLine = UIView().then {
        $0.backgroundColor = .ptGray02
        $0.layer.cornerRadius = 2
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "MY동아리"
        $0.font = .pretendardBold(size: 18)
        $0.textColor = .ptBlack01
    }
    
    private let addButton = UIButton().then {
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.setTitleColor(.ptBlack02, for: .normal)
        $0.setTitle("+ 추가하기", for: .normal)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.ptBlack02.cgColor
    }
    
    private let devideView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private let tableView = UITableView().then {
        $0.register(
            BottomSheetTableViewCell.self,
            forCellReuseIdentifier: "BottomSheetTableViewCell"
        )
    }
    
    private let tapGesture = UITapGestureRecognizer(
        target: BottomSheetViewController.self,
        action: nil
    )
    
    init(crewData: [CrewResponse]) {
        self.crewDataSource = crewData
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        view.addSubview(sheetView)
        sheetView.addSubview(sheetLine)
        sheetView.addSubview(titleLabel)
        sheetView.addSubview(addButton)
        sheetView.addSubview(devideView)
        sheetView.addSubview(tableView)
    }

    override func setupLayouts() {
        let height = UIScreen.main.bounds.height
        
        sheetView.snp.makeConstraints {
            $0.height.equalTo(height == 667 ? height * 0.3448 : height * 0.3694)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        sheetLine.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 0.17)
            $0.height.equalTo(3)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.leading.equalToSuperview().offset(24)
        }
        
        addButton.snp.makeConstraints {
            let width = UIScreen.main.bounds.width * 0.192
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(width)
            $0.height.equalTo(width * 0.361)
        }
        
        devideView.snp.makeConstraints {
            $0.height.equalTo(5)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(devideView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(height == 667 ? 0 : 20)
        }
    }
    
    override func setupBinding() {
        Observable.just(crewDataSource)
            .bind(to: tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "BottomSheetTableViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? BottomSheetTableViewCell else { return UITableViewCell() }
                
                cell.setupCell(
                    title: item.crewName,
                    isSelected: item.crewID == APIConstants.crewID
                )
                return cell
            }
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                UIView.transition(with: self.view, duration: 0.25, options: .curveEaseInOut, animations: {
                    self.view.backgroundColor = .clear
                    self.sheetView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height)
                }, completion: { _ in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                })
            })
            .disposed(by: disposeBag)
        
        view.addGestureRecognizer(tapGesture)
    }
    
    func setup(parentViewController: UIViewController) {
        guard let tabBarController = parentViewController.tabBarController else { return }
        tabBarController.addChild(self)
        tabBarController.view.addSubview(view)
        
        sheetView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height)
        
        UIView.transition(with: view, duration: 0.25, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
            self.sheetView.frame.origin = CGPoint(x: 0, y: 0)
        })
    }
}
