//
//  RegisterCrewResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/08.
//

struct registerCrewResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: CrewData?
}

struct CrewData: Codable {
    let crewID: Int
    let crewName: String

    enum CodingKeys: String, CodingKey {
        case crewID = "crewId"
        case crewName
    }
}
