//
//  ProfileView.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/29.
//

import UIKit

final class ProfileView: UIView {
    private let crewButton = UIButton().then {
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 14)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.setImage(.ptImage(.showIconBlack), for: .normal)
    }
    
    private let cardView = UIView().then {
        $0.backgroundColor = .ptBlack01
        $0.layer.cornerRadius = 10
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .pretendardBold(size: 18)
        $0.textColor = .ptGreen
    }
    
    private let birthGenderLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 12)
        $0.textColor = .white
    }
    
    private let introduceImageView = UIImageView().then {
        $0.image = .ptImage(.introduceLabelIcon)
    }
    
    private let introduceLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 12)
        $0.numberOfLines = 0
        $0.textColor = .ptGray02
    }
    
    private let myPageSubwayLabelView = MyPageSubwayLabelView()
    
    init(
        frame: CGRect,
        crew: String,
        name: String,
        birth: String,
        gender: String,
        profileImage: UIImage,
        stationName: [String],
        introduce: String
    ) {
        super.init(frame: frame)
        setupData(crew, name, birth, gender, profileImage, stationName, introduce)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileView {
    func setupData(
        _ crew: String,
        _ name: String,
        _ birth: String,
        _ gender: String,
        _ profileImage: UIImage,
        _ stationName: [String],
        _ introduce: String
    ) {
        crewButton.setTitle(crew, for: .normal)
        nameLabel.text = name
        birthGenderLabel.text = "\(birth)년생 · \(gender)"
        profileImageView.image = profileImage
        
        stationName.forEach {
            myPageSubwayLabelView.addStation(stationName: $0)
        }
        
        introduceLabel.text = introduce
    }
    
    func setupViews() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.ptBlack01.cgColor
        layer.cornerRadius = 10
        backgroundColor = .ptGreen
        
        addSubview(crewButton)
        addSubview(cardView)
        cardView.addSubview(profileImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(birthGenderLabel)
        cardView.addSubview(myPageSubwayLabelView)
        cardView.addSubview(introduceImageView)
        cardView.addSubview(introduceLabel)
    }
    
    func setupLayouts() {
        crewButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(crewButton.snp.bottom).offset(6)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(UIScreen.main.bounds.width * 0.213)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        birthGenderLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nameLabel)
        }
        
        myPageSubwayLabelView.snp.makeConstraints {
            $0.top.equalTo(birthGenderLabel.snp.bottom).offset(9)
            $0.leading.equalTo(birthGenderLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
            $0.bottom.equalTo(profileImageView)
        }
        
        introduceImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(UIScreen.main.bounds.width * 0.085)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.centerY.equalTo(introduceImageView)
            $0.leading.equalTo(introduceImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
