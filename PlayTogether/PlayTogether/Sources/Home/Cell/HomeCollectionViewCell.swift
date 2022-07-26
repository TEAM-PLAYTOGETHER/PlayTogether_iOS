//
//  HomeCollectionViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/26.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel = UILabel().then {
        $0.font = .pretendardSemiBold(size: 20)
        $0.numberOfLines = 2
        $0.textColor = .ptGreen
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.backgroundColor = .ptBlack02
        $0.font = .pretendardRegular(size: 12)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    private lazy var personsLabel = UILabel().then {
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .white
    }
    
    private lazy var dateAndPlaceLabel = UILabel().then {
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .white
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
        backgroundColor = .ptBlack01
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
            $0.height.equalTo(contentView.frame.height * 0.2)
            $0.width.equalTo(contentView.frame.width * 0.1824)
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
        _ title: String, _ category: String, _ nowMemberCount: Int,
        _ totalMemberCount: Int, _ date: String, _ place: String, _ time: String
    ) {
        titleLabel.text = title
        categoryLabel.text = category
        personsLabel.text = "\(nowMemberCount)/\(totalMemberCount)"
        dateAndPlaceLabel.text = "\(date) \(place) \(time)"
    }
}
