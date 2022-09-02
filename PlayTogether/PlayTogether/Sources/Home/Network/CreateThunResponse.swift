//
//  CreateThunResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/03.
//

import Foundation

struct CreateThunResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: [CreateThun]
}

struct CreateThun: Decodable {
    let id: Int
    let category, title: String
    let date, place, time: String?
    let peopleCnt: Int?
    let description, image: String
    let isDeleted: Bool
    let createdAt, updatedAt: String
    let organizerID, crewID: Int

    enum CodingKeys: String, CodingKey {
        case id, category, title, date, place, peopleCnt
        case description = "description"
        case image, isDeleted, createdAt, updatedAt
        case organizerID = "organizerId"
        case crewID = "crewId"
        case time
    }
}

