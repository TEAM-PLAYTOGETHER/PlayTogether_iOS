//
//  SubwayStationListTableViewCell.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/20.
//

import UIKit

final class SubwayStationListTableViewCell: UITableViewCell {
    private lazy var title: String = ""
    private lazy var stationType: String = ""
    
    lazy var stationTitleLabel = UILabel().then {
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
    }
    
    private lazy var stationTypeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SubwayStationListTableViewCell {
    func setupView() {
        backgroundColor = .white
        selectionStyle = .none
        
        addSubview(stationTitleLabel)
        addSubview(stationTypeImageView)
        
        setupLayout()
    }
    
    func setupLayout() {
        stationTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        stationTypeImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(20)
        }
    }
}

extension SubwayStationListTableViewCell {
    func setupData(_ title: NSMutableAttributedString) {
        stationTitleLabel.attributedText = title
    }
}
