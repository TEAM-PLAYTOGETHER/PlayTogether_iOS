//
//  ExistThunResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/02.
//

import Foundation

struct ExistThunResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: ExistThun
}

struct ExistThun: Decodable {
    let isEntered, isOrganizer: Bool

    enum CodingKeys: String, CodingKey {
        case isEntered = "is_entered"
        case isOrganizer = "is_organizer"
    }
}
