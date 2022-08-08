//
//  CreateThunCollectionViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/29.
//

import UIKit

final class CreateThunCategoryCollectionViewCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.image = .ptImage(.logoNotSelect)
    }
    
    private lazy var label = UILabel().then {
        $0.font = .pretendardBold(size: 16)
        $0.textColor = .ptGray01
        $0.textAlignment = .center
    }
    
    override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }
            setupSelected(isSelected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension CreateThunCategoryCollectionViewCell {
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.ptGray02.cgColor
        
        addSubview(imageView)
        addSubview(label)
        setupLayout()
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(1)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupSelected(_ selected: Bool) {
        layer.borderColor = selected ? UIColor.ptBlack01.cgColor : UIColor.ptGray02.cgColor
        label.textColor = selected ? .ptBlack01 : .ptGray01
        imageView.image = selected ? .ptImage(.logoSelect) : .ptImage(.logoNotSelect)
    }
}

extension CreateThunCategoryCollectionViewCell {
    func setupData(titleText: String) {
        label.text = titleText
    }
}
