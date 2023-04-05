//
//  DetailMemberInfoResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/10/31.
//

import Foundation

struct DetailMemberInfoResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: DataClass
}

struct DataClass: Decodable {
    let profile: Profile
    let crewName: String
}

struct Profile: Decodable {
    let id: String
    let isDeleted: Bool
    let nickname, description, firstStation, secondStation: String?
    let profileImage: String?
    let gender, birth: String?

    enum CodingKeys: String, CodingKey {
        case id, isDeleted, nickname
        case description
        case firstStation, secondStation, profileImage, gender, birth
    }
}
