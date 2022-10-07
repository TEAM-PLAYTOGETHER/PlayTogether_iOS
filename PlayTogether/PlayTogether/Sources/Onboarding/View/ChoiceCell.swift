//
//  ChoiceCell.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/16.
//

import UIKit
import RxSwift

class ChoiceCell: UICollectionViewCell {
    private let titleLabel = UILabel().then {
        $0.font = .pretendardBold(size: 16)
        $0.textColor = .ptGray01
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGray01
    }
    
    private lazy var iconImageView = UIImageView().then {
        $0.image = .ptImage(.seletedIcon)
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    // TODO: Rx Binding 바꿀 예정
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.ptGray01.cgColor
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(iconImageView)
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26)
            $0.top.equalToSuperview().offset(22)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        iconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-26)
            $0.top.bottom.equalToSuperview().inset(19)
        }
    }
}

extension ChoiceCell {
    func configureCell(_ title: String, _ subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
