//
//  DetailThunResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/15.
//

import Foundation

struct SubmittedDetailThunResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: [DetailThunList]
}

struct DetailThunList: Decodable {
    let lightID: Int
    let category, title: String
    let scpCnt: Int
    let date, time, datumDescription: String?
    let image: [String]?
    let peopleCnt: Int?
    let place: String?
    let lightMemberCnt: Int
    let isOpened: Bool
    let members: [Member]
    let organizer: [Organizer]

    enum CodingKeys: String, CodingKey {
        case lightID = "light_id"
        case category, title
        case scpCnt = "scp_cnt"
        case date, time
        case datumDescription = "description"
        case image
        case peopleCnt = "people_cnt"
        case place
        case lightMemberCnt = "LightMemberCnt"
        case isOpened = "is_opened"
        case members, organizer
    }
}

struct Member: Decodable {
    let userID: Int
    let mbti: String?
    let gender, name: String
    let age: Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case mbti, gender, name, age
    }
}

struct Organizer: Decodable {
    let organizerID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case organizerID = "organizer_id"
        case name
    }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
