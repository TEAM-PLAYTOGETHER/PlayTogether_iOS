//
//  BottomSheetTableViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/04.
//

import UIKit

final class BottomSheetTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.font = isSelected ? .pretendardSemiBold(size: 16) : .pretendardRegular(size: 14)
        titleLabel.textColor = isSelected ? .ptBlack02 : .ptGray02
    }
}

private extension BottomSheetTableViewCell {
    func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
    }
}
