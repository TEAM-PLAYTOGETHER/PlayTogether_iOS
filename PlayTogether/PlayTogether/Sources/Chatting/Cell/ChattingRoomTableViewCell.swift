//
//  ChattingRoomTableViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/31.
//

import UIKit

final class ChattingRoomTableViewCell: UITableViewCell {
    private let profileImageView = UIImageView()
    
    private let nameLabel = UILabel().then {
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 16)
    }
    
    private let lastChatLabel = UILabel().then {
        $0.textColor = .ptBlack01
        $0.font = .pretendardRegular(size: 14)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .ptGray01
        $0.font = .pretendardRegular(size: 14)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(profileImage: UIImage?, name: String, lastChat: String, date: String) {
        if let profileImage = profileImage {
            profileImageView.image = profileImage
        } else {
            profileImageView.image = .ptImage(.profileIcon)
        }
        
        nameLabel.text = name
        lastChatLabel.text = lastChat
        dateLabel.text = date
    }
}

private extension ChattingRoomTableViewCell {
    func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(lastChatLabel)
        addSubview(dateLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(UIScreen.main.bounds.width * 0.106)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        lastChatLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(profileImageView).offset(1)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
