//
//  BlockMemberResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2023/04/11.
//

import Foundation

struct BlockMemberResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: BlockMember
}

struct BlockMember: Decodable {
    let id, userID, blockUserID: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case blockUserID = "blockUserId"
        case createdAt, updatedAt
    }
}
