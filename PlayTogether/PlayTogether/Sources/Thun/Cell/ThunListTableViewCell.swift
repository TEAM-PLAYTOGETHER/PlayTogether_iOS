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
        $0.textColor = .ptGreen
        $0.font = .pretendardBold(size: 16)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .pretendardSemiBold(size: 14)
    }
    
    private let personnelLabel = UILabel().then {
        $0.textColor = .ptGray02
        $0.font = .pretendardMedium(size: 12)
    }
    
    private let tagLabel = UILabel().then {
        $0.textColor = .white
        $0.backgroundColor = .ptBlack02
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = UIFont.pretendardMedium(size: 12)
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(.ptImage(.likeFilledGreenIcon), for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardMedium(size: 14)
        $0.isUserInteractionEnabled = false
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 0, left: 20, bottom: 10, right: 20)
        )
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
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 52, height: 26))
        }
        likeButton.snp.makeConstraints {
            $0.trailing.equalTo(tagLabel.snp.trailing)
            $0.centerY.equalTo(personnelLabel)
        }
    }
}

extension ThunListTableViewCell {
    func setupData(
        _ title: String,_ date: String,_ time: String,
        _ peopleCnt: Int,_ place: String,_ lightMemberCnt: Int,_ category: String,_ scpCnt: Int
    ){
        let dateStr = date.replacingOccurrences(of: "-", with: ".")
        titleLabel.text = title
        titleLabel.textColor = .ptGreen
        subTitleLabel.text = "\(dateStr) \(place) \(time)"
        subTitleLabel.textColor = .white
        personnelLabel.text = "인원 \(lightMemberCnt) / \(peopleCnt)"
        tagLabel.text = "\(category)"
        likeButton.setTitle("\(scpCnt)", for: .normal)
        likeButton.setTitleColor(.white, for: .normal)
        likeButton.setImage(.ptImage(.likeFilledGreenIcon), for: .normal)
    }
    
    func setupClosedData(
        _ title: String,_ date: String,_ time: String,
        _ peopleCnt: Int,_ place: String,_ lightMemberCnt: Int,_ category: String,_ scpCnt: Int
    ){
        let dateStr = date.replacingOccurrences(of: "-", with: ".")
        titleLabel.text = "모집 마감된 번개입니다!"
        titleLabel.textColor = .ptGray04
        subTitleLabel.text = "\(dateStr) \(place) \(time) (마감)"
        subTitleLabel.textColor = .ptGray03
        personnelLabel.text = "인원 \(lightMemberCnt) / \(peopleCnt)"
        tagLabel.text = "\(category)"
        likeButton.setTitle("\(scpCnt)", for: .normal)
        likeButton.setTitleColor(.ptGray02, for: .normal)
        likeButton.setImage(.ptImage(.likeFilledGrayIcon), for: .normal)
    }
}
