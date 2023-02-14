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
            $0.centerY.equalToSuperview()
        }
    }
}

extension SubwayStationListTableViewCell {
    func setupData(_ title: NSMutableAttributedString, _ line: String) {
        var imageName: String = ""
        
        if line.contains("1호선") { imageName = "firstLine" }
        else if line.contains("2호선") { imageName = "secondLine" }
        else if line.contains("3호선") { imageName = "thirdLine" }
        else if line.contains("4호선") { imageName = "fourthLine" }
        else if line.contains("5호선") { imageName = "fifthLine" }
        else if line.contains("6호선") { imageName = "sixthLine" }
        else if line.contains("7호선") { imageName = "seventhLine" }
        else if line.contains("8호선") { imageName = "eighthLine" }
        else if line.contains("9호선") { imageName = "ninthLine" }
        
        else if line.contains("공항철도") { imageName = "airportLine" }
        else if line.contains("에버라인") { imageName = "everLine" }
        else if line.contains("김포골드") { imageName = "gimpogoldLine" }
        else if line.contains("경춘선") { imageName = "gyeongchunLine" }
        else if line.contains("경강선") { imageName = "gyeonggangLine" }
        
        else if line.contains("인천1호선") { imageName = "sub_Incheon1" }
        else if line.contains("인천2호선") { imageName = "sub_Incheon2" }
        else if line.contains("신분당선") { imageName = "sub_Shinbundang" }
        else if line.contains("신림") { imageName = "sub_Sinlim" }
        else if line.contains("의정부") { imageName = "sub_Uijeongbu" }
        else if line.contains("서해선") { imageName = "sub_WestSea" }
        else if line.contains("우이신설") { imageName = "sub_WooiShinseol" }
        else if line.contains("우이") { imageName = "sub_Wooui" }
        else if line.contains("경의중앙") { imageName = "sub_GyeonguiCenter" }
        
        
        stationTitleLabel.attributedText = title
        stationTypeImageView.image = UIImage(named: imageName)
    }
}
