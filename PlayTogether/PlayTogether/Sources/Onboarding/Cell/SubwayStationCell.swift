//
//  SubwayStationCell.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/11.
//

import UIKit

final class SubwayStationCell: UICollectionViewCell {
    private lazy var stationNameLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private lazy var removeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


private extension SubwayStationCell {
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 50
        
        addSubview(stationNameLabel)
        addSubview(removeButton)
        
        setupLayout()
    }
    
    func setupLayout() {
        stationNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        removeButton.snp.makeConstraints {
            $0.centerY.equalTo(stationNameLabel.snp.centerY)
            $0.leading.equalTo(stationNameLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().inset(11.57)
        }
    }
}


extension SubwayStationCell {
    func setupData(_ title: String) {
        stationNameLabel.text = title
    }
}
