//
//  SubwayStationCell.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/11.
//

import UIKit

final class SubwayStationCollectionViewCell: UICollectionViewCell {
    private lazy var stationNameLabel = UILabel().then {
        $0.text = "선택 사항 없음"
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGray02
    }
    
    private lazy var removeButton = UIButton().then {
        $0.setImage(.ptImage(.exitIcon), for: .normal)
    }
    
    private let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


private extension SubwayStationCollectionViewCell {
    func setupView() {
        backgroundColor = .white
        
        borderLayer.lineDashPattern = [3, 3]
        borderLayer.strokeColor = UIColor.ptGray03.cgColor
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        layer.addSublayer(borderLayer)
        
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
