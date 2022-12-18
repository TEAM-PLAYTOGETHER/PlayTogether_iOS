//
//  OnboardingResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/12/18.
//

struct OnboardingResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: CrewData
}

struct CrewData: Codable {
    let list: [CrewLists]
}

struct CrewLists: Codable {
    let id: Int
    let crewCode, name, listDescription: String
    let isAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case id, crewCode, name
        case listDescription = "description"
        case isAdmin
    }
}
