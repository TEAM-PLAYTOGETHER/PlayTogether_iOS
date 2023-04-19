//
//  SubmittedDetailThunTableViewCell.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/18.
//

import UIKit
import SnapKit
import Then

final class BlockMemberTableViewCell: UITableViewCell {

    static let identifier = "BlockMemberTableViewCell"
    
    private let circleImageView = UIImageView().then {
        $0.image = .ptImage(.profileIcon)
        $0.layer.cornerRadius = $0.frame.height/2
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    let unblockButton = UIButton().then {
        $0.setTitle("차단 해제", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.layer.borderColor = UIColor.ptBlack02.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 14
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
    
    private func setupViews() {
        contentView.addSubview(circleImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(unblockButton)
    }
    
    private func setupCellStyle() {
        selectionStyle = .none
    }
    
    private func setupLayouts() {
        circleImageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: (UIScreen.main.bounds.width / 375) * 40, height: (UIScreen.main.bounds.height / 812) * 40))
        }
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(circleImageView)
            $0.leading.equalTo(circleImageView.snp.trailing).offset(5)
        }
        unblockButton.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: (UIScreen.main.bounds.width / 375) * 65, height: (UIScreen.main.bounds.height / 812) * 26))
        }
    }
}

extension BlockMemberTableViewCell {
    func setupData(_ name: String,_ profileImage: String?) {
        nameLabel.text = name
        circleImageView.loadProfileImage(url: profileImage ?? "")
    }
}
