//
//  HomeViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import RxSwift
import UIKit

final class HomeViewController: BaseViewController {
    private let leftBarItem = UIButton().then {
        $0.setTitle("SOPT", for: .normal)
        $0.setTitleColor(.ptGreen, for: .normal)
        $0.setImage(.ptImage(.showIcon), for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 20)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let rightBarItem = UIButton().then {
        $0.setImage(.ptImage(.searchIcon), for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    private let contentView = UIView()
    
    private let thunButton = UIButton().then {
        $0.setImage(.ptImage(.floatingIcon), for: .normal)
    }
    
    private let categoryLabel = UILabel().then {
        $0.text = "번개 카테고리"
        $0.font = .pretendardBold(size: 20)
        $0.textColor = .ptBlack01
    }
    
    private let hotLabel = UILabel().then {
        $0.text = "HOT"
        $0.font = .pretendardBold(size: 20)
        $0.textColor = .ptBlack01
    }
    
    private let newLabel = UILabel().then {
        $0.text = "NEW"
        $0.font = .pretendardBold(size: 20)
        $0.textColor = .ptBlack01
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarItem)
        
        view.addSubview(scrollView)
        view.addSubview(thunButton)
        scrollView.addSubview(contentView)
    }
    
    override func setupLayouts() {
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        
        thunButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(tabBarHeight+16)
        }
    }
}
