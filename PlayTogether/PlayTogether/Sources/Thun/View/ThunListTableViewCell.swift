//
//  ThunListTableViewCell.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/20.
//

import UIKit
import SnapKit
import Then

class ThunListTableViewCell: UITableViewCell {
    
    static let identifier = "ThunListTableViewCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "\(ThunDataModel.shared.title)"
        $0.textColor = .ptGreen
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "\(ThunDataModel.shared.date) \(ThunDataModel.shared.location) \(ThunDataModel.shared.time)"
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    private let personnelLabel = UILabel().then {
        $0.text = "인원 \(ThunDataModel.shared.personnel)"
        $0.textColor = .ptGray02
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }

    private let tagLabel = UILabel().then {
        $0.text = " \(ThunDataModel.shared.tag)"
        $0.textColor = .white
        $0.backgroundColor = .ptBlack02
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(UIImage(named: "icn_like_filled_gray"), for: .normal)
        $0.setTitle(" \(ThunDataModel.shared.like)", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupLayouts()
        setupCellStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellStyle() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .ptBlack01
        selectionStyle = .none
        backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20))
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(personnelLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(tagLabel)
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        personnelLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(-16)
        }
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 52, height: 26))
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalTo(tagLabel.snp.trailing)
            $0.centerY.equalTo(personnelLabel.snp.centerY)
        }
    }
}
