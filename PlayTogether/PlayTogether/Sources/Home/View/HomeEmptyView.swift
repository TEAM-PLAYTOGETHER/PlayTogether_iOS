//
//  HomeEmptyView.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/28.
//

import UIKit

final class HomeEmptyView: UIView {
    private let label = UILabel().then {
        $0.text = "아직 만들어진 번개가 없어요!\n새로운 번개를 열어보세요"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGray02
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeEmptyView {
    func setupLayer() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.ptGray02.cgColor
        layer.cornerRadius = 10
    }
    
    func setupUI() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
