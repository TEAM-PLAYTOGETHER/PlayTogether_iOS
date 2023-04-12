//
//  SelfIntroduceResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/12/10.
//

struct SelfIntroduceResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: RegisterUserSubwayData?
}

struct RegisterUserSubwayData: Codable {
    let nickname, dataDescription: String
    let firstStation, secondStation: String?

    enum CodingKeys: String, CodingKey {
        case nickname
        case dataDescription = "description"
        case firstStation, secondStation
    }
}
