//
//  CrewListResponse.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/04.
//

import Foundation

struct CrewListResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: CrewList
}

struct CrewList: Decodable {
    let crewList: [CrewResponse]
    
    enum CodingKeys: String, CodingKey {
        case crewList = "list"
    }
}

struct CrewResponse: Decodable {
    let crewID: Int
    let crewName, description: String
    let isAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case crewID = "id"
        case crewName = "name"
        case description, isAdmin
    }
}
