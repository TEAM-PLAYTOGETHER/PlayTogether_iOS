//
//  MyPageViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import UIKit

final class MyPageViewController: BaseViewController {
    private let rightBarItem = UIButton().then {
        $0.setImage(.ptImage(.settingIcon), for: .normal)
    }
    
    private let cardView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptBlack01.cgColor
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .ptGreen
    }
    
    private let crewButton = UIButton().then {
        $0.setTitle("SOPT", for: .normal) // TODO: 삭제 예정
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 14)
        $0.semanticContentAttribute = .forceRightToLeft
        
        let image = UIImage.ptImage(.showIconBlack)
        $0.setImage(image, for: .normal)
    }
    
    private let profileView = UIView().then {
        $0.backgroundColor = .ptBlack01
        $0.layer.cornerRadius = 10
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = .ptImage(.doIcon) // TODO: 삭제 예정
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "안드_김세훈이아니라" // TODO: 삭제 예정
        $0.font = .pretendardBold(size: 18)
        $0.textColor = .ptGreen
    }
    
    private let birthGenderLabel = UILabel().then {
        $0.text = "1998년생 / M" // TODO: 삭제 예정
        $0.font = .pretendardMedium(size: 12)
        $0.textColor = .white
    }
    
    private let myPageSubwayLabelView = MyPageSubwayLabelView()
    
    private let introduceImageView = UIImageView().then {
        $0.image = .ptImage(.introduceLabelIcon)
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = "한줄 소개임 ㅋ 뭐요 왜요 팍시~! 아유.... 하기 싫어! 아아 제 진심이 아니고요 와프입니다? 하하하" // TODO: 삭제 예정
        $0.font = .pretendardMedium(size: 12)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .ptGray02
    }
    
    private let devideView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private let menuTableView = UITableView().then {
        $0.rowHeight = UIScreen.main.bounds.height * 0.061
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "마이페이지"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarItem)
        
        view.addSubview(cardView)
        cardView.addSubview(crewButton)
        cardView.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(nameLabel)
        profileView.addSubview(birthGenderLabel)
        profileView.addSubview(myPageSubwayLabelView)
        profileView.addSubview(introduceImageView)
        profileView.addSubview(introduceLabel)
        view.addSubview(devideView)
        view.addSubview(menuTableView)
    }
    
    override func setupLayouts() {
        cardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.262)
        }
        
        crewButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        profileView.snp.makeConstraints {
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
        
        devideView.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(5)
        }
    }
    
    override func setupBinding() {
        //TODO: 추후 삭제 예정
        ["강남역", "동대문역사문화공원역"].forEach {
            myPageSubwayLabelView.addStation(stationName: $0)
        }
    }
}
