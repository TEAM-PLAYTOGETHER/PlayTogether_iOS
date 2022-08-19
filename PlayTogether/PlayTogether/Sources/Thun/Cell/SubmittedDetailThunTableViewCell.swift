//
//  SubmittedDetailThunTableViewCell.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/18.
//

import UIKit
import SnapKit
import Then

class SubmittedDetailThunTableViewCell: UITableViewCell {

    static let identifier = "SubmittedDetailThunTableViewCell"
    
    private let circleImageView = UIImageView().then {
        $0.image = .ptImage(.profileIcon)
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .white
    }
    
    private let arrowRightButton = UIButton().then {
        $0.setImage(.ptImage(.arrowRightIcon), for: .normal)
        $0.tintColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCellStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(circleImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(arrowRightButton)
    }
    
    private func setupCellStyle() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .ptBlack01
        selectionStyle = .none
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    private func setupLayouts() {
        circleImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(CGSize(width: 36, height: 36))
        }
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(circleImageView)
            $0.leading.equalTo(circleImageView.snp.trailing).offset(12)
        }
        arrowRightButton.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().offset(-17)
        }
    }
}

extension SubmittedDetailThunTableViewCell {
    func setupData(_ name: String) {
        nameLabel.text = name
    }
}
