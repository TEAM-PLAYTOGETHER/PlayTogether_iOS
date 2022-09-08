//
//  MyPageMenuTableViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/28.
//

import UIKit

final class MyPageMenuTableViewCell: UITableViewCell {
    private let menuTitleLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(menuName: String) {
        menuTitleLabel.text = menuName
    }
}

private extension MyPageMenuTableViewCell {
    func setupViews() {
        backgroundColor = .white
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        addSubview(menuTitleLabel)
    }
    
    func setupLayouts() {
        menuTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(35)
            $0.centerY.equalToSuperview()
        }
    }
}
