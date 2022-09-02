//
//  MyPageSubwayLabelView.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/28.
//

import UIKit

final class MyPageSubwayLabelView: UIView {
    private let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addStation(stationName: String) {
        let subwayLabel = PaddingLabel().then {
            $0.text = stationName
            $0.textColor = .white
            $0.font = .pretendardMedium(size: 12)
            $0.lineBreakMode = .byTruncatingTail
            $0.backgroundColor = .ptBlack02
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.drawText(in: CGRect().inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)))
        }
        
        stackView.addArrangedSubview(subwayLabel)
    }
}

private extension MyPageSubwayLabelView {
    func setupUI() {
        backgroundColor = .ptBlack01
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
