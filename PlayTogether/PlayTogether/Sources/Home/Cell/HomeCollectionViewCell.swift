//
//  HomeCollectionViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/26.
//

import UIKit

enum ThunType: String {
    case eat = "먹을래"
    case go = "갈래"
    case `do` = "할래"
}

final class HomeCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel = UILabel().then {
        $0.font = .pretendardSemiBold(size: 20)
        $0.numberOfLines = 2
        $0.textColor = .ptGreen
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.backgroundColor = .ptBlack02
        $0.font = .pretendardRegular(size: 12)
        $0.layer.cornerRadius = 14
    }
    
    private lazy var personsLabel = UILabel().then {
        $0.font = .pretendardRegular(size: 14)
    }
    
    private lazy var dateAndPlaceLabel = UILabel().then {
        $0.font = .pretendardRegular(size: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension HomeCollectionViewCell {
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(titleLabel)
        addSubview(categoryLabel)
        addSubview(personsLabel)
        addSubview(dateAndPlaceLabel)
        
        setupLayout()
    }
    
    func setupLayout() {
        categoryLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(categoryLabel.snp.leading).inset(26)
        }
        
        personsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        dateAndPlaceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
}

extension HomeCollectionViewCell {
    func setupData(
        title: String,
        thunType: ThunType,
        persons: String,
        dateAndPlace: String
    ) {
        titleLabel.text = title
        categoryLabel.text = thunType.rawValue
        personsLabel.text = persons
        dateAndPlaceLabel.text = dateAndPlace
    }
}
