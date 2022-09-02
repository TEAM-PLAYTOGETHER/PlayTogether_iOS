//
//  ChattingRoomTableViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

import UIKit

enum MessageType {
    case myMessage
    case yourMessage
}

final class ChattingRoomTableViewCell: UITableViewCell {
    private let myMessageLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.numberOfLines = 0
        $0.textColor = .ptBlack01
        $0.backgroundColor = .ptGray02
        $0.layer.cornerRadius = 10
//        $0.clipsToBounds = true
//        $0.drawText(in: CGRect().inset(by: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)))
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .ptGray02
        $0.font = .pretendardRegular(size: 12)
    }
    
    private let yourProfileImageView = UIImageView().then {
        $0.image = .ptImage(.profileIcon)
    }
    
    private let yourMessageLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.backgroundColor = .ptBlack01
        $0.layer.cornerRadius = 10
//        $0.clipsToBounds = true
//        $0.drawText(in: CGRect().inset(by: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(
        profileImage: UIImage?,
        send: Bool,
        content: String,
        createdAt: String
    ) {
        if let profileImage = profileImage {
            yourProfileImageView.image = profileImage
        }
        
        switch send {
        case true:
            myMessageLabel.text = content
            setupUI(.myMessage)
        case false:
            yourMessageLabel.text = content
            setupUI(.yourMessage)
        }
        
        dateLabel.text = dateParser(createdAt)
    }
}

private extension ChattingRoomTableViewCell {
    func setupUI(_ messageType: MessageType) {
        backgroundColor = .white
        
        switch messageType {
        case .myMessage:
            addSubview(myMessageLabel)
            addSubview(dateLabel)
            
            myMessageLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.greaterThanOrEqualToSuperview().offset(128)
                $0.trailing.equalToSuperview().inset(20)
            }
            
            dateLabel.snp.makeConstraints {
                $0.top.equalTo(myMessageLabel.snp.bottom).offset(6)
                $0.trailing.equalToSuperview().inset(20)
            }
        case .yourMessage:
            addSubview(yourProfileImageView)
            addSubview(yourMessageLabel)
            addSubview(dateLabel)
            
            yourProfileImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalToSuperview().offset(8)
                $0.size.equalTo(24)
            }
            
            yourMessageLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(yourProfileImageView.snp.trailing).offset(8)
                $0.trailing.lessThanOrEqualToSuperview().inset(128)
            }
            
            dateLabel.snp.makeConstraints {
                $0.top.equalTo(yourMessageLabel.snp.bottom).offset(6)
                $0.leading.equalTo(yourProfileImageView.snp.trailing).offset(10)
            }
        }
    }
    
    func dateParser(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let convertDate = dateFormatter.date(from: dateString) else { return String.init() }
        
        dateFormatter.dateFormat = "yyyy.MM.dd.  HH:mm"
        return dateFormatter.string(from: convertDate)
    }
}
