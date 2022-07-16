//
//  ChoiceCell.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/16.
//

import UIKit
import SnapKit
import Then

class ChoiceCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let titleLabel = UILabel().then {
        $0.text = "개설"
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .ptGray01
    }
    
    let subTitleLabel = UILabel().then {
        $0.text = "번개를 열 동아리나 단체를 개설해요!"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .ptGray01
    }
    
    lazy var iconImageView = UIImageView().then {
        $0.image = UIImage(named: "icn_select")
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                iconImageView.isHidden = false
                titleLabel.textColor = .ptBlack01
                subTitleLabel.textColor = .ptBlack01
                contentView.layer.borderColor = UIColor.ptBlack01.cgColor
            } else {
                iconImageView.isHidden = true
                titleLabel.textColor = .ptGray01
                subTitleLabel.textColor = .ptGray01
                contentView.layer.borderColor = UIColor.ptGray01.cgColor
            }
        }
    }
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        setupViews()
        setupLayouts()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.ptGray01.cgColor
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(iconImageView)
    }
    
    func setupLayouts() {
        contentView.layer.cornerRadius = 8
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(26)
            make.top.equalTo(contentView).offset(22)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-26)
            make.top.equalTo(contentView).offset(19)
            make.bottom.equalTo(contentView).offset(-19)
//            make.width.height.equalTo(48)
        }
    }
    
}
