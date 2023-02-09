//
//  OnboardingData.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/19.
//

class OnboardingDataModel {
    static let shared = OnboardingDataModel()
    
    var isCreated: Bool?
    var meetingTitle: String?
    var introduceMessage: String?
    var inviteCode: String?
    var nickName: String?
    var introduceSelfMessage: String?
    var preferredSubway: [String]?
    
    var crewId: Int?
    var madeCrew: Bool?
    
    private init() {}
}
